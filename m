Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B69C2F999F
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 05:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764827998; cv=none; b=F4Ot7dNWSebLjIWq4wYCXDyZVRcOQoJNzjnqRztT6CrP3gKoGmmt4fLtBJUJPx1lgKiFj/kKWY5QefQW18Ye22bq8If8p4x8Z76FylrfpURPzMAthPLAQHPx5UfHDzEBNdeAHfu6JQ3v+yZfw4PxjMd764cgYk9JRN5xRooBNz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764827998; c=relaxed/simple;
	bh=72hvBrbG4zzHEnzsLBUiKxK6ye8DrkxZH38BILJu58I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LW6Nen7ViVzFxqahHzr8Jqbh3am+9lbw9sOAGVvUVhi9vQMUNbKEm+jI+V52Dn0EK2x0MwJmDTRmHz0UJUIOSO4HsdeWX1Sy+ioEhvAD2QRwB/lYp1lthOaDt0ewTYpRlqdoi2qTKX5zkIpiyRwqxW3uAvGm22M2rKs+mtjmFv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=gYBQWu92; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="gYBQWu92"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-42e33956e76so262583f8f.3
        for <patches@lists.linux.dev>; Wed, 03 Dec 2025 21:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1764827995; x=1765432795; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QgS/O6/Sl8IAMxGl+9k2XWQCGd5oRGPkIOX63aTsOEk=;
        b=gYBQWu92s21tNFjZwoL2VZHGxlm3d4neWUvuEBkJDA3T21MYqz2TojnpjSaEo2Z7Sq
         dOLvOoOH1gcrLdleU3rn0jRwUyV5w101dNNHXRz6C/t2zwOSFkVMNr6YcHLRWC+wab8p
         TZ6pr5apCddFKkdGPKVP6n//7MPNs/gFZPcM6kmVWtJSCqKdoYn+hwJQ0d60M9fN5hdA
         IyzxvtGjFhfx0guT63umIt13RIC3mRon3vyaNj88KDssvcA3jM1LDpSdWQeb2fNByaEq
         tlA/XbikLm5xwbJSH+Bkn12Uh9STE1Pv+naYI5B2G/Mr0q7dpUvNzWMAF8P4VL5JvsAP
         ET2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764827995; x=1765432795;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QgS/O6/Sl8IAMxGl+9k2XWQCGd5oRGPkIOX63aTsOEk=;
        b=Kc3pmEhyyxS51aQwxcPD0sviysbpk7I+21zkTOJGNSQNvObKy5cFsyNRER5Aykufvl
         KnGHUHe8roDrA2pvHeQdZnsXfN6CjwEcsVPviDyW6ZTw3r7Z6fMuyTf8CtlVikPNNv3g
         h5wlbdDi+b0M/qVyIbkKqZFKq/8nekP8FgCPLogEbF55dQRjUtLsNmIf0Fs6DmoKNdQW
         +Xh1aMrvrpwXxa2D5zMN/jAASIVdMLxvr3jjFmAv6LJBcJ2O6UPSBgrzAVpNi64KYONM
         4ppEvsZHAXq9sDhfap7/j+/Y9Hf2w6+WCcmCg6oSbkvQ6ACFqNYixngclrayK+WtkZzF
         Cc7w==
X-Gm-Message-State: AOJu0YxygHQ3RLFswA4eQOgo8C0B5d1mxicGNQ60NpxVLM9mEyPIpXAN
	ejNz7Mg7UNbHPzFqxzr/zwz8OBsNVNH3ath1enPS5l1U0zBOn1hFN54=
X-Gm-Gg: ASbGnctGd7j/l9nJawECHFn/dqLOYUeAavOsN6AiP7km/i4FBi4ijudMc5xf/MbaMlU
	oqGpXTiJjpoOFSepI4nVfw6AnIFmJu2UhGlzo8lnOcr5hy78L/ttxpEjUS9J2B7RR9LVRv8+kOQ
	APvWTYs70wMmJGlxJE0tca+7EKRDX9c04sJfzUm95SMSDWV8LgVH4uRq+GldIR/c5c76RHriQEa
	pL1Ul7iPsz6tHXZsMW4kbYr7+V0dS9npPLnei5uVZWXFrz3EXP0ZU01MH32Je5Wfs8ilgInAcWL
	zI34h9ExCSFHrTdcaAA5opU8ZVqzC4ebJEv/O/ThIU72n5AFi+2K103TEYSOW6+uXy0xYz1bTel
	znMJG9frUfLN2Lyqzk6PDcRztoTIIAil3n38SOPVtN+eLmdbVn4AkV6A6zO6HXSoJsuWHOFH2qg
	k45LvVrLFvzbjMjvCYhAGUh/AZt2IuZiE6gSz7ZeRVb/W0+0uSwuqkcbRwisJ9K5Wa877XcZuCM
	3Y=
X-Google-Smtp-Source: AGHT+IH9D+k1SnCVN25YpRn4b/dyEdDyhiW6KnqgmakDVpUUwqiq+qosJE/0arN9UTx1Lm+BXs4wFw==
X-Received: by 2002:a05:6000:2013:b0:42b:3246:1681 with SMTP id ffacd0b85a97d-42f7317d5b9mr4900772f8f.18.1764827995335;
        Wed, 03 Dec 2025 21:59:55 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac6aa.dip0.t-ipconnect.de. [91.42.198.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeb38sm1199930f8f.12.2025.12.03.21.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 21:59:54 -0800 (PST)
Message-ID: <cc2b0762-0dd7-48fa-9630-8bb895cf9ca7@googlemail.com>
Date: Thu, 4 Dec 2025 06:59:53 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/568] 6.1.159-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251203152440.645416925@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.12.2025 um 16:20 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.159 release.
> There are 568 patches in this series, all will be posted as a response
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
