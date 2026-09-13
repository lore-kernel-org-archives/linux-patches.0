Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BB43E171F
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 10:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789294472; cv=none; b=av8w+OmmH4yCaBNzVm6EXRu5HDUvWY3KKw4QAESHix6/9qecAdLsD6+fUKF67Uc565hfSqX19XVUC+LG5VkLSTHe6wQWtXHuvzNOQknq3gV2mbzFNpaTGiYthe7j13QG2ilTH24oLjZ3B2ZE1qC76cGoGKM14hXKenCI0Yd/a44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789294472; c=relaxed/simple;
	bh=1kt6d8FnC0B98nCUGE+SmlFlqx1hfYRjftBJJGy4rKE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l9+hvhAwHDOkD7OaKPBD36neoLy+NNLvuXLcbqZXF/jz3Jq0lx9zuC0c6YgLzS2JHSe56Q6kwa1RiHOzJjUfUX96Dqe6k20okHLx0sTvQBWUkwx5hey15CiOWP2eFLsx+wfXCR3XIWzR2ropRZcwx5QZTa4Q8IcLHjyR+m7/KlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=m3N5hGIN; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="m3N5hGIN"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49e63568bfbso18430205e9.2
        for <patches@lists.linux.dev>; Sun, 13 Sep 2026 03:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1789294465; x=1789899265; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wBMZeq61/F4p0+3rD8e6cPnmdSCExohBg4rHJSwrdv4=;
        b=m3N5hGIN5/iOzAsmXMZfTdJc1YUKrMIJD9qi/edKbsqtSUL3CLYg5r0KqzR1l/1Kla
         n1XzkeW3yUS5RSjiYxkiHJKPUlDw/v7CyoEUI3zzoA0wWKNWNFVFIffwVujpRXFYQS3e
         4UPrnFmWYaJwoTVyKIBAN8Viyk3311WWfPc/8ngzLYAvxTK2LFSvqFnHu1hJfYPbfQtM
         tp0Eyys/h6HKWZvy4kkfzVVfg1OKXD9PEewlm+6PzT/U8eTmcmzMP4okosfWnBaxK/1c
         fbrtL4h8ygmcJpA2UgYEQhlrkNDH4WDrNQBgZEF5qJ17mqnxXXtkVHUyK8yCeD3fKZqI
         SkWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789294465; x=1789899265;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wBMZeq61/F4p0+3rD8e6cPnmdSCExohBg4rHJSwrdv4=;
        b=bEKf98bh3WTBdizjxWtHtJrGtLqtWXxhoXO/BR3pcJsJSknJMAW3ySNsRIIfMbMq4Z
         0cZ9cbghTOZchA9/YHGZIk6h5Pkf0qAT5Dnh89gmcfk0wb7L/g4kLbIo6X70rA71X2JJ
         Njcih5blrmt2P5ohEpQ77UoCQv0BW8yD8DKC4jL+MjkpV6ONaMTkqSNruu9mQXmSkt4H
         XcNSJoxqFpnZNABXyg/SVX2LFX2/0p5TrkcjETc/Q6HCpEvlLd/uYU4WYHDE2x++iXQx
         XzXmly/rHV/a82s7LRHIFl2E1GzjR/E8mEn+6M9plaJ7blf3N1iswudn+0z+TdhpfUo9
         JPUQ==
X-Gm-Message-State: AFuF++mOpLStTKJrszeXyoIVjExumpzTYA/NaG4wyypEaUdSq3X/6ZyO
	jmdo4+vw1JGVH2avTpOqeht8Rvu7BUcttkwbpXL+rvgnG64IcJHZUk8=
X-Gm-Gg: AYBFou2XZtYAiiG0nW5fwL6qOoFSsGpAxwQY3fm7uMi1lxsKBRnOws6hcPPEecL9dYj
	CXBIe0FfgAEIlNVZM4TFpdd5COnKRB+qIL3iltyhpFd08P2SIKIN+r3etMl18QKaxtrDhzBMltr
	D/tfgrpSaslc6djY2zXThi3c0s6GA7vWTzsIXnEDIWKMBrW1DCHRqovZqoCvkjXbgAcZzMkkC8b
	Qny+WP13cXtLozCJtxpPRGkxG6NvyJiF/krg2h8p40Dg3VPCqpAn0jvZRXlGUSrftnVuSV7H4RW
	0VUBf2Pq5Mijs7PO2XO5g8WRDpnYI9g8Ui7Gz+4s3h2oFYEesrSQktE9XjgUjr5+9RV2SiPCESw
	p8VkQ7sznF+hQe0FzpANyGIFSJyfhuH1UZPm78LagNmeytK5PKTlqjdmIlYPhS5PTr85Co8V5b3
	GIIz6vj0zctS/9tJwOlNq5cfTMRmqrcVuOr2GkzlLKWGiebGapxKqXeYrmYPhH5/DdXCe3WtdRZ
	Ary66HlLvlV1F0kF/7uDIGFeGMXhadUs6c2UxsH4xpFaB5P
X-Received: by 2002:a05:6000:420f:b0:485:8c16:5eed with SMTP id ffacd0b85a97d-486eb2f99fbmr13029738f8f.39.1789294464781;
        Sun, 13 Sep 2026 03:14:24 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4716.dip0.t-ipconnect.de. [91.43.71.22])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb33e020sm19329616f8f.18.2026.09.13.03.14.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2026 03:14:24 -0700 (PDT)
Message-ID: <b8982310-19ea-4ae4-a849-537af8950117@googlemail.com>
Date: Sun, 13 Sep 2026 12:14:23 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 0000/1191] 6.1.188-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260912065548.086904252@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.09.2026 um 08:45 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.188 release.
> There are 1191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
