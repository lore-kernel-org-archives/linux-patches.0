Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CA6D532
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 19:32:16 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id 36so22775210pgp.10
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 11:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DlLQTdoKsOZVDNxk9NL/UbvvDxhujJxGzQgZNmNgx0U=;
        b=JXBX8KVj4Ffl+KJEJrfPsUrsxZRLXQkhl1iFB291/nmaQpGG1GOlYLFoGiRJIhDaeR
         qq8s1vRb486jdTWKcvdRaKpDZy9w1PPqEHiXITMCeNqDPpV6CLycsms2aVn4ec6E5epu
         2RTR5zNLfSikRyLyWBTv4OktwynBGLLlZhyoUoZNuV2oS7P4e7bheeAP9F7nHzqaDXfk
         nHbjiLVn08yOEn37yKdX0LkTtcUJHgBxbjca9aoFUnfrWjX4q1feq6x35Xx4pUUUXYbU
         xj7LmyCuyyKTWE9VXiAWKVCz/r5Ecc6dvpXGyP89Ts4gxj1Hndm5TMQDEz/tuFtHteO4
         rEeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DlLQTdoKsOZVDNxk9NL/UbvvDxhujJxGzQgZNmNgx0U=;
        b=zHtyvNi8A1uTresSwv2r1uAhxKHLBe1hF7NoEQxW34c9cadPnoMn5QS3+cUoiTrBd5
         xRw3z03eR/Ep6GRh48vjB7D1cytH6NF/7hj4S8p8ezBhe9mxFdKCze2uK1jIAnn7jZKA
         Wi7dvh7rGeT0X5Ch8maKYZpbdRn21qMtFDRc10LEaX0YBgI36zVWfzkDLGioUlV1hTaZ
         6MXXA3GO9DM5rInmXqrziiXN9AAq86QQMCi4i04m3albXD6WfNTiNfw101TXs2N/Ayzz
         EVpzXUZkYAcc2EZQ3i1WL5Ntgi9z7ZXoSuUC6qjB0psLY6ZcrRgKMidW+5Yr62ZURz+O
         l/Bw==
X-Gm-Message-State: AFqh2koMPTvltGXX3i6ku3NPmvKqz5yZBQBkXm1I6ssX7+En+F5/vzjT
	n84h5KoTCjCj+gz/eaDiE+Q=
X-Google-Smtp-Source: AMrXdXtNKpWN7uz3qBQ+i7AEsePVao3aNrWvFpHQCQ0As59xfpRQeXFe0p6yqjitcWqnqXzVGe45hQ==
X-Received: by 2002:a62:7b11:0:b0:586:e399:9cd4 with SMTP id w17-20020a627b11000000b00586e3999cd4mr25691538pfc.25.1673983935820;
        Tue, 17 Jan 2023 11:32:15 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id h18-20020aa796d2000000b0058dbb5c5038sm3124010pfq.182.2023.01.17.11.32.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 11:32:15 -0800 (PST)
Message-ID: <b19210c0-bfc7-f601-c8b3-4b4e263c9cd0@gmail.com>
Date: Tue, 17 Jan 2023 11:32:12 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 5.4 000/622] 5.4.229-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230117124648.308618956@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230117124648.308618956@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/17/2023 4:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.229 release.
> There are 622 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.229-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
