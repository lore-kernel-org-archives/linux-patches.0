Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27D93B47DF;
	Fri, 13 Mar 2026 16:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773417773; cv=none; b=QpzKL9kO+kw87MCc66PdKpTNEt3iplZ29v75TqbwBd44/3bMaXtSSrjLOndzkU6CFxXGPYwtgeRfvsRsOxcWEkh1EKnDf4kXb+JPqENTRr9LgbK79+Sn1t6/wW17EuibqB5ColysreEKQdz/GsIzGWFBzzr41St2yVPku+xaSC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773417773; c=relaxed/simple;
	bh=TdUCTd/WUOBMkc+IsUcewmwCKvcHQbdZ/rkwLaTqrt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vs75cXCqfX+AIOS274xdpEmLX0C9sYPqmSW8wVfLjb8j6GA49zKdtHcawrz1po/crn0cOIh1ULi7KWYmWuuppRFgdI0RINXxSbzZyZW4BVDvpc9RIh97r7/GOrzaySVGoahvnLD0ZQhVIqxkn4dwn0Aw2muc6ylq2QSiIByd2vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bw7w7Y0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bw7w7Y0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07B6C19421;
	Fri, 13 Mar 2026 16:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773417772;
	bh=TdUCTd/WUOBMkc+IsUcewmwCKvcHQbdZ/rkwLaTqrt0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bw7w7Y0SphHNkvfzFnUILtVa3xLB06aOSaGIY81+15y81qNYW4Ys+WOOgxks1FVTt
	 5uGehplLhyrwk4zhzlRuE0yDo3O9JvFpgN4p1lB/n7PTOnrccQgEoMJLAIvhDgCr7J
	 DNtmzhMYo45BhsNgTgZUatZ/yAvrnR5J/gTkR7og=
Date: Fri, 13 Mar 2026 17:02:48 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>,
	MPTCP Linux <mptcp@lists.linux.dev>
Subject: Re: [PATCH 6.12 162/265] selftests: mptcp: join: check removing
 signal+subflow endp
Message-ID: <2026031328-subpar-scruffy-b4b8@gregkh>
References: <20260312201018.128816016@linuxfoundation.org>
 <20260312201024.124696392@linuxfoundation.org>
 <0fe5137d-9b80-4afe-a7d8-cb38a3118070@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fe5137d-9b80-4afe-a7d8-cb38a3118070@kernel.org>

On Fri, Mar 13, 2026 at 10:54:07AM +0100, Matthieu Baerts wrote:
> Hi Greg,
> 
> On 12/03/2026 21:09, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Matthieu Baerts (NGI0) <matttbe@kernel.org>
> > 
> > commit 1777f349ff41b62dfe27454b69c27b0bc99ffca5 upstream.
> > 
> > This validates the previous commit: endpoints with both the signal and
> > subflow flags should always be marked as used even if it was not
> > possible to create new subflows due to the MPTCP PM limits.
> 
> FYI, this patch adds a new subtest in the MPTCP selftests to validate
> that the upstream parent commit -- 579a752464a6 ("mptcp: pm: in-kernel:
> always mark signal+subflow endp as used") -- fixes a warning. Except
> that this commit had a conflict and is currently not in v6.12. Sasha
> sent a version without the conflict (BTW, thank you for that!):
> 
>   https://lore.kernel.org/20260309153846.1288656-1-sashal@kernel.org
> 
> I guess that's probably fine like that because the issue exposed by this
> new test is not new, and it will be fixed by the missing patch soon I
> suppose. Probably no need to modify this RC, and the fix can wait the
> next version, but I prefer to send this message just in case people hit
> the issue.

Thanks for the info, I'll queue up that other patch for the next round
of stable releases, sorry I didn't get to it at this point in time.

greg k-h
