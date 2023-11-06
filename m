Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBAD29417
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 17:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hjoj23h9"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1cc0d0a0355so35042495ad.3
        for <patches@lists.linux.dev>; Mon, 06 Nov 2023 09:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699293160; x=1699897960; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mvMLV/XYihjMVpZoZAMN1HtjGi3fRmETd2VsU6bI7YU=;
        b=Hjoj23h9B8ZMScwmDM34Wg49ujAg+GraWIAXJ1abAhQo1E8BtPLT5LSkcOKq+oHHFO
         Eus9BFLApRaLr/rgVQvlWkOJKBTNXdtSvMqWSY8wMCgcV/7bzK0xThRQseCqsrunyKF5
         q3r4MPYnlXN7LLBmiAvIaASHzjTIFjCR9BtKZKy+IRatykdLuKKTEOOp6mopJD7lMEfH
         NLrGoTMdoHRL10v8kiJxKM2zQ37yityob5O0LBVuVN/75GUiKB+FlvYA0spyGBBw/B+f
         Yd2nU+NLCuqcJedwvYcXX3t7l5BPwpCEp8FL4Uo5fp0SO8RtmnwisDBwKb86VC2sRomR
         tKHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699293160; x=1699897960;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mvMLV/XYihjMVpZoZAMN1HtjGi3fRmETd2VsU6bI7YU=;
        b=tNAcfnbQNkvA9dw2HuRlmaM/lAzwXCRJ/jeNVIqYnyI9vY4MKMFFmuXdVvz+7H1Jy5
         D0hHQHlID5oZRfPf+07V8+gOx2WjT27hHDKAz2UstXbARIYecxVoHAZu7x7lp2+T6GSz
         7pO3I0jqcHlTccCSqHt2WwcBKRRDoq3qSH9heeB4yNFl3B2nDK9e4SDVA5HzUflnh/Xz
         RscS75T4gyWEngHPCdyEtA8+MkauFPo8hCPECP0aKvjpJinNp4iMcNFvRe75GFlyNR74
         ZUZ9P8ECW3V6lVMFBmzS8hkIC6GW+W6N7V0u7XLPYdywNeRXkpbt/C1CjR+1iethfrOa
         zzqA==
X-Gm-Message-State: AOJu0YwoVjtFdn5gGkw3vYtMTUAbHHy/OR3zi0o3tUaWMsp7nuxOjXQr
	HFFHoqpbfeDSEh4Vj3rnHqc=
X-Google-Smtp-Source: AGHT+IHkBjm95S2cCyGqYNTJXIfdVIzMId/N24sP+ZbAuxhORjpVmXmMljjPwYKN6tI93qg3Uu5XSw==
X-Received: by 2002:a17:902:e80e:b0:1cc:482c:bc54 with SMTP id u14-20020a170902e80e00b001cc482cbc54mr23308613plg.48.1699293160443;
        Mon, 06 Nov 2023 09:52:40 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id iz18-20020a170902ef9200b001c9c6a78a56sm6188602plb.97.2023.11.06.09.52.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 09:52:39 -0800 (PST)
Message-ID: <a6e89e5c-9f9b-435f-ade3-f88fa4103abd@gmail.com>
Date: Mon, 6 Nov 2023 09:52:37 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/62] 6.1.62-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231106130301.807965064@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/23 05:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.62 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.62-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

