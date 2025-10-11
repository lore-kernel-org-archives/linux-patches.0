Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFE1FBF0
	for <patches@lists.linux.dev>; Sat, 11 Oct 2025 21:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760219951; cv=none; b=mqc5fY31f5U1SC05pQppDhIWRkV/z2CzvAa35hQXarxwXm74t3TQFQxPfTvsqL4ZFRm0JHYapuiQR3SSLD8ixStiPpFqgf0keV2XBicZN1E2R4HNWqbqSMeimh9w/UKAAbEFk4rdvV7wM5B0BjKB9EIzN7NmxWkIZZ9FvdPyNoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760219951; c=relaxed/simple;
	bh=2huGcfbPwSh50phjR6U4KnFgcmdQ/b5O6KDcOTP5300=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h6kb8Nzo4ps0cB3jHc7gx1uEPmLgpOtJCpEeJwa8Uqd3jTVp1NMaZOYNmtbA+78LFMkkSuO2kV1WoPgWQtj6e5bxCS9+1zPlH0frlZl1Lle5CSp+IW5SaQ2f6K0Uq/LN+a1y/9FgnSYvmOe5ItYw4C4cqMTNG1MHO0yJK6mUT7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=RpZgoVj5; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="RpZgoVj5"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46e52279279so21499285e9.3
        for <patches@lists.linux.dev>; Sat, 11 Oct 2025 14:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1760219947; x=1760824747; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MHThunLmw18bkcxxk1/kwdh40gHKEqGwgzIfI1FE8xY=;
        b=RpZgoVj5W1dHKQrrJxR/QeOSg1qgsLBBZxfGGV/mOG1wxAiqYj0lBW26Esuq8bRp3E
         hwhetL2wT7CeGMNv8FdKwbkYPxPsdxHyoM6nwlPGNtNs2M/R5msyqEy7D89p+eV9hmw4
         6mwGNj+zl8AtWVrYQHHQwUhjZti4l39eOw0lWMsaBclmz2vSRvenW3p8w2Swk0gulMxA
         KgJYLIAvDIg8OPh40sPUz0+npdK0glktixFSIOdMz9pIwV2NgZPkCNL9CwsAnXMhbpZ3
         cYi5oIUz9NmYEog4UU+cY5FhFwW6vwr9QpY9rjMZQrvNOhe46YjghhmFKdrQTF+hf75a
         kKSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760219947; x=1760824747;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MHThunLmw18bkcxxk1/kwdh40gHKEqGwgzIfI1FE8xY=;
        b=B3woGCt5l3steBtTsbKQh2t3gHonSZLzoLr8G1ji4BQcQYz5IpzExAZi9XcZOgm+CA
         SHPvJ6E7Toh3IwwuaADa4wicc+ND8rlII46QXo6H7saAW0dl/b8DR6ZXeIcoQdriyBI3
         uhP+tK4uT+52vDAHOFoSjt/+/q81/Q5TCSDGCXxENhEYxLKQpvwq4/TRmIlUuPQJ1K7F
         i/WosT9z6ORyz/I8iaoALfpVEvVnnRwQilYyD/0CTk7QunJu2rT7GX4vOtxD15mJOEfm
         h8/HNM1FdiA1wKluDRFnL/SbtrF/asZ0smCNYB6DOThyJDJ8Cvqm9gECmKUv/n4ZD2yt
         mpFg==
X-Gm-Message-State: AOJu0Yx8gKp8YbXpZlUr5slV63vKul4P3Mk5f9SusxEK4SAAxgZpDMHG
	KcYJuk2R07jPa1RFpvKhEMH8PZbCW3Jv5rlQI9J6sq9ssmJanLNcQmg=
X-Gm-Gg: ASbGncsSI5Oz0OQ1JmzS7HqrTIZJ9fcizxm2A5fnHKUpayIgpF3EE7vULPJIeBZPzny
	0cwOH2xvf6Yu7rYH5cNGds66XXUMCS1K/EmKybL12JRxJsd5ncYpvqfaiTrlQx+eVQoVJgFEt3B
	ueFdf8CA3iFCU2bmpWUCBjcLh5fiMCFZS4WbMU4+8k5wyKF06l03hJFNyGcWECZzSOA/EG4jfR3
	gUqLxeBSo8aCe4FyFNJsEX2s8Kf2yRB4XqiYWgJGqbM1dHPJtLTBNOtegxTlhvWIVWsM+XqaQqi
	xwafB6f4TafXIb/CSMSZU8wamNio3UUFdujBpCN0wkQ7qgiegVFr7wA50pRzDcBfY41phyYE8pJ
	xPaHjx+1MA0h433rchayCeH58Y0Vnkpx88Aoz9PXAdhP/g/QqtR7a3RJSXKuce1A5nY/+irXs3U
	/78kgVn6j1gOqMi3V3TGjFwjGSigL/1OaxvJM/1uo=
X-Google-Smtp-Source: AGHT+IFY8BvUEE5h0xt52mM8sCae3x2299mFEpXNCOJQAjgaAdK8tGVw0x5V3Un4+D2uFHAuzg4xjw==
X-Received: by 2002:a05:600c:4688:b0:46e:5df4:6f16 with SMTP id 5b1f17b1804b1-46fa9b1788amr111462435e9.35.1760219947277;
        Sat, 11 Oct 2025 14:59:07 -0700 (PDT)
Received: from [192.168.1.3] (p5b057b9b.dip0.t-ipconnect.de. [91.5.123.155])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb49bd977sm108385825e9.11.2025.10.11.14.59.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Oct 2025 14:59:07 -0700 (PDT)
Message-ID: <3992ab53-474d-4031-a601-259ba3966bec@googlemail.com>
Date: Sat, 11 Oct 2025 23:59:06 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.17 00/26] 6.17.2-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251010131331.204964167@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 10.10.2025 um 15:15 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.17.2 release.
> There are 26 patches in this series, all will be posted as a response
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
