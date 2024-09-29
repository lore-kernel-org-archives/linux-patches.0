Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D72918593C;
	Sun, 29 Sep 2024 21:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727643607; cv=none; b=jVN/n2Vz1CLmYIei+L5baiR0VHkx91d4NSL4y+z62z+wAcA9RdIKeSeRbMPAzsJib+DEP4yaSuSdLct28yTnNCpLx5wiy2pL8ZukZ4sOnCLUja+/xhfP/029868rGSP3nxee0OJih81aEBjHWFU2ubksdkwJbkYuiQze83iUrRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727643607; c=relaxed/simple;
	bh=KGA3zi5t2JC0Swy+ojjoAMeumKZ91sROSi+XAnxz12E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rsYDW2Qt2FB0ni/gpLOJsFVdtYGoY7FKoTd+gcSfuYAdSdXLrgVvtmXiYXun2cXuHv3YgwbOWH4MmN36xRBMJkRlSy0ZvZNq5+z1DTU50N7ppOPf16iO9jLv90bLqtGIoGwABH9JdJXzBmV1YhsQoZMWHGW0/sAhcQsVWGwSvMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kyQv10VR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kyQv10VR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED23C4CEC5;
	Sun, 29 Sep 2024 21:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727643607;
	bh=KGA3zi5t2JC0Swy+ojjoAMeumKZ91sROSi+XAnxz12E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kyQv10VRXlRiabafxLFEgTOODhvlFZOUIpXDlCQUeeHDu5noQAOWstgN3KqXh5Ow9
	 R/qB9aymfvbDQ1+UtWvvnYu0Q3mKdizizYFUGLQxQfVV4jyWEWEt1OskiZaoGgv6b7
	 3GmlHw/EmDd4iZOvjcBKITawfVQ6pUIKdX0sGTlq9jYtSp0PhIkpc4smE/w5oldkur
	 EHxPgMgB70moOAp2l+DCUplKF9R16IKpoMjRpYCAkD1S4rz22/40jP2246vfK63flb
	 eLN8XOGCGVZSsRYdgboPGcHEpQRfIsX0g/k7yOljKXqRXcfqI7kmulcUQuN0iW8vsd
	 HRL59h7dkEuMA==
Date: Sun, 29 Sep 2024 14:00:04 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Paul Moore <paul@paul-moore.com>
Cc: Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] MAINTAINERS: Add security/Kconfig.hardening to hardening
 section
Message-ID: <20240929210004.GA1300946@thelio-3990X>
References: <20240928-maintainers-security-kconfig-hardening-v1-1-c8c64071cc02@kernel.org>
 <1923f716100.28a7.85c95baa4474aabc7814e68940a78392@paul-moore.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1923f716100.28a7.85c95baa4474aabc7814e68940a78392@paul-moore.com>

On Sun, Sep 29, 2024 at 10:20:59PM +0200, Paul Moore wrote:
> On September 28, 2024 8:26:28 PM Nathan Chancellor <nathan@kernel.org> wrote:
> > When running get_maintainer.pl on security/Kconfig.hardening, only the
> > security subsystem folks show up, even though they have never taken
> > patches to this file:
> > 
> >  $ scripts/get_maintainer.pl security/Kconfig.hardening
> >  Paul Moore <...> (supporter:SECURITY SUBSYSTEM)
> >  James Morris <...> (supporter:SECURITY SUBSYSTEM)
> >  "Serge E. Hallyn" <...> (supporter:SECURITY SUBSYSTEM)
> >  linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM)
> >  linux-kernel@vger.kernel.org (open list)
> > 
> >  $ git log --format=%cn --no-merges security/Kconfig.hardening | sort | uniq -c
> >        3 Andrew Morton
> >        1 Greg Kroah-Hartman
> >       18 Kees Cook
> >        2 Linus Torvald
> > 
> > Add it to the hardening section so that the KSPP folks are also shown,
> > which matches reality over who should comment on and take said patches
> > if necessary.
> > 
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> > MAINTAINERS | 1 +
> > 1 file changed, 1 insertion(+)
> 
> For the sake of casual observers, the reason James, Serge, or I haven't
> merged anything in Kconfig.hardening isn't due to any malicious intent or
> lack of appreciation, rather it is out of respect for KSPP and not wanting
> to step on Kees' toes.

Right, I did not mean for this to come off in an accusatory way, so my
apologies if it did. I merely wanted to codify this arrangement so that
patches get picked up or acked by the correct people in the future since
I had to send one earlier and I noticed it did not match reality (with
the data to prove it heh). I hope it is fairly obvious that Kees has a
good working relationship with you and the other security subsystem
folks if one pays attention to the mailing list :) and for the record,
even with this change, get_maintainer.pl still shows the security/
maintainers and list for this file, so you can still be kept in the loop
if so desired.

> I've happily merged KSPP related patches to those subsystems which I'm
> tasked with looking after and I plan to continue to do so.

Always happy to have as many KSPP allies as possible :)

Cheers,
Nathan
