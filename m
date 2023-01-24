Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9F07C
	for <patches@lists.linux.dev>; Tue, 24 Jan 2023 01:02:53 +0000 (UTC)
Received: by mail-io1-f44.google.com with SMTP id n85so6423216iod.7
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 17:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QzXjtHokknNOIo6i/tDT9iY3dlftA7c+qD6KDgI/3xM=;
        b=Ya6DyH/c2FTdfl3jQ1YJUj5Gj+vPmDibNyFtLMocR61+n4mprvIqqG0ILITHWaCZTg
         2ITPjo7yI3ZJQbIBmiY+Chnr1F2iODXnGQDW0aSbNJrLTg9N4bjZI/2Ed0P5JNVIobYF
         nP+fAv8scO5NYmXkEZ5CsCEiETs5Ir+2Y5oG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QzXjtHokknNOIo6i/tDT9iY3dlftA7c+qD6KDgI/3xM=;
        b=NkBl36KV7qLkTpGEh8zsQecF0+MzHaDit68sSMaJry0h0A3MkAzDa7K6T6PgQLlkEu
         PAPjJFLgTAjcRXkM6Ff451cP2SDm57AZUmya+DSKAsRrNvrWEAQ59tYB54Mab9SitgnD
         Z9X2Ewsjo9h1L6GsTCA78IC3d99GoSQU4MGe+dsSVo3ZVcDiSyF5bAjfwGJMgibes0yg
         NsA0rmTPXnvEqUNqWK8M0b48jzVlvK5HJCjd1/vlx+tmi9fFsyRPzs0k5xQOyup4HBGp
         YKyOvC57GVjpRF6G8pXcKz5++Ci24nY5BpeFYAklzJnC5um8PLnXMrkHCHd+8v+YHFDH
         GXGw==
X-Gm-Message-State: AFqh2kqUv0WzVg/UbHmqswO217fJag4nFFJcW1V5QWAHGoq76PmVox38
	c4IlW+XmU2dUvK7D6rdtR4UcOw==
X-Google-Smtp-Source: AMrXdXuT7QTYaVhT7eW2ioWfw+txTXicI4WfnHl2vrWE842osIoJlfttp/JuUbxsMP+NGaq8VNAW9g==
X-Received: by 2002:a5d:875a:0:b0:707:d0c0:1bd6 with SMTP id k26-20020a5d875a000000b00707d0c01bd6mr348453iol.1.1674522172688;
        Mon, 23 Jan 2023 17:02:52 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id a15-20020a02998f000000b003a53692d6dbsm216336jal.124.2023.01.23.17.02.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 17:02:52 -0800 (PST)
Message-ID: <d2902d2b-67db-9670-fe6a-7e4af5f86ad3@linuxfoundation.org>
Date: Mon, 23 Jan 2023 18:02:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/188] 6.1.8-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230123094931.568794202@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230123094931.568794202@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/23 02:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.8-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
