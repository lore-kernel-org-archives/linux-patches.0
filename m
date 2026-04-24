Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168C637B01A
	for <patches@lists.linux.dev>; Fri, 24 Apr 2026 21:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777067109; cv=none; b=DBclwuiQNGaQs1gLozD8RI7vr1iMkqnpTWKg9U/K8ZqhU5KHpJPs0HGqB+L6Gbly2a49GUOIovM7uWS1ETQTKWwpLAjhqx2JEntLz1tcprwUUhBgHIkreQ1XOPTQ/6cMzKuPk5dWA39CT/PwZtBGLdQ8OTL5+r5xDhVEExt5610=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777067109; c=relaxed/simple;
	bh=VYmtfYUDxWUTjpyf+Tzlir8naKamfgNhl8+b6UQyOHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EmKayDjlfZ5RZP6ynijc8FQK7nUukdGIR0X2dKRvlnkdMaZnX9legqGMLK9AVQaFP4iAkrzPAVr/F44heX4mFBiqiA9hSxVegV2EOkHx8CUaDsHL7TTvwXYgvGoI6/gfyGLbCltlmEuAciTfMtqVeCkjUj4bkxA+7ZtG3g9VxXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=YLIJGaXG; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="YLIJGaXG"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4891c0620bcso53758455e9.1
        for <patches@lists.linux.dev>; Fri, 24 Apr 2026 14:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1777067106; x=1777671906; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b2aI81L5chyLWW9Y8pZFgdge3TQIZkIab3J5jWZXj7s=;
        b=YLIJGaXGKt/i1T+2uZaqkI0IJmyjcPwRxO005F5PNKJu2HbooPEsRgQp1STEuNOFy3
         ODLs+GDF5/zOR7U0pCkTwuPsqJqMdLQw0RZsnhORYDCX3zWZyJsXYWAiDMQc0Ydu9hEx
         k3LnNvI1hJaHtxt9/8+dtK3MfTTBbbNW6wPZiAdV7pMX6TQnXiDUo3CJLEmJxwdXw4dX
         oI7s543rlsN6jEKQt4h5xTjRRpHVFfElevubU0p+YBHCt56POJNzJUToGYP1tngO+ZMD
         QjJf6OQ2eSjWCbNqs4XA78zTF+3DoYcgPA4n42tWA4KENj/hgiE/H2aJv1eGbI9mDIXF
         YwFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777067106; x=1777671906;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b2aI81L5chyLWW9Y8pZFgdge3TQIZkIab3J5jWZXj7s=;
        b=K9AR75Bqee+r3xpTuPfnE+EwLARBOBkgnTzfg5Bt1LjPW7FdgpU8shWHeOMOboOW1h
         knNPOZjZu6t9n04PvMNgpYcyqLQLxP/+jcU4dCkufX6JzoN18EkS6EVViH88BxVJXT5Z
         QHjsqzqdGbj8snrH4jvgd+mvFJZRtFKM7V+ZkiGFdHsbfFeRFuv7btHLMWVHhwo7vBf2
         5MuO0FCMebfv45/I2u0OTHt/nLrJvyd90SlTzfoBMYtmy4HYByDtVuyFbo6bOIcA+JwD
         2NXKCujaBAeu1Dw9g2VHfiuvk5q7iInheEBXhUwTTlwNdHgRFfn4XFBuPB+x6Cr6/AI/
         p3Hw==
X-Gm-Message-State: AOJu0YzDSVoiC2Au14XHz9XE6kaO67uBlk74kpRDKk4xNwK2oOvfCWp5
	BewLIbPTQSb4vn1MpcUefnBLENMgJtUUGnCSolXI0ga/3K6ldzRtHIw=
X-Gm-Gg: AeBDieuq4Pkt5TyUk8feDWKywgX4IpoILNTCr42xmjStYT/SU7XL1NTOLPCcwyXGmES
	p34g1NtGMcSfMSU8b2/F8oEkge4FRPgiMyeB5Z3M0BLljt4PHNrX9RzaHmwkox9vdhesUmrSH0h
	PLx5pOB/OIWIdJtOKauPiyyMUBcw0SGBzR2k5zq/U5Uhq3B87H7kT5Rxx1Fvp0gbHsJ5R5CEnIB
	3+4QYN77RrAGgnoFcwSaUEggwANpnjAnHNHBPTTAshdYsbI4KhQOuCbwOacTeoC/T7YPcODSbiG
	UGiC03KC1lgf+eF2i5fECSgBvQ6IGSZxXi2/zzLu5tnyYRB04+O9h9yWr5LZFEh5na9SajT+9cH
	98Myzty6WX+V1fVoxiqgtu6c+D8bWByha/u6ZqjP78XR3vfgcNro35hBhabF25OBk5SJpbsc/aj
	G78PZLBHxPg8auv19AZeu7VwvNgu77au3zoc6gO2WArBlmfayfEOfyrOsqzcDp9wc/zz1F5T3zK
	I/iv4oHcaNL
X-Received: by 2002:a05:600c:8b8c:b0:489:1d74:56d with SMTP id 5b1f17b1804b1-4891d7406famr365430635e9.29.1777067106240;
        Fri, 24 Apr 2026 14:45:06 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4e21.dip0.t-ipconnect.de. [91.43.78.33])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb77b001sm295762485e9.3.2026.04.24.14.45.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 14:45:05 -0700 (PDT)
Message-ID: <60cd58c5-26e7-46f6-8071-08e2fb0705ba@googlemail.com>
Date: Fri, 24 Apr 2026 23:45:05 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 00/55] 6.18.25-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260424132430.006424517@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 24.04.2026 um 15:30 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.25 release.
> There are 55 patches in this series, all will be posted as a response
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
