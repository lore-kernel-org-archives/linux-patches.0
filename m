Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794072469;
	b=E/q0JbUJ3Grxve0C1SdDUMjTbGbTCRMZ/mZ4u0wu9Lf6533TE1UGHckbEuvB5GLASnkX
	 /8B1YvYure/5HfMdNIvs48lcQz53n3kwoOQw3DYGGoEvFyhWMCH+VFED+LfykzVCfoF3N
	 rGQ9XLkgn5JEdNX2QccVIwFc79wya65Lqw4fwjUId0s1//Dd58WP9bpKjtJtfBzBgO4FR
	 cUpKhXwVwj3Ob0wXbGqbWO9GMr0b0xaBrxrWnqsoxShxwHxS1u2YsloVCwYhsbSxkz6EG
	 k/T+OT5j5cqVLHcpexIYpyLcjPlkw95YrsZQptG80XPeqP/dGPOZkyvHtU6vMQUhQFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794072469;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=2owh4YFvS9EUc9o02yTBqgiJn10dXj2haaCLbozm9sU=;
	b=NEHOfCliajxB7YLncq7+01YZIOxR+GZ4/IQte0FcvLY8H6vrAw++sZnHJM6p/QL6/o+k
	 Txkd8GTQNaMO4T3MO1o+knSC/F3FxaxMHQbUfpsOZjXLmF1if/NHFONaIkmSqNMCDMakj
	 8WRO6wJBjlqW9n1vzyBzRyH1PYzoCVsMsDgHkeScyU3PhYGGP6fupCdwmQSWLzBYKszoZ
	 aS9jv3ZMRHI53s2BWyhu5yigFMxaJEY3b1zJ5zlY+tGOOU79TDQD/3Zthtr+pcV28wQEj
	 ojXl5q9paBgeP+bD+99yydUBkvpBUo6PGt4Zi49Nxq+or4nU0dt7rcZM0YndFcdJ8sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b="JD/un577";
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3284F606A326
	for <patches@lists.linux.dev>; Sat,  7 Nov 2026 17:27:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3284F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=JD/un577
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso17907545e9.1
        for <patches@lists.linux.dev>; Sat, 07 Nov 2026 09:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1794072468; x=1794677268; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2owh4YFvS9EUc9o02yTBqgiJn10dXj2haaCLbozm9sU=;
        b=JD/un577wbTxIRxdzo8FrqXZaYeAu84B2g/LAjHc/FRxH9RA0Z15zRqYKMyrjScmFM
         VJtoFRs2kh2OnWIdG3RQANNRiO2nj1V09Q4V6hx/LIRmG8sUBImPf+wyBywV6p5poMoE
         ZnABIWAfhlukQWW5KhxB2idHfkpErJ2XEUG/ko1GpEJ0OH8o8O/3AAR3+3BS8tPVyZTk
         S0XyFGNjuPlnbUT5aJnsDIHdykMh+Z3iOwrXlLFK766RuAKryy5VyuNOCGgi2mwBtYVr
         S2EgzzyT1MRl5pQwgyd5hVxaboa1fL1Ngn/T+ALYIOE7ba0KwTS9dkzF3zu8PLYJx0tw
         BwKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794072468; x=1794677268;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2owh4YFvS9EUc9o02yTBqgiJn10dXj2haaCLbozm9sU=;
        b=HWfWT7qLvsrpIDTqVLY6cbP0L5KkauHu+nMNu7keYdHCERx75uX1rpcGKwNTVxqTuU
         0QPgtHT9TTTc6JiVGR8cg2X6VDOc8eqJAzorlUU3p0IELSRHcwJR8qcceYIdsDl2O5ld
         Qf1JoDQbuGkwBdfLmL/18NM03Uu8HNaAziz6p6ZyApPuAMiOuDArEAv1LW+2OOAIqIEd
         GVsISHumgfttvAemehl8UW+5r4Bj+TNFbqB3ZCDPkRWSjnx0zIpMSowBYQU7mZBtKxAP
         t0xA3NnGQZr5hTGnOh8Xc2x0S7/gc+KUAPKeOSxoXfFWOXS9QSwB06ZhR7G7VEBKfqhx
         vt0Q==
X-Gm-Message-State: APuU4Z8F5tT4wMAle1h5AilIjmTV7Z/QhTA3vAa1tAGsvL93MG+v1K1U
	hC2pM8ejZw/l8Yn5d410Acifoti52tjekhob3PfncDMWLppStytpnAg=
X-Gm-Gg: AYBFou2SDbWwW8axZpV5hOLE/aOztD9MORHgCnhPXKOjfshYQU8xYfztogI7qJDGO0Z
	nen/LDaK3gGLj1kD5B2S9M/ZQaUgm77azXOhrx8lTA9+0Xc6QJzdaVn3R5gVnmvPz5kOE2v+4kq
	qN1CmNBZMM3c1QPMx7d0HYJY6yDxo1rvMH+v2vsL8OyZUdd6blW9FAq42tIgmspglWvO/v6jn+T
	Mv9KKsCA/Sc/ZjKVYsNF0DBUYpd78vPfEahGdREUQaDHWJ7RVtkfR2qeo4TXAvgCCjWJXvM3SU+
	FB2ZcpuWOP8jQjzNoE5vcmnr8XFQrZ2cc3Kbl2Bm/4f5gV01nZVZuGI8q9IMqOX6r1U8Z64eTP1
	QfR73n0m/OIbZ5dfEnCg5nhNXt8A4BxZEZwaRgUctiMUzanlVShx+/IO4+yhHMIUnFQ0j8oqQrt
	bvhJg3u+wBQCoQ5yJlDultjIJMWXN6tmNXlAdIRcmMD2zyv0NDuGzz2E714ovPhq8Qfy9395Yyb
	2ULkneVunHMDor4Di2abuwVcHgNzypOXf+K7Owuk3zphe3HCSuO/D2E1OWSHgNJ9dbC4aBFEcq+
	4a4FclhDYGhCkqkw+cl/23Ew2ghZa8sLwqbbm554FYUr0tibUOw7IPKAM2aUtaAlyGGHwg8hFc9
	zIbU=
X-Received: by 2002:a05:600c:310f:b0:4b6:bb67:bb9 with SMTP id 5b1f17b1804b1-4b6ded4a3b0mr105329935e9.29.1794072467520;
        Sat, 07 Nov 2026 09:27:47 -0800 (PST)
Received: from [192.168.1.3] (p5b2acf48.dip0.t-ipconnect.de. [91.42.207.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b7e32b46a3sm88407715e9.6.2026.11.07.09.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2026 09:27:47 -0800 (PST)
Message-ID: <0e21a66d-5f93-40e0-8991-aac8a464b7c4@googlemail.com>
Date: Sat, 7 Nov 2026 18:27:46 +0100
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
Subject: Re: [PATCH 7.3 0000/1257] 7.3.4-rc1 review
Content-Language: de-DE
To: Ronald Warsow <rwarsow@gmx.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261107134939.434104957@linuxfoundation.org>
 <68c2efb8-e54f-40bc-9c36-76c719a590d5@gmx.de>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <68c2efb8-e54f-40bc-9c36-76c719a590d5@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.11.2026 um 16:34 schrieb Ronald Warsow:
> Hi
> 
> kernel build / boot test on x86_64 (Intel).
> 
> I need to revert (here)
> 
> 1564da6afd7ce5297ba24f2d1e61d6a79a9ff6db
> 
> 
> otherwise I get:
> 
> In file included from kernel/sched/build_policy.c:71:
> kernel/sched/ext/ext.c: In function ‘check_rq_for_timeouts’:
> kernel/sched/ext/ext.c:3852:41: error: implicit declaration of function ‘scx_exec_sched’; did you mean ‘scx_prog_sched’? 
> [-Wimplicit-function-declaration]
>   3852 |                 struct scx_sched *sch = scx_exec_sched(scx_task_sched(p), cpu_of(rq));
>        |                                         ^~~~~~~~~~~~~~
>        |                                         scx_prog_sched
> kernel/sched/ext/ext.c:3852:41: error: initialization of ‘struct scx_sched *’ from ‘int’ makes pointer from integer 
> without a cast [-Wint-conversion]
> make[4]: *** [scripts/Makefile.build:290: kernel/sched/build_policy.o] Error 1
> make[3]: *** [scripts/Makefile.build:551: kernel/sched] Error 2
> make[2]: *** [scripts/Makefile.build:551: kernel] Error 2
> make[2]: *** Waiting for unfinished jobs....


I do see the same build error on my machine (2-socket Ivy Bridge Xeon E5-2697v2 server), and the same revert helps.


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
