Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830167F6
	for <patches@lists.linux.dev>; Thu,  1 Dec 2022 00:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE745C433C1;
	Thu,  1 Dec 2022 00:14:48 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="HwCb57zR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1669853686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Nv8gvPbFw2821E5AG4Xu9traJZGJZZdmyGaSwU8u28=;
	b=HwCb57zRDfJMhZHRxFuuhpEJK5s4GnwI+cF/dzV+LWkJblAiPMn9DB7lPotvYjYVlXi6kJ
	To2/DCIuACvOuxXEBdEU3P9OWFLJvHrQL3tyOSL3nyMd72gfWUiJFkiVOulM4ILJLkEt8Q
	wbjWWb+SSKizvMtY70GWAZWzdOBPHqI=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 85359182 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 1 Dec 2022 00:14:45 +0000 (UTC)
Date: Thu, 1 Dec 2022 01:14:43 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'Thomas Gleixner' <tglx@linutronix.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>,
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v10 1/4] random: add vgetrandom_alloc() syscall
Message-ID: <Y4fx87227hQfLrFq@zx2c4.com>
References: <20221129210639.42233-1-Jason@zx2c4.com>
 <20221129210639.42233-2-Jason@zx2c4.com>
 <87cz95v2q2.ffs@tglx>
 <310b91f650424d338e56794b8861a088@AcuMS.aculab.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <310b91f650424d338e56794b8861a088@AcuMS.aculab.com>

On Wed, Nov 30, 2022 at 10:39:38PM +0000, David Laight wrote:
> > struct vgetrandom_state {
> > 	union {
> > 		struct {
> > 			u8	batch[CHACHA_BLOCK_SIZE * 3 / 2];
> > 			u32	key[CHACHA_KEY_SIZE / sizeof(u32)];
> > 		};
> > 		u8	batch_key[CHACHA_BLOCK_SIZE * 2];
> > 	};
> > 	unsigned long	generation;
> > 	u8		pos;
> > 	bool		in_use;
> > };
> > 
> > Plus some kernel doc which explains what this is about.
> 
> That structure looks horrid - especially for something shared
> between entities.
> The 'unsigned long' should be either u32 or u64.

This struct isn't shared. It's used only by user mode code.
There may well be other issues with that long, though.

Jason
