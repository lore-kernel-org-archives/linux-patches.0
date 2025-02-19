Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BE41EB1BB
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 13:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739971515; cv=none; b=J4SAMZe7UMzORchpS9XWHt1LhiBL/ZFgYwMwQLUahYlE/1ajWLcXwrcu/sh5QtYvydefGCNgc2p1GhPP63iAJJ45kgbWHzQZ/Yn6oGdB7wEApr+f99iNf/Rcj+f9ZNVaxLwtWxAVQBzTZEeEx47RZF6MQkRNs5IfhP2eXPEYBjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739971515; c=relaxed/simple;
	bh=HwBLCKNmVxXse7RXAauNSA899MHmbY1+j3D37eiFYfg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pB/9z5WukJhJyGoUN3yRtfz+szJLrp5PH+dA3oTkSWb3ThKaVnjalvYhNY13Z9UD/LXlVOfs/F3mLSrYJT7P61DYKPgDlrmlaWVM78W1Bk87P1x05+nI8MkFhgqltEsW8p0VkR/JXKDqPKtfEz2IdqffLDlY719uDhr/rRJCwRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ciZPVZee; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ciZPVZee"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-38f26a82d1dso3364497f8f.2
        for <patches@lists.linux.dev>; Wed, 19 Feb 2025 05:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1739971512; x=1740576312; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u6cw3ZSdEjrvAZgRmXEizqKICNgRIdZIQG+x2ExmABY=;
        b=ciZPVZeeEWxW69wa3F3T/l3AcWyDjjvgRM6BINki/0tFq//Mju4eYEpDwdtsC2Bq4S
         IEUXhOd9so1JH05kwSwgDErR4YOhWKMJ9Fhcd+H6nIv4gfz+bc2110NJr7Y6SpUuiLO5
         XfifguYahoWHbHtyQnrAURvyMjHpYpBDga65FRsAL48CeTL+8Q/8aTN7RHJrry67PaQ2
         QgdP/KUMGKrp/dgh4TUxwD8+Jeklbxr24PEgIkCRsELYMnwoZQI0nGA15c+JnDSGXchL
         9XXNCtHQ1qabq8XqIraSuWCGPwhgDexQ19UZJEAxh5ugsXRealrV6Iur1Q2K8cgWKcX/
         9l/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739971512; x=1740576312;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u6cw3ZSdEjrvAZgRmXEizqKICNgRIdZIQG+x2ExmABY=;
        b=IqCNLAdoiSIzv6J/HjFoJMYZxGkRB0hGREfq/nojdgmoVX8zPfAt5mcUvTFmiwJ2/r
         Qwnm8ry8FtycmtIKo3+qrKRhrGZLfBVGm+hYN8qL5oI/+0+xYRHmrgUUKQx/6pe6porp
         TaRFAvBWzWsr3Q0SFGVb18VxpkASW+oUTOrtthYbxmoQJ66S9EuX9VZSVfKdd/b/fT7G
         u/H+Rm/SEnLjD4GghEUk8207WBD1DGlIdRp69pBDcZ/ZcZkgzsEzfLnE1L82KjWVOdai
         SB5Lo2+SQANp0k1bqQ/SJPeJRAo3Nih6FrbVvGlh2dY1/TerRFLjEEtzjdRBy8eojfZQ
         AvHg==
X-Gm-Message-State: AOJu0Yz4WrEPlfvQjaz6YihaASMAqn/z2yeWM2zS+20jdDONq15U+gJT
	V1s3lIMY7CFsR0cbFXF2lsQhSW2GWDrRu/AvA7SllVdcIy53K7k=
X-Gm-Gg: ASbGncvilcQnKrLttffb2TRpWBBow4hkZU8wvZeoWBZuphqaok86wYwtVBOOxR10miu
	lltAQy6E6TB7HzKHCUTcxWKG2Uz0eAdhNf0Ik8gtEHZiSoUJFdH6LWPtXE7cZjND+Uc4pjWsSaW
	dIPSgDDFJX6DEd2R9mtwBpXqh+ARzyFnLKdFnDiMJPzne8+g2HJff3XSs5dwcYFULnfsa8qAjhh
	JNeKoo0kfaSJfQ+MOANB20cZI+MD3KGDBkKxrLfKo/E+iqWtLu7RiWyfLeqFVRlfzHLxLRohmD3
	zREVCkRQrCK9xKAtl0RCO3nDHDCBQgcwenFNiEiQJwiVpl+s1i9gMf9zHs3FQvq+t0Zw
X-Google-Smtp-Source: AGHT+IGXrBbi/q1hJgvU5//RS17OQnmiXYoQ0w34hBPh40gPj5gwJOlB2kw6ykpMs6G7ieCkm9Fk8A==
X-Received: by 2002:a05:6000:1a8d:b0:38f:429d:7c62 with SMTP id ffacd0b85a97d-38f42acc40bmr11028735f8f.42.1739971512265;
        Wed, 19 Feb 2025 05:25:12 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4e7c.dip0.t-ipconnect.de. [91.43.78.124])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439922141a5sm58151465e9.2.2025.02.19.05.25.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2025 05:25:11 -0800 (PST)
Message-ID: <fffcae15-8cc9-4943-9021-06be5fd46e6e@googlemail.com>
Date: Wed, 19 Feb 2025 14:25:11 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/230] 6.12.16-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250219082601.683263930@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 19.02.2025 um 09:25 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.16 release.
> There are 230 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
