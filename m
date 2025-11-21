Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56691FF61E
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 18:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748759; cv=none; b=t8zkUTl2axqIO4JHP2THhNSdU2JuwYccJOSTDHkLq5EMFR0dxLqbk4j1P2wXe+regwoT+dhT5z4GXOoZA8owon6/QHpAciBHKxqyHbPKWaMhndiP7XxU5N/jMRqHSNURBJVjgidCHUnIm0xJmaAwbBFTHcqzwYWyX6EjDTuAFUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748759; c=relaxed/simple;
	bh=LPrDGpbQnKvwM7kMqfxF5Ldd1SuXNo98KEBkPC8gibg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jjDek93dAMO2LkcHYRKqUFd3I6+plVvLA4+U8W+WpYmP0Cfu7uSPKTA22aeAWc6x4FbRO7X2nh7vStJXrXqTRkrNCNoXjE486WzqiHiGd9bmUZ1CV4HFnS8U1oU3NvH4PhFjFWO3Ec1xktZuun+ECWwKvWuqLvKJX4kyFQhNiJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R+2m67l2; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R+2m67l2"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7c66822dd6dso95973b3a.0
        for <patches@lists.linux.dev>; Fri, 21 Nov 2025 10:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763748757; x=1764353557; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RR/i1yaFaavbNdSsVmJ9IzHV+HQy5kzJWXUbmdZhUUo=;
        b=R+2m67l2drwZHJLfKyVFYvDBMndDe65aAU+9nZPK+R0Yqie+ClSdMrK65JXya7WG6s
         09j32KlsdsI6ytiC4sFnQAVCIMFPC8YFJxdDSATpGsNELXNC8zZEdmVK1rzN9Ytdv2eV
         360yLhczrcvl5JgcjDqPEs8U2MQVgeoZtcOJAUS8mE0fot/tzaVIwdbP7D0tn3xL0GLa
         0L5DIyBjVtCtnArbI0KhihxSjosCGy7m5oXA7Rhtir6Zh0MebZ4kT5O9Cy0bkKfbPIai
         RezBvadLEH/mKRpxg+xRF2u/gsiwIUVD/pIBK5nKTGs+5yTbIsEDRqPtXFRisu4WNv8V
         bZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763748757; x=1764353557;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RR/i1yaFaavbNdSsVmJ9IzHV+HQy5kzJWXUbmdZhUUo=;
        b=MnbbJOrHc/2eNl5GUFuroEe2bypJJcqHzBwUCjHaVZx9DOgBAqgGjJM1N8f2TeUTw9
         uv3bhwmtxw2KTrBEP2eGXMyD5GdPHYAFSnEXOXW2sNOHqNDQnUzmLCnFHLWUaY93HDWR
         139jJna1zW4Hc2gJj0sefoEncOC0U3S1CsIZsVpEX2SdYpJ5A1teAbpsxCyM/qs/KUoR
         kjUDHVX9GHURNr0xXWWxDvqg1tJ2smK70gweuRsf4tMToz99sEaJ2Y4f0KNuXnxWv55q
         sth8piONS/1w/ivWX4Bq0CGhfXRlQlRsYIdRux6+8sXTVskpKrllq1163FjYByepN25x
         y3RA==
X-Gm-Message-State: AOJu0Ywo838aLvnLPYftIXKnamc8Ow0rCW5k4jUp5WhPf4KB7QG2PnEE
	N8d70tC4nNmd5D+zy2s259I2ps55K3h1yDDKIGqjscW+TGSK/qwGaPwz
X-Gm-Gg: ASbGncvGBwv4FeZ0RtGTofOOoyW37hhqyrEAVecjV3ipM0YNRKhpIOguRGMirY84TwB
	YKnin26xsAlHNZoXL1hugBZkehSL6qxtoh9/3ZRi7gGRcSXpl/SsN3tvesAf+tVQCKLXYBz7Mlj
	1kIVeXZanWAuIotEW4i1z1YpA5jPVQtn1lIHorEehE1Yam9srTKyjNUKe8k+ot7S1R3cz19BOjA
	TJ6o7wT2VNH7exQY9OpPAhHqkalkJlNx9Rc9YJ5tws8+VMFi5oXDRUyOPYAKkBIjHkwufT2H1MI
	+OuuP5N/xBXmjpkgo3o96yXNyX7cePVgOmDIxPK2+hTERKiKe+tbgxRG4D8Mn7DYYRcH6rPepHp
	2xv1wYF0i/VsUXiZjfFwJO44WBYAmbH1+6ByJZdh/SABOR+1Kg+M2ScPi2vqpqNikGEJJ8Rv/I1
	dl15m+EK+5j5MvvOXN3cMPzfYq54lbU/kYsimdYA==
X-Google-Smtp-Source: AGHT+IF/fz6OcfhFX3lvq9ZzMVTzDGYHMbljXg6ptX45yQgciSaOLtMD5D+NHOa0dapg4ZJBqlUhVg==
X-Received: by 2002:a17:90b:2b8f:b0:343:85eb:4fc7 with SMTP id 98e67ed59e1d1-347298501abmr7984056a91.6.1763748756719;
        Fri, 21 Nov 2025 10:12:36 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f1262364sm6701964b3a.58.2025.11.21.10.12.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 10:12:36 -0800 (PST)
Message-ID: <ef85c608-7f90-4c22-85f7-eafbb88e3665@gmail.com>
Date: Fri, 21 Nov 2025 10:12:33 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/529] 6.6.117-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251121130230.985163914@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/25 05:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.117 release.
> There are 529 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Nov 2025 13:01:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.117-rc1.gz
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
