Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A2F1FB8
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 07:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F95C433EF;
	Tue, 21 Mar 2023 07:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679384626;
	bh=+o5mi4UIlI7dJ8Bt06aDjLVpQCulxpfSxXJkInsWqL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2I7dfgQJYCuIzpdv7aOusjOkwd9MBtNn33RAdKt+dIEwNChIwdKiDMJtaNPgLKNGs
	 AZUPM4Jhf2laVPALd5l6dW2/7fFMO0g6oFElG7aSrLpm+ovOsd5xoPFQjGtHgeU0zZ
	 3vdl+CA20awLquhewaWZ2+7VOjoUcvfrobeaO3xw=
Date: Tue, 21 Mar 2023 08:43:44 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Gow <davidgow@google.com>
Cc: Pavel Machek <pavel@denx.de>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/99] 5.10.176-rc1 review
Message-ID: <ZBlgMNnD2BR1Yvac@kroah.com>
References: <20230320145443.333824603@linuxfoundation.org>
 <ZBi2y4cQRKnTAAFS@duo.ucw.cz>
 <CABVgOSnfMXd4Q=GXvq8Ma26wpaM6E=LOYLxXn83YQEV-Yn2sBg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABVgOSnfMXd4Q=GXvq8Ma26wpaM6E=LOYLxXn83YQEV-Yn2sBg@mail.gmail.com>

On Tue, Mar 21, 2023 at 12:02:30PM +0800, David Gow wrote:
> On Tue, 21 Mar 2023 at 03:41, Pavel Machek <pavel@denx.de> wrote:
> >
> > Hi!
> >
> > > This is the start of the stable review cycle for the 5.10.176 release.
> > > There are 99 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> >
> > > David Gow <davidgow@google.com>
> > >     rust: arch/um: Disable FP/SIMD instruction to match x86
> >
> > Why is this patch here? It does not make sense for stable, it was only
> > in AUTOSEL for less than a week, and I already explained why it is
> > bad.
> >
> > "git grep KBUILD_RUSTFLAGS" if in doubt.
> 
> I agree: let's exclude this patch from -stable.
> 
> While the CFLAGS part of it is still _technically_ valid without Rust,
> it turns out it triggers a bug in gcc <11, so is probably best
> avoided. See:
> - https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99652
> - https://lore.kernel.org/linux-um/20230318041555.4192172-1-davidgow@google.com/

Thanks, I've now dropped this from kernels 5.15 and older.

greg k-h
