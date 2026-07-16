Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF45434CFAB
	for <patches@lists.linux.dev>; Thu, 16 Jul 2026 20:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784234148; cv=none; b=UGmhsoKwgqYtBblsg99HBxd+PTfzu3jnkknWBLrNWiAO7zhKmMC7RLJOfZ09MH4/bjCKxZU5VuxkvTHZ6mVANFCEsx2rien0Oe5F/GLZr3uDGnpO0PzQD1laefOUs5OR8/27fIB+h3U0vwPphj7bAVKwRVfzd1ZHUkEPkMuOy/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784234148; c=relaxed/simple;
	bh=uzYzUOpCUybuVsbVA3DcsY6yHybI8URN7D+i+1CPVTg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=osDPbp3WSyYgYmlrU8VnmOHx7B1sOu8w6rwOgbzIhko/cwiISkGl91aiVRbCg4OSxTWMligymjThAJFUT1bWlm6obj3xChqGRbhrG4UkLh1giTdYYUbYnrB/GgWLLxYyGid+9bWwQm56l4baSviPOfYuc5Y4iPF6OUs4SUyf1oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=SgZgwiUa; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="SgZgwiUa"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-493c733f15aso61854765e9.0
        for <patches@lists.linux.dev>; Thu, 16 Jul 2026 13:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1784234145; x=1784838945; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2c1DyXPkjEzI9dz3oHSPFi8xNB0t5SPnNQYNpF18ngA=;
        b=SgZgwiUa94FFg4S6toJj+/B2Vm9ZbqQsH2vCXA3Vpnw0Kxon4ck2waZ3nNacpJNPY+
         3dN0P5Tmz/OAUhow/A8KoSp8Z7rhdo55qN8r+Zes8JAE+s5KnATMuuNYhQhFLr0gCkxE
         7liG69B1ACqu15ESe/A1Sa6tnhdVOXZOJibCx2nv53Q6UXnSzPZrfU7/vTN22X5K1ZfV
         1454HuICpxqouB5lppx9NaaoT369xFuGEkxlem0DsUuF6gDJIcbqHqJl9P5fz9eyPkXJ
         VqUOXxdQ5hpgXuilTRqdZ3JpIiQDbVDjF7dXkOazwfUOI4iOQWj1ZjCPGGQc81i3WcMm
         XpCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784234145; x=1784838945;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2c1DyXPkjEzI9dz3oHSPFi8xNB0t5SPnNQYNpF18ngA=;
        b=j0xziNBGlUXFZVYFFimVnBVin7qWwq6HPxWEkkOb8xuTxQHGT7uWwK5F3Ej1KoSd/U
         415XWGrtFbkiJnqim5k4hDOAuLfPvO0uq3dYNAs450F9kZlEfR5HyNZqOXytwRRPImJh
         iwfucdmBMCGs/AzLESvovsAhoD0z4EKudIaf1JivcBIPbZYXR0jSckfyKUkg7WQkx+IP
         pVR74tALuRevvlECKfBWmyREzwE8t7FsFfmbR9Rj3LxgjXFGNWjq6zOzxs1uLrmhAyQb
         SzD+oKkm8JLyuoDS+oRnVjaSPpx+t/aLNTQ6lYFm7oXfv/RgPw98vzmEd2WMDK5d1+Ud
         CNkg==
X-Gm-Message-State: AOJu0YwuyS7HmU29KwHSH+l/H0DPHEeubd4zUuwTcgmvK7fNMBF14XjZ
	Kkv8gLjfOdmik64oX2yEX2WMpqdW9JjdrlhVjtR2MCan3LnEj+FMI30=
X-Gm-Gg: AfdE7ckWHF/BQn0m6ZlrB3zIZy5zSfVH/W7TdlJrXbt1wqZ+OsdC4w7XAhG3yOQGOQU
	W8j08Keh331Mu3+cCgINp/2Q8pCbCkUN0bj4ImCh6Bsm76HXY0zEDZf9qAflp/1XcT5t/Td+ZOv
	yAgSlHVhMHHSqYvUvIwOlvZ4L3RXM8e9vW0hry49g6gA03UizhNxm8RU/7nKiOC1jvva9Hpmse2
	SxYn8MhXs5k+tkzXd7qTGcbUf9Cg00lvdxzb0NNR78EzDU+qE7YxJK/Di0zd8zn2nfZArLVxZlP
	JeeAm13fkp63D8WNNpJfa/+NFTgQI26y3bAcrfOsz9vfJh7iNWWVzrq7fw8l7XHamoSkV19dW7Q
	q4eyjTPS/c/tr7h+IUNNmHL5e7f4pCatc2gu9u8FJpukEFzl46qcXW6AuPEciBMy1eDFUu6Eaxw
	ucFifQJB4oygvesWWOAUtTAzONrtEHa6dTl9IBPSRTSNAiH8iNH0aSXw==
X-Received: by 2002:a05:600c:1f8e:b0:495:4598:6e14 with SMTP id 5b1f17b1804b1-49545986ecdmr35345505e9.24.1784234144880;
        Thu, 16 Jul 2026 13:35:44 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b44d3.dip0.t-ipconnect.de. [91.43.68.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464b7f84sm25780178f8f.27.2026.07.16.13.35.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 13:35:44 -0700 (PDT)
Message-ID: <565b9102-031e-4fff-8d5b-9352182bb44a@googlemail.com>
Date: Thu, 16 Jul 2026 22:35:43 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/480] 6.18.39-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260716133044.672218725@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.07.2026 um 15:25 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.39 release.
> There are 480 patches in this series, all will be posted as a response
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
