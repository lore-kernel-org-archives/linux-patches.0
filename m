Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792431141;
	b=18CK+7pFMo40UFmI+EkHJnwEakRfobiXZOdl47329MJw/aoRriNMywC+0RKvlD8fw3X3
	 LdXKKPSUrkrE3lb1fq7GzwCo4JNKIvawyTv3dzm2n0m0rclyX3bh850bUbP+yuswHnOmP
	 DaNUX0Ms8xZ3WOWV4pjBdkCRQFvJTFf4XODocNH01OvpmgKLgYMQuWlGw+JkC0jmLkq+O
	 4ZjagAaQlPEHVyVhrcV58bWiLq+1jb3F1lTdcYjkSCBYiV6n9ISwcUxFNCgMKKnN8oJ4p
	 z0Xqd94Rql9bhNwe6/s3q2a5rxpOxqDcrXbDQ13ZHRwCxB/73aBiMqEdNf4gOJ1FGJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792431141;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=fH71wL26lccrp6A48zhvdYj1x6+Gqq4exVWEJZ0+OwE=;
	b=Ap21eLX8P3SFSr5GXccamxovvUIsfNJzWW2Bt2KYRbZivgGk/kYLZ7otsl1REPLOCUmB
	 bGxdJth6JmLQKSYMBCgDuJbviBcap9hgxaxGFBTrcWG+gy46gnXuRxL3lLmBA8cYJPA5d
	 0hM+9I07rPvA6XJAb1GqxFJH4dXs/wiM3IY03H/dnVl0T7Ogjy2qEoB5qbLCy4pqLRvRk
	 osT0Kt5cBEyFqWuSvRt2wgOPtncjb8X6eFbNgcypfzenk7zrtKDmTDmw/b532CpRUXqpQ
	 H1oLHTD0zMupd9e1Q8M0+apWIsaFl6w8OGlJKrYjc1n8Xjhfi7n0um/KyjQs+zPRfpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rPtzO+h5;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94713606A31D
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 17:32:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94713606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rPtzO+h5
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-3535a54bed9so3291683eec.1
        for <patches@lists.linux.dev>; Mon, 19 Oct 2026 10:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792431140; x=1793035940; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fH71wL26lccrp6A48zhvdYj1x6+Gqq4exVWEJZ0+OwE=;
        b=rPtzO+h5Yy6p02RHoBQnP766GVJryvZm49IbzSbUynd/myAvP1Gso1vNrruMpHAzVg
         fqL4jSfbS8T3GetV4Chct2VUNfFsDIvIFcF5tL5to03GKtzp0g8MyHCYz0zzTkWnUWtV
         1WrCnmSqX5TqPuum4tzfNC8t8L2jMxortq5tkQdfiEKU/lyuKUf3KHED3xs6i0V+EeGC
         HJsABPfel3tt7HSxfZxmVSw12lOsaIx+gDMpyugrySpwZtAGfYtgEKHkELIkvrAYC//5
         hrf3EABBCpzcrUqqfZkQfEDbu3JL2HfOhaQxu50XuEYC+8g49Qj6BvCA+vBBAIh/kzmK
         JB0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792431140; x=1793035940;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fH71wL26lccrp6A48zhvdYj1x6+Gqq4exVWEJZ0+OwE=;
        b=IMw46nTzxUaBrlY7uM0gOupPGkWHeKv8KZYXmDM/TTK4VWJ/HeTrIVeUajup03kctZ
         taOtTz2qEoQhxszm/T3nF35B2a03PVPwpcV+Cv/mgxG7MIzWqYvS/Y1Kh2GtJWiMLAWO
         sjXZrtMjj5N12wgUmAwitNASXEkb8EMHiMHrMV+noUlynfwcrW8yqlS/1rmNMp+GfQyF
         Lkz18Y8i3PdJwqyeCxkfBkpCcUAlHm1otaSowm0BkNjqiGbZ+TMYK2y80F+x+k0XS9lP
         O7Uu8aaDtvGL9atkJ1QQJIYGLCupqOO1n/efAOZV0gp64+B14LsmEIWrDHwWAfd4NBm9
         PYWg==
X-Gm-Message-State: AFq9FYLKwYMuLKrI4d2AhAWV9xA9rPnPUp+xlFjzBWONRFZ2bLs39cfx
	XWqLezrVIhnJpB7+aQziBc5poybmb7D559Sns+fOzCRIdH0TQheDW88q
X-Gm-Gg: AYBFou1Hx9MKeUqBuQ7f1P5ac8P7v2rQtMDMVFJpD0I58lZNRWvlOLlOAZrl6E3nmdl
	1U5C5aAU4X1K3BkD42OJuvQbkMLNlsUoggiR5wKmGTroNnixHuMD5BY+ppHUr5cK4Z3zfUUD3Up
	8W/AWIaSUZQU5xxlxUV+CXq3UmP+96qFUy1n44y7iHQFCgIgtl6C+a1qOkvvOWYhi715d3Mp3xD
	n1sG2tS28RZZQ7ZZ24Mqh2/48AbOiut/HFuZF0g8UvGx50CHe/AmmV7vM/gkaYaVzSovt5vX90C
	Vbl2GExzK/Ycl3q8Sl5pMl59PTeEMVwVDcrXAzN/wWU93iNnQDgztTht+XtmMgjjsfclG/WHnTW
	wP7bgipDOsw6pF4Zf0G91DLBx1Unf89TwQZxL/so5k/mVPkDLBFqgZKexDjhQ+qvLp91mvsk7MD
	R08W9XwLSQS031z+ehNrqp2TkANTNvhLCkPeaxyvbfJing/v8u6QtRVTDSPoC0RpF1bX6S39dVl
	HOje/OK9HVfr9hTLAXcLcVecFf0D219DpjS86k8naV3nmV+NXaOmj057XwYUUsNiEiLGAF+icQ9
	xuCEAw==
X-Received: by 2002:a05:7300:e9c9:20b0:35e:a225:3ba6 with SMTP id 5a478bee46e88-361c9c78086mr12197480eec.13.1792431139584;
        Mon, 19 Oct 2026 10:32:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3608308a87csm56584669eec.28.2026.10.19.10.32.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 10:32:16 -0700 (PDT)
Message-ID: <c5bea60a-e2b2-4bdc-8b1c-9aa464c1c84f@gmail.com>
Date: Mon, 19 Oct 2026 10:32:12 -0700
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
Subject: Re: [PATCH 6.6 0000/1674] 6.6.160-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261017160431.119607952@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/26 08:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.160 release.
> There are 1674 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 19 Oct 2026 16:02:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.160-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build on ARM and ARM64 with:

util/event.c: In function 'machine__resolve':
util/event.c:755:32: warning: implicit declaration of function 
'perf_env__get_cpu_topology'; did you mean 
'perf_env__read_cpu_topology_map'? [-Wimplicit-function-declaration]
   755 |                         topo = perf_env__get_cpu_topology(env, 
(struct perf_cpu){ al->cpu });
       |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~
       |                                perf_env__read_cpu_topology_map
util/event.c:755:30: warning: assignment to 'struct cpu_topology_map *' 
from 'int' makes pointer from integer without a cast [-Wint-conversion]
   755 |                         topo = perf_env__get_cpu_topology(env, 
(struct perf_cpu){ al->cpu });
       |                              ^


/local/users/fainelli/buildroot/output/arm/host/bin/arm-linux-ld: 
warning: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/arch/perf-in.o: 
requires executable stack (because the .note.GNU-stack section is 
executable)
   LINK 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf
/local/stbopt_p/toolchains_303/stbgcc-12.4-2.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.4.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o: 
in function `machine__resolve':
(.text+0xdfeec): undefined reference to `perf_env__get_cpu_topology'
collect2: error: ld returned 1 exit status

And as reported, on BMIPS, we have this build error:

net/sunrpc/svc_xprt.c: In function 'svc_recv':
net/sunrpc/svc_xprt.c:873:1: error: label at end of compound statement
  out:
  ^~~
   AR      drivers/media/platform/renesas/rzg2l-cru/built-in.a
host-make[5]: *** [scripts/Makefile.build:243: net/sunrpc/svc_xprt.o] 
Error 1

-- 
Florian
