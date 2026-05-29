Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9E43A8737
	for <patches@lists.linux.dev>; Fri, 29 May 2026 19:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780083207; cv=none; b=V80erT0rIyOV77ZjFpk5vX+bo1OpK26yS0j+dhVLW2IoN6vcNfdpoBFMW2nHcbAvopV+o/yfr9IpcaDWQbxWp8WVuXZmpx4Rw5KGdA4IgBhKYwlTGstf1ABKJFC8hCum83ehoU85kV76h47VhLdmwWOk9cysToOWA9jTkrcmzKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780083207; c=relaxed/simple;
	bh=i4dpGhW5T68WIUwlYd5eofVckO/HNmKTiF1m0nQ3GBQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ddeoZym6phPnZYsm/w9CiDtSn2pvKO2/oM9Myug/mqR3McOtwzdTPW0uGP2R2bkv+Vs5pTp7xr5/9nJVwsWUzD3dPwEn3drGO4Kk3IaMk3pYsa6XsxWt0qagOHy7PVhU9u8t2scfGOwkpHTcV9Lsy5kzPxYxJNG07oZMjw+/hog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=olffHSka; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="olffHSka"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-516d634956fso91619191cf.2
        for <patches@lists.linux.dev>; Fri, 29 May 2026 12:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780083204; x=1780688004; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SiSJ4bH8ZMtUfZ/nsfhYHWoJ7VZh5Xb+WRKRtalot4w=;
        b=olffHSkarkqn9Q4bjOob07JnhmoLqc77ONjgUnDT8ESkhNISUO1lOQHukFxlzPdweV
         bkj+wbWUoH573uRM6pqyRGnAlaaIkkE7LaCvv4cgP/nVGpta6oNHfXSbaynvLZGyVklw
         YDIOpcOwjFlXq2BiTyFcYJercXqg3zrzAuypEBBWfUDYoyx7kUUAUr6ONIB+hzAbAaX+
         eAz+zAYGSE+OQ08l2sgXnLcKpeaY12SOZF7p0GIlFgOFQUFJCGNe/z4qfS2IyoNObKvI
         biW/Yk6GSf1Bm16yObnzJ4LxtAKeWin7bdTPohsq9qQnAqClQlS912OIp6ofXff2Lk5B
         ouFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780083204; x=1780688004;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SiSJ4bH8ZMtUfZ/nsfhYHWoJ7VZh5Xb+WRKRtalot4w=;
        b=NQoQ8m/+HfhfipubP/IWXag0Kc9STcOC14qBxiIQ5DokE8cHcv6GQoyMy7vXWyHf4F
         WT+LvHG8qbcIvA395jm52CrB+hTu3SqGKuAmi05AejoG0NHQLWfEGrOOh9UlorNz2ZlK
         CoRmg51QNajq+BYqMtutRmLgrYJUkQUNpIHNZYiV9aRsRAP8tYdiHOswKlk42iuC0z4f
         W6SWcZoTDDz10t2oc7wB4f9Q1LMSaBGB032eu+EhI5sXt+G/mHWmmJQVM/zSEDQ5yscM
         9kXR0cMzeio9+i/V+/M1P2EHmQOYTRyGJOMeLg4XVYj+/qTqo62mJ1BHdY1WWUMm3DFZ
         3p/Q==
X-Forwarded-Encrypted: i=1; AFNElJ+NyzKOHHfdi5jIy+/XDc87AgHeP34aKnsulMNes81WzDi/pg3A0fS6wHg2ts0xW4BhJy+X5k0v@lists.linux.dev
X-Gm-Message-State: AOJu0Yya5N6vBRUJ+iOmEAjDEtqAVg5Hi+UDdi2z/k6K50UDB6bRcwkz
	DCZAGADmBTWIpsjTqQAhXkDcjuBTO6+vQqGyCP0ppUfvaYspvoBKFg1v
X-Gm-Gg: Acq92OFB8RGq0zO3c1s7K9NmXF8QxeqhmOYyeg1lwNjN4rBBU0qfaEJGlirLBxXse8L
	ksOF1WAGf91f/5hsbUnp8n0ufDtcqb/J3beiC9R7bJXDgsLc9I81/GM9CIyqUOCDH1wKZimWCi9
	VXmvHi/EsXI4cla/2Yq0/s8JIYgnXsRuProTv4BAO+FBIdBEcSRHBQcq9GX/q5mm9zxyy0cWCh1
	CILKkk1xFIwfsE4L5/RdJAF4ZF0IGwr6gZ63aR6oO/6Vq5VAQ9DivpYiFn3u5ClkoGXWy7boJR0
	ADvv6Ew+5r6w1RtWnYPzhYP5q1onPpfHtw0sUdcP4KIDUkg3WsW1OWs/sDfoSrmjmxUDE9M80Da
	D8n9UJ/TPFKSR+yGSUYLOku8DwV0vgHjlQ4nIbkx3gjJyjpY3PI9YPOFh8ool6tCwi5J5aTpuUo
	5nszWhTIFoLx60xg3wEcWrcr2Z5rvN2JpeR4nIn+n+gXjU6NxWK4mpVM3LYl1Q
X-Received: by 2002:a05:622a:5912:b0:50d:e471:2d1e with SMTP id d75a77b69052e-5173a7a33c9mr14237631cf.35.1780083204572;
        Fri, 29 May 2026 12:33:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517397eeec2sm8684571cf.19.2026.05.29.12.33.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 12:33:23 -0700 (PDT)
Message-ID: <56735228-63c4-49a6-a25f-08d37f604aef@gmail.com>
Date: Fri, 29 May 2026 12:33:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/272] 6.12.92-rc1 review
To: Sasha Levin <sashal@kernel.org>, Miguel Ojeda <ojeda@kernel.org>
Cc: gregkh@linuxfoundation.org, achill@achill.org, akpm@linux-foundation.org,
 broonie@kernel.org, conor@kernel.org, hargar@microsoft.com,
 jonathanh@nvidia.com, linux-kernel@vger.kernel.org, linux@roeck-us.net,
 lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev,
 pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
 stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
 torvalds@linux-foundation.org, Anuj Gupta <anuj20.g@samsung.com>,
 Kanchan Joshi <joshi.k@samsung.com>, Christoph Hellwig <hch@lst.de>,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org
References: <20260528194629.379955525@linuxfoundation.org>
 <20260529060918.123155-1-ojeda@kernel.org> <ahlN6TPTgMwBT9_d@duo.ucw.cz>
 <20260529122623.bio-integrity-rc-prereq@kernel.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260529122623.bio-integrity-rc-prereq@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/29/26 05:44, Sasha Levin wrote:
> On Fri, May 29, 2026 at 10:27:21AM +0200, Pavel Machek wrote:
>>> I am seeing:
>>>
>>>      ./include/linux/bio-integrity.h:101:12: error: unused function 'bio_integrity_map_user' [-Werror,-Wunused-function]
>>>
>>> This looks like it needs:
>>>
>>>    546d191427cf ("block: make bio_integrity_map_user() static inline")
>>>
>> We see that, too:
>> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/14592368004
>> We don't see the problem on 6.6, 6.18 or 7.0-stable.
> 
> Thanks! I've queued up 546d191427cf ("block: make bio_integrity_map_user()
> static inline").

Thanks, also seen here, FWIW.
-- 
Florian
