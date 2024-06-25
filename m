Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D79445978
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 15:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719330884; cv=none; b=e4XxgNIdBSg1Zm/sQQ+TE9Z60O5xzzv/mSbF5cNlD8SSi9c8aLTPEGmfFrZ8Y4v2A8Vk+QZe53xQDy35uPWsfL1+PCQQ62hOReKmajv8JYExg0nC+OKcybdeCa5mv+8bDN0TH0XQjVOc/OZ8fNnMmerypc+HoifCySjSEfELzG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719330884; c=relaxed/simple;
	bh=2mrnQG55tRd27uQwnYDRLuqaqJEbguYvDL9A1PzdlV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TzOa7h+3vAR1VUm50U08yvR5BlXFIQBEfhQoFEajQnjM0LMoKaaO/fg4mWrnDu2wvfBgB8dxTojApNcJSNw6hlD41MTQ/C/eIZSYa1kr270Nvn2HB/hSaA5bEObFJHOrwplqbDj5enveGdmcCT0uypFBMPXQP6doV6v2sVWS7VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=cgfoV2Zs; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="cgfoV2Zs"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a724440f597so380902066b.0
        for <patches@lists.linux.dev>; Tue, 25 Jun 2024 08:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1719330882; x=1719935682; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GJp76l/aLyzw9yrEVieG2Btqr7vRxW9tKrTvw/WqX7o=;
        b=cgfoV2ZsLXwlSpboWuJpCo03DQ6w+XpPU+8BvX7gosjGyptqIDIgfjFcIkOaKg9RQs
         KdYNP+BDyx0zJQXQlMaQset8cGQ4AzepFpDP46seLMNar+1a+e6UZf3B6T8WUMmnrRD1
         59H9xiTCqOXFxdoTg9iB4WrH0OJum5vDVmWVukHGjK2e6p31W+P9QT3oz/CLnMCjhL8Z
         T//EH0Xbb2imEY3uKEF8YAzzFaFkl5cJU4jDCFBuiKNL5l1fayXa703A4qVDR9wg4Skg
         04HsYlWhviiZBk38ri28jyQSsMidC8U1RXCfMqX1x+FyOMc88834dFvwr4G5PVJ+r8dn
         O8fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719330882; x=1719935682;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GJp76l/aLyzw9yrEVieG2Btqr7vRxW9tKrTvw/WqX7o=;
        b=xFm5Icpkvnv0xjNF7KQr7uMa7ZWx9mJMqBOwaJPtV+NVGSp2crJ4BpuXfbSIxbw5zr
         hdAlQHDDD5wRrdhaW9eobZC5WSrPHh8ES2/Szzop1FJsb/YkqD5+Bd1aBLMvA4lxO9d0
         YrMsSlm/hAlwVb8hNY0sjUc7m6jgHg+35nOAtPS+eNEbvhiYlmMC+XvOm72VDmakAsCV
         vJ6O233CC/JbVNRWisNMHgne9V6FLuXaz+EXGoXRW3KZNBK4P89uFZhhMYO2ARXzzXof
         y4+8td9VDj1qrRjN0/nXGv2MBhNODl8fPV+bDk4K90KrVrSKvtidCd5j6yocl8j6nVyO
         W5mQ==
X-Gm-Message-State: AOJu0YzaY+jxiFk2TTdhIYYu4TrTDwUbjY+izpCwCRPel8bZ1+qd9P2R
	836q1C8FhYu0TXjW3fg/RNXHSrwJqX5nUrCH5+nMN8OE9U3Sp+k=
X-Google-Smtp-Source: AGHT+IFjq3eJARwUpHREloE8MuQxh1+u85uWLkDkjlu2n5TxUxT6jYFbku3UVeV9wbUvWfgTzF8Kew==
X-Received: by 2002:a17:906:2690:b0:a6f:e19:6fb2 with SMTP id a640c23a62f3a-a7245b93368mr483072666b.29.1719330880241;
        Tue, 25 Jun 2024 08:54:40 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4a32.dip0.t-ipconnect.de. [91.43.74.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a725459233csm226716866b.96.2024.06.25.08.54.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jun 2024 08:54:39 -0700 (PDT)
Message-ID: <21054231-fc6c-4382-a66e-901327f66374@googlemail.com>
Date: Tue, 25 Jun 2024 17:54:38 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/131] 6.1.96-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240625085525.931079317@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.06.2024 um 11:32 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.96 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No regressions on my 2-socket Ivy Bridge Xeon E5-2697 v2 machine. Builds, boots, works, 
nothing odd in dmesg output.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>

Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
