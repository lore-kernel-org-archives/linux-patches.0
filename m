Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624973D9029
	for <patches@lists.linux.dev>; Mon,  4 May 2026 17:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777917191; cv=none; b=C/YnjjktECWvOkQZbjzWuGyD6QoErbvoSRQl6JOk1JVxAfT8eaTAhjyxJ46evB4DcZ627HtLyr49G78K6xsiCv9EJHu1HMHIEfCBg/eUd7A1TZqcImP+IxQvqwqF5XSLu+MyhSPWrfnGvyrjYmP9pM0y1Pnkj7qkEVE72Z30lBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777917191; c=relaxed/simple;
	bh=A7zVJjk9p5b3yRu83h9R1sY5YYj6J5Nheuy0BQC5sws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tMucoAuO4YOp/RyRWoHdpzYFYMSD3BPD4tbFlE+lvF2b+dpubDvpdAYBnLSTaWi6bIK5s7W14ZmLR7Lm1NdRNGrHj+3Bx8EdhdDLxSbh0gqXTyZRtTePkZm9G28m1KGG7hsY2+fWzeCdR1yD0p3/4OzN/C3RTPIhFHDFT3TarwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=RWrg0ztZ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="RWrg0ztZ"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4891b0786beso29896925e9.1
        for <patches@lists.linux.dev>; Mon, 04 May 2026 10:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1777917189; x=1778521989; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FL5be2Iglw/AASVY1DtldbmAqjumnN7JHWuDb6ACSFc=;
        b=RWrg0ztZzfSELk9LlbkAeocY5cqJ274wSUd9pYAxKvR13Nmg986Ch4aMCNSwCIwHpl
         ontgjRvbN0lweW5qAF6zFUR70pR4/HKfQJ69/ssfdCOVgrwPsIhq3jXVB8qGbvk/soeU
         zqnoE9YA0kijC1Q4YWdPUkfa27LBNRXWYwQ4AkDb7wjxKeWAfv/vjr5QCW4Wf2s9QE/u
         7yORB2eDgRoDviU2an3Z+DkkrytBhJ8GFAoCKG4UmetyPT5Cd+KEuCJeZySGGMSbJpqa
         ftnCCATSlMSaLUwHpgMYOZKRNdPmmV1KM+MymgAgaapf8IqvDWkXikbmEfRkJVSbh+YX
         9HRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777917189; x=1778521989;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FL5be2Iglw/AASVY1DtldbmAqjumnN7JHWuDb6ACSFc=;
        b=VZy0jrDKEk4i1UWPt3XpXirSu07jHEqavKcptUFcZn+xDkVd2cNTMg67XYmbARRaad
         UdjzbwC3yFsly+vrytknhW4rQY2iucDC8IKTzSIaZ8IsFVzECAVmtKLY0YQ6kHhhyrzC
         MMRrHQLWfzg35cpa/r+VJB/h8/5BnLLQCSyhua1iXk2By29g31rB+Dd0U9EVYjddE/LJ
         hE5Mlt2C+Z7Mimo6pN8Z2wbK2Jm5ics8mtObMbhqz3k4Y/yQDBXPO7IV0X04EC2wK1vV
         O36GVDp5BuBKTOOrnrlfNVcJXzZ2I+MM9Ef3UcW7tWp/9Om6QUZUxJzQd0NNcD57dT8N
         Ergw==
X-Gm-Message-State: AOJu0YyjCQKv8VQ0Ou0EZl1kq+LOlZVDN0mG2DV1zmoMyF7NRpePeLYm
	Qa6vVR3wM8JvgYW1rae4C1ewAKFSef1ntzzCmrY8OVwik9lq0gdxcjQ=
X-Gm-Gg: AeBDietRA5jDo2hnZwVqk/RGDdyKlys04EUxNH2yo01GVmtx8BcIkpuvXPhPQu+xUvX
	lZj9+a95QfsYymBnKpKbwMv7hf16tErp9GlG28GZHwfyJvusMKjywZL5qMdNW/QyJ9osHNFDI+n
	rBBi8cKrVoHYyeBn9GUJ/vQdPZKdji96W3tudP3DxZPGvBlmGSuRK24nbG+tyrJSbuChQth95EE
	q6iOUSfG1/e7U7G0qvEBl2aJRHdQN8ZZbFmQmXg3h0qUinIefM3XDQJjYpY1MiASPBkCwHWaqey
	y11OvziLx3/0tzKJchBWhrPx7X2/OK9nI75yDpBkoincb1eJQ3OLgRnZSuvbATpJngBPi05ZoK4
	by3rRLwTBjZn0f35vwUoqOzPzxUjpB5dVXFaZlBu6wYm3E1a7KG1RGNrzuQ4OOL9vLl1FsWC/4k
	vJGzTBHw71DkBIjCqVVC5vnT6bZqCwrN2FRW4Khhvx0PWMXjnwowpp/+tfTSLOn6wHz9qAGC1Xp
	43alc9AEdW/RAQKRA602E7N
X-Received: by 2002:a05:600c:8590:b0:487:5c0:671f with SMTP id 5b1f17b1804b1-48a986381b8mr130493075e9.9.1777917188670;
        Mon, 04 May 2026 10:53:08 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace33.dip0.t-ipconnect.de. [91.42.206.51])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48d149e8a09sm425295e9.2.2026.05.04.10.53.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 10:53:08 -0700 (PDT)
Message-ID: <390906d7-225f-4d9c-b784-f4d7e52a1203@googlemail.com>
Date: Mon, 4 May 2026 19:53:07 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.0 000/307] 7.0.4-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260504135142.814938198@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 04.05.2026 um 15:48 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.0.4 release.
> There are 307 patches in this series, all will be posted as a response
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
