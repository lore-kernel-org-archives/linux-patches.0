Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF427E0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 01:37:35 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1669772252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T7ypEsMCG1B5UetzSV3WNhjCcELQd+iloz72chOLVNs=;
	b=mqN8y5hK12RezXboBh5E/1jPdV113HO1jjlvxQs0O/mry6NEbui8U1JV0PDAY8hh16Moej
	/Tm/oZPYZVzCtin5IyzTvtCZmbbT3fzAmlFcANy16n8360tNVhhY4qvIkWXVORhBhGXime
	fyzrwAaeDcJ2erbc16cTS0AOdCytSqqLEZpI25l/SDyaE5gjA6qgZqqMgiuEW7EpndNxw8
	DatA53gg/9nj1qghDiKRd/+fSpBwg7MqVlmZEC6BvPEqlzYmhIE5eImw0QcrC+AQO1UcRF
	gbj7NTi1TMyF2CrMzmK9P4wDVp3qK9G9JawIvkyL8FP9KNESvI8RnaVUPH+kJA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1669772252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T7ypEsMCG1B5UetzSV3WNhjCcELQd+iloz72chOLVNs=;
	b=Re7LLaTTDmDxGKk42H/loPS+sN+Q+LpBPzhLvMq+fu/rXOX+LrRQaFMxdzQ4QaRg/ksYL6
	pSux3G/9lRvpZdBw==
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Adhemerval Zanella Netto
 <adhemerval.zanella@linaro.org>, Carlos O'Donell <carlos@redhat.com>,
 Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
 Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v10 1/4] random: add vgetrandom_alloc() syscall
In-Reply-To: <Y4arB7/zB8mRoapK@zx2c4.com>
References: <20221129210639.42233-1-Jason@zx2c4.com>
 <20221129210639.42233-2-Jason@zx2c4.com> <87cz95v2q2.ffs@tglx>
 <Y4arB7/zB8mRoapK@zx2c4.com>
Date: Wed, 30 Nov 2022 02:37:32 +0100
Message-ID: <87mt89te77.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Nov 30 2022 at 01:59, Jason A. Donenfeld wrote:
> On Tue, Nov 29, 2022 at 11:02:29PM +0100, Thomas Gleixner wrote:
>> > + * Returns a pointer to the first state in the allocation.
>> 
>> I have serious doubts that this statement is correct.
>
> "Returns the address of the first state in the allocation" is better I
> guess.

Does not even come close to correct.

As my previous hint of 'using this as template for the (hint:missing)
man page' did not work well, may I suggest that you look at the various
return statements in that function and validate whether your proposed
return value documentation is valid for all of them?

Thanks,

        tglx






