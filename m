Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE586A937
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 23:54:21 +0000 (UTC)
Received: by mail-il1-f176.google.com with SMTP id s8so2446710ilv.10
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 15:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677023661;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8wKzCBIrzleXPLPzgon4Kd+/Lf72uKEdFGeTeuKUEj0=;
        b=iatcsXEGN9iXSm0s4j7p4xxNxDf0jmkUNo1H8FJsECzqxoFrp2R7EESDRJUJi3Q0+5
         U6w7UGMcEfWAgQqgvhho/NwcQqAinD67Nqmh3SKLURppioDirYDyFil4xeS0VviwU1AH
         Hz1Epc2cjH3y5DOrdUMuA6s0Vf3PRmgqhiAAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677023661;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8wKzCBIrzleXPLPzgon4Kd+/Lf72uKEdFGeTeuKUEj0=;
        b=veXGTb6FllEe/EGCJFlsyI1KNqK3n8a5POT7JvvoF5IQ29rLsFUbot/GyxFt1xDbHX
         B4AYwbdNj3dLrn5fnZrvAQ+9ga/RLpXUTCk7XxTMXHgpxpoMZUyHJgy+pto6KBhgmZFh
         FrCzHL7jnPNFzWPKw08Pcn6kqJmwq/EuLlKkHcH9imWcKQ9kQifbieqrsVXUAzqycEGz
         e7OhuUfGavsDtbPZpt7Ji7WOMYXTSHr0P+tkDK07WszrBfca5n8czOlOiHLRwUQW0I9h
         8WB6r7LY7U88J6e5rvc/S0phuYz5K7CK1u7R1Xq+eNzzVJ6mUvVFuXn5JARXXn//sq7y
         4B/A==
X-Gm-Message-State: AO0yUKU4bXvWh351Fyn8FLQg2I6J7l+DJ3ZaZ5mfPU/7TjfpDLYP/PIg
	QA08SJ4+UW9i+cdok2oFjtE9dA==
X-Google-Smtp-Source: AK7set8greIh9RXufbMmZQqMyLNXcOJdQKVVXWxBalZCc19cdd8nj1Pw3dow4riLmlffporOfkSu2g==
X-Received: by 2002:a05:6e02:c73:b0:314:9f2b:f63b with SMTP id f19-20020a056e020c7300b003149f2bf63bmr3056666ilj.2.1677023660986;
        Tue, 21 Feb 2023 15:54:20 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u3-20020a02c043000000b00363362cd476sm1575326jam.101.2023.02.21.15.54.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 15:54:20 -0800 (PST)
Message-ID: <959efbce-b31b-c06e-1134-2cd80bea87f7@linuxfoundation.org>
Date: Tue, 21 Feb 2023 16:54:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 4.19 00/89] 4.19.273-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/20/23 06:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.273 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.273-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
