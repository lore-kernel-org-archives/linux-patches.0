Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C407C28935B;
	Wed,  7 May 2025 14:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746626696; cv=none; b=IUfrd+o/J8Rhs5FoPQBzM9I7+5PgCnzHKjfMDh8+dJlwwE8/WoMOQENViiyIQVsB00TyqGplJf66bVaR67eSAULV60lQWy3Wa35Quo3RGZA70DR0F0Am/xjTEm2gxKwjwvAunt+sp2rimE4fWz4PxhBgbFoz2HiM1saUHFIFh9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746626696; c=relaxed/simple;
	bh=LyeCkL9rXFb9nzsz3cXF9ksBjZko/3X7PeSEcfUSBJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G+XXPJtTJUteyuTkcaM2GwUPCXRW+FQ4Cy8T+GMHo/dqVS7Ti2Hd64mwL+IFPP4pN5xx3CGyIbuCGU8JMS51D4nIIqHFx+f3yV7uZBLbyYX0YBvG9pz7F83+JDbGdsFxmn2v3Jig9rgDN1ogScZki7yGi1tjgBHhFUJmvfvftPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0WxNwYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0WxNwYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20E3C4CEE2;
	Wed,  7 May 2025 14:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746626696;
	bh=LyeCkL9rXFb9nzsz3cXF9ksBjZko/3X7PeSEcfUSBJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u0WxNwYJmCc+ussMenRL/XAK3UzQxKc/ji/DUhY+MuAf0CCR7quj6vzh/1ZgGwRA7
	 W9NJ1YfbH6iuD2Zakct7vEYfODCEREfXi7i5XfcmeqiLwkQ1tLSrVy5pS7A46Pw8+w
	 GPcHIaqeC/ojX04b0bR9qsP7yDfctxZN8Kn/hs6I=
Date: Wed, 7 May 2025 16:04:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Tai, Gerrard" <gerrard.tai@starlabs.sg>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: net/sched: codel: Inclusion of patchset
Message-ID: <2025050712-prone-covenant-80c9@gregkh>
References: <CAHcdcOkW1D_zKh-HPsfjX-oGYhv-OwojPXVwcA=NYoO0hcCbZQ@mail.gmail.com>
 <2025050519-stem-fidelity-25b1@gregkh>
 <CAHcdcOkMt_Mpcm1AjxbU8MurGO5e--LPPJOrSTA+utDOzVHE3g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHcdcOkMt_Mpcm1AjxbU8MurGO5e--LPPJOrSTA+utDOzVHE3g@mail.gmail.com>

On Wed, May 07, 2025 at 10:59:53AM +0800, Tai, Gerrard wrote:
> On Mon, May 5, 2025 at 5:28 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, May 02, 2025 at 12:49:48PM +0800, Tai, Gerrard wrote:
> > > Upstream commits:
> > > 01: 5ba8b837b522d7051ef81bacf3d95383ff8edce5 ("sch_htb: make
> > > htb_qlen_notify() idempotent")
> > > 02: df008598b3a00be02a8051fde89ca0fbc416bd55 ("sch_drr: make
> > > drr_qlen_notify() idempotent")
> > > 03: 51eb3b65544c9efd6a1026889ee5fb5aa62da3bb ("sch_hfsc: make
> > > hfsc_qlen_notify() idempotent")
> > > 04: 55f9eca4bfe30a15d8656f915922e8c98b7f0728 ("sch_qfq: make
> > > qfq_qlen_notify() idempotent")
> > > 05: a7a15f39c682ac4268624da2abdb9114bdde96d5 ("sch_ets: make
> > > est_qlen_notify() idempotent")
> > > 06: 342debc12183b51773b3345ba267e9263bdfaaef ("codel: remove
> > > sch->q.qlen check before qdisc_tree_reduce_backlog()")
> > >
> > > These patches are patch 01-06 of the original patchset ([1]) authored by
> > > Cong Wang. I have omitted patches 07-11 which are selftests. This patchset
> > > addresses a UAF vulnerability.
> > >
> > > Originally, only the last commit (06) was picked to merge into the latest
> > > round of stable queues 5.15,5.10,5.4. For 6.x stable branches, that sole
> > > commit has already been merged in a previous cycle.
> > >
> > > >From my understanding, this patch depends on the previous patches to work.
> > > Without patches 01-05 which make various classful qdiscs' qlen_notify()
> > > idempotent, if an fq_codel's dequeue() routine empties the fq_codel qdisc,
> > > it will be doubly deactivated - first in the parent qlen_notify and then
> > > again in the parent dequeue. For instance, in the case of parent drr,
> > > the double deactivation will either cause a fault on an invalid address,
> > > or trigger a splat if list checks are compiled into the kernel. This is
> > > also why the original unpatched code included the qlen check in the first
> > > place.
> > >
> > > After discussion with Greg, he has helped to temporarily drop the patch
> > > from the 5.x queues ([2]). My suggestion is to include patches 01-06 of the
> > > patchset, as listed above, for the 5.x queues. For the 6.x queues that have
> > > already merged patch 06, the earlier patches 01-05 should be merged too.
> > >
> > > I'm not too familiar with the stable patch process, so I may be completely
> > > mistaken here.
> >
> > I'll be glad to take what is needed, but please list what commits need
> > to go to what branches and in what exact order please.
> 
> Here's the list of commits. The order should be the sequence as listed
> below.
> 
> 6.14, 6.13, 6.12, 6.6, 6.1: (all 6.* branches)
> 5ba8b837b522d7051ef81bacf3d95383ff8edce5 ("sch_htb: make
> htb_qlen_notify() idempotent")
> df008598b3a00be02a8051fde89ca0fbc416bd55 ("sch_drr: make
> drr_qlen_notify() idempotent")
> 51eb3b65544c9efd6a1026889ee5fb5aa62da3bb ("sch_hfsc: make
> hfsc_qlen_notify() idempotent")
> 55f9eca4bfe30a15d8656f915922e8c98b7f0728 ("sch_qfq: make
> qfq_qlen_notify() idempotent")
> a7a15f39c682ac4268624da2abdb9114bdde96d5 ("sch_ets: make
> est_qlen_notify() idempotent")
> 
> 5.15, 5.10, 5.4: (all 5.* branches)
> 5ba8b837b522d7051ef81bacf3d95383ff8edce5 ("sch_htb: make
> htb_qlen_notify() idempotent")
> df008598b3a00be02a8051fde89ca0fbc416bd55 ("sch_drr: make
> drr_qlen_notify() idempotent")

This commit did not apply to 5.15.y and older, sorry.

Please provide working, and TESTED backports of patches for us to
be able to include them in the stable trees.

thanks,

greg k-h
