Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0184766A0
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 19:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787772835; cv=none; b=Xyg4eOdm+kiUnb9UttrLA4WP6v7XbTr/oYvqQFAua5jiUzNqf1U4PeFt5tpcxKGfO765avlKcIJ0u2dNp+81YE8iNjlwoyuWyo1yieMpVjLVg7NNtYsQ2K39M288HH+XIBxKxcXLlvafvATiZ91fI3oL3ycy/PlFN+n08XFOOJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787772835; c=relaxed/simple;
	bh=5OoHPncp9QD6PL7OJKrlnuCelFdwbO5jF1abK4OZpKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N8BWu5x/dDbK3a44fPvNcduOb/Iil7KqNVvELBQig8E0jIoeiIpGdW4xwd+IWQ0HaWIpXzvIirFYVTS6jvA/tJRgc5lFV0n5szC3hezGJEykrjkKCtQBVWu7cvllKBKkcWXSNRM3Zyp/f0mUBdpzHIHWGHA1hshJIPT/UkvzqSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=X6sN3+RR; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="X6sN3+RR"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c250c6a6a6eso215692466b.0
        for <patches@lists.linux.dev>; Wed, 26 Aug 2026 12:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1787772824; x=1788377624; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=u+83bvx92ZvGFRFIAdgfKyFZQ/ks4CIryMAh2oO7ljc=;
        b=X6sN3+RRO39V8YBF2EY549YZgul3b7d6AsRvEzZlWO7/z5pmSkwFj7AjrX1FduT7CT
         vol52h40fsT7/7LvJ9co2/Isfku25LfgQtCibfuqfLm9AfXDpdyb3iT4PF5qgAUgezKT
         hPVpyVW/UxDmZM5qIrWNkcwgOa3N8BDaDZYopN8X4+ZlEqlhq8oYb15kCOj8yKF9zofU
         ZOGIsW1AN4fjC1dPJLDG/oNFxbYikXdU6M6bMG829nBoY0V6uxSgFCYuhRhfN4YMdNuQ
         GzsYojfROdYbPEx21NC6W4+INPnTKVwo2vAg52+PIdLY0tyESM8FUVhEMlM+7k9ugpdW
         9W5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787772824; x=1788377624;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u+83bvx92ZvGFRFIAdgfKyFZQ/ks4CIryMAh2oO7ljc=;
        b=g2VbFFqGBxj4Pb2GPfmfPKMngj3kkk0/tUM62FRoJCg1Xd4O3/p+x0UOdllsZcc/EF
         ArLRU7TAffbF7nxer6YEwKuj2tPnwCAjt6LsKFLZXwzMF+ybcMnWg7LPwEiaA7qC2p7t
         L0tCWDni90RWba3U7R6I2pmFgvECstQuNjlJSaeLQk8YsT012uaeSBqg5WMGUQ+CGem/
         MDHZEbWMBgdQityUkkGZMknnzIcFynZGLlSy3rTpAjtn9Cmp3Algf3dXzOBAdl42KP+R
         mJ1B/e06UvmccGepxBLnWdgbyuSi17jkuL7ilu/m8Y00qm/XE+Nk3lTSj9Z0RtmhTINR
         msDg==
X-Gm-Message-State: AFuF++ntc3pnFu+gw0u3B9SD9cseZCG4Fq9/KdNuycevyrLFjS9oqvjn
	sZKOu+lA4yNjg4jsWNuPvK0u6brRd3u67pumSNBis4Jd6UwdmJYK/sY=
X-Gm-Gg: AR+sD11JZNvj1nql1SX+gt0UDMp2lj0n1WeEwzoiOiivnPZC+7/rEfAN3DG7jIVJqSQ
	KS33L1BzMmFuef8L2nqbnQnotVg2SHOLcRT+1QyHK+RDT5opPdHxlP+s6aFioIT60cxfUA/Wuuc
	aQrD5qm4T3pwFUIlmRcLt003wHNldf8dx3gLTclkPbMjCgSwXgBd/mMwMLBjpmVCx2wmq+6H5Cd
	48YOqdEVruOCN4BtuNFZVxAv6T+UEX/Cmdex2vP6FaOyYXSgnUnOVGkdfrxzWPN0wYQNVgZutqF
	/7hgLqI9ihySsNH9jrlxF8fgtGYlJnrRNb7h/qUrQPo8rgn/mWaTNpqrLXu6l3qar+6dzDcaxyl
	DD0GYqZ3Uuyivuh2XQbraC0hSeZEl8n4Wf4iSWRXKctnB98MNSCqTiiyLBjvNlgoEtCKHotQBmd
	Drn2sf5R55yzyGYi2aNrNtpxK3sU4irixQYAcFi3o1NXpPXzTx0LZ9C2jXa0UCIE8hAlYy1KcnU
	Xa3XgkpVPBCUwWLCawj/OITE7nYRmkn0LRcqDQ=
X-Received: by 2002:a17:907:84e:b0:c24:c24f:e176 with SMTP id a640c23a62f3a-c250bc30e7fmr984052566b.15.1787772823754;
        Wed, 26 Aug 2026 12:33:43 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace5e.dip0.t-ipconnect.de. [91.42.206.94])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a88ae4dsm842539766b.39.2026.08.26.12.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2026 12:33:43 -0700 (PDT)
Message-ID: <2ed27071-4636-44af-9b7d-bed4d5035732@googlemail.com>
Date: Wed, 26 Aug 2026 21:33:42 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.2 00/82] 7.2.1-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260825132541.560541185@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.08.2026 um 15:24 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.2.1 release.
> There are 82 patches in this series, all will be posted as a response
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
