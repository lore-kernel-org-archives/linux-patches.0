Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B370F349CEE
	for <patches@lists.linux.dev>; Tue, 12 May 2026 23:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778628664; cv=none; b=GYseBfyBbQr67bTt2wYywzSKVrgVNEfrYErieg2dO44PeiHaaKkC78JwWfPzI59kvkA3iNkutnrTSiVIuAllZaqIFDK/1cvUz4G9vPmlGq6RmfB9YI+s2SWCexgSrqUdbZzAstBt0oqOSimApbU3NbYFp5YIzeTwWd70mI9wjv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778628664; c=relaxed/simple;
	bh=FyFKajl5L7V5+XAy0wD39pUFnzZ9XNW279qkg2Ja/78=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W5pTip85hQJ7TvppQPRJmorgoyYxuRKsAZQxHVbI1yC4xZC+/PWG28buihdqo8BSmXQ/PGk8ObkC2nkxbyg47hVMADR8ex0zyG0fzVpNi6u93+bY63gqTNbUVXgVMgc/RgWuYNL/F46TxD37izYTpjmA4jU82Enfd0/lV6XE7ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=So7uESNn; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="So7uESNn"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48a7fe4f40bso69948225e9.0
        for <patches@lists.linux.dev>; Tue, 12 May 2026 16:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1778628661; x=1779233461; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qJWZbO9K9VNLteCi7nQZ8KhPP31M2G8iC8LnNx4jfJw=;
        b=So7uESNnSQ2EJKw+1803RedsWTt5LGeoBSJyoDrVssjtbQ10GqLM9nv3Q4gDXzhwg7
         47TUFgVdxZaYHQcDu3AmwJtQmh1e4U1Dn3svcZiHaaoLg7UOwGL0o0aOyja3j/LxzxKE
         jXCkyRcA5fznBbe+hgSJtwIDhVHJRh8S54O1H7M0NuUoawEO8Fz2rWSiaiHwA2lp9EwM
         jfiUYJ8j6Jr0iVSrySPtEGkV7RwWfSfuC2BstriLvBbGc0Se9veaFuUQD3o047A0Y7m2
         pmIEqFBcIjFFeBFOX/DpMMI35UaDKu1umWyQhfIP5iZVYg+bdT/ABb/fi/hUfdzD7r3J
         QpIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778628661; x=1779233461;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qJWZbO9K9VNLteCi7nQZ8KhPP31M2G8iC8LnNx4jfJw=;
        b=Kls5qfugXQKqz26IcpIX5UEJ09GlxjMbTHszA5BJE44s+CaReH28bpRRWb3xjrZ9JE
         OwawkJxRILz8kpCWaV1urHEfLnw8gO+cei7lc6H24Msx/53Zu+PNMoloLvhOMdVlby76
         CdwV95biKgJgMf0t4q30vCZcTu/NeaCaMdW2ES+F6i6Gn2Vd550IRTJGoU2HODc71qRv
         Fr4cKa/Ayb5bLycLJrEk1tbSPmt5N2VsB6NBJ6QknPKjLsZ8UHdMsnxfXOZNvu8T7i4l
         56EbS4n0woNmOxed30+MoYdTqOqk/SgFYmXzO0+XaHRwYREXUO+D1la2FaJhuw6V2Zpb
         Q70w==
X-Gm-Message-State: AOJu0YwMwgyann/1FOYp4BG4k8TIcdwBxpG+L1hxVKINoi0eVVnwvJJF
	hgduqBX7N3Wogte2NQmwm11qYqTw2aBSDs6RrDGJf2yKEAb5jFWJCWykZ9zx
X-Gm-Gg: Acq92OFkAuDZmWxkwt8cYLU+e5H0dSGG/OoozmpJG+yYJF/QOsDxrUeU31WJX8wk8hs
	uFd/5Yn15ZkNIA9+EyiwOq7VpU7bkCf+hDmuo/YJ9y3IKR7XWt0P9UhW09ml2JnlABnhZC+TDdc
	iRALc9vOuPM8D5d4xv9MQ3NnxnHuykwmkBeM2AZRBKxcmaNtse1ZjtpPscdEKlsZOZycZLcIySg
	zWf1FsxlQij7f/HZ9VLt4V8I6uxuq5FWdaCShft5PJv4BMVpp+LmhQdM2/mdjI9iJvyUEUPo/ZC
	XcsVfD30l/i1QeLIf4CZP26cryZ2/ZdPQglIRriZlwPeOVL69e1OKP3ua4jYWCqLjrgfbvSlLUl
	7EP2nMLYu5Nf4TJvi4X6zJIo4w/pN/KgAUbdoAGCETrvbhFkmnffDdFKqqQRDz/BEXtmPLZEOlF
	piQeud5f7qFagAgNvM2mXEsaIZTZeKRcCdsHvexMaOWqka19it8xXmfrb+x7EQQGdb1ZcHekaHN
	HUxawC2vRewkw==
X-Received: by 2002:a05:600c:19cd:b0:48f:be94:d82c with SMTP id 5b1f17b1804b1-48fce9e1a34mr2332915e9.19.1778628661121;
        Tue, 12 May 2026 16:31:01 -0700 (PDT)
Received: from [192.168.1.3] (p5b05786a.dip0.t-ipconnect.de. [91.5.120.106])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fce05f41csm10297535e9.5.2026.05.12.16.31.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 16:31:00 -0700 (PDT)
Message-ID: <90116a48-a75d-48c9-b09f-97f541c0031c@googlemail.com>
Date: Wed, 13 May 2026 01:31:00 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.0 000/307] 7.0.7-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com, Tejun Heo <tj@kernel.org>,
 Andrea Righi <arighi@nvidia.com>
References: <20260512173940.117428952@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Greg,

Am 12.05.2026 um 19:36 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.0.7 release.
> There are 307 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Trying to build 7.0.7-rc1, I get this build error.

In file included from kernel/sched/build_policy.c:62:
kernel/sched/ext.c: In function ‘bypass_lb_cpu’:
kernel/sched/ext.c:4019:35: error: ‘donor_rq’ undeclared (first use in this function); did you mean ‘donee_rq’?
  4019 |                 if (task_rq(p) != donor_rq)
       |                                   ^~~~~~~~
       |                                   donee_rq
kernel/sched/ext.c:4019:35: note: each undeclared identifier is reported only once for each function it appears in
make[4]: *** [scripts/Makefile.build:289: kernel/sched/build_policy.o] Fehler 1
make[3]: *** [scripts/Makefile.build:548: kernel/sched] Fehler 2
make[2]: *** [scripts/Makefile.build:548: kernel] Fehler 2
make[1]: *** [/usr/src/linux-stable-rc/Makefile:2108: .] Fehler 2
make: *** [Makefile:248: __sub-make] Fehler 2
root@linus:/usr/src/linux-stable-rc#

The offending line seems to be part of eb5b997dadc517 (sched_ext: Skip tasks with stale task_rq in bypass_lb_cpu())
Adding Tejun and Andrea to CC.


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
