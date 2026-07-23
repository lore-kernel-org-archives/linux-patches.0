Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312673D7D69
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 08:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784793723; cv=none; b=r6RodfDV/nwsIhGg3erQXy9r1dWR+xvJB9mcIGETayPR1AI+6dREKFyS6PdQGXZAjA8CsyBWjWlSInF/7ojzDBTGU0SNVJQ80R9PxSyatQPe5BBblRosx2BVDNGwwwNrM/YzYJk/FcscI6T78yamQOE5feUtMRYFlGd7LZQfw98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784793723; c=relaxed/simple;
	bh=FvV2KSiP4aydCDWgpncY3EngVAUWRaSxMKfVCwZE6y4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=skuKlVxLEt2pKTllGtHmlz9Fr5lZ2Zj/aX23ntCfomL8vgaGFK8rpuIiS66jbYf1IN7ke7Ykqz/88J6GRBmqV9TKMXVHEV0dnBtvur377CRL1i1McBTuZYCtKXdML5ifyMj7MRohn1tO1h8SGK7nvzl8IvQ44C0Pt/VlwC4AXvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=BWmsqYyq; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="BWmsqYyq"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4728c12ba97so155924f8f.0
        for <patches@lists.linux.dev>; Thu, 23 Jul 2026 01:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1784793720; x=1785398520; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bcVf5qvDyeNebb3WLMp3AnEJvvfycKVazF77NxY9kOU=;
        b=BWmsqYyqSqgMjNrHaSHXunq2mLBXhGODyDnmNYTMOte6k8VRBQDzdci9lJ8EhHctEa
         UzuSGFW250LMsHLDGwSqGbE9HX5XDfK14qTmakmmMZS2QJ67IRp0JiqQJPu0pPkV+Vg8
         9qw7tarqByJRmZU3xUpNmpidg62YKcqOiiA7U2qO6gZVCZip5IN1d/qw5ohdtoCgez9D
         Q9JfJp9jpBOT/5A5JKKFCQak51G3YBTI/F7xx6/2Pl/hb6O4TFrt/4FQly/VH1q9f13o
         fdZdrnl/eZZMqq0X97ikAF7M6ZywsPFLyZhCR6dI3eFbGKsqZxZH6rUnqiya4Hx5dRP4
         rUDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784793720; x=1785398520;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bcVf5qvDyeNebb3WLMp3AnEJvvfycKVazF77NxY9kOU=;
        b=a+2J/FDLb1ZPZhKkO3y/W8y5ualu0yeOjzhqCr7zkA4VT7KT582hCfm5F8WynqLtHY
         iOzu5yKHB7bQJnwBZyGL0q9nKc+F+XjG2bdYu4m2eoO8FUKKvioaQl17y18RylOLtlu0
         HZQVsndw0EfI3B3T/kD4PKMvQC+KZImNdGXPIx34DDqtKKVPhQtX0h5O8MUQZcKML2u8
         7WS+TPd0r5oMsOZxYXOMevwM50sh3mF8zfZB8nhgguD2Mb1Ji6T9i/OEuoXPjD6bf5CI
         F48rbQEcHNOZpOF9aBUEMAScbNwadaPkZHos2h6tw9eJZPHjOuu7YV4OeE3bIH2tbjm3
         mXHA==
X-Gm-Message-State: AOJu0YyQKQ/XztXeFdsod6ITutDd0r9USabH3NfoolDct7frGoqPpDYD
	JXeVPnN6UiMku+sGQlQcLASGiy22XzLHULQdXvZLVxoVAA+KSiGjfBs=
X-Gm-Gg: AR+sD13DQ95vc64YKjGD3vVajjGIZfjMwUGJD3edDNBtkr8bP5puXghnklB2BQIMYHp
	U+o3gXTVlTCAv00bICBl7LQed908GVxvuPiG25p60Na9gQXllBgZJZgmIF/a3VjCVV9XgyzDEo3
	YW9khrH8sDPRtfhtTQmgy/FLwA9deiDVH99ozuDAyQbRXzGOZPQjLF2h3SZis6H6HNiCFsPaFkz
	qYyWurWxtvjBZMXCrKZ3lz0lzFxkzo6dxrZRNhDvieeJ99SzCm1w/plNJb+xVzmesZPIx21lmLQ
	nvwzRcfwKKCNkwGd4xX9D+E14ldTfxr3ZWhXclwGFrPv3VnqDO98BuRf43f17Rw1qYCWAYdktna
	ZQa+FtPRv6s6CHRBCNQIyMP3nYprG5j3nlzSrsUDk0JxyJEeu5hcTrMiBk43013KGPMSXC80hGN
	Jgz04yOrHoh2QCW0lVzgo2rHdfb+VwWz7MfXbTUIQVEMh1xJKgHx9KPQA=
X-Received: by 2002:a05:6000:4717:b0:47f:9254:d45c with SMTP id ffacd0b85a97d-47f9254d53dmr669618f8f.31.1784793719489;
        Thu, 23 Jul 2026 01:01:59 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acb97.dip0.t-ipconnect.de. [91.42.203.151])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f864305f5sm12596933f8f.17.2026.07.23.01.01.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 01:01:59 -0700 (PDT)
Message-ID: <afde8c0f-a03e-4be1-b31d-f507c493e76c@googlemail.com>
Date: Thu, 23 Jul 2026 10:01:58 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 0000/1202] 6.12.97-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260722142834.868902312@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260722142834.868902312@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.07.2026 um 16:31 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.97 release.
> There are 1202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or 
regressions found.

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
