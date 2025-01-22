Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DA6214805
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 15:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737560932; cv=none; b=eRXa5cR9DEQPM7eLXxTUoYtHAFKqcHOlOsj2KrJzuF5y6YGcFclRA236y4q1EuicDBoF4PxsRvtz44Phy6WWhNH2McIVqJ4XoDWdFSwwtRR/63Yflz8C1j2TrOK1Kos4T3cvxrLPgXAZaWOt3oXPhCb2HkhnZgR9qshNlu7/vyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737560932; c=relaxed/simple;
	bh=dc+GqdrGn3daNaaZ4C2Z/pJ6G4ucN4JtXuHEYvQsj0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eUISHkytiw1iXOdCE9pj0uow7+22vkYG2DCYsnQBFfPj3tim2bobhh3+gOaDSNxYfmPW1Mor5h/VzAJze9pJVaH7Wu5nqbKVTQINq+W3E0wpMNea2lvrIUtbhcWW8VeHxahmUmKNo9nWWUiQR6htRb7gK0cTuPE2x4uyl6jsi00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=bTt4/Oss; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="bTt4/Oss"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-436ce2ab251so49481205e9.1
        for <patches@lists.linux.dev>; Wed, 22 Jan 2025 07:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1737560928; x=1738165728; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AsDcFrsPme3l9DX9UB35yNaxrFvwCBk6agQsq7R+/iI=;
        b=bTt4/Oss9XVgSd5WcSuolospGYOpUO5iORKMUtWDrjkilyuqu15YlTjahP4zqcvqb9
         WoHpnUr9S44wvcc+h87+L7Aa0wvgvFJCxup6jyGjSWwIX0BWIj0TCq34N6VD5oz0ueBv
         AyMHaLwgFNr3NypLnPPom7PCtUq/FRMdfMJYbmkoOXc4cBhBaCX7+Pl1VCW8/CM/pI+/
         1ddTnJsgMNwnOlYU3rUo2QyK59M5VfleRFFMdLaqFBxSUbbhUjhpeA84sR+07GuPIGrm
         lPC+lR8H6QcKKsASWBRM8qH17lE0SkhrVne5p6JzU3PIFhG9UnoExrL3dXokX02SfAwf
         6auA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737560928; x=1738165728;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AsDcFrsPme3l9DX9UB35yNaxrFvwCBk6agQsq7R+/iI=;
        b=gmmtSIC2RW0MC+oPzSt+eONcT3WzZ+ufPS4CJCvBmO93UcosddSfS8lta8g05umcY3
         /ZtmoyNSolhmfAbIA8Hj1U4jpVrkVcGAFUx8PB9SStaXlW+TYeUt8sUwThSX9bVkzHqk
         bUqOIZ1i9EBeVAyEa7oZfBQPByemUBmLhHhWTR6+txyunerhHtitZ0MnYp4BP2OAU4E+
         h68puVjGJ589wtQnSR1MqITyvXpj6fLaD5vJm/CoTgRKTJTXYg4JNFKQgjEBr/+hQGtq
         SGqilHeC4qVa9L01eAd/xT/bL4cL8AL5UfzYIbkNQPvgwkfHKwA/NwJQMaDNYm/fcJqD
         TaXw==
X-Gm-Message-State: AOJu0Yxp5fUjcbsaYhIutg7Q+PCgTCppMJxQMSdf5hqhKnzqU3CpPTxl
	6RygwissF1u8N/Wel2Gq7i4bHX+Lp6P6/TFlK3vfo+85DQYHu/mCxwQ6vqs=
X-Gm-Gg: ASbGncvjKlF6810zLQIBmpF+Tv7c8nV8tP/OkvPgMJPPGbFcsNpK5Nwb+FjzWHjZEbF
	TQ5L6KjlenxUwp2izl6EMLw5FI9cWVwzv7jWLU7/ag/0UxFTa8pd2j6PJ1yC0bfdDB9izkxm8O7
	BZCT9uUUSKENK0eJFWvfFy7j7/Po/n0M9ryHYTnkdoVj/mecM1DnADdHPudSriTJQwChcwKfa8u
	UwHZNgCOjklo2k1nh61dVaSTGgb2QjGpS7roEntGy+sE4M9SmVMytNQkjDQRwfJdU2l7CpM5WbX
	e0Hgdv6sXGjLv/YzhU1HBeLcOcxMYUfSzX4ziCQOBnPiTDclDHaDlrzcDg==
X-Google-Smtp-Source: AGHT+IEKxgxW69fSv39uqAq1GmoVXiT0kxTzQy0QL2ylYV6T+j+9vNHPLMq18A7CHF9to+mRJnLs3w==
X-Received: by 2002:a05:600c:138a:b0:434:9d62:aa23 with SMTP id 5b1f17b1804b1-4389142e88dmr185142395e9.20.1737560928309;
        Wed, 22 Jan 2025 07:48:48 -0800 (PST)
Received: from [192.168.1.3] (p5b2b407b.dip0.t-ipconnect.de. [91.43.64.123])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf321537dsm16871670f8f.13.2025.01.22.07.48.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 07:48:47 -0800 (PST)
Message-ID: <d3b843ee-edbd-4577-af04-1f6cfca89661@googlemail.com>
Date: Wed, 22 Jan 2025 16:48:46 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/121] 6.12.11-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250122093007.141759421@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250122093007.141759421@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.01.2025 um 10:30 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.11 release.
> There are 121 patches in this series, all will be posted as a response
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
