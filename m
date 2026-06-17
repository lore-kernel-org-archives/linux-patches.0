Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB48B380FE5;
	Wed, 17 Jun 2026 08:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781684638; cv=none; b=djKArBbJ21bFO9cny0h764Y5hIyylJ28ljgMA4BgYUfXnCEVR5ENglLnSnJtSkgctZ+3Dz9m95O8YLn5kZt99vffsGIbi0EVIOyugv5+SMSUBPRMb5LbqmwahMfniuCUfa5LWwbTIQKx+VNlW99YnplGLQNEvtJ6XYlLvf0bkU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781684638; c=relaxed/simple;
	bh=wo9nDHvniRQxPbdj8SFuco+7g3miFHcszLbivPTH4GE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OR32MPhhL+Losfe/rfEMTa24tzNCLxFrwOgfRXwrG3CohBvTjm0lwhq8aZ5oBRyHFW3LHEFKQgEkBrf5rtzU/GD8wTZAlq097HF75z+IW+ktIqP0652gmE5sSTRK5IuvChMW6R72BA0kEGjnvB76HpvV6g0b98RtygFFr96SBVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XP+r4S1i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XP+r4S1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC451F000E9;
	Wed, 17 Jun 2026 08:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781684637;
	bh=mNb7fhTPpwYtkdprDlxN8Lw0+AyTFfgFLASUz89Mo5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XP+r4S1ikCZtadJNF+gqxTElSYr5B7PKudKOLiVEfEP7iloSNfPywYPZUyK3yI8yX
	 ddVUZVPqB7Je8Xh0+efIu9I92decAL7jl4LKiyqv+AIG0+rd0hDvHzQke0mzTbpNVc
	 GB04tKJxL2FY2QMQl38AESa9nlhbkjW4FBB9jKo8=
Date: Wed, 17 Jun 2026 13:52:51 +0530
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	David Vernet <void@manifault.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 064/522] selftests/bpf: S/iptables/iptables-legacy/
 in the bpf_nf and xdp_synproxy test
Message-ID: <2026061736-absurd-italics-ce32@gregkh>
References: <20260616145125.307082728@linuxfoundation.org>
 <20260616145128.790200973@linuxfoundation.org>
 <80be436bbcda9b8a66058c01eef0b0f94722e7ef.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80be436bbcda9b8a66058c01eef0b0f94722e7ef.camel@decadent.org.uk>

On Wed, Jun 17, 2026 at 10:11:34AM +0200, Ben Hutchings wrote:
> On Tue, 2026-06-16 at 20:23 +0530, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Martin KaFai Lau <martin.lau@kernel.org>
> > 
> > [ Upstream commit de9c8d848d90cf2e53aced50b350827442ca5a4f ]
> > 
> > The recent vm image in CI has reported error in selftests that use
> > the iptables command.  Manu Bretelle has pointed out the difference
> > in the recent vm image that the iptables is sym-linked to the iptables-nft.
> > With this knowledge,  I can also reproduce the CI error by manually running
> > with the 'iptables-nft'.
> > 
> > This patch is to replace the iptables command with iptables-legacy
> > to unblock the CI tests.
> [...]
> 
> There is a later fix for this: commit 967e8def1100 "selftests/bpf: Fix
> bpf_nf selftest failure".  But I don't think it's that important.

Already queued up, thanks!

greg k-h
