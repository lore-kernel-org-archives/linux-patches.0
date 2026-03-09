Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBE5387595;
	Mon,  9 Mar 2026 13:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773063239; cv=none; b=jLcDxLp5eMV6dcXClPQOOUa0rHxyZuk1Vz6/vy71Yup4p0WEU1R8IiN3i6mNmg4X07wpbUOpXg0aoHeYP8N1GtxEYWG7VNtxXEIf0jqiou9sDm5bqTlFUnCBDjYmcPOErS2vny+d7x2I9fQmf+rkTiyf2LbdfONUmNntH18hVBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773063239; c=relaxed/simple;
	bh=lsbKcTQtG7zwZnF6rhbOwY3nmYaQR8LdFtqe+3movFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VmPn/4Q0+lLYQGJlDefrf4JpBwC8Mz2IEzzdFAQ5vl5Duk+RcflBkw5rsz7FBPSa3h5Ak/uqZ1q7SspB91mDJ6KaTEejMdH4BNbqe7HhGUfoTWZQ9XEqqEidR9qSQ1kJHp0U/Nu0EPeB/jXlJyx/vlb6mIE4LRedSePaskFv7BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4em2hGa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4em2hGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0373BC2BCB0;
	Mon,  9 Mar 2026 13:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773063239;
	bh=lsbKcTQtG7zwZnF6rhbOwY3nmYaQR8LdFtqe+3movFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V4em2hGa8hk+gVCNK6/4LkPZz/Suc9JGwzsn9ju8evHigMyVGs/Y5vuytnxhJ+pIe
	 xx+2DcgxGvT41AnlS+ZFDQ46a+bLEdyJzxWama/ybhuW9gMeS+JyESpfuLR7Z3VDiQ
	 HBihATg3sa02FEp23I0pJiAzQaTes3WPlhumvXTs=
Date: Mon, 9 Mar 2026 14:33:56 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Florian Westphal <fw@strlen.de>,
	Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Re: [PATCH 6.18 315/641] netfilter: nft_set_rbtree: validate open
 interval overlap
Message-ID: <2026030945-tarantula-viewless-6b65@gregkh>
References: <20260225012348.915798704@linuxfoundation.org>
 <20260225012356.353371017@linuxfoundation.org>
 <aaeEd8UqYQ33Af7_@chamomile>
 <69b9d4a7-166d-4f7e-9787-e1b96775ee19@leemhuis.info>
 <2026030457-shivering-crucial-a99e@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026030457-shivering-crucial-a99e@gregkh>

On Wed, Mar 04, 2026 at 10:04:40AM +0100, Greg Kroah-Hartman wrote:
> On Wed, Mar 04, 2026 at 08:29:16AM +0100, Thorsten Leemhuis wrote:
> > On 3/4/26 02:01, Pablo Neira Ayuso wrote:
> > > 
> > > Would it be possible to revert this patch in -stable 6.18?
> > > 
> > > There is a bug in userspace nftables 1.1.6 that gets amplified by this
> > > patch, resulting in rejecting large interval sets with -stable 6.18.
> > 
> > Sasha, I wonder if it might be worth the risk squeezing this revert into
> > 6.18.16 and 6.19.6, as there are various reports coming in about the
> > regression that Pablo mentioned:
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=221152
> > https://bugzilla.kernel.org/show_bug.cgi?id=221158
> > https://lore.kernel.org/all/9d110d860c0c7e110d018ea53a7666eba275da20.camel@gmail.com/
> > https://lore.kernel.org/all/2a780701-f1e4-4ff4-b796-889f7ee19ead@crc.id.au/
> > 
> > I think I saw a at least two more.
> 
> Let's wait for the next cycle, this one is "big enough" as is, I can do
> a "quick" release with just a revert here for this if needed in a few
> days.

Sorry for the delay, now queued up.

greg k-h
