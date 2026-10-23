Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792791280;
	b=cjjV5RRy1lrP2aS/Fo6J9l68YubJr2RaorZBWBlshlHRQYD6GRoZjr+lVJNlcNLzWd0S
	 vHsBGGeZxhDB1kyUGtSn7bq3+Hs3JuJhyBYUIkJX5eaBRI4Kx7aJNG0eSVQGBWOjfuQti
	 EmeZzvZeFKDHwpdhtNCQkq/j8wBQ8vSf7NmfM5o079MZVqRWPHIdBSPB9rqJk1sHiH8RI
	 FrVXzKLFnzOt0dqtJ/mQOP/6F7ioG9AiRb9vRNxbMPyAMScjT/FSNXGaVzqLUiwLPVOfB
	 /ahykGHCWotzmiYLkg8TLbIhdcvs7VkkYh6ihXN/sKC3pE/eWFL4Po7+i2pIBpqztEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792791280;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Sender:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=eesM4V7nSI+jbVwdqW3OP3XkNj+CjBTD1XOjhY7hHuM=;
	b=T/7QANFiS6NzyiHwT6nvQLeZOO1hrQqCfn0K6mk88KyJSLuMHnQDYBr1Y5pMkzb2jYrr
	 RydFoj1bQPu3kVx9A5ejkeK4/mxp6rF9GVwQfxe+Sf5ZLGjM/W9fmW2+J3sTswCTA9tAI
	 Vk59apIg6WsRjgMDr0CmlDe0zS/PrtTciSOQ3/E7vu6bzqJyPwXop3J2nUiTSBNiyNAca
	 W2ZZLf23T6R9lN02fO0IMkRiizIVS9RdmNzj+ErlRvIYhddt2fMfAXjCw951OKFWKNxdX
	 rjnTPZObWSejK9JTn7yNm/NOk92T96wm6A5RSA3T/QDTC/mbKJELq9a9v2IL331fgkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=debian.org;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LXvWQNX1;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB57606A31F
	for <patches@lists.linux.dev>; Fri, 23 Oct 2026 21:34:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DBB57606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LXvWQNX1
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso8709355e9.1
        for <patches@lists.linux.dev>; Fri, 23 Oct 2026 14:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792791278; x=1793396078; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=eesM4V7nSI+jbVwdqW3OP3XkNj+CjBTD1XOjhY7hHuM=;
        b=LXvWQNX1+yWbb+VrmT45nGQzU/f+qy+9M6km7Jof3bRvgURxgGbKdvuNT0zup/HfKQ
         +XmSM+g3gcVsef31hnhnwIOQ2VXyashi6s7lyCZv/klcfhd8uIsJs8WIvHNmPQsLq11v
         Fxed4iW1W7h6exmj/ZoImU0ppG+6ERtV/j48Yxow2PN3iM9m6rYlmbQaGtyDZb+OfSBL
         X4NSddWfSjPc8G6hTgCLIr8CzlzD39rDFWwhZjPjEMByBRiKcE5eJOQxV990KGhIYA0C
         vJRyIs+R8sp9d6tLkShEb8igA2u4c3/uiNjqMomUX7Cu3VidqP+8q0nTHKEk39iFi0cH
         F7wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792791278; x=1793396078;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eesM4V7nSI+jbVwdqW3OP3XkNj+CjBTD1XOjhY7hHuM=;
        b=Gos+aYBHYTVZRGQbZXDPC3Cx0GSKTiaTU4mIfqX6tsKGZczc9zRjaOZ2eU3eCTmOrH
         PGFWQ/4rvUVBmgsd5N3TEhwMB2oHRElqXXSrbxJuJ9ED2+9/E/8/rAY/WgK7sA5mNHic
         urMnj4ABmIhJjRmNbA/s86cG6MgnTn9g6zJcUNg5vLZodMBYf7dTpd+dvVjRFAeWVVWs
         7LONf3OoDqWkZog5TkIEZWAg5NgifZL4S1WIj/0yYM5Ar0X15fmuuPqXixBbg4kWXkHa
         nzPbLOVAymSeU9zDnLZtKN75NtGjRiESSlNmVh+EJoj+xi5ux9dwyXZMgg9aFG2bLf2o
         yjEg==
X-Forwarded-Encrypted: i=1; AKwUvBzeglA5vD8diWQjnkEEqTFrKB+YiY1WwxtzEUdpkEpelEjvjSK4Zm7CCDc5qNkcfckrpMLwtmJQ@lists.linux.dev
X-Gm-Message-State: AFq9FYKAh69GZJxyquRuqTD2jdjB4M1eb8VzkI+V5g/fdR0io6r90I4d
	CVM3voPwGpPpoXjIfD8Mg6Dx1cLVGSOzU3gji4Ez5bK2JJ8zm6k3PQIv
X-Gm-Gg: AYBFou0s6i/iIZFPi2wFYfI8liiWIPlX+flE8Da8jDBNL2odQLt8iEZig8H6U9w4RTb
	zRQfsqwK8VeGKoXvq1Op5MiwNNrBPREHN0Uy2NGRBOSyUutC/XMDsrPU2jAAklc5iGrGUGQzV2W
	jmJXB8+4Z3V5BbwGu5DPsnmxvcmoj5s9am7dQSQSx3H11qCzd4ez2+dPPyq09x6uAod1VDBMzWh
	iOFb7wSHR/oVDLhSngycuoWSZDhrVO+twpPyY+AGWqu09vBeT20Jfl41HtaXYiKL8n6zlv+rKbY
	lpzTjfu3F9XGn+Q00czMLj0IO4U8JAYqbnRC3oG1ZKKmSV/Rq0x9Udvky+vP/HPJgtXiaFHxfx1
	v60bygxe8CRD7N3qVeIa5oHt1CCUqTRTxzEBoe3j6WOf1I+YRYk+Op11rl6iCXOibj2T6ebkmTV
	rAr2HFxJPm3aw+CRwgdP6Mq3RBwGnFxKkRJy6h4daXw47pgyN22w46Q7tJXfOpHHND5Bw2ljOPB
	zb7zwCF5xgwFjVz64BsL/L3pqKufm5vM26Y8nfX7okEQgExoCbu5y+OL9ydVGlDCkE/FiuFg+8W
	BU/zc1v8x+3S1C4=
X-Received: by 2002:a05:600c:4e45:b0:4a2:d82:11bb with SMTP id 5b1f17b1804b1-4a35acbf5e7mr1981825e9.30.1792791278019;
        Fri, 23 Oct 2026 14:34:38 -0700 (PDT)
Received: from eldamar.lan (c-82-192-247-196.customer.ggaweb.ch. [82.192.247.196])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a04ad39sm34604505e9.1.2026.10.23.14.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 14:34:37 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 70FC1DC0579; Fri, 23 Oct 2026 23:34:35 +0200 (CEST)
Date: Fri, 23 Oct 2026 23:34:35 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Pavel Machek <pavel@nabladev.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.2 000/242] 7.2.13-rc1 review
Message-ID: <atvS68GhCvmAphrQ@eldamar.lan>
References: <20261023163713.816071858@linuxfoundation.org>
 <atvHKoRHHjKV4l8A@duo.ucw.cz>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atvHKoRHHjKV4l8A@duo.ucw.cz>

Hi,

On Fri, Oct 23, 2026 at 10:44:26PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 7.2.13 release.
> > There are 242 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Either something went very wrong with our testing, or this fails on
> all our targets. 6.18.59-rc1 does not seem to have those widespread
> failures.
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2982452623
> 
> Example failure is:
> 
> I'll look some more to try to figure out what is going on there.
> 
> Best regards,
> 
> 								Pavel
> 
> 
> [    1.238864] Yama: becoming mindful.
> L426[    1.238864] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
> L427[    1.238864] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
> L428[    1.238864] VFS: Finished mounting rootfs on nullfs
> L431[    1.238864] BUG: kernel NULL pointer dereference, address: 000000000000002c
> L436[    1.238864] #PF: supervisor write access in kernel mode
> L437[    1.238864] #PF: error_code(0x0002) - not-present page
> L438[    1.238864] PGD 0 P4D 0 
> L441[    1.238864] Oops: Oops: 0002 [#1] SMP PTI
> L446[    1.238864] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G S                  7.2.13-rc1+ #1 PREEMPT(lazy) 
> L447[    1.238864] Tainted: [S]=CPU_OUT_OF_SPEC
> L448[    1.238864] Hardware name: SIEMENS AG SIMATIC IPC227E/A5E42630598, BIOS V20.01.11 03/15/2018
> L449[    1.238864] RIP: 0010:rest_init+0x33/0xd0
> L450[    1.238864] Code: 34 ff ba 00 02 00 00 31 f6 48 c7 c7 70 a2 e6 b2 e8 52 d3 28 ff 89 c3 e8 bb 2d 34 ff 89 df 48 c7 c6 80 db 85 b3 e8 9d d7 2b ff <81> 48 2c 00 00 00 04 65 8b 15 63 6e 45 01 48 89 c7 89 d0 c1 ea 06
> L451[    1.238864] RSP: 0000:ffffffffb3803ee0 EFLAGS: 00010246
> L452[    1.238864] RAX: 0000000000000000 RBX: 00000000ffffffea RCX: 0000000000000000
> L453[    1.238864] RDX: 0000000000000000 RSI: ffffffffffffffea RDI: ffffffffffffffea
> L454[    1.238864] RBP: ffff8cf23ffed080 R08: ffffffffb385db88 R09: ffffffffb385db80
> L455[    1.238864] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8cf23ffed0ab
> L456[    1.238864] R13: 0000000000000000 R14: ffffffffb380c040 R15: 00000000b43e8000
> L457[    1.238864] FS:  0000000000000000(0000) GS:ffff8cf287953000(0000) knlGS:0000000000000000
> L458[    1.238864] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> L459[    1.238864] CR2: 000000000000002c CR3: 000000000d630000 CR4: 00000000001006f0
> L460[    1.238864] Call Trace:
> L461[    1.238864]  <TASK>
> L462[    1.238864]  start_kernel+0x7a2/0x7b0
> L463[    1.238864]  x86_64_start_reservations+0x24/0x30
> L464[    1.238864]  x86_64_start_kernel+0xcd/0xd0
> L465[    1.238864]  common_startup_64+0x13e/0x158
> L466[    1.238864]  </TASK>
> L467[    1.238864] Modules linked in:
> L468[    1.238864] CR2: 000000000000002c
> L469[    1.238864] ---[ end trace 0000000000000000 ]---
> L470[    1.238864] RIP: 0010:rest_init+0x33/0xd0

Same here indepently, but not yet bisected.

Regards,
Salvatore
