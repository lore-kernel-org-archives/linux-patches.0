Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C628120E6E2;
	Fri, 10 Jan 2025 13:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736517105; cv=none; b=k2eABifppmilZPVVFmCJhPnsKpNw2e7uJ5DXdIRjWruA9H4kYCLxQFbhPupBbx50YsUzHkThGXjgwblIp10+4zjXOOWJdeaFPkNLIsLeJX1xU9EV8bfoBAvFgAzaLsIGQoGc4JsawK2cytFyKnYSrG8pfq38FIgY1VOVSJLud1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736517105; c=relaxed/simple;
	bh=Rt/eG1yJ9kc4YJnlHDUcrP/SSCRWQx0Qo7+i/2ry4VE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sZ4YVwTB2e4PbgdUcO9cQNK+yJlh3na7LclxCFpZBmtNZVrpJ1FI8gzpVjn2evKAp4cL+J/mxR2DXEnv9eKkDfy9GiKOSXItTjYI1d6UscmG8tgS3ukG9mPO29BsQY3RkpAx8REQFbBwrm8+yD74mKZdwMBHjVrqoJZRTriXzto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxoycvnV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxoycvnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF159C4CEE1;
	Fri, 10 Jan 2025 13:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736517105;
	bh=Rt/eG1yJ9kc4YJnlHDUcrP/SSCRWQx0Qo7+i/2ry4VE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JxoycvnVfJ5eOWFhXHqFU2aAC8smJ4uPlJmRcPyOrM/SBBdXBwKrj0PGLs1tHjkk8
	 WIt1y3e13vh+7612F7oWfYiN2p4SYQ+w8/iBQ27OvqLAaAhf1hLMOEhqs8bcmNRu1t
	 B3SQ+VSbqADbvyTJLYU2++Gg4+EcoEOUxcdIUfVY=
Date: Fri, 10 Jan 2025 14:51:42 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: Baoquan He <bhe@redhat.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Pingfan Liu <piliu@redhat.com>, Klara Modin <klarasmodin@gmail.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>, kernel-team@cloudflare.com
Subject: Re: [PATCH 6.6 079/222] x86, crash: wrap crash dumping code into
 crash related ifdefs
Message-ID: <2025011027-rosy-yo-yo-f51b@gregkh>
References: <20250106151150.585603565@linuxfoundation.org>
 <20250106151153.592449889@linuxfoundation.org>
 <3DB3A6D3-0D3A-4682-B4FA-407B2D3263B2@cloudflare.com>
 <2025010953-squeak-garlic-08de@gregkh>
 <CALrw=nHC27RRxG7aPzzGNaknaHiDzXKSL7o+MLCY=kjNFzWX3g@mail.gmail.com>
 <CALrw=nG+_KyvPiKBnZOVin4XL4fbwiKWj6=o2x0rMELQBpP9iQ@mail.gmail.com>
 <2025011043-tiny-debit-4507@gregkh>
 <CALrw=nERvgZSsSrex9c11k8ejbq36sYQsjw9MTA8pjC7h0hZ+Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALrw=nERvgZSsSrex9c11k8ejbq36sYQsjw9MTA8pjC7h0hZ+Q@mail.gmail.com>

On Fri, Jan 10, 2025 at 10:05:45AM +0000, Ignat Korchagin wrote:
> On Fri, Jan 10, 2025 at 9:58 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Jan 09, 2025 at 08:44:43PM +0000, Ignat Korchagin wrote:
> > > On Thu, Jan 9, 2025 at 6:08 PM Ignat Korchagin <ignat@cloudflare.com> wrote:
> > > >
> > > > On Thu, Jan 9, 2025 at 6:07 PM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > On Thu, Jan 09, 2025 at 05:39:04PM +0000, Ignat Korchagin wrote:
> > > > > > Hi,
> > > > > >
> > > > > > > On 6 Jan 2025, at 15:14, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > > > > >
> > > > > > > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > > > > >
> > > > > > I think this back port breaks 6.6 build (namely vmlinux.o link stage):
> > > > > >   LD [M]  net/netfilter/xt_nat.ko
> > > > > >   LD [M]  net/netfilter/xt_addrtype.ko
> > > > > >   LD [M]  net/ipv4/netfilter/iptable_nat.ko
> > > > > >   UPD     include/generated/utsversion.h
> > > > > >   CC      init/version-timestamp.o
> > > > > >   LD      .tmp_vmlinux.kallsyms1
> > > > > > ld: vmlinux.o: in function `__crash_kexec':
> > > > > > (.text+0x15a93a): undefined reference to `machine_crash_shutdown'
> > > > > > ld: vmlinux.o: in function `__do_sys_kexec_file_load':
> > > > > > kexec_file.c:(.text+0x15cef1): undefined reference to `arch_kexec_protect_crashkres'
> > > > > > ld: kexec_file.c:(.text+0x15cf28): undefined reference to `arch_kexec_unprotect_crashkres'
> > > > > > make[2]: *** [scripts/Makefile.vmlinux:37: vmlinux] Error 1
> > > > > > make[1]: *** [/home/ignat/git/test/mainline/linux-6.6.70/Makefile:1164: vmlinux] Error 2
> > > > > > make: *** [Makefile:234: __sub-make] Error 2
> > > > > >
> > > > > > The KEXEC config setup, which triggers above:
> > > > > >
> > > > > > # Kexec and crash features
> > > > > > #
> > > > > > CONFIG_CRASH_CORE=y
> > > > > > CONFIG_KEXEC_CORE=y
> > > > > > # CONFIG_KEXEC is not set
> > > > > > CONFIG_KEXEC_FILE=y
> > > > > > # CONFIG_KEXEC_SIG is not set
> > > > > > # CONFIG_CRASH_DUMP is not set
> > > > > > # end of Kexec and crash features
> > > > > > # end of General setup
> > > > >
> > > > > Odd, why has no one see this on mainline?  Are we missing a change
> > > > > somewhere or should this just be reverted for now?
> > > >
> > > > I actually tested the mainline with this config and it works, so I
> > > > think we're missing a change
> > > >
> > > > Ignat
> > >
> > > >From the looks of it it is missing 02aff8480533 ("crash: split crash
> > > dumping code out from kexec_core.c")
> >
> > Ok, I can duplicate this here now, but wow, backporting that commit is
> > not going to work.  Let me see if I can just revert a few things
> > instead...
> 
> Yeah, I tried that yesterday, but saw it is not that trivial. Thank you!

Should be fixed in the 6.6.71 release now, if not, please let me know.

thanks,

greg k-h
