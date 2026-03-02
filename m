Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE55337BA6
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 18:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772475360; cv=none; b=FFT+0aBfHFY2PVOBAa1xeV1RF8RPeodGl7h6ogUs5Sw+kd3449MpxOiq1WCQYItYYbgxxFIYUzg/F2ZeTkbqzCVsEg2GZkwrmFaE3kECp3pXg4H3ST94Q2holV50wCdR+58Q26JjARNwcer+QmtySqt+azBpYF888m37G7zI97Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772475360; c=relaxed/simple;
	bh=rPMb0I7pZ3vyAA8bY5JVNGz19lHwfYEeVajqxiFUkpI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DEheWoh03uhsIq/lsqs2iqqYrpFXRz5WLVRhcSS1UwjbwFi1LbxNHbwny8pP/iffL761f4vmkEZsoFOk0wReGM/zCDU2iy/wzK2q3Z0ryJpgDKkNv5gvWvpxjg4v+eDSQc94xKCR/NaYCLABao37/aXkg/FGY1eb4dANFydHo6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=buIdxcmg; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="buIdxcmg"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48371119eacso59807305e9.2
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 10:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1772475355; x=1773080155; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tXuSNcy75SqjYK5Ug8/mqeLaTdYOof3KHvJM2rsZ7tY=;
        b=buIdxcmgsiTsvuWwsKlFdI/GZHUpz7QkDzT7i6GJvJKdF828kz3j4+V7zyXhxaN9nJ
         N4DBx2Uf0LUu4kDO9DWAi9y9HpPA2kiCOD4kzFV3HvCt5NWLURAD6az2Zwfk/C0sw1FN
         VtIKo7C8pTci6yYgSjIy4FNlvJeD5hky3ciM5LSQL61L8rhuMXP5hjkihM8ru8mD0tsH
         B5gZjm+LpiWI+WIN6lSsadjTUTmvzlkmfOU571YVlSMK9hHMKJiE1sxFtgsp2/MkAI7P
         DTmID4U3VpnTSw7BTCaCtMhBxl8qNySUcQqCBHinXdkOYZ6Ei7DBWSc0pdsJk7tatXyR
         bFfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772475355; x=1773080155;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tXuSNcy75SqjYK5Ug8/mqeLaTdYOof3KHvJM2rsZ7tY=;
        b=DR1qgUo01JHrQHPC0ny9qo1wK6X23HHrXpe0+z8Jj3QCUfr1Ppo0NEVTNDtsxOpQ7x
         C1dnLy0486H9zICLv9juirymHRGVbFnehB+UBR8DO5RDbgbWA+26MtKWMkLGO9TQRCKD
         DmujRHuv2it617UhhRax3HtuZABKuZW8ztTbyfmkupMbyiBRYecpVFG3Kx5JFuvXeYdF
         pvbFOHkGbnLuYl4ZzxbhYNGV1zugwFzXxtzRITKL91TgJIrHpY020Cyq5pVtmD8BFFib
         aFXUJ8KCd0Qyd3QX9pqiNkMMC0hneXLkCcGnmeWcj7Pa9Vjfese4q60cRlBxHRL2ZM7g
         RCpw==
X-Forwarded-Encrypted: i=1; AJvYcCUz7Jqiwkz3+ogthu9i97/bKz4w6bJvy6kdHvtqUtwG9VLKfm6sh2aG/TWr+b0TI+jrkDLJsxC3@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2pONxAE2tRs5pvYhRE/MVo1/vxUE8I5+uhEESZVUlSfuoWXpa
	2rIPH0tkXnBgw+nrLiL43lbQj/f3FpK+VyK3v+vQCCtXq8lf54Edus4=
X-Gm-Gg: ATEYQzwvhOv6VZCUecfDtB+cn46TjTfGPh6YGpBs+SixX3NDq8WzRnIAckd9XUuoLyP
	6UGc76KUitBaoFbGNl7NNtO4o5YsE/keEacQw8rVGrTyJJwlN/q5wVOcSDWZqLeWf1n0AgVTfCH
	hZ0E45m/3tyCOMu+2vNYOg4D1cit+vjYWwYk1b3gqn1BNGgrBa1BxRHNDzOHJHVnAjvSbpKnwbw
	ys1t6OKr0Fr0Nes/Zi0jNFaiKrz6kZCR4u5PoMthqApjoooQ8vvgT0cBaF/gVE4qLGc7wFglJAo
	vfGOZCEWIrA5Lakx7MCpj+rNz2dL55Wldk/0kBpq0LMtKocqAYznpvES2sZWCBIXZRXzrKo53XC
	XK2aTHMCb+HUu9tj/z56QXYYR0UCXAdbrt4sz9qBST35PGcFtTFB2TLehcmafPlHnRMIIkWHh/2
	Vh+Soe/ig2v6kjLdH/fyW9TTn1/zBGYJwFRQIG4ywROVWPScJQUbftDVZ7aSrNtUbmKMNzcWICe
	A==
X-Received: by 2002:a05:600c:1393:b0:483:498f:7963 with SMTP id 5b1f17b1804b1-483c9c1f8fcmr224424305e9.26.1772475355218;
        Mon, 02 Mar 2026 10:15:55 -0800 (PST)
Received: from [192.168.1.3] (p5b2b433d.dip0.t-ipconnect.de. [91.43.67.61])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483c3b4a121sm291923475e9.8.2026.03.02.10.15.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 10:15:54 -0800 (PST)
Message-ID: <ae51335d-39b5-4b33-8b3a-be89a6aa3b1f@googlemail.com>
Date: Mon, 2 Mar 2026 19:15:54 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/533] 6.1.165-rc2 review
Content-Language: de-DE
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
 gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260302160943.2522184-1-sashal@kernel.org>
 <66461c13-1bb3-473c-b57f-adba9db4f756@googlemail.com> <aaXNiwFkUEy8SaTm@laps>
 <abe2fb5f-61b3-4597-b27b-c6c61f5efc7d@googlemail.com> <aaXSVaGrwY-k80m5@laps>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <aaXSVaGrwY-k80m5@laps>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.03.2026 um 19:09 schrieb Sasha Levin:
> On Mon, Mar 02, 2026 at 06:57:53PM +0100, Peter Schneider wrote:
>> Am 02.03.2026 um 18:48 schrieb Sasha Levin:
>> [...]
>>
>>> I'll drop it and push the -rc2 branch again for all affected kernels.
>>>
>>
>> Wouldn't it better to push a -rc3 branch then, so as to not create confusion? (I'm confused now... 🤔🙄)
>>
>> Or did you actually mean rc3?
>>
>> Also, the causing patch ("x86/kexec: add a sanity check on previous kernel's ima kexec buffer") is in all others 6.x.y 
>> -rc2s from today, so maybe Harshit should quickly check to which 6.x.y stable branches this patch was meant to be 
>> backported/included?
> 
> I just force pushed a new -rc2, and dropped the offending patch from all
> branches for now.
> 
> This one will end up being a slightly bigger release, and we can revisit this
> commit and any others we had to drop for the next cycle.
> 

Ok, great, thanks! Will pull all 6.x branches again and retest...

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
