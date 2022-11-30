Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B14658
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 01:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2817C433C1;
	Wed, 30 Nov 2022 01:11:37 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Eus0bUdS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1669770696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=msWMG4aSQ8iKP4FJghE685UoBbc0Ucc1Sy5dTMvH670=;
	b=Eus0bUdSqgwFOp9KuWRv/cCU8JAcTcLeJIq8hJjhZHkCyJM8u/i+j0ymPjn7F+Z7k3IRne
	uVLet8ft9iK2zHlLCp1eTC96x5drHYHI6rgwi9BwW738BWs6hxr6fUyb8kxBnsMeBmh/eA
	ReqtNZAkyY1g9HxH1iWr4mDVnzG57yA=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id aac5defd (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 30 Nov 2022 01:11:35 +0000 (UTC)
Date: Wed, 30 Nov 2022 02:11:30 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
	x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>,
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	Samuel Neves <sneves@dei.uc.pt>
Subject: Re: [PATCH v10 4/4] x86: vdso: Wire up getrandom() vDSO
 implementation
Message-ID: <Y4atwmYQOV0cZ4n6@zx2c4.com>
References: <20221129210639.42233-1-Jason@zx2c4.com>
 <20221129210639.42233-5-Jason@zx2c4.com>
 <874juhv0fe.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <874juhv0fe.ffs@tglx>

Hi Thomas,

On Tue, Nov 29, 2022 at 11:52:05PM +0100, Thomas Gleixner wrote:
> On Tue, Nov 29 2022 at 22:06, Jason A. Donenfeld wrote:
> > Hook up the generic vDSO implementation to the x86 vDSO data page. Since
> > the existing vDSO infrastructure is heavily based on the timekeeping
> > functionality, which works over arrays of bases, a new macro is
> > introduced for vvars that are not arrays.
> >
> > The vDSO function requires a ChaCha20 implementation that does not write
> > to the stack, yet can still do an entire ChaCha20 permutation, so
> > provide this using SSE2, since this is userland code that must work on
> > all x86-64 processors.
> 
> Way more consumable and looks about right.

Good.

> Please take your time and
> give others a chance to look at this lot before rushing out v11.

That's my plan indeed. Now that the patch is reviewable, I'll let it sit
for a while. In between v10 and v11, my scratch work will be in
<https://git.zx2c4.com/linux-rng/log/?h=vdso>, which is rebased often.

Thanks again for looking this over.

Jason
