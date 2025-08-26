Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43A22D3732
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 17:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756229813; cv=none; b=d87eRMPR7qCePb0VVx68uyaIDx916sUenWVenB1ELKSGHnuwEmoM8YViKMMAyX80EfrCIEL6XLaPBlcBYscRsyv+ikxZ85P2uaXT2/v7ptd/OJZTgj246Nb0hpe2CDAGyzcLtJVjm3dh0DMF4p1F2Um2gLp2Dxb+cn85J4QcA7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756229813; c=relaxed/simple;
	bh=h1hzb6kXNb9sJb6UEdW1dxiFgtKRip9v4zaf7STaU34=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o2MhYVtEebSkHKlS02fB7XN9PkjbMGwXHfPECIGQaFqjIqq+L6QUNT8embhcPPWnoFmFhLapSthqz68XBhWTaqceLTgndzfqGxaEG8UpSRUbowOhjlF8Ep5RSR2e93MsROIqsAZTaFaYkf+PQHweYyDkPejIwHffGlNquF1IhOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nMUrYbVt; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nMUrYbVt"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7e8702fd3b2so551771485a.0
        for <patches@lists.linux.dev>; Tue, 26 Aug 2025 10:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756229810; x=1756834610; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2bul+sAEYxjTR9TR/KmNbpMJP4z2RV4SuYQGlJPpSwc=;
        b=nMUrYbVtdI9rwDHMZ7fNwlnt+UrllG5qLf9srH12yXe9XFDsXhMSB7zYo98/zhujBm
         /NUWTKgmr1U1U062L8+eV2VA7rxDERyQ/bNUuQCLpijMTmGB//6W0BqwXEc1ezOnOZR1
         2tejJGa4AJlvePXFGk4geOHzRyffGeFwBgZvt4uWDpd4LwwCd8OGqdd0FWeMom/pGald
         bO1FhPSMnVPzPI0U+s7IDTvdi/uaUXnfTSYkdMSM1Hz5bi852flR5BxQZ+KuUOsBPiPd
         fGBxyfWMfguP4kGho5YivS9UDDMyUftYbIMJFaRM3LCP8k3MmcfTvesMnLXmsAzoWmIu
         rs2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756229810; x=1756834610;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2bul+sAEYxjTR9TR/KmNbpMJP4z2RV4SuYQGlJPpSwc=;
        b=DaQ2Eo1022XxVTzTc/3axLK4sOYADn+afF5tstfRXILVcIpMsCCD96Z2YGvPg2CrcN
         2LAj82JeKZJX27pfYbZMG80A4NpaECivaePjvlXa1KEGekvgSHTETcmwNAJuPdzQ9Pwv
         VKzDOe1SE312bRZEhGR4XXhsd7RH2ll3FJIV7sJZOCLyRtPODakKnU+5nor00Y88idaQ
         4JoVMo05MJtIomws2YSuGHd03OuNvJWcOtRXNgX/uPQIoOTdlo4Bdc9Hc9pUV2bvUqEa
         WdcvGebjemtemIbtSU94VcGKFCKO7ryN1PnTSW0WJ6aYwuK95NhdC76ub9jtZFLtkJF/
         BMcw==
X-Gm-Message-State: AOJu0Ywzr/F8sQFr2nShulDCCCCfCJ7R7qp8hGVwZt0p5tBDDxwTjDAd
	y7dWxh5a5ukxhYJLc79nf4O/SycA6vvAoLH9uSvOlHXHOhkK1bSz41M/
X-Gm-Gg: ASbGnctkBf4E8XQB7SbTEvfdB+aDWc1rb6Tuip0V0nAsrq5vNtEWnFw7njKDXcbq1y4
	AuUnNCcbmugPNuafL8k0vdgtK7eHrsIllvsSR9xkEjKiYDyDq3U4o4o2ps4pymaRncTk7coDzyv
	ygBCKVsxwinZCCuKxq97ry0WIE7WhJ+w0xlMPkg//0U6UnApyb6u/8z/U7UMtPW6atbEqHL5uUu
	ZKbfMFSUAjeCVoIIdb6kYeLuw488btRFVG5CDb+Zya7qecwGAz1yNmSzPkZXzzHN4GHaOWzCaVO
	tMLxah8ItIqmWNso5ikO8Z8rzg/fCXdwm8/HOFkrr8/q1nhgXvl+JAU6ZKQ/etK/Ma1tZEs71uP
	pUuhJ6H8U9CyXDarHBVyR288X2i/+XQc/XQz4ewHzxtgkr2xdWA==
X-Google-Smtp-Source: AGHT+IGd4yxiaDJ1nN1xxwqrq7CTubcIsmLr29Btgu9rztVhTtyKu+4WSygLfx17nr8zqzbzmsuISA==
X-Received: by 2002:a05:620a:4245:b0:7e8:54f7:67cd with SMTP id af79cd13be357-7ea1107cdf9mr2125426685a.50.1756229810342;
        Tue, 26 Aug 2025 10:36:50 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7f0929c268asm452807185a.35.2025.08.26.10.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 10:36:49 -0700 (PDT)
Message-ID: <49147e71-067c-467a-9a04-c1729a0a10a7@gmail.com>
Date: Tue, 26 Aug 2025 10:36:44 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/523] 5.10.241-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250826110924.562212281@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/26/25 04:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.241 release.
> There are 523 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Aug 2025 11:08:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.241-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
