Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795674858;
	b=3NzEnn4ZZ844Cin1vrCnFacrVBd0AkdyxdeMXaYT/o9HwUWIGQX3M3+jKNtcuqg8ULYl
	 huhvqKUR2PIuQb95g4Ji7BnNkl8uozrSp0DHFAI+4oZnaluN+/lJIRAdBxeTPkkgVK6YK
	 KtnHaBZBenwO5lCrTg+Py4ETlM2xTjKU9GUihMqxCTE0vtouNtQ56lZoHEd3Dm9xK6A0/
	 veBVYHI4j++dPoeCw9AUo93vEblU8HS6WjYf9tICPp1gHSOYcDAV17x+voMULNmqSWkpD
	 iWbI/ZXg2AV8kTYcKMttYqSkb5AiNsV67CFZo3mOsuBHYw5SRACCqcHztAxD1S1oiTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795674858;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=sJxcm9f1ooixESmgsbsPOMx8LazcfEcqf+7g3gT12TM=;
	b=1eAb6N/DBXctylHTwzw/+kTYLN1GWHzSrb7jR2OdIuflWL5wFca+8urcUJtPO3ExmM7x
	 HVtp2SS2EwP7UE2/PpD6aJR+rPLpLMBC0wVzz6BW9O4zUgzI8hNtazaKLPi0RfvRqjdtP
	 93mxpxdkUDsImNkzP8E/z1ppEh/FOP4jGLi8vqYI5gncgDUKu2cv1AH4Py6uWQBjW2s+G
	 SNwyR6QfAjHIk6eA21yO7VN+4V+BlPctFSGnSyymfWEe/VWS0IoJ6rEYMyi24nnG3qchX
	 ZLMklno+/MK52qMILsM2G3ceRjuFxMt+4GX9vRoVnqOWepSUBCYDQI6ReQeNidYon/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=khPl4Kpu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA19606A334;
	Thu, 26 Nov 2026 06:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=khPl4Kpu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D791F000C0;
	Thu, 26 Nov 2026 06:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795674858;
	bh=sJxcm9f1ooixESmgsbsPOMx8LazcfEcqf+7g3gT12TM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=khPl4KpuPiGbxHtJT2x+EeiiRZdRP5+Hm5NKbDxKt4aV0jDdHKzJvDCTr7uDAAV0m
	 5h1Uacqz+scskT0DyoDceN0x6GyF7UFGSGXYF2r7U6vEjguQqNczzXphWskNQUQbw7
	 JCxgqB/B+TaZZGKmUWhBPpttLwV07UVkaJ5d8AUHXwvimKunW2GiZA/sHhN5CdBv7o
	 mK+AadWYZVtHXuJ0/4Lt7GZcMPqoK2HGMt3T8RuSoVPzMcQl4rrBrWz9idJ2tAWhJX
	 qwsfJyCuZ+hGp9sHk22UE/9h+c5ZmQevdn6jFXcFZ89ea1h1jWpW9H83nrLqXEcOPC
	 9IHE83/FLg/YQ==
Message-ID: <87bca99f-82b5-461d-bd3b-23f217b895d1@kernel.org>
Date: Thu, 26 Nov 2026 07:34:13 +0100
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
Subject: Re: [PATCH 7.3 0000/1005] 7.3.7-rc1 review
To: Ronald Warsow <rwarsow@gmx.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261125143821.729802100@linuxfoundation.org>
 <1ba253a4-fdef-4169-9e9b-cdb6652e47c6@gmx.de>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <1ba253a4-fdef-4169-9e9b-cdb6652e47c6@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25. 11. 26, 19:12, Ronald Warsow wrote:
> Hallo
Gruss gott,

> RC doesn't compile here and currently couldn't figure what's up.
> 
> Question as an git greenhorn:
> Is it able to bisect a kernel which initial doesn't compile ?

Sure.

> if YES: what is the bisect start then ?

The previous stable release (v7.3.6 in this case).

> Error:

I reported these against the respective commits already:
[PATCH 7.3 0361/1005] sched_ext: Reset task fields on exit of an 
SCX_TASK_READY task
[PATCH 7.3 0478/1005] sched_ext: Add scx_bpf_dsq_reenq_task() to 
re-enqueue single tasks from a DSQ iteration

> In file included from kernel/sched/build_policy.c:71:
> kernel/sched/ext/ext.c: In function ‘__scx_disable_and_exit_task’:
> kernel/sched/ext/ext.c:4223:17: error: implicit declaration of function 
> ‘scx_reset_task_fields’; did you mean ‘scx_set_task_sched’? [-Wimplicit- 
> function-declaration]
>   4223 |                 scx_reset_task_fields(task_rq(p), p);
>        |                 ^~~~~~~~~~~~~~~~~~~~~
>        |                 scx_set_task_sched
> kernel/sched/ext/ext.c: In function ‘scx_bpf_dsq_reenq_task’:
> kernel/sched/ext/ext.c:10432:20: error: implicit declaration of function 
> ‘kf_switch_rq_lock’; did you mean ‘switch_rq_lock’? [-Wimplicit- 
> function-declaration]
> 10432 |         entry_rq = kf_switch_rq_lock(src_rq, &flags);
>        |                    ^~~~~~~~~~~~~~~~~
>        |                    switch_rq_lock
> kernel/sched/ext/ext.c:10432:18: error: assignment to ‘struct rq *’ from 
> ‘int’ makes pointer from integer without a cast [-Wint-conversion]
> 10432 |         entry_rq = kf_switch_rq_lock(src_rq, &flags);
>        |                  ^
> kernel/sched/ext/ext.c:10450:9: error: implicit declaration of function 
> ‘kf_restore_rq_lock’ [-Wimplicit-function-declaration]
> 10450 |         kf_restore_rq_lock(src_rq, entry_rq, flags);
>        |         ^~~~~~~~~~~~~~~~~~
> make[4]: *** [scripts/Makefile.build:290: kernel/sched/build_policy.o] 
> Error 1
> 
> 
> Tested-by: Ronald Warsow <rwarsow@gmx.de>
> 

-- 
js
suse labs

