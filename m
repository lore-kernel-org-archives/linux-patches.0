Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C92B1C05
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 01:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC06C433D6;
	Thu, 24 Nov 2022 01:04:18 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Y2Z4qlgT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1669251856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yftSFBarwsIAmHDvyINGRo5xUo935YOMsD41b+7z6XU=;
	b=Y2Z4qlgTpiGXtP1SVXvDkga0N2bcii6cQRPN+0CxD4tNzpCdW4Z6r0c8zFANyJq9R+shjy
	Kd4Ojo2VS9hRz8cn/SBBa4n67I3/mcatA+Ieu02TUpK6YtV3o2cuJJEv6hPTxXPx01HyO7
	NJLzyP4tPcqf9wMwP18O2Dfw8VITBk8=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 405ba4b1 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 24 Nov 2022 01:04:16 +0000 (UTC)
Date: Thu, 24 Nov 2022 02:04:13 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	tglx@linutronix.de, linux-crypto@vger.kernel.org, x86@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>
Subject: Re: [PATCH v6 1/3] random: add vgetrandom_alloc() syscall
Message-ID: <Y37DDX5RtiGsV6MO@zx2c4.com>
References: <20221121152909.3414096-1-Jason@zx2c4.com>
 <20221121152909.3414096-2-Jason@zx2c4.com>
 <87v8n6lzh9.fsf@oldenburg.str.redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87v8n6lzh9.fsf@oldenburg.str.redhat.com>

Hi Florian,

On Wed, Nov 23, 2022 at 11:46:58AM +0100, Florian Weimer wrote:
> * Jason A. Donenfeld:
> 
> > + * The vgetrandom() function in userspace requires an opaque state, which this
> > + * function provides to userspace, by mapping a certain number of special pages
> > + * into the calling process. It takes a hint as to the number of opaque states
> > + * desired, and returns the number of opaque states actually allocated, the
> > + * size of each one in bytes, and the address of the first state.
> > + */
> > +SYSCALL_DEFINE3(vgetrandom_alloc, unsigned long __user *, num,
> > +		unsigned long __user *, size_per_each, unsigned int, flags)
> 
> I think you should make this __u64, so that you get a consistent
> userspace interface on all architectures, without the need for compat
> system calls.

That would be quite unconventional. Most syscalls that take lengths do
so with the native register size (`unsigned long`, `size_t`), rather
than u64. If you can point to a recent trend away from this by
indicating some commits that added new syscalls with u64, I'd be happy
to be shown otherwise. But AFAIK, that's not the way it's done.

Jason
