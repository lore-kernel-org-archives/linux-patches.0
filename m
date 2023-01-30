Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1904617D9
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 10:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD55C433EF;
	Mon, 30 Jan 2023 10:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675074148;
	bh=l2jre3iHB3Bs/ZVbdIMxyNn0ZCbV0x1+gKltjmDsJhU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RovmwEzX/oA70hh2nVs3iLRzg9vlO8H6cKlzZ0XyCOZJ5HLhXY69du2oQonxfYcwZ
	 kZLqBWajvD4badsCKgVhdvZZsLAKXp7+7qpDp3bCYV/WnBgKELTCQogzAPPKOSczfm
	 7Zh7N3yV5C0Ty5ShBu6nDO7NJ+/nM9b6L+pfqxRA=
Date: Mon, 30 Jan 2023 11:22:25 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: stable@vger.kernel.org, Chun-Tse Shao <ctshao@google.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH 5.15.y] kbuild: Allow kernel installation packaging to
 override pkg-config
Message-ID: <Y9eaYcJl52ub5dAl@kroah.com>
References: <20230113002149.3984494-1-swboyd@chromium.org>
 <Y8Ky1UgT2yxFB2EB@kroah.com>
 <CAE-0n52wiAiHACFXeki6w7hfn3swuUp6jK6gpFvPxfrnmcV0TQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE-0n52wiAiHACFXeki6w7hfn3swuUp6jK6gpFvPxfrnmcV0TQ@mail.gmail.com>

On Tue, Jan 17, 2023 at 12:09:29PM -0800, Stephen Boyd wrote:
> Quoting Greg KH (2023-01-14 05:49:09)
> > On Thu, Jan 12, 2023 at 04:21:49PM -0800, Stephen Boyd wrote:
> > > From: Chun-Tse Shao <ctshao@google.com>
> > >
> > > commit d5ea4fece4508bf8e72b659cd22fa4840d8d61e5 upstream.
> > >
> > > Add HOSTPKG_CONFIG to allow tooling that builds the kernel to override
> > > what pkg-config and parameters are used.
> > >
> > > Signed-off-by: Chun-Tse Shao <ctshao@google.com>
> > > Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> > > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > > [swboyd@chromium.org: Drop certs/Makefile hunk that doesn't
> > > apply because pkg-config isn't used there, add dtc/Makefile hunk to
> > > fix dtb builds]
> > > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > > ---
> > >
> > > I need this to properly compile 5.15.y stable kernels in the chromeos
> > > build system.
> >
> > Is this a new issue?  A regression?  This feels odd to add a new build
> > feature to an old kernel when nothing changed to require it other than
> > an external tool suddenly requiring something new?
> >
> 
> The chromeos build system checks for pkg-config being called directly
> and fails the build if the proper wrapper isn't used. We set
> HOSTPKG_CONFIG in the environment when building the kernel so that it
> doesn't fail.
> 
> It's not exactly a new issue, but a self-inflicted one that makes
> building the stable kernel annoying. I figured it was similar to fixing
> problems with compiling stable kernels with newer toolchains, but if it
> feels odd then I'll just have to remember to pick this patch whenever
> bisecting stable trees. No worries.

Now queued up, thanks.

greg k-h
