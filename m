Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4653067A
	for <patches@lists.linux.dev>; Thu, 16 Nov 2023 20:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T19yBCna"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-77bcbc14899so73674585a.1
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 12:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700165138; x=1700769938; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XP8UF2SywWm6uvEiv3yQBU5bbISulYs0tmRsi39B+rQ=;
        b=T19yBCnaQQuyunRhlerL48HLiSCfvyapLzfLelKamwerrCsVZN9nEpV2uCXIw8zx0t
         azQqgozYRAShU2F0doj/9WtDk5vRZ1Zecv7CDTmnocTSlLlM8mbXD689LpFlXDlJVyG3
         mHQ/FGARhu0DlQ2NKVAENWL8xT81/cMeX+v9IQDiW115CvgFmPRpglMF1NzrXOUIRE2T
         9rMsjaA8M3PfYBPpmidoRvg1VZXrqSf1S7hed62aTkg8+QcU3Mf/PVF4aJ1Rxvv1viRC
         XKugL09EcDV15zG7ja9+9uv0pGFmQdxqO0N9l3dyUnVK6+PC8MiYtZ8+ALEKPbWR5hdA
         idAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700165138; x=1700769938;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XP8UF2SywWm6uvEiv3yQBU5bbISulYs0tmRsi39B+rQ=;
        b=o9AB/T9NiFD0EWWsUm/uS9gMtHzY2tp7aVj0e5rNnc6pEtwVaND5VksH8I05VgVPeZ
         Yo0jJb+vwfpmjyUpmaQCA///uOknySJBVPQRrt/y1P/5m0VzDowcv67gGiCRDY7/eq15
         6z69M48w03w0EduszLqeKhtRZAILpjRZ6/M5XW2clzd1C3Zwi+qX6Sdwqbz1Iqi+U9Qk
         cV5lfEt0ZGmmieZT9rz1z/OpRgjcMVboNZvA+ZFFkR4ScYCCYxA+4tUsp0Mf7ZG9LVIy
         un9IAEqVtp1HZKb9M1kBHn49Uewe8O1WGVWZqdoakJDIqWW9+j6tZAcDT4V+k47tI2EF
         /0aw==
X-Gm-Message-State: AOJu0Yzpa2WFdxkJ6TrjgSfFIUdgpJaUYUFLt1/rkFshmyt2yDgifwHm
	hZBsZ/g4YVXsW7gHMZKQneA=
X-Google-Smtp-Source: AGHT+IE0rXw4mwZQi9/52TosY+1L9ojppFoOTRaT6/GO5DyaXFESEwXgi5vZk4i3eF/DKYcdk5ambA==
X-Received: by 2002:a05:620a:bca:b0:76d:2725:f36f with SMTP id s10-20020a05620a0bca00b0076d2725f36fmr12213399qki.71.1700165138249;
        Thu, 16 Nov 2023 12:05:38 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id tp9-20020a05620a3c8900b00775afce4235sm49161qkn.131.2023.11.16.12.05.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Nov 2023 12:05:37 -0800 (PST)
Message-ID: <7d953999-5303-4fb9-9a2f-66c31a54bffb@gmail.com>
Date: Thu, 16 Nov 2023 12:05:34 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.5 000/550] 6.5.12-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231115191600.708733204@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/23 11:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.12 release.
> There are 550 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Nov 2023 19:14:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

