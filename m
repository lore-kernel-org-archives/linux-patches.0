Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352973976B6;
	Fri, 13 Mar 2026 13:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773409790; cv=none; b=t/VYfLl1QHuWQRxEQZw8D0HO7zsow9tjUOh0Y+Fh1OfhMN1QpqX2VhNsAfPMighWHwVLGXF0tJcJM0jbfJgbcOjx/3E0P+NUVzXm70sB5thHY11/hgYa9whPtZ8a/Ms5MovEYpl6VxjyAbvqqGTTVlnriagqn0laRhh0PGO+bNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773409790; c=relaxed/simple;
	bh=t9ivlOfBBXOXqvNL3l77+EjcZmEMBN+3jdHwaM2lnvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f+ZMNzA0V45lEkzz7MnY9HNbT7m5hDoM4rd+h++9IJST73ukc/yh+3ag//9Bqj9IhKyoElaqis+IbKv6ORtlHOXg0m/KwJXbhcmgEm8na0eaBhJaNxAvZANKkr/30HakTobaJnvwH0koqMAo6Uabm9szsqac4S8S/U406dy63AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nWz1Qzl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nWz1Qzl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AD2C2BCC6;
	Fri, 13 Mar 2026 13:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773409789;
	bh=t9ivlOfBBXOXqvNL3l77+EjcZmEMBN+3jdHwaM2lnvw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nWz1Qzl4WqrK6ZtgHHPr6gEsoWt+ZazIcI7+DnFxSG0zw4WjUFtL0c7Hxtjq82W2z
	 2EUWw09XB+TNVYESMKlrnC8Ap1JhJENNb9YMYwnatGpYvDOxd3uEYhP6cAaSRA9z7Y
	 CsbIh4pvSqTqrjp6XXbgwB5lIkfksYLlkczY2AUc=
Date: Fri, 13 Mar 2026 14:49:45 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Barry K. Nathan" <barryn@pobox.com>
Cc: Ron Economos <re@w6rz.net>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com, Francesco Dolcini <francesco@dolcini.it>
Subject: Re: freeze during boot regression Re: [PATCH 6.12 000/265]
 6.12.77-rc1 review
Message-ID: <2026031314-civic-sandlot-7a67@gregkh>
References: <20260312201018.128816016@linuxfoundation.org>
 <b4f58774-18d4-4a32-9c85-603f9e2c98fc@pobox.com>
 <ee851013-fec8-47f8-9863-392f17e54474@pobox.com>
 <2a313336-ccfc-42b7-a14d-c116733ef64a@w6rz.net>
 <1c54210a-e197-4eb9-88b5-2ed2589c7230@pobox.com>
 <88e4edea-f204-4f06-b898-2995237fc823@w6rz.net>
 <d87a1702-6906-475c-afd7-9b4b25bfd48c@pobox.com>
 <71d1fa5b-e6bb-4289-bd8d-445aeddcb9d8@pobox.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71d1fa5b-e6bb-4289-bd8d-445aeddcb9d8@pobox.com>

On Fri, Mar 13, 2026 at 06:38:25AM -0700, Barry K. Nathan wrote:
> On 3/13/26 03:53, Barry K. Nathan wrote:
> [snip]
> > On 3/13/26 02:37, Ron Economos wrote:
> > > On 3/13/26 01:05, Barry K. Nathan wrote:
> > > > On 3/12/26 23:10, Ron Economos wrote:
> > > > > Probably those sched/fair patches.
> > > > 
> > > > Yes, after bisecting it turned out to be
> > > > sched-fair-fix-eevdf-entity-placement-bug-causing-sc.patch
> > > > 
> > > > Taking 6.12.77-rc1 and reverting both of the sched-fair patches
> > > > results in a working kernel that boots consistently (which I am
> > > > using now to send this email).
> > > 
> > > Confirmed on RISC-V. Reverting "sched/fair: Fix lag clamp" commit b547745a2c78fd1cc1fdc6a0d1b05c884c05cec2 and "sched/fair: Fix EEVDF entity placement bug causing scheduling lag" commit f9891a33ba67ce40e5a17023d2f3a5e2b7d72ffd resolves the issue.
> > 
> > After looking into it a bit more, I found two upstream commits that
> > should fix this issue without reverting the two sched/fair patches
> > (either of the two commits alone should fix it if I understand
> > the bug and the code correctly):
> > 
> > 
> > commit 4423af84b29794a9bd2bd07188d8e71083e54c61
> > sched/fair: optimize the PLACE_LAG when se->vlag is zero
> > 
> > commit c70fc32f44431bb30f9025ce753ba8be25acbba3
> > sched/fair: Adhere to place_entity() constraints
> > 
> > 
> > I think c70fc32f4443 is theoretically the proper fix, while
> > 4423af84b297 is a performance optimization that just happens to also
> > fix the bug.
> > 
> > 4423af84b297 turned out to be the easier backport; the upstream patch
> > applies to 6.12.77-rc1 with an offset but no fuzz or conflicts. So I
> > tried 6.12.77-rc1 + 4423af84b297, and just as with reverting the two
> > sched/fair patches, it eliminates the boot freeze in my testing. It's
> > what I'm running now as I write and send this email.
> > 
> > Next, I think I'll try doing a backport of c70fc32f4443 (I think it
> > should be easy enough), and I'll try testing 6.12.77-rc1 +
> > c70fc32f4443 (probably both with and without 4423af84b297).
> > Maybe 4423af84b297 on its own is enough though.
> 
> I originally wrote a much longer email, but I'll try to keep this concise.
> 
> I was able to backport c70fc32f4443 successfully, and the backport does
> fix the reboot freezes (with or without 4423af84b297). However,
> backporting that commit convinced me that it's too risky; I'm particularly
> worried it could make future sched/fair backports more difficult. And once
> 4423af84b297 is applied, I think c70fc32f4443 ends up being a fix for a
> theoretical bug.
> 
> So, even though c70fc32f4443 is the commit that was cc'd to stable@, I
> believe 4423af84b297 is a better (safer, less risky) way to go.
> 
> 
> In summary, I believe the two best ways to fix this regression are:
> 1. Backport 4423af84b297, or
> 2. Revert the two sched/fair patches.

I'll go drop these for now, and if they should come back in the future,
someone can send all of the needed ones at once.

thanks so much for the testing and figuring it all out!

greg k-h
