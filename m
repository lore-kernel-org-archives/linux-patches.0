Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F87248F74
	for <patches@lists.linux.dev>; Tue, 27 May 2025 18:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748371894; cv=none; b=ZCHRzJLiNrlcCJxx/PEDJEzPYcSeDu1Uvc2NVHobOi8kynKNGSCb4vfBO+hpL5oBPUyuBXSlB9MZ74HOG3ax8Vz4xL84GS52bn1RsLSNRIV0q1X9qzUQVxWl+l+0DYxxvD0MM/ybu7iurWesEsF8h2wWeATQWa4I4n82FPb/Y/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748371894; c=relaxed/simple;
	bh=DorkWvyQFhqHg576mXMVfLHslqa0f+WRYlVMyLIbaPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lEmIFdaKz0JN19MTJXH+bm2gVDGJmtr3rVZLVQLFmKhFUwQd2ZbifA97WhoeZZ8lT4LpL1xuTiU95QerV6hzIjsD6os30rsfqwSVQXEUsFP/+X6HfSEE6y6O8FmVXq+rMoJyt990Hertj1tZ3yNuX9W8fK6Wmb04Np11+48Bocs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MR5xTPNL; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MR5xTPNL"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7376dd56f8fso3937396b3a.2
        for <patches@lists.linux.dev>; Tue, 27 May 2025 11:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748371892; x=1748976692; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=/lDH/3PwgjT3x6eE2j8PwCN44/PwlqgIbgZX0zmflFg=;
        b=MR5xTPNLHhssdqdnyWuQF0bm14haazb0BOjbs0V0q3bW1Wr7B5pnhTE3HvTB44748m
         7Gu72M4PxswzyQLKRf0/EleoVoDy/H+u/UWLP6+/l8sFVYz/gV8al95Zs7pb07l+hJa2
         4Td+4xaF+gejNWXIVjgIGf9SSsBkw5OeWD6V3U18cRfQ0ilhb8c5uEkIZ157AmVxyiQx
         dmUn3tqOygffJM/KOrNdoqbu6icavRH6eN5jkXD45GYvecE3TzbKetPHrhg9gkn1MwwE
         lq7rOjaubylFzJuacWdoaTKzyRY/TFvyWSTG9g+WyfbW7hG9BLZs+YuNSd7SG6Ibkxps
         M08w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748371892; x=1748976692;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/lDH/3PwgjT3x6eE2j8PwCN44/PwlqgIbgZX0zmflFg=;
        b=gJq8jEL8c53/oy+f81ebzOKbUbPuQlZuntivlDO8m5EsKcH2cHgDxAulLFQqjoKjuZ
         FpV7V1L68AhasVVj8Q6UC/PI7Ib//BdtafSkCnXTFub0SDWl+ioYh4uLBO75wPxT3yCL
         3lDPHdSvZVJ9+AHqKlmj+RpmYk1h5535aQTGWN8TYzVAIkQ/GGiYK+tEzWLQOYwNa1TF
         QJgNK6nCIRClxk3CeBlHnwXuPtcf7ErXYmoUC69aQWOUU5T/WKPJ8ZBrmUC5vqliajLL
         A17KWdcVgIHntSA3+HwyZhVzrT4uGNJppatOY31ss0AFWIzNFcMIFrWJH53QiwXYE+pt
         DOpA==
X-Gm-Message-State: AOJu0YzWukBTccJnNhPXcl9u2IsypDjJ+pspNCwbdi0K4E35wUTDeKmS
	Cp3ctvrdCeCsGkvTK+Y816R4LYAKfWvMQEcBKUVj1d7ommEnqFieOsrE
X-Gm-Gg: ASbGnct0trKTM2um9Evj7jmHeLiJhhhFBC7SuPp2FzUyc6sbhL09+r3ONg6r+BCTHxW
	NSf8BeX5ASlCoOOWITktU5xXRNFk+To+G5cPmit/qrZeQY2OmA4fG/CdGzADUM7VMmyxCz1xTMX
	eYEsf6xRkFSk+CTrSdt+Y9rcfZnWsNgozMTPhkMmBzqesk+PuCti52k7gNYvMEA5VLo4zpeMTGJ
	gxqCIVkaMW8Z3VBrnmiYUce1/mCXiDfwxjKp5aXt7mDUmXreEYil3rUW5B1yBp9BWYsw4rniZ+B
	XulWFRDXcdHPPT2aTuaGHZZTdY7bINITeLy3oKp5MgKx3kWYXvQa8CWMZLlajRyE187+Clo0GO/
	66LY=
X-Google-Smtp-Source: AGHT+IHW/7KgqhIztkSadBJ7OGmMIVFY4IapTEGDwtHiO71g3kGv7EzLqGkXWRBbN8FENeoIkZa21g==
X-Received: by 2002:a05:6a00:240e:b0:740:595a:f9bf with SMTP id d2e1a72fcca58-745fde9d5e0mr20545357b3a.3.1748371892418;
        Tue, 27 May 2025 11:51:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74628cc6b99sm1526133b3a.124.2025.05.27.11.51.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 May 2025 11:51:31 -0700 (PDT)
Message-ID: <55df493e-7862-4847-b5ca-60d90e4bbc62@gmail.com>
Date: Tue, 27 May 2025 11:51:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/783] 6.14.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250527162513.035720581@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/27/25 09:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.9 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 May 2025 16:22:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
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
