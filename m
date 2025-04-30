Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E550126F0A
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 03:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745982232; cv=none; b=K765DLqJkVCVzJpom5j9TUwzVwrguuTePm5Oo5rYZJIJluposHUCjndMdWW4Xe15NiyT8H0h/UW+zWQp/zn7C9KI6csRhEEG4VPApgrvpWAQVcYY2oZoGVJaC/1spmI9vCg5Es2UqY72mshPMJ1ysKaFl9QtQjEq32Xt/1ziYjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745982232; c=relaxed/simple;
	bh=flJyldUPUjTdxfP+ie4pglwXh2rhaGbocVUL5PwSRPU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kp8+NorbUNH0XH9OqDo8hRaiOmwIot9T0MO6FeAZb7omoMvKgwmNlZCiscMqkiXLUKQQDl8PFlIRnE33yWRqa6w5J9RD4h1royAcoH/N3LPs3iWIW/YrAECGQdtrINwEqPb3PeMba88YkUDe1VN2RfR97zxC3c1JxP/HBZsOJEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=MY+9Jk4Z; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="MY+9Jk4Z"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43cf257158fso38164505e9.2
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 20:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1745982229; x=1746587029; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gE8L88GgBMGbh45ODSYqjl77s9d7K6gsG0j9QpojvBo=;
        b=MY+9Jk4Zt2ymyyh4YMYsxA9nDi+ylrZV+jZHK2dwizOWBPpXScg7wCgJb3HrXUe6Eq
         MMLNpV9YiqsgEUapHEMT5m8hX+sqny+2S/3sMcV8c5qTT7KFHN+ECKE1ghSDEFv7UUw/
         cbdb0OPfP33ytjMLjfAtdYMf2q9wvQgxdiQZYqrJSgzgRfTJzGBDmWuWhpt38rDIJL0E
         wNxadkZ2CPEHJn4+LPHWy7iwplcXzUbSFgInfb4n2WCRDgc4YD1p2g/vjGQh4erp0XqF
         79gWi+r2ylmoKoilcFbj21RncW4K9sOCZPFRZaZkzacjeVvT3kZFsUmx+0W+tvDIcYIL
         gO4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745982229; x=1746587029;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gE8L88GgBMGbh45ODSYqjl77s9d7K6gsG0j9QpojvBo=;
        b=U9nSvQY/WR1q/VIiV+Qs+hol7v6f7jR44CBvOCfYmjS8LJRPU2FgsRQU+H7bHq/mGA
         X0pEoJNh+WxzIcllEVBSJY+ORB6BboJWfLuO0x4fxiGV5e0jvrAGtvK27bkq2LQu6+MP
         XztX5o6jAsiK/UQUlrn8AGwmkqTR/AoRPd26K6KCgPrv2XHloAs+Wnl7fFG+4KqRSlb2
         1RXYvBvjMuepvmSPH3ZmoLOahJN/q9VzifpogDFrsyWNQNkhFw5jTTR8WFrZzXq4Vzre
         dWhQOm5XopqwOsaAw0LLPjbNdmQB7wKVn70sdF1X5yLAKggiDs/CwfHOK5LCAUWM4f3s
         XaqA==
X-Gm-Message-State: AOJu0YyiPU/Eny3uiakum3DG1XXwp4LRpejzSQWhHDwKUyNkybeJ+17F
	zO/tElg6mPSUhgW1fTdPLg2k7fxTVEXaQBVceb9jiz3s5yFrzrA=
X-Gm-Gg: ASbGncvCzEKI0wmH/EtIDWzbaOaUI803hh/fA0JGp5nwU5sjJAdlvge0MMoQ5nvkBOH
	qRtY0xf/ppDXTGCDPWtxtqfUgOlLr21y5FXkgiA/Q2QpAtAiS+ChWUp0eY5GY/fF7nR+2Ju/QDZ
	A/MuXtmY7hJcuFB0PfIZk3a9whcruo6yMbN3GVOyv6Ub9CaWjmH9mvxNVtizfHMCUH36KyUJ/nG
	S68NtDQdzRVjotAHOxsbwcxurRYawaSk0rhWnWsQg9AEw6Aky/obz2v/tIz+Su8cySDWXBnDBb1
	eEeOusy7gPd4l3y0LJAx1zGZ21bG6bOR6PXVWZ/snptzMHHgjwEsh2kFCXMYMQD7WbCciUQYG3a
	KoEb0hqHEN00Ao+XYd5o=
X-Google-Smtp-Source: AGHT+IFuSFCMk2NyOA+Ab/UGUF2QS2kK1ZDDDW+pqr1XFieTUQv3rWtf7EKj7LPcGoSe4pwrbjCwhA==
X-Received: by 2002:a05:600c:3d18:b0:43c:f629:66f4 with SMTP id 5b1f17b1804b1-441b25dd103mr7939065e9.0.1745982229350;
        Tue, 29 Apr 2025 20:03:49 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac6c7.dip0.t-ipconnect.de. [91.42.198.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441b2b972casm7710135e9.3.2025.04.29.20.03.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 20:03:48 -0700 (PDT)
Message-ID: <8427fad9-8c45-4fd1-9675-bfec041d3028@googlemail.com>
Date: Wed, 30 Apr 2025 05:03:47 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.14 000/311] 6.14.5-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250429161121.011111832@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 29.04.2025 um 18:37 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.14.5 release.
> There are 311 patches in this series, all will be posted as a response
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
