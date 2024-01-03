Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAA81CF91
	for <patches@lists.linux.dev>; Wed,  3 Jan 2024 19:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h7aYc2lF"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-5ce10b5ee01so552108a12.1
        for <patches@lists.linux.dev>; Wed, 03 Jan 2024 11:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704311708; x=1704916508; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X3iU8aqcre6TJqNl9hYE6bRCOPELUfFdiBKR8Euu9Ys=;
        b=h7aYc2lF+geav3ZVf6kaYlax9zSpCnQlZpa25hSoUW1C4XXgyw3o0UHM6d2s1qPqE9
         01HYj1p0xOnlOdTmTUBNW7LJTQGmAha9TBH+qyeR6x7I3qmW6Z1TJyuyb7QW/lS3rwKi
         Wn6YTF8lqDWMplKtDdCk2wn8d8ta9GJTDjk8VCWoWXEVIo3BKEaKKunSfwqbDPlro7sF
         LAM8qxy4B6GYp/VoMFCQrJi54+uDzspxk2BHcLvkyTG95TIYgMKCXaJ7SfOCfcyyD9Wv
         6W/fSMfVneNpIboWwc1LYpe2FpKkHku3oOgDXrG33cFCumSrjlj9vZJSZp+1CW4eMpiH
         VTkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704311708; x=1704916508;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X3iU8aqcre6TJqNl9hYE6bRCOPELUfFdiBKR8Euu9Ys=;
        b=KgqQSq43wI1eGN0JjuhoPmtcAU7AV2mSkhyQKAhboFfpFP4GFy+bxNaA0m36jcnlmi
         vt1TTtcTJ3XrSBr6Cc+mry4SLXGbmzcusMKlfAZipp/JYx6KrFlSDgMpcxsWjgKNQlb4
         HuKlQDsEllG9BN+a3mujbyONWwHwwaTv9pAhiYGku25bCY8AXJNwk1ihXn0xAAF1YBD0
         gDdnV1AOyKYycFgWgjVbgRgEqUkjGXsGsf5Ahub1xU7wQzwLdSFVlcnJTnN+X/FVT0ik
         PE1iSEfhevs++oJvAPhn/TOd6U0sHxBuC2xsa9+2FSQWOSSAzFVl+FrRiZD4opJ/Y/g6
         ZjpA==
X-Gm-Message-State: AOJu0Yx2Pk8WWyJjeiotI2uQAzQE/CGGG19uVEXP2FzgHfVfhyGmKuPg
	BepxTNQMNzjlTGI/DGXWc4c=
X-Google-Smtp-Source: AGHT+IGClAPCl9CbqKzsGVTXv82t4CtF/ve+Vpmn61NCHnYs+cWDY36TDd1dJAx61YoOCl3oeA27Rw==
X-Received: by 2002:a05:6a20:4323:b0:198:fe75:5692 with SMTP id h35-20020a056a20432300b00198fe755692mr748022pzk.23.1704311708263;
        Wed, 03 Jan 2024 11:55:08 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w19-20020a63d753000000b005cd78f13608sm22746267pgi.13.2024.01.03.11.55.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jan 2024 11:55:07 -0800 (PST)
Message-ID: <abd2e7c5-b1f3-4a70-8634-fb7f51080da8@gmail.com>
Date: Wed, 3 Jan 2024 11:55:06 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/100] 6.1.71-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240103164856.169912722@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/3/24 08:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.71 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jan 2024 16:47:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.71-rc1.gz
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

