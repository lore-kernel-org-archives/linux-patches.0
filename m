Received: from mail-io1-f67.google.com (mail-io1-f67.google.com [209.85.166.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC1E253CF
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 20:08:15 +0000 (UTC)
Received: by mail-io1-f67.google.com with SMTP id ca18e2360f4ac-77dcff76e35so73432239f.1
        for <patches@lists.linux.dev>; Tue, 01 Aug 2023 13:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1690920495; x=1691525295;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qGwXx3KOfKZdlW9q4qIboZeupOtTw2c7/yPWU17zfUY=;
        b=cTmSS8ZCb3+sHnVnW+0ROnlOAFrjtMNiSg4vWSXaQ7eEiABh/knJcF6+qc41JWMoEb
         Ge5drTPwhRhrEjQO/+4tixsrBxjz3t73WLoU6lsD5JknlzjX1oxhkiuszFdOX1cAjUIx
         MDAOlmEP15Mx5lb3xrh1HTpLiMWDiU7H/Ncq8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690920495; x=1691525295;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qGwXx3KOfKZdlW9q4qIboZeupOtTw2c7/yPWU17zfUY=;
        b=lBpEWCLOyh+cGBlorFW4ppA7Mr+ZQRhPvcjjCBmjJRzbmK8ZbkGiageVG4QCl8RgWG
         k1WeU//qAcsX1QCDkP+k0MXCoC1CrbU/NTbev6tQig/N8s4ILaOQvbezPMiyGEjQlsMI
         m3AQqMtJj8cBX6kIQZnK6JodPPiSH1mFs8da03OjyLsxJfsRb810gwtU5+W4wQ1FCxHd
         yIzykOApgdhet5x5N/2xu83yeOUvsKujhwBswi6/jns8lZHYyzIJ6VWWPSpZWpzWdW5M
         C5bFu/bms+lfiq6UStlRMj2HI0+G2eiQCMu1xDMM7QVA6xiPCX71QtFTsg4rokLyZLw6
         6bJw==
X-Gm-Message-State: ABy/qLaV/GI9JFAj7LeZzEY7k0MokcD7Z9jtSuIvpGYExDcko/yllRK+
	NIuOF3ZvDvy6/IkRv3BoJEmi4A==
X-Google-Smtp-Source: APBJJlEfXOObYKBwXKqr86KaNuXOU6D7KQEKoOJ2zSv9v6mNaZX5XkMSztmkOL3XIqru6Hmri1r7LA==
X-Received: by 2002:a6b:c3c2:0:b0:790:958e:a667 with SMTP id t185-20020a6bc3c2000000b00790958ea667mr8992208iof.2.1690920494927;
        Tue, 01 Aug 2023 13:08:14 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id s4-20020a6bd304000000b0076ffebfc9fasm4161813iob.47.2023.08.01.13.08.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 13:08:14 -0700 (PDT)
Message-ID: <87daf7ca-7ae6-1a21-90e3-5b109c4f3d12@linuxfoundation.org>
Date: Tue, 1 Aug 2023 14:08:13 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.4 000/239] 6.4.8-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/1/23 03:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.8 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Aug 2023 09:18:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
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
