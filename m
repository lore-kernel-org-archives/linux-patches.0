Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=188.68.63.102
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794070284;
	b=f5bmOn+tjO+TActBaf5AOWTWQ4LW/7SYIpBhazt/Z6lNDZQ0JqWnI+YP16bYbq9GpAx1
	 axSgI8uTgZSVQGCav4Q4/sSRbY+LoNqYltxrTjAyv08aDsO9JF2z09kskHg0UNHV4q3Go
	 2s1Y7j2fMKKS0j5T+Tfs9PTSvEf/n9yUqe7Xf0OGJiYOORmHgS6N67ahZyXt9T7ItpBWo
	 edq0vP6gYQLAWOiCfD9LUOGAeQXLEBvddg6NWjl7n9vu/2ZAt/rt1hf6KqpGRcbPdJ7Pn
	 2Pxwk71jZjc5DtxyEHIC7jlA9uIVdWrkqWmdkWhMmForFq0GKgcdkN+pPCXe8u9v+Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794070284;
	h=DMARC-Filter:Received:DKIM-Signature:Received:X-Virus-Scanned:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Spam-Status:Received:Received:
	 Received-SPF:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:From:Content-Language:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-PPP-Message-ID:X-Rspamd-Server:
	 X-Rspamd-Queue-Id:X-NC-CID;
	bh=qRO/LhoNHzQDuHYrAy6gaiy6iK5ILUoNKm7gazg+Oo0=;
	b=nTXzIR0BnESvj35ySGj43XQSiKyAo9m8FDYAz0CjR7ls2CAokyoPzyVV3M50JPvVZFx5
	 4wAt3aUUsno14SaLDs57oK9RIIvZFb0NwCR+AI+IBTv5RRuM6Q+d4oNoHjXLJmweL6oH3
	 F67b2sHJgNYTdJ0mE21OAYsADhROFKTbP5Yc64Jd30ZqGUs/BOSiT+6jCE8GpU0iMFIWb
	 M01ABfLQLV2ArhItMKuCMfCXCn7B7iBXNAkmV8f2b4dr2/jlSKAMVHxv8X5QZpPSx6skH
	 lb2LVhGM0/n55W2OA5K+j1RzK//kYNm0vCvRPNeEgQWoD39+hLHSVh/rZmtFV1vb4TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=leemhuis.info;
	spf=pass smtp.mailfrom=leemhuis.info;
	dkim=pass header.d=leemhuis.info header.i=@leemhuis.info header.a=rsa-sha256 header.s=key2 header.b=Ioa1txZy;
	arc=none smtp.remote-ip=188.68.63.102
Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF8A606A326
	for <patches@lists.linux.dev>; Sat,  7 Nov 2026 16:51:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1EF8A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=leemhuis.info header.i=@leemhuis.info header.a=rsa-sha256 header.s=key2 header.b=Ioa1txZy
Received: from mors-relay-2502.netcup.net (localhost [127.0.0.1])
	by mors-relay-2502.netcup.net (Postfix) with ESMTPS id 4jMMVt7314z6Nh8;
	Sat,  7 Nov 2026 17:50:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1794070247;
	bh=7sFUzNCPUQYAY+iiWHy92/LW8Ghkh3sGUkMXnoq7yUk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ioa1txZy/QZf+iZLivL0kV8DdLztLwgUyUKSNstrdN7aN5QRi8FJkcJ+Q8bXABQlG
	 4CArOVLbi4tlsHSguthL37NH+gDz3kNPqaiflk0YOX2VEoQumFcoU/4YjwotU/MU58
	 XT7c9A7Q99jwo8H2qDk7l6oAfV/8I767XbjJIbOR6/ghHRI510VwUo9h7bL4VBLThb
	 gWnywG/6oA20UpMaOJbaWezbbQR2xOH7nnYwMwtA+7Yi9U+3O0JUZ7vi3nsZSu8sX7
	 2F+BtyW1gZZotr5pMaEXE6fytGdg2KhBlZWZok4xEM+BqO0bSHa5M/VQxQbxBtVcmy
	 uLie1scdkYj2Q==
Received: from policy01-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-2502.netcup.net (Postfix) with ESMTPS id 4jMMTc5FXdz4yvc;
	Sat,  7 Nov 2026 17:49:40 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at policy01-mors.netcup.net
X-Spam-Flag: NO
X-Spam-Score: -2.898
X-Spam-Level: 
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy01-mors.netcup.net (Postfix) with ESMTPS id 4jMMTZ0Y6cz8v23;
	Sat,  7 Nov 2026 17:49:37 +0100 (CET)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 938185FB03;
	Sat,  7 Nov 2026 17:49:27 +0100 (CET)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=linux@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <0f632371-ee07-44ab-b574-a762b4063fca@leemhuis.info>
Date: Sat, 7 Nov 2026 17:49:27 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 0000/1257] 7.3.4-rc1 review
To: Ronald Warsow <rwarsow@gmx.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com, Pascal Ernster <git@hardfalcon.net>
References: <20261107134939.434104957@linuxfoundation.org>
 <68c2efb8-e54f-40bc-9c36-76c719a590d5@gmx.de>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: de-DE, en-US
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 MEK4
In-Reply-To: <68c2efb8-e54f-40bc-9c36-76c719a590d5@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: <179407016847.3182742.2836733914992484162@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: 938185FB03
X-NC-CID: kfG2x75ENRT7qX18+iX/yyMLXOzA8J5Bq4WFe1ephN6zwk5RJ0Y=

On 11/7/26 16:34, Ronald Warsow wrote:
> 
> kernel build / boot test on x86_64 (Intel).
> 
> I need to revert (here)
> 
> 1564da6afd7ce5297ba24f2d1e61d6a79a9ff6db

FWIW, that is "sched_ext: Fix the stall watchdog testing and blaming the
wrong sched under bypass". Ran into the same problem; Pascal (now CCed)
did so earlier (even before the new -rc was out afaics), too:
https://lore.kernel.org/all/c2569e78-f102-429a-a4a6-0b59d14226e1@hardfalcon.net/

Ciao, Thorsten

> otherwise I get:
> 
> In file included from kernel/sched/build_policy.c:71:
> kernel/sched/ext/ext.c: In function ‘check_rq_for_timeouts’:
> kernel/sched/ext/ext.c:3852:41: error: implicit declaration of function
> ‘scx_exec_sched’; did you mean ‘scx_prog_sched’? [-Wimplicit-function-
> declaration]
>  3852 |                 struct scx_sched *sch =
> scx_exec_sched(scx_task_sched(p), cpu_of(rq));
>       |                                         ^~~~~~~~~~~~~~
>       |                                         scx_prog_sched
> kernel/sched/ext/ext.c:3852:41: error: initialization of ‘struct
> scx_sched *’ from ‘int’ makes pointer from integer without a cast [-
> Wint-conversion]
> make[4]: *** [scripts/Makefile.build:290: kernel/sched/build_policy.o]
> Error 1
> make[3]: *** [scripts/Makefile.build:551: kernel/sched] Error 2
> make[2]: *** [scripts/Makefile.build:551: kernel] Error 2
> make[2]: *** Waiting for unfinished jobs....
> 
> 
> apart from that no regression
> 
> same .config:
> https://marc.info/?l=linux-kernel&m=179390956799135&w=4
> 
> Thanks
> 
> Tested-by: Ronald Warsow <rwarsow@gmx.de>

