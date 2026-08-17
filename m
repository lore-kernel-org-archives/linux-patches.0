Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499F41A6839
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 17:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786987238; cv=none; b=QvBgLGeMYnYys3rzPm/yc8NQ4gLt7kHyfRLpZSs43aWRztowg1JdWJtCdYYC2VPrbsCUL8Uocu6Zinc4HFc94TksG0oLibibogz/KX/bfbnTZRP8hsdz1QYgkbYevTYLQ5dhKCDH/bVkE8o6FmuL839X2hg/QTcqOYbjB836NY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786987238; c=relaxed/simple;
	bh=FkzwyK3KPZZP37ixbuECgtmLOwoZSJSYgIIH4AGLFl4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tTR/Rwgh1Ksp7T0V8TYYt3w7RuzlVhluELp8szNRIREGdBNTVGgUL8LpPywXSk47By2F4iFntTb9offoo/u3ElDkOPo+ZV2D+5cI4+x8Q98u8nwc1VbpZ3TcWP2cSKbA7ts0Is6FkRmXJb6nP1Awg7CDLYCbGfUO+lP8PUPvNAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=P10XMTZS; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="P10XMTZS"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-480033bdcf4so2219340f8f.2
        for <patches@lists.linux.dev>; Mon, 17 Aug 2026 10:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1786987235; x=1787592035; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q4v0BK/tyq0gTbl7z9GFhQ9Wm9CgOL+/eWmBB0CzgUE=;
        b=P10XMTZSgMi0kBLG/sbeUsD/exWM1dThK5Oz8u6wdkFeax11i9mUQ/tgTMA3OmDxF2
         gsjzKaDuGraWZb1QxREF5zRKvIGibOaOopsz1HuV7KoUGBWnt3QPmArw9IaMrcLFD3Sw
         OkHE6h5BgwyZL0gEpLk064Jszwoax2io7jVeFDmdpKGyxjLr6ztjZ1247ZIf6E3sO92z
         x69Nl5n4zfe5ku7tEb3K3MkxNgVNTDRmLQmo99DtUF/t4hY0DdoDKK+syPslLdXaXHJq
         mrXsA9dI/WcdxtGYiVGfuYRKMj/ISaJqkvcqYbN3fbz6r5bf96oIFYrXLei7QxJFG+bO
         pZWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786987235; x=1787592035;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q4v0BK/tyq0gTbl7z9GFhQ9Wm9CgOL+/eWmBB0CzgUE=;
        b=PRLPt9lol1iLS2KsJYH/X1Yrt+/X5IWzqeoKkWPggRs+zojjKdSXYV2T6mf7a3BsFO
         wwV+y7U5dGjhUjqZJHP0W1GCYP+zil4p3NXXBg6spTdpkNk+5J4NFWXx7xvV/3f8tHQi
         2YlL/o6xhJlVIkiozN1UKMH+R1Ev/8SYMfwyaL2zWMSo6flUZIIBTaWnBoZFVkZ9M41S
         xbeuy9ChOmugrwXHjyB1pdUMVL3D+OAfnznFPU6yA5n0NayRiKAZYVMxczzFfsX3ATvk
         55uMfDGZfm5BzQJZqdPQ+5HmRKCexaJmtkoMKcC6rakI8WjSAn6LxUmCS9WONPP+mfv6
         98Lw==
X-Gm-Message-State: AOJu0Yw/Oas955hpKkYTriv0YUleCTV/KGLkF6TuQlht1lechYNozXuW
	SWSd3t1O3ZNbyP7Y5lPEG1qxwFCoDahtJ19cRy6P2MgKpkRedorNoVIvd72J
X-Gm-Gg: AR+sD13wWLf4mNjhduJmuYI5XwS9nl85WlxkeizuDHD6r3F20zLxh8ovkKzZWglquLr
	QPs4L4qzNGyfEErhLGSbX1xbKtLLVB4DylrGNUaNZNdsY7lnOlLkjJrDG1w1330GsLPob7IZGjw
	YXllH76GqB+z32JupxvQQ6DFJ8mulO7M4SPxf53G79pp4ut1CJFrcpqzts17pcF2OpRSRmuSBre
	QtMhsxCeyVJKDYyfZ/RiI1hxh+2jVXZeN+3200aBO44Oxoi0DruyfDVmMB8tA8YgPQV0DHO8n3h
	nMjXnvKag0uGdQ1Ifrn/dlQQNwFKeWTv5xES5loGtoFcQAMRC2pwtUrz4dFMdQX4RcIEKS71FTA
	3R4qlBqGzbg/Pd/IeZZYiKnjd2AW7X/yS78R3mPKmGaTEYLDJIfb81tFuaW27KFKJiZ2r2mXpPG
	ClyorExSRo9gzNRxK2Oexnktsok3o1z3kIWV6spsfRZQe0iLwQAamkY49JP0W61ol4SGUA+rFkm
	J//L9Py+w6J9KJh+XpuSOv48GliILb5wrnQrOW1
X-Received: by 2002:adf:e002:0:10b0:482:a610:7a27 with SMTP id ffacd0b85a97d-482a6107a55mr5847941f8f.20.1786987235375;
        Mon, 17 Aug 2026 10:20:35 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b466b.dip0.t-ipconnect.de. [91.43.70.107])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5a315d3sm5510095f8f.6.2026.08.17.10.20.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 10:20:34 -0700 (PDT)
Message-ID: <8cee667a-adda-4d36-a865-c467a71dae71@googlemail.com>
Date: Mon, 17 Aug 2026 19:20:34 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/609] 6.1.183-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260817132543.039278408@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.08.2026 um 15:24 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.183 release.
> There are 609 patches in this series, all will be posted as a response
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
