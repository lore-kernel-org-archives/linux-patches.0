Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A828463DB
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 16:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8769C433D6;
	Wed, 30 Nov 2022 16:42:59 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="qB3A7/VY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1669826578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W/Yt9sETrgcOb+DFigZ5Lt0ZvNhz6xfqYXZDCs2pVzA=;
	b=qB3A7/VYJ10nES57qBL7DfgjAnODhcq2/24XjKlcwEMsW1D0HyobQG5kRvnya8gNn3igS4
	o4AHMTDtYqhgeFW+WBKPKw2vni9/C8mQlo26RQz2R9cqu1qxsRUiO/yQ/y/U7zcHciSfrj
	KUm3nXAX40DhCaMaTCTONPNnOhGty2o=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4a27c100 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 30 Nov 2022 16:42:57 +0000 (UTC)
Date: Wed, 30 Nov 2022 17:40:40 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Florian Weimer <fweimer@redhat.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
	x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v10 3/4] random: introduce generic vDSO getrandom()
 implementation
Message-ID: <Y4eHiCo8XEr1n7SZ@zx2c4.com>
References: <20221129210639.42233-1-Jason@zx2c4.com>
 <20221129210639.42233-4-Jason@zx2c4.com>
 <878rjs7mcx.fsf@oldenburg.str.redhat.com>
 <Y4dt1dLZMmogRlKa@zx2c4.com>
 <Y4dvz4d0dpFzJZ9L@zx2c4.com>
 <16ec2a7a-c469-4732-aeca-e74a9fb88d3e@app.fastmail.com>
 <CAHmME9rpdCGLQzfsNkX=mLHfWeEWi4TyrOf_2rP_9hsyX9v6ow@mail.gmail.com>
 <574ad32d-566e-4c18-a645-1470fc081ede@app.fastmail.com>
 <CAHmME9oGffi539nEAJkOjC-2yAR+0Ra+wQw5oG6Y6+CRr5e62g@mail.gmail.com>
 <974d7fcb-efbb-4508-a4cb-4b5328669c14@app.fastmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <974d7fcb-efbb-4508-a4cb-4b5328669c14@app.fastmail.com>

On Wed, Nov 30, 2022 at 05:13:18PM +0100, Arnd Bergmann wrote:
> On Wed, Nov 30, 2022, at 16:47, Jason A. Donenfeld wrote:
> 
> >> > There's padding at the end of the structure, yes. But both
> >> > `generation` and `is_ready` will be at the same offset. If the
> >> > structure grows, then sure, that'll have to be taken into account. But
> >> > that's not a problem because this is a private implementation detail
> >> > between the vdso code and the kernel.
> >>
> >> I was not concerned about incompatibility here, but rather about
> >> possibly leaking kernel data to the vdso page.
> >
> > The vvar page starts out zeroed, no?
> 
> The typical problem is someone doing a copy_to_user() of an in-kernel
> structure into the userspace side, which would then copy the
> padding as well. If the source is on the stack, a malicious caller
> can trick the another syscall into leaving sensitive data at this
> exact stack location.

I'm quite aware of this infoleak, having made use of it countless times
over the years. It just doesn't seem relevant to the vvar page.

Jason
