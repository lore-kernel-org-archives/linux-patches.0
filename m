Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92822DA75A
	for <patches@lists.linux.dev>; Tue, 21 Jul 2026 16:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784651571; cv=none; b=RfjS+LF/oWbMZmYzsQbQH/49ZzkvM9qQhS6z900lQOXZkpzGK3gEoDwHKoxR/GZJPXhq2rFLJfyOEpiKLcnYghag1DRKwJ4pyQbIqRmmBVyH1UzqR97LRRLPdZvusZbAdIJFO5pQn8rNxN6gDmKsoirGi/Zl/U9z9bPsFwCeqWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784651571; c=relaxed/simple;
	bh=HmWR9QEkurh9by8p+XQNBkuAhyZ6c/KcKvYRTvnDJGE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QXsPWqbldP0gdXO7+Fdrp8YmSDorkDrd1vs4MEjfafQzL0dJfayNKY2fQbSDPtg9q97McV1RnDHikKst7bqNtApFqHmS8GyQHcd7u/6Pk0O06teLJESvRZeIpA7Inhz7YBU834KZ21inZC7Mt9GlF5hpl0Gnvp1NUCPAlGWNlxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g/+fonE+; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g/+fonE+"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c96c92c0980so5405601a12.3
        for <patches@lists.linux.dev>; Tue, 21 Jul 2026 09:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784651570; x=1785256370; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rojvLStlOa8TuKO/DtD3fsmX3MSIIpt1yWUNLbmNaiQ=;
        b=g/+fonE+Rf6+KWUUGOtEOBg1JHbFBult7RiUupEhS60KU0Qd/B1gcJcw3F2mVxnoi5
         owdK/oY8e4Up35XIwoa+kZMwCIr0wqtZgS0TLBzqiMKPjk/UEmFDp63I+t2ftHCy8r7Y
         kPkQjICS+2SP+ZTpacrGh+t8Kg5rqfs/GllLfTtEh7IhH7/FGMkjOtAvoGk/OcnbnvOI
         6dspZk1ZJBRRjeGD36a1oM4vFNJeNeEzCzd0MhuGysPaZ0JukWQtgJ5rtr2iDLFtyAzI
         fL3JsFqIdWQrtO04FdjYlu4uq+hmEwrIH2WHX2hj7vNvDFjWWvs7ZkV8dX4inHvKAzF0
         3JkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784651570; x=1785256370;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rojvLStlOa8TuKO/DtD3fsmX3MSIIpt1yWUNLbmNaiQ=;
        b=ITFaxddr5CcuE81VnT7Dkh5A4zND1Lgb0RHz9eZu/RXT2uyyzhEpDwExClR5KSvEsO
         ch9Q304HmVHfOHkIYMUMhe4bppr0TMnNcs1l3VCbOqfs0J26EiI77ilD6RZtzDdqEFWJ
         wiNnZeiSzRuh3JMnr7zZOy+X44hxhivOJbrfDhSDbUlm3EUgPpILbahI/ivMMypBv0bh
         +BDPCwHSgYeT45osczdN6DY0m1rmbUwJfGON3v4ujZrQ7gYOaO7UtelTYojO00lg6abt
         /gR4+SYvvl1JcjI57jQ5tdRyYn5yaqrfGMXmWMugHEtjZKYoo/EEqmQSCztWE09yT7SX
         YLQQ==
X-Gm-Message-State: AOJu0Yy4u9IxfITS218xvvA3i5uagjArvq0mnETYcQBtbwK73wLriYNS
	brOl8qzUcrOrqAwc6UzES+4j4izueCDUuVKLnqadJl1abXIvREbe4LNG
X-Gm-Gg: AfdE7cmUo4w/onxdVrinMt4Kb79f+YlZVKMzDl+FmJqPtqKFlwxkaFvClJAi2gvLE5u
	bSxFXnfQnxqQwTYjnQv+3XaT7SJM0W9smFDZF6g+U6PCM4lt/PtDI6tGn722BsacutBmGxYG+7P
	9dfhXoM1SpEhxhNW8brqguBpqKuVHrZFwwWyS84QUAopZTZN4idetEARihwNjXgxuUxqaj5v6kQ
	L1YwBrRmSbyrk0JFxD7ChZcNAKJ1qZIoN3qrPCsXfETBk/EX86obpTkM2gaB+ALupHunkwifdf0
	Es5C7neLyZMt+P1y9FG+4bNjU+rnY9COnH5jJQ1kNRPd/CjEFOQOx/ux7WDAbtjuFitkn9S/Obs
	0SWHZOQ7D3bKXn9qBLx3fD7jlVQnTRytrVsGvtibCyYXY3E2edg1xnM9zalJiGKvx5xxa266EQk
	gQHtx0S0HKddY48OLk0fwDeyoR5Ptv
X-Received: by 2002:a05:6300:7105:b0:3c4:1c9f:d91 with SMTP id adf61e73a8af0-3c41c9f2e52mr1788962637.59.1784651569833;
        Tue, 21 Jul 2026 09:32:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce29ffb13sm42467604c88.6.2026.07.21.09.32.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 09:32:48 -0700 (PDT)
Message-ID: <c0138a17-5653-48ec-87c2-4da1d3354306@gmail.com>
Date: Tue, 21 Jul 2026 09:32:47 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/699] 5.10.261-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260721152355.667394603@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/26 08:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.261 release.
> There are 699 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.261-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


perf fails to build with this error:

util/event.c: In function 'machine__resolve':
util/event.c:668:32: warning: implicit declaration of function 
'perf_env__get_cpu_topology'; did you mean 
'perf_env__read_cpu_topology_map'? [-Wimplicit-function-declaration]
   668 |                         topo = perf_env__get_cpu_topology(env, 
(struct perf_cpu){ al->cpu });
       |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~
       |                                perf_env__read_cpu_topology_map
util/event.c:668:83: warning: excess elements in struct initializer
   668 |                         topo = perf_env__get_cpu_topology(env, 
(struct perf_cpu){ al->cpu });
       | 
                   ^~
util/event.c:668:83: note: (near initialization for '(anonymous)')
util/event.c:668:81: error: invalid use of undefined type 'struct perf_cpu'
   668 |                         topo = perf_env__get_cpu_topology(env, 
(struct perf_cpu){ al->cpu });
       | 
                 ^
make[6]: *** 
[/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/build/Makefile.build:97: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/event.o] 
Error 1
make[6]: *** Waiting for unfinished jobs....

which is due to commit 07511f3c23cdaf1dbb44802f026fcc476351dfe2 ("perf 
tools: Use perf_env__get_cpu_topology() in machine__resolve()"), it 
looks like we need to also backport those commits:

751835c57632006232bf30405cd7201dceb0b8e0 ("perf stat: Introduce 
perf_env__get_cpu_topology() to guard NULL env->cpu")

6d18804b963b78dcd53851f11e9080408b3d85c2 ("perf cpumap: Give CPUs their 
own type")

c760174401f605cf63314d3817069a40945f0e0b ("perf cpumap: Reduce cpu size 
from int to int16_t")
-- 
Florian
