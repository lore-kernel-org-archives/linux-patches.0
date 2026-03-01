Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A532BD5B9
	for <patches@lists.linux.dev>; Sun,  1 Mar 2026 01:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328563; cv=none; b=oEq/8Zoq5kylMbXJMNEOfs3ehYo+hoDEYRMeEdoD+aQUciO4Ye8TUrUr5wYLEKTDbIX6rPdDWuqMPnnJTy2hMKw06t+wsmI2LKDD/TS2b4WqOO9nUA7c7MNVXZC7Vifgj/G2Qeg5OXcvN0DjrWxEXwp7zHH7FrfbjyyqM9fy75U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328563; c=relaxed/simple;
	bh=uEu7dR9Uvw7QvGFddKA74Gf8SlDLsV/O8PuOIUY13R0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B49R0dbfL3Twwlo+MUAvItVwhEgIcJMl586jDREWr8RdTvO6M4wXJAWkv7rSfEXt/4RzSVpGM6RzcSyCc6DcJGQwu0oTPa7HmVr7U7lQSI9hAfo4nfWG/eHXGouVu5H16b5dNQ7NX5P39tN9iiP9atHTAf0oOy2TMZU495rgDM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Lt+PM9iH; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Lt+PM9iH"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4376de3f128so2227454f8f.0
        for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1772328561; x=1772933361; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JijInAiycVpYptM8wZl50nhTPo1Mz10VzFs80VPpey4=;
        b=Lt+PM9iH6e7W/shIhFlH/5aXkA21QnMezQqAiKllITzsWL/bZjPCBZbMiKkK9hm10o
         /FubM+aE20zQXFbnHddjJdYLUE0e84vSXPSvVckgqDGdLTAraDqf+thxAzbRxrKnWN56
         dKa6J3cGEqjhYZu/iSaXaM51au3NN4nABYZSUYPXQcDl53Nc9sI94psjzPcCLkByxlEf
         /avzaXFMoB9jz//HCkmj85b1DQArwCQs1+ps4TOp92swrMnqNktWw7wcIhdyYd/awUjV
         8SF2kB02gKUNTy+VglLFobdw5b6SCLeHvmNMP5RFbZ3wcqfWLwVJTqd5JtB+j32I7XMr
         e6uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772328561; x=1772933361;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JijInAiycVpYptM8wZl50nhTPo1Mz10VzFs80VPpey4=;
        b=YrGTwn3FDJgdLe6fz2IKB/lfQBXBMFeLrXeFkhODzDSt48EEAFIpshijmXH4jc7Dl+
         pVHABbuc2PimHkAfOcefXIsvhfnsxwcZuHEnMrsFR89T8lk8vIU2k7ehtPQlc8d3LfN1
         b49aQ5CqjwN1oK5zMll5ui52RVDh8tV7Tsd0vmZWGR1e+2SKFLSoCeKDS99SCUPMKyjR
         zBXGNQlk2TAAeqAKAjHP3wf86uBUy/CXHbHwFiXsPmxuHxxvhQVRws45RE63PTNH/pDa
         jES+s8pgTh00i1keDs1c+i1Rj+f0S3ch23dMUfs3drzQOlMDZzLEkgjryz4R9C+MMAE7
         bBtw==
X-Forwarded-Encrypted: i=1; AJvYcCWWx5ccDuuXNNPIb+fTlehebnY5Nhhh4orwhNMfe7MOb3HrKNaul+2QyijooJYfG+oCDLLvYyqQ@lists.linux.dev
X-Gm-Message-State: AOJu0YyX51Xol29ZjRuQJxkv5sYqiZmTlnNe9t/U3af5Yge/X5OcgKaN
	vb//0qnuebL3ynccArUHcA1tTtNSC1IDE+bBdatsrqC97JCBrXDDPas=
X-Gm-Gg: ATEYQzxyn8PxidZUZYaw7/iVJnOSvJITmVGg79qmJMJslSU5DgPB/ip54OCXlxkSxHF
	QonuljkiK3Ft3Cufl8A2tivrzMqQt+cegKDCCqv0T4K2vKRyvqwWaeESh3nI8H3zirXTzP71cDd
	las+abCeeDkD2idai+BKXbmXxQlbl6FziNSPFKmgCjqMkmNZCWDAC5xP1hFIn1JBrj6oCjoiWNI
	GeThaEv91fZgaSFAD6rQbvhVh1MUuu4polx5Dt0Qk5sS0F65deqB6y5PQRt8OtsFv0SEiOM3J1r
	FEtXwhwuVDWFrTDiZuspQyOdl3Q88HjlaPfvRKROJOkcnrAAteF/NiRd6PHzYJnYeWLMQs7rgjU
	j/eSZNkdiqKClTffQt9bMm9j7j9NjC6qYCsOThnUjjyq0ot52tcSQd0Wf2qyxpgrKz7L5yZOQIQ
	nBOzK7C1+s7N7lujEMV15I6Zl294mkKfuuURifmEls4xiw6WIN3dsOz+3G2+XDCwM2dO56lMhX5
	p64
X-Received: by 2002:a5d:584d:0:b0:439:94ac:c43a with SMTP id ffacd0b85a97d-4399dddba02mr13234876f8f.2.1772328560563;
        Sat, 28 Feb 2026 17:29:20 -0800 (PST)
Received: from [192.168.1.3] (p5b2acadf.dip0.t-ipconnect.de. [91.42.202.223])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4399c60f8e5sm19600709f8f.4.2026.02.28.17.29.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Feb 2026 17:29:20 -0800 (PST)
Message-ID: <6f83866e-ecf1-441b-b798-e67fc6b4a801@googlemail.com>
Date: Sun, 1 Mar 2026 02:29:18 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/385] 6.12.75-rc1 review
Content-Language: de-DE
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260228180001.1567994-1-sashal@kernel.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260228180001.1567994-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.02.2026 um 19:00 schrieb Sasha Levin:
> 
> This is the start of the stable review cycle for the 6.12.75 release.
> There are 385 patches in this series, all will be posted as a response
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
