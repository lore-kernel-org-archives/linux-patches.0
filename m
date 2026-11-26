Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795675987;
	b=w21jdHQH1rkfNPomBcyZ8hAtW/W2KgR6bEUpkoq4/7u9dV7h1vdnY6BD3Lm+diTE6Kmh
	 GL3TGAAAYKmCMAtqA/FZ025LimWIu5oUcquLIilbvneqnLoJkMB5ydSCT5ANvamX6fB8h
	 fhO6He83xPrLyQgAUygWa7xSI42JI/6m5ipE+ygJ00BnK+Jho8tIGUwAUR8TvY6mMmd9t
	 DNyt+WDXffT26NPS92TYrHVgoMeIL+9m+d0USisFW0ZmPXKat3+uhblOxdF9QiL0mwqX/
	 TwHRp61MytS0N9XupPE2T2dmMufBuzw7sgVX9ztFW8nXwax+cFmbyRAxtFD87V9kPTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795675987;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=q2CDoIWYAq1+PzSJD+o7MNawkP7AuiFf2eXqCsRLeW8=;
	b=O3jy2PoWYTogR/j5lr/bEip/aCupjrDb3rjL9ibqyttCpveqFu+SsqpQCG5x3d+8549l
	 erZ/DxrSNRU4BvDcxCnEZD2EPnqc6MTZTKbl7C51x2hgndIXujmUHKMWrLWStK+3HPUln
	 1urdcIjBDBS6LPB3NtyALofJYsrymnOulLEVE4o+iqmqeQ5VSC6exoTkAxe8Z/GUu/Zfv
	 bi8dk3P7uqvyQIE0cRiIdfYYQA9+ThxUsGSA7+BMOoerUB8i5V84a44waiZlpyDSFYSz8
	 norB10NzruBYDJC2FTY+mx2ksqbpHiFVq0MyAy9Vehp3IqebNEdPOVsgzU8Ypko/CnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OwBf4ZaA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9E7606A31C;
	Thu, 26 Nov 2026 06:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OwBf4ZaA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97F21F000D0;
	Thu, 26 Nov 2026 06:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795675987;
	bh=q2CDoIWYAq1+PzSJD+o7MNawkP7AuiFf2eXqCsRLeW8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OwBf4ZaAtI9jAFxIRVzTJiHd35eJu+kFyxrV2/k/svmNOCjJwDQ/MlaxrS7PDoB4m
	 BSe6fDF6ZsGEYnsJcU44+5AFAN/heGQUDalWqgGbuTlH8amqpNIerwRfDeu/sUXSPL
	 9RH9k2xrJpmbsQZYgwRW93ld/FZcDoE2+5mybHXkkQLo0NzODplLNEFjC1neufqOok
	 SoPdyjRRdNdOwzzhgoNm1CfeZa1H1NZNl/zZ7/JOp264HLMM97ke1tIIRNAHJbwzHz
	 Dg/1V0q5jcTZR8nM8KK60snociHLJpkw9BY378taf4EpOS8Ba499nM34ok2U0Oj1Pn
	 T+DFN1RXJhReQ==
Message-ID: <dc5dc970-d7d5-46e4-8b2e-327c7e31a90b@kernel.org>
Date: Thu, 26 Nov 2026 07:53:04 +0100
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
Subject: Re: [PATCH 7.3 0361/1005] sched_ext: Reset task fields on exit of an
 SCX_TASK_READY task
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Rahad Bhuiya <rahadbhuiya2021@gmail.com>, Tejun Heo <tj@kernel.org>,
 Sasha Levin <sashal@kernel.org>
References: <20261125143821.729802100@linuxfoundation.org>
 <20261125143830.189554233@linuxfoundation.org>
 <0782adf7-20af-45a3-a09b-2a34c76afbac@kernel.org>
 <2026112640-recite-tipping-891f@gregkh>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <2026112640-recite-tipping-891f@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 26. 11. 26, 7:36, Greg Kroah-Hartman wrote:
> On Thu, Nov 26, 2026 at 07:19:47AM +0100, Jiri Slaby wrote:
>> On 25. 11. 26, 15:28, Greg Kroah-Hartman wrote:
>>> 7.3-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Rahad Bhuiya <rahadbhuiya2021@gmail.com>
>>>
>>> [ Upstream commit 564405c424f49d70b13debe7fe5b550234ad6b84 ]
>> ...
>>> --- a/kernel/sched/ext/ext.c
>>> +++ b/kernel/sched/ext/ext.c
>>> @@ -4198,6 +4198,7 @@ void __scx_disable_and_exit_task(struct scx_sched *sch, struct task_struct *p)
>>>    		args.cancelled = true;
>>>    		break;
>>>    	case SCX_TASK_READY:
>>> +		scx_reset_task_fields(task_rq(p), p);
>>
>> This fails to build:
>> ../kernel/sched/ext/ext.c:4223:17: error: implicit declaration of function
>> ‘scx_reset_task_fields’; did you mean ‘scx_set_task_sched’?
> 
> Ugh, I wonder why this code never hits my build tests...

We seem to have:
CONFIG_SCHED_CLASS_EXT=y
maybe you don't?

thanks,
-- 
js
suse labs

