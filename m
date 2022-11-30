Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90830A42
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 10:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4E9C433D6;
	Wed, 30 Nov 2022 10:06:46 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="bviZgfjr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1669802804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QHaLJoXz+lC9Wofr7nMpzVPQqEpDYfg9bt0J6FDLCDk=;
	b=bviZgfjrON/lxa7Ch44JjNxgQYoEbP23uCE/+8yl6p40eNN+hvJwChL+MloHeoSVGGJ4ev
	WZrJI0xlrAwHl/6a1ajpPPWOLuLq1Y/9EAvy5YLyPeFuyCwHy6sjVLhHlGoMZ+Ht+nzGFF
	UlAkcn5F91O2LulDbTBP4bkyIQhEYfA=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 396f555f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 30 Nov 2022 10:06:44 +0000 (UTC)
Date: Wed, 30 Nov 2022 11:06:39 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	tglx@linutronix.de, linux-crypto@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>,
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v10 2/4] arch: allocate vgetrandom_alloc() syscall number
Message-ID: <Y4crL0dqX7U4wnHH@zx2c4.com>
References: <20221129210639.42233-1-Jason@zx2c4.com>
 <20221129210639.42233-3-Jason@zx2c4.com>
 <CAMuHMdUGkhFu7X8eUMU1qqTOLKC=xsXWG2obPUeTwzyMGD8grw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMuHMdUGkhFu7X8eUMU1qqTOLKC=xsXWG2obPUeTwzyMGD8grw@mail.gmail.com>

Hi Geert,

On Wed, Nov 30, 2022 at 09:56:06AM +0100, Geert Uytterhoeven wrote:
> Hi Jason,
> 
> On Tue, Nov 29, 2022 at 10:09 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > Add vgetrandom_alloc() as syscall 451 (or 561 on alpha) by adding it to
> > all of the various syscall.tbl and unistd.h files.
> >
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> 
> Thanks for your patch!
> 
> What's the policy regarding adding syscall numbers for VDSO-related
> syscalls on architectures that do not support VDSOs yet?

I don't know exactly what the /policy/ is, but not wanting to rock the
boat, the first iterations of this series only added it to x86. But then
Arnd joined the thread and said I should add it to all of them all at
once and separate that out into this commit, so that's what we have
here. I think the idea is to keep syscall numbers synchronized these
days between archs if possible.

Jason
