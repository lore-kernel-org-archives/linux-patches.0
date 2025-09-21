Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C4A2472AA
	for <patches@lists.linux.dev>; Sun, 21 Sep 2025 23:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758495610; cv=none; b=ISwMapqufzm+bWCsQgMZAxqLrRE8kVEwJv29nhRQlj902oJPPllUiOFI3QMYhY00y9y6frXyUgqkS+LUrP4bsYGXUjS82la4afQomY/D8OZpIMTzj9mPctyvCafgBjwKuJvCtG1VGL3iHucrwYUk7DwHF7txThqhpXF2lVrZMU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758495610; c=relaxed/simple;
	bh=ELXgiFpL4fiMAZS+SkuTbOgj6eoEEfijwrUVviCqOdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=slHWMa0VB5xZMf9axPhuJElxTBJK9554VNlE38OqxjQYbc+thBmQSGyb2U4OZTLApZ0oA/C1U630QW7SI4gmv5Mj+yji4UOF6qsrrYt0+YV39vH5zpCQ5Esuk0oMRNnzcs06L+V8Pbj6ic+uRijgW2vEHNrfAjzxho+FOfByfjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BOuJoRQJ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eWQf20dt; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BOuJoRQJ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eWQf20dt"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0FAEA602A3; Mon, 22 Sep 2025 01:00:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758495600;
	bh=r1p8honBNF1FMRtvU+WulJzqohTj6V/MCmBNuD2fyUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BOuJoRQJvNNPwBgkhhqJGAmt//rXOw0TWwesAe9i+00YmMwHTG0xWjQ96vPqrQnLG
	 PvdJupfgsXB7lXmJtyjKRjeMhs+d8x1AX/YENl/+59Xh28Ev0z3IHjyqEGAW/duHbV
	 3sOwEzuGccIvSk1m5wWEyR8lQnI1uICUmRpTnd7AIlVpaUeN6Nn7aHyC8dpT2Ah1n+
	 P4sJK9QJpxTEvPYubdCGlIcoPgyxtSDs3jtHmgkLqG38a5uLvZsJLTwJp85G/cUO12
	 dSymanF/33caRzL356L4C2O/VbOFO3UfKtXrVFSN5+ORHtM347/+gyB3ODnXBt6S0b
	 gJ/TcKDXwWNuw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 076B56029D;
	Mon, 22 Sep 2025 00:59:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758495599;
	bh=r1p8honBNF1FMRtvU+WulJzqohTj6V/MCmBNuD2fyUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eWQf20dtSrDHgSEQW+O3jp83aZAbC5KkhO8/D3MB6NUAtFvb86UiX4krwXnQg21np
	 BE+ojDcgx7D++Jsg5gVhGaHphiBUFpWraSxpLW2LViD/Zfz4F9oz7uuNMJNAL4Mjlx
	 kSUHVqgZ3X1lfzjQEFa0DKNVGGQSHZPVtgCabR8fiXSPYM/wP5DoYu7hauy1xdepQH
	 i8SBH3nHi3Bnia1CJPdlhinRDj5qSiAZ1gJ554eKLwoP1q5xgicZt6ygRsegur1bX2
	 v165LtnCqF2j13+Y5alBs6g8SPe8ufyI2jTqqhyPR4QIwkYxYeqDTLYZDTi2YxYKsi
	 jpoQlGm/JXLIg==
Date: Mon, 22 Sep 2025 00:59:55 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Phil Sutter <phil@nwl.cc>, stable@vger.kernel.org,
	patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 113/140] netfilter: nf_tables: Reintroduce shortened
 deletion notifications
Message-ID: <aNCDa_09aU4x5I_4@calendula>
References: <20250917123344.315037637@linuxfoundation.org>
 <20250917123347.067172658@linuxfoundation.org>
 <C2AE0418-CB38-4660-80F8-238FEF0D47E4@nwl.cc>
 <2025092148-unsheathe-gooey-9836@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2025092148-unsheathe-gooey-9836@gregkh>

Hi Greg,

On Sun, Sep 21, 2025 at 07:06:09PM +0200, Greg Kroah-Hartman wrote:
> On Sat, Sep 20, 2025 at 09:12:21AM +0200, Phil Sutter wrote:
> > Hi Greg,
> > 
> > please skip this one, it's a pure feature which requires user space modifications.
> 
> It's already in a release.  And why would a kernel change need userspace
> changes, that sounds like a regression.

Old userspace version cannot handle the feature in this patch, this is
an issue for stable distributions where userspace remains static while
stable kernel are being upgraded.

Please revert this patch. If this stable dependency is not so straight
forward to revert, I can send you backport revert.

Let me know, thanks.
