Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793408500;
	b=NIBFydbYCRpT9NfogBae+axGvSUGkfIGMcO5SsrcsIJnC4h/di9mlrFL6RcZLXozZr7l
	 1xXebT+y864Fku2N4qCYEdxBRoHGIVY861d+0F+7wGaKAYNhjCH/gc7rn2rvdhjev3oWi
	 YWaz3E2fyyBmzy5c9QqnqrlrN0J5T2BbxFbrHDLSK7E7oUS8YhElT31xP+vbXm+zSjgCf
	 YLARLAFOKNUHkrIhMKEcWBK/PdMAWnFgdh0Hk5KfoHgVh48NGQbtd1c1dNH1ccyE7Eykb
	 0nPfB/ror0SWB1vwW79USjAN1xt1Nl7tE1OrLQ83Zggj+EVLpU14dECuG/5HoRN++1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793408500;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=LZfsTBRamD15PPndPrII3yvEWmYbhtdxrXyNeJy7iMk=;
	b=pRI9rJ5tqS1L0FRczIDBUbQUxpohd1j32P81KRj7D1HuQQgHgUBDAg1uomHojwLgN2me
	 nPubnkubY6JMJ9wowxUYt8mnWXSYrZIoAaHc4a1xlfgXR8/1Z3OBjAuAlMAxfHU7VyMD5
	 gPFnUyfNJrddeW9HA4LQqY/cqcTjpVXEm82BTAIAuvuRndnFLY4gM1LhHzrpHFLPnXw1a
	 YQgT4Vb9BhkgdFF6JoYUudUk5KlBJ5LHb7MrjxWXng/YNiLyx7PUeYcGdgiUfKz6We3nS
	 Mr4fzrnuTs7gadYW5NSFM6wNuknx8yqPRSRraXMGj0hYQM2KsxIgxnFyTTKJbFsJ9dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=JV6TBLkG;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CED7606A31A
	for <patches@lists.linux.dev>; Sat, 31 Oct 2026 01:01:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5CED7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=JV6TBLkG
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a2084d62cdso11396845e9.1
        for <patches@lists.linux.dev>; Fri, 30 Oct 2026 18:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1793408499; x=1794013299; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LZfsTBRamD15PPndPrII3yvEWmYbhtdxrXyNeJy7iMk=;
        b=JV6TBLkG4xUWiy6P7KLS2wdfF7xekO/P5f4wE8759OuJLw/lPYk1Mg2NCuk+TD4t7X
         2PPTo+iZYV4VfSkyDfbQj0zfg/UIFz20/P3TJhssMWaqDUT6S9ROBVmLzz0TNoxXgctO
         qAAxD7LyYKBuHNWYUZAnYHqRm1EPe1baMjH2D+IQa9BVxOHCJZb3N9ypV/x5sDgrxUvl
         1oiVr8bqvUFdXPAIoroAIaZDEC56sbmv73wPSXdh/Y7yIBkRNawRO3KPo5E6dkVVIHgN
         JOPriHIgckTCMkdSSA93VE/wGafpRHV5MCby+jQjKfzI1JEjh4potUjQtH0INTNTcC0u
         7+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793408499; x=1794013299;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LZfsTBRamD15PPndPrII3yvEWmYbhtdxrXyNeJy7iMk=;
        b=s+rET7gbvPxMGw6I0grAu/vbmR6cyjSlJSyihVGiW3gbcg4ouq1q6NXRakad4wTQIW
         8eM7yzGVWkrZZ1dyyIFUvAEwM0kVvHxRxohPtgnjxOD2iXkTTvolRc1vR62/hNUFx10J
         xP36+XSbEakmAHhd1WC9SwWFhlwIJd9TTpa7yEDtI3QKURsR5qOvFaklN6r7QKHw5u5L
         WunDE3AZ365rmmanBMbwO6snPbQqTclr/C2YoKkRRUmAcP3Uz0tbWgnSrO43n//WPkL5
         NkkvkQFOA2Ud8ZUjDMSz/oMWHyetDTbY8bvg12h6AhMuJUG4TUz1MaOHmeUo+zss7DbI
         VhMw==
X-Gm-Message-State: AFq9FYJvOZeGfpiWYYzopvJmHv4SWX4l3XDTaqK+VgOMhG+t43AV03Ul
	6mVnkFTainVPbBelcQh+xZyE+VqNt2zGokc7HzUM28Fu+EuXbq5Oe8I=
X-Gm-Gg: AYBFou1iAz3Lox250feVgupaeExrDISiY9Za9a8jAa+J7gAdEZKdHn018LGOXYdf8sy
	DISe7e6hEaaz89Cn9dLnih5hJLKpTN5y4g146CeTuI91B9PmHhcj/2XCmEe1Lq6JyH4EV2LQCvC
	+VNX3k63CR0zFYvwDt/OkwTas7oqq9+vAN2/5HvDzUoZMKBzrmvS/1XERKopnwsgIbSI4rIJ5/q
	mPF0PFKbItSoO6F2FSNT9AoeLR+81xn62OVYddxp/RBGKWOkPUtT7JUnfTWptXKu1ODXktHwBg8
	inlq8CHQf10MJHQrpE1sT8iY62+10ycw/Ji68PuyeoYZ+RfclLNKoURUfI2+WcBD0+nXlvf95Jd
	u6BJfrdLdEQD/StYfloS1sXSJgLkZjw0bfp2AScS5TyUEAjvX9j51njYj9nXIyh0VhRt2ZhAIIS
	E9F8s4AkY1V8BP8SVnk36YerHsi86pA0q3arkS+mSjtKdVrnByxzCApp1mxtHpAOi22mI7/of7s
	tuCAfvPn5QSoDolRfqxxmT/rQ8PIbpg14p9w0Yf5RppLUOZ5zUQD8nNKFqZyMq4g5T6JZA4+gig
	Sg/P/vAchCoBd817Nbp2Cjo/O9J5wK3RzwlnNGwQKuGepw8BsVNbKo0alqPotx3A2uFibm/B1IT
	R6+E=
X-Received: by 2002:a05:600c:198c:b0:4a2:5ca:767f with SMTP id 5b1f17b1804b1-4ac151a9a36mr94244865e9.4.1793408498561;
        Fri, 30 Oct 2026 18:01:38 -0700 (PDT)
Received: from [192.168.1.3] (p5b057761.dip0.t-ipconnect.de. [91.5.119.97])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf5b27e46sm146688815e9.3.2026.10.30.18.01.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 18:01:38 -0700 (PDT)
Message-ID: <0db80581-4d82-4771-a495-4dd1c4a1c282@googlemail.com>
Date: Sat, 31 Oct 2026 02:01:37 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.2 00/10] 7.2.15-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261030121255.257615100@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261030121255.257615100@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.10.2026 um 13:15 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.2.15 release.
> There are 10 patches in this series, all will be posted as a response
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
