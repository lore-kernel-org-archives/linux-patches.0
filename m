Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5689CA937
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 23:46:16 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id u6so2520971ilk.12
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 15:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ivk6iO2FEdJoiIGowkm1rg844yh34+pQEG2+qwMK8ms=;
        b=fmq7xTiP4WCijOT13mImOwhRC+hjxrJUHYnc/K4z+jhQOiMsTT33KN6dTZ0MmKmoSp
         Mw4J6TFYIXswfGioEFWoYSFu+dMSE+IrR7DPYMsE4KEg77os0CRHd9DsapoqWLU7rdIl
         6DBb8OfJIkzLMG4fhphrJ1kfbn6Pw314GSSxo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ivk6iO2FEdJoiIGowkm1rg844yh34+pQEG2+qwMK8ms=;
        b=42TW0krlZk27K1J1wk23R1tOkx/5xxc35EYTKsWWnJwlW4MHCoM26JNZDbdd7eY14o
         3XvzP78Q2omPMcTZUH9x/inVBgPRQ1YvM7k8YcmlwxTPJD6YxCxVn68y0tipX3wNbW8m
         Y9C4Wk1I9L3RP7xQ2+KNOUlWVL/wpnxo/tEg615KY/f+UG/H+2lqI7MXi0YI48dhpjAj
         T1KJUlaC/qsWWf9SVNzidoWTz7oWTFHvdx8xmQFCusX86mwz3RFK2ihYGVMs09w2LnHm
         3up/sRsvIAias5+79a1sdgxzr4SPIK+FWl+w1mQxWzgvdQ8RztIgJuGToccLSPbrJpQj
         mvEw==
X-Gm-Message-State: AO0yUKWJI6T+W/bGRdq7SDlSrIo13gw2mT4KSiaXwt8+mJXDSGyECTh7
	qLBOpcmLIlsGRaSJbP/iYO3Pgg==
X-Google-Smtp-Source: AK7set+nDLAJo96Q8kN4foJSmTlcJ8nXZR1X2MjJDNrNilr4N1kIrvbTMO3Nlc2IMR5vD3LJEZjj1A==
X-Received: by 2002:a05:6e02:1605:b0:315:2b2a:f458 with SMTP id t5-20020a056e02160500b003152b2af458mr3635171ilu.3.1677023175255;
        Tue, 21 Feb 2023 15:46:15 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id z14-20020a02ceae000000b003c48ba8f772sm869889jaq.151.2023.02.21.15.46.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 15:46:14 -0800 (PST)
Message-ID: <a8eeee3e-6594-7adf-85cf-961f8c59c91d@linuxfoundation.org>
Date: Tue, 21 Feb 2023 16:46:13 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/118] 6.1.13-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/20/23 06:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.13 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.13-rc1.gz
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
