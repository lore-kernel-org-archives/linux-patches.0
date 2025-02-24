Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7ED204686
	for <patches@lists.linux.dev>; Mon, 24 Feb 2025 19:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740426095; cv=none; b=HDpIOP9LRuCV2qmSk2ytXsuM4N/A4H9RKluG/a5qypeMoNexKRZ8ypUhTv9TsQHuryZAQtHBD8KVv6KQ8O760MKpEQw5wW9l68XMK4b7nLjpfEliZJXW6Gpl4qYCgaAwVNHiw61cGMXuMwxA1HIzxmiTCxlRWyvmvqmNrXib+iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740426095; c=relaxed/simple;
	bh=pIlWuwhv32Fy8JMLlSg+tD+gTMaQUC3yphF4Z1NQYtA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DTCrC2POp98Bzt+ylqdjfzL4gtsybEuNHCbKqMW3gu+UpV3vhyIeO0La8UTo+CKNaHaYj2PrsntHGphNrJamVwbl5YgjGpna4QKmyypJL3a1HjP5LtupAYeyGvjILmJLB2fq9pYghsrI+ZBmmwJ2ONda1zF5T5tkGDdr/T2vKAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=AcLqBpz3; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="AcLqBpz3"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4394036c0efso30044835e9.2
        for <patches@lists.linux.dev>; Mon, 24 Feb 2025 11:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1740426092; x=1741030892; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B+zMpSCX50TzWUIveAEPWDT1S6dupXFUyCvXOBadv3M=;
        b=AcLqBpz3L3bGmtciW0aAa11Gx/swo1LEqU04EHH+HB3vNhtgOq2KJqPw1Onaz/c9oo
         KmxmRIajGW6NQKOMMUO/j1ViBTgIpAhQwFpmwHDF4WrnJmHQFTLlxg2858023D2bfjTT
         FQt/jf2yw80ZdmFh7LkYrmuDQZM02EUVNh2ATFdRueUjpU3l2JLCz4CNM3GxcsUjErI6
         mWRZkDz+S8PhdWBDB/NIXBMtR7rtqc4aW0ndcTpKwgbmNvu+4OowLgjoOV7bnE52trOZ
         U+a+zq6SeMYXxRtSnTKNuDPx0jhHPqxwZLREx2IFLyCu7cKaifYV4jjVH5Dwws0Vc7ZE
         cugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740426092; x=1741030892;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B+zMpSCX50TzWUIveAEPWDT1S6dupXFUyCvXOBadv3M=;
        b=evjbmxnXyR5Sdu1rcY23E/OIy0xhVuawrkiyqzJuhQ1aAp3xvUhuo8y8aQ0XS8utg7
         JwsXssG4pAOSQngBaYyTjfEClpHuaRtSi3Ulz+l7kp9ZExdNdkX/vTMHXrPzvdQOs7ry
         W8U/vKjeh2U8jP+NTcLBgN4G8vmqRGeNzz1iY2qKWzwPMyXFPaV0z684HmeBC7OYT/LQ
         osXQlEdVFiSuJQ3w9xYUa1Do91X4JNc4VBzSWzJkPhrUU5EUPq7GdoaIOhPwRs0zihbp
         DIxzVRbbYUL/3R3VoRJVR8oawz60wwlWlDmGvGAirpX1w04HboihYAuJNZkLsh44LA76
         4NJA==
X-Gm-Message-State: AOJu0YyYVYl/yjNMfD97UUvg6E0yOGizlbYpxOGr+GyhttMX+93DDots
	b1+G6DX0jjnKrJhTQY8Y38C0bLyDmpUbrXL7/uKJ86+z6JH/14E=
X-Gm-Gg: ASbGncsmGthWjpDdLSYdNtaVX8QBborH3xc9wg8MdkkCJVtb6Uz7yatKn9x9pOPV3j5
	Lb/lzJ7JjT9LRykW506dCF7GoIGEA23xzwqGZPjkvu7IhtpoFyU0dF1eK8r4PLxHYolYRA44BPf
	ltX0POgcQEhyOknAjm8h4oJg1xDuDkrAMfvrvRvfvgLv8Rj/DSeS21QgSQEqQgyIScRDKXpL9VF
	oYXAYpcQZGWk7T7GdBNlG6qCjcpNsWcZU+hb87qGtT371H8b7wIP+O6RvwE+jE2/AZsbrAGk1sj
	cqt+5DD34AXW35H1DFUn2GusSUQ8SU4A+jJwqLeLU2OLdqeJ9apTStB4FAGYm0mYHtRv7rNDWS1
	+e78=
X-Google-Smtp-Source: AGHT+IE53N4mkXuJ7fLpoJ5n0IdUhAPGRtSiEGaxYfcj5xCF7dklfjhVyZ7U1mE301X83KY4BJJ6Sg==
X-Received: by 2002:a05:600c:1906:b0:439:8a62:db42 with SMTP id 5b1f17b1804b1-439ae1e62fbmr103998865e9.8.1740426090451;
        Mon, 24 Feb 2025 11:41:30 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4180.dip0.t-ipconnect.de. [91.43.65.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ab1546fadsm1083775e9.18.2025.02.24.11.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 11:41:29 -0800 (PST)
Message-ID: <5ab54053-bd9f-4481-aa7e-476dac292a30@googlemail.com>
Date: Mon, 24 Feb 2025 20:41:28 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/140] 6.6.80-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250224142602.998423469@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 24.02.2025 um 15:33 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.80 release.
> There are 140 patches in this series, all will be posted as a response
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
