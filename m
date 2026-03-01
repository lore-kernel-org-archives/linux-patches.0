Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A531CEACB
	for <patches@lists.linux.dev>; Sun,  1 Mar 2026 02:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772333197; cv=none; b=V65YMS9k+I22wwvOyezOiuvUWB0mXrYrgl5qC9JRe/45/q9CMf76/HPBvv8/H72c2WcMZDGmHseRtlI++7KEf0niWZSl/LLokrfQptrtP4Iw7pjlXRWVU3SYhMPH5wio7FsTuAC6EPeVka0sMxEHjN9ExR413OGo+27Vwcx+DuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772333197; c=relaxed/simple;
	bh=no5Kl79qBHlskgJixUUH8IL9x8RELPu06giLQfu/fsQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tlRSlj4RMpQBRKoD/zLIH5Qq+2TpJEaHdyBzRzUqvLEB0rgLAGgJUXk9yzJNHsv30pYsMkI+dCbSXhVVaoQxnuH62qthlKlzn9puCkL3fB0vsiC99hb5bfNBQLyoT9l9sBHQ0ikA9oHyy83n/g4PSjcaUKMoJi19nOQktB+2Qpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=I/arc1WT; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="I/arc1WT"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-436e87589e8so3245051f8f.3
        for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1772333194; x=1772937994; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=990rgNafF4SkuRw2Mfccvvcy/96hM7lSZyKlDDeK7/4=;
        b=I/arc1WTcPsYRJ8TcF4w86Xu+MtsIWEk4Lq9FBsatn/OCaG1RdT1c3XhUElQw4aJ/M
         hocvTqNh3VMYSK7TGjRHAUiO9CUmj8cozXDg77k6bvsxEUOF3LOiYwcOS3vFifV5TbGe
         OaUY70Oojs5xPTa2g7l6p+RwVeN7Zwf4BJAwy+pfCx2r5ddItC3uq6PA1GIv6eVNl6NS
         cazSE073O+BF76flC4XoL7Tr1AwKu8jo2tQZyfYJZl7KIH7xKtPR/5UW0PLnpVcBbAjB
         z0ZFCd/QyjL9ELEkquOGlxezh6kNmi3MtkYZOwTVG31fFNhNXXcEaC/4MwdC04Gp0SP8
         g2Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772333194; x=1772937994;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=990rgNafF4SkuRw2Mfccvvcy/96hM7lSZyKlDDeK7/4=;
        b=GIp+6RrfbtICVFzTayqNXglFkwvStxT3wurtlxcVMQAWjHwbl0Er3KbGjnZogUqS6l
         svlz3L8gi6/MlZQrcpYfYBZu7CdWcGyrjUcz8zkRkA12mijEYrIT69ltrKvLx9UUnbGX
         6/Lgs22GB6qTOw+C7DZQZmkn8pBr8aVkD9+Y8dy6QoS4dSzAeIcZN62zO9ThRkbE8Cpr
         hGj/whKNrpdDseP1wxkggl5n81QHOuLJF3VC/P32Yek9fBZqt+kf/umwEzdUJv8vKh7E
         Kel94p1Mc7EPqt0ZqMTK/elZklXElYszrSKgebVklD9kv7f6nxvD7fafx+Kpe1IdiX85
         dGCA==
X-Forwarded-Encrypted: i=1; AJvYcCWSDEm+FKL4bqrrCC5B0rz5cMezx037K9Th50qV3BTjMQ1Jy/Sc6z0YVwPO894QAqUIILNUR3xi@lists.linux.dev
X-Gm-Message-State: AOJu0YwO055lILo1kUmZayC3/lPZVMHZw0zS4xZkjAr+kiAu3nQzD1vD
	YKt+95S1XSbdzeXEmcvvw3kD1oRrA3BFwLvdz2jrIwiLDqLDOtPHjKU=
X-Gm-Gg: ATEYQzxLPeooeRckjI5nSt62oAdLJ31snhsIkZQd5+UirODUAUUgvgz7NWkEigzRANB
	P4MvXdqNZS5NNx376CChl1mO9t1O86FZz10yQuNul0motrfDki97Hxh62/JhrrYL0jplEuRpHrn
	Cc4m0cx7tyMFzMtIvrFF8099Io3vJD/o6Dv9e5liEyFAUl19VEwzRuOvvA7oInO4EWVFJp0Kw6J
	gxD7SGvUW5G9Cq7Z583OjSk6sSaRZojbx0jG7Du1BxEUEXtMhtgCZ1NYHdGF6ZtQDbTa1YOS0BA
	NbAfh1tPr2GG7+A3uk17fZmhLf9l7d98CVsU6JSpR+epSJ0u16FVtVcx0tLWLRIZfDsQTjgYeAQ
	BUh/cSGoREz8NnmbF9Ybqw28sO/ILVmZTe8Z9xbLZAn60gr1daqvw6cqfQvpSXV79Qyadz9gO48
	j3HhQjt/EuoVFwLIKe07xIrI7Q9XInZgi8sQ376zBol/JevOjkByJv17QqZMplCLUwta40jKw1p
	xok
X-Received: by 2002:a05:6000:144d:b0:435:bcbe:d104 with SMTP id ffacd0b85a97d-4399de1f29fmr14234769f8f.34.1772333194152;
        Sat, 28 Feb 2026 18:46:34 -0800 (PST)
Received: from [192.168.1.3] (p5b2acadf.dip0.t-ipconnect.de. [91.42.202.223])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4399c7645b9sm16211510f8f.27.2026.02.28.18.46.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Feb 2026 18:46:33 -0800 (PST)
Message-ID: <fe1a069e-f10f-41a6-b864-c6abcab54445@googlemail.com>
Date: Sun, 1 Mar 2026 03:46:32 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.19 000/844] 6.19.6-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260228173244.1509663-1-sashal@kernel.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260228173244.1509663-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.02.2026 um 18:18 schrieb Sasha Levin:
> 
> This is the start of the stable review cycle for the 6.19.6 release.
> There are 844 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

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
