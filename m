Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967D53DCD9C
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 21:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787695197; cv=none; b=qh6gl8RA3rfq9Z/XxH/Fn4Ejj2qFODkY1zy//7BuTOlDEfpXQFSJHonULVDL2c5NvLAYQy+GG1eRX+9WCtYYlnWi+JjeajUAi0SR3bvDzKaIxBcQ/wyFEcpiWMQl52tO93KQIzZY8Mpq4NYRtlySctfiBN/RAhUjbTA56nb3y/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787695197; c=relaxed/simple;
	bh=eggbiwEDWPBFIyUTkcJelYeKliQMWKoa31AxhuOodWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T1I96eQSXiJ6S5NA0KXQAer4XOq+j1MjwvnkgD8jIV7TG7exS7Tup+LWqscHjpyNRIf4tdUO/nAbs+3VI5Lj6tI+beyX6sRqtKXwuzpNeQ78RYCp62opaE0BeXrI/PK7e0EGQlauzo+ABnfuDgIZEnnLVeFyiXUpIAi71zYQyPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nBmU/yMo; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nBmU/yMo"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cf50c6f235so4790815ad.0
        for <patches@lists.linux.dev>; Tue, 25 Aug 2026 14:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787695196; x=1788299996; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JmqLyLgU5uXQdZuwEx0AYCIdO1NJyt7iU2a+eX5wWCI=;
        b=nBmU/yModNreSanW8XtnwYtHVTSm1Tztq6EwR4ZnYk6M/mbTaP/fn0szVi/ADCchj2
         CLelReLdgBw9Z78e4lLLh8TQOp75Gilnpsjbw1IERBw4Tq13mneWUIelOd/O26gPAfm1
         U00+mlouY0vB3+Pe9dXVBpjYfO/Z+JxgHKvDPCdaGjzSKsw05L7hdBBhsLJNiKwYnnwS
         LvI0clY/1hS3lLSux4M/Mv6TACzFLw+wRqv0N8VgPay9N1lY9gOMT4lf1ccIQyoTtOO7
         eXB8jse27DUdQ7L/ioGKjgLHzYADkpVuv6ebS6tG+HNXDQ1MBYAkx8mZctP6AW0bhQVW
         OGXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787695196; x=1788299996;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JmqLyLgU5uXQdZuwEx0AYCIdO1NJyt7iU2a+eX5wWCI=;
        b=iGKI7WtTHNATCz1QNWOcRJfwT6Gy4tddwGw0/0SS3oNJfXTv0Cv3/Wq/Gr2gkbw9wB
         xczut33gdNAsdWHv8KBlbW2ggQEaacleIUGg9lMRJIKnPWLuAqwdTvPH34Ka24JfuVks
         62bj8YRRedGzEf54vDZDAYpnmXcAK5HbdHlxwqbPKqnFI9++DMl9Cav1mkWnbu2g7wda
         nOag+/MbQd7ipTpnkZxB+r3o3gEu9sxnrdiwUflpH7HFij5z+F39QdPfaYLhkxHcjhUD
         4LjA6k0FB/GPGWHEDI+j4LJfwbehUlu71Og0M/p1JwRPlIAcJ1cLv0+ekdgDaowB14pu
         lUUw==
X-Gm-Message-State: AFuF++mVghImV14TWnUUcfpW1BbQMkbWDNVDL7xkt4u5oMyPBQaaL8uf
	20UOTCPLr2+Z4SoyhUawc6RJ3hhF6wwyn3vZp/+FEg8dwOYXtAr93F2h
X-Gm-Gg: AR+sD10nDHOE1VCRopPOL8Rghrtbka741K46LQ1LEY5fCrMisheaQyPVan+lwmcifYV
	EIwkdc3O+LA+vwVZwTv/3rSX9ehA6FNpt2HeowFuqBnbXsvhVwzQXAxY4UAVsYQclafrEbQ2DmD
	xQss5oYpLjpPq7TFLdTx1Xw0/uQ/8840zHcRe0Te1x/Otxhh6rmPgiaAwIVInJPDIOsUfbvRsHw
	ppgaz3X/tTIJ7FWb+4//+jz7IvuOJ9yOSA+Y7vVu5WOQTyPSNPGYcS+XADHcrRjJHM/PePSKwLJ
	gSFOlRoDAx1qVzATmni1KGUxh/XIobtRTsGHpcPvo6WH/MFaAmMMI0v581fYH6x7g4XuBai7OTe
	pYBvXpC4VBaknrr5v3liUIMXxnrQQJI6TWJ/wdHN4GbVOT871t5i+3IH5XMKNprHTeQOVLfyJsV
	KbwOM9G/3J64iDej4rXiLzmT1s2ziifxlEvNLogNFdMTE0BwRT721R7XSihkRgE4gBA5hMC5x6P
	+EbzdvaPh5HgXg=
X-Received: by 2002:a17:902:cf0e:b0:2d6:fea6:fe28 with SMTP id d9443c01a7336-2d707a8eb67mr25538455ad.4.1787695195755;
        Tue, 25 Aug 2026 14:59:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3283fa89e8fsm1840296eec.8.2026.08.25.14.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 14:59:54 -0700 (PDT)
Message-ID: <3a323ebf-6485-446e-a0f3-25be37d0bedb@gmail.com>
Date: Tue, 25 Aug 2026 14:59:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/87] 6.6.154-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260825132541.813800447@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 06:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.154 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.154-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
