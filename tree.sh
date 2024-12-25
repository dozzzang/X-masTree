clear

tput civis
lin=2
col=$(($(tput cols) / 2 - 1))  
c=$((col-1))
est=$((c-2))
color=0

# 트리 애니메이션 
tput setaf 2; tput bold
for ((i=1; i<=69; i+=2))  
{
    tput cup $lin $col
    for ((j=1; j<=i; j++))
    {
        echo -n \*
    }
    let lin++
    let col--
    sleep 0.05  
}

#	줄기
tput sgr0; tput setaf 3
for ((i=1; i<=5; i++))
{
    tput cup $((lin++)) $c
    echo 'MMM'
    sleep 0.05  
}
let c++
k=1

# 바닥 눈
snow_base_start=$((lin))
snow_base_end=$((lin))  
for ((i=snow_base_start; i<=snow_base_end; i++)) {
    tput setaf 7; tput bold
    tput cup $i 0
    printf '%.0s■' $(seq 1 $(tput cols))
}

# 눈 내리기
snowflakes=()
snowflake_positions=()
snowflake_speeds=()
for ((i=0; i<50; i++)) {
    snowflakes[$i]=0
    snowflake_positions[$i]=$((RANDOM % $(tput cols)))
    snowflake_speeds[$i]=$((RANDOM % 10))  
}

#전구 깜빡임
while true; do
    # 눈 떨어지기 효과
    for ((i=0; i<50; i++)) {
        tput setaf 7; tput bold
        tput cup ${snowflakes[$i]} ${snowflake_positions[$i]}
        echo ' '
        snowflakes[$i]=$((snowflakes[$i] + snowflake_speeds[$i]))

        if [ ${snowflakes[$i]} -ge $snow_base_start ]; then
            snowflakes[$i]=0
            snowflake_positions[$i]=$((RANDOM % $(tput cols)))
            snowflake_speeds[$i]=$((RANDOM % 10))  # 새로 생성 속도
        fi

        tput cup ${snowflakes[$i]} ${snowflake_positions[$i]}
        echo '•'
    }

    for ((i=1; i<=69; i++)) {
        #전구들 색상 변경
        [ $k -gt 1 ] && {
            color=$(((color+1)%8))
            [ $color -eq 2 ] && color=$(((color+1)%8))  # 트리와 같은 색의 전구는 제외
            tput setaf $color; tput bold
            tput cup ${line[$[k-1]$i]} ${column[$[k-1]$i]}; echo o
        }
        li=$((RANDOM % 69 + 2))  
        height_limit=$((lin - 8))  
        if [ $li -ge $height_limit ]; then
            continue
        fi
        start=$((c-li+1))  
        co=$((RANDOM % (2 * (li - 1)) + start))  

        # 초록색 제외하고 전구 색 설정
        color=$(((RANDOM % 7 + 1)))  
        [ $color -eq 2 ] && color=3  
        tput setaf $color; tput bold
        tput cup $li $co
        echo o
        line[$k$i]=$li
        column[$k$i]=$co

        sleep 0.2  
    }
    k=$((k % 2 + 1))

    sleep 0.1

done

