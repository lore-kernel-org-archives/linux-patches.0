Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84040AD46
	for <patches@lists.linux.dev>; Wed, 26 Oct 2022 20:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95938C433C1;
	Wed, 26 Oct 2022 20:45:13 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="pH1rSdfh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1666817112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nNeamkc4JAtTmIrGRdah4akNhJHCUZoQ7Huk4q1sT7E=;
	b=pH1rSdfhT50C6j6cbFr9MDbg+u9LGNKlRB0wmWbEL2pav8pwHun2IBez1gq3ETQhOCJ+xp
	z+AFgWsgMyRLwQU0Hs6evCLWVSEq7HVoEt01WgpfXabR4+zzTD4RjM/4tbHFhwQzeqPLfh
	6HXRsmo4dDAaEKRlWHZS6HQVAJUbo9s=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 61349750 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 26 Oct 2022 20:45:11 +0000 (UTC)
Date: Wed, 26 Oct 2022 22:45:08 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: kasan-dev@googlegroups.com, elver@google.com, patches@lists.linux.dev
Subject: Re: [PATCH] kfence: buffer random bools in bitmask
Message-ID: <Y1mcVEzAwxXz5v70@zx2c4.com>
References: <20221026204031.1699061-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221026204031.1699061-1-Jason@zx2c4.com>

Hi Sebastian,

On Wed, Oct 26, 2022 at 10:40:31PM +0200, Jason A. Donenfeld wrote:
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT))
> +		raw_spin_lock_irqsave(&kfence_freelist_lock, flags);
> +	else
> +		raw_spin_lock(&kfence_freelist_lock);
[...]
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT))
> +		raw_spin_unlock_irqrestore(&kfence_freelist_lock, flags);
> +	else
> +		raw_spin_unlock(&kfence_freelist_lock);
> +	local_unlock_irqrestore(&pcpu_bools.lock, flags);

I assume those conditionals are really upsetting to you. If you don't
want those, can you propose something that has the same good codegen but
doesn't need the conditional?

Jason
