Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F4B4683
	for <patches@lists.linux.dev>; Thu,  5 Jun 2025 14:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749134749; cv=none; b=l0qcpYO3jarJCkgQ9VqsI/Rw65C4omsTAkKpvJOlKv07xWYs/tN05NkqZIQuPAOTNo/FHu3Y2oF1W14KQIJkyum1TXx9TpiiBi+rO8vhs/6sUF4VM/RxPANLU7DxeABBiUn3y+ljmUj37XFUV6S2a0KEgBAySpb80K1xy4WZxzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749134749; c=relaxed/simple;
	bh=wzJu9IsFw5YM904H7/pvRn/+nOYXpjnLcwgDxbZOF0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eiLrETs2xHt7IJG/CcIhpBapcF6ML7kxcwV2BxWOvJp06WdNKwb7uhVjmMUMdAXN+KZMBrv0w7q2OvSUGSRK5vDedkNRdSxSQyBJjhAy1dABTYE0FGJj4w213r7EJE3WzVN0KJNMYBHnZjzXxj++t/bJinMlk2C5vMVNPw8n52s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=VgwaFUI8; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=HEW/oith; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="VgwaFUI8";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="HEW/oith"
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 867121380322;
	Thu,  5 Jun 2025 10:45:46 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 05 Jun 2025 10:45:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1749134746; x=1749221146; bh=hQZWSILjK0
	j8AeO5uo2Zr1u/cfShxfXbflD+jwo9ut0=; b=VgwaFUI8yrTCjkyzXo+gCQFLku
	/OXHGdqvqoWDqApb/GP38IEbtgt0A21kdj7SsPfgYv0xXh1YHm85eNL9uopfu2j+
	JwcNquyT5HLZbQ9NITazIRNIBSTSNTb9Q+N7/nC3uFC5v4Ytq+9Gq/OCCSvXAFCw
	tM8974K1egyQsEg9VJtLw3nupB8W1i1YVefFuJu2BHtvfY30PJQvR8B8S9Fgj7qX
	6wpcwQpjvPRRU0duM8hJsjqX5n5zsdKJ9Dps2PrCa0tGnuxidJcznAlNY4MS+LAZ
	4k6ORs16rrXoxfM+POpSweIT54MKECBibrmXNdchE/tJkzRl0alNqxVqJTMg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1749134746; x=1749221146; bh=hQZWSILjK0j8AeO5uo2Zr1u/cfShxfXbflD
	+jwo9ut0=; b=HEW/oithb/v0pMG3J5TTvc59kOQFoK0dTQVtOfV2wfsbAh8yFWR
	7qxsTbSQ6yYRpPBRtPUc6FeGp6hK0Rrzpv58J7zQnM+0UkIgFyQwrIKzRRNM5TUk
	hmvYoB9uJow0gekuE3G7VEFhcaBXEy4y9vArP2+JoCWVdvPY6xviBWZzZdGTcN5M
	QbHJbCkJqT0G+0v1C9cWMAqFF4Z+5bE5LSLmQiIyz8bKBsJdcoXIJY2wjDCLj2jy
	JKRDZpR1CS4Eh6nrzvVLbzLDrf4fRZHv6AswpJLchYkbJohkwfvZzYmbi4n1Tpox
	ncExnR60QWDStqUWSBfhrg8J+90MOIOJJwQ==
X-ME-Sender: <xms:mq1BaFoS3TnhyJ1UFyF4x48SWnQ8ijbB_L1Jrxayqw5KMkmNbPyFGA>
    <xme:mq1BaHrIi4Cb30r1_7i7k-IgH9lmdutV3gA9Mo6gUVXpgyrL0zBb-qvmOeeFg78uG
    wMi32lwOnx_SA>
X-ME-Received: <xmr:mq1BaCNQeuUAa8IGQP_rojCAnvMX3oOpASaxIzSQ6cH_kddJdxfFMA9Dnr3IEVngCrshFqrv67XHnAaZoGmHR_hfECLCFxY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddugdefjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvden
    ucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrf
    grthhtvghrnhepgeehueehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeel
    vedttddvnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhdp
    nhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehkuh
    gsrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepihdrmhgrgihimhgvthhssehovhhn
    rdhorhhgpdhrtghpthhtohepshgrshhhrghlsehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehprghttghhvghssehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtohepshht
    rggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvggthhgruhgurh
    hosehrvgguhhgrthdrtghomhdprhgtphhtthhopehhohhrmhhssehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopegrtghonhholhgvsehrvgguhhgrthdrtghomhdprhgtphhtthhope
    hnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:mq1BaA79OhiY9K0YElRj_LLefHaf8YmID0p8y97GGt65bZh-bPXQPw>
    <xmx:mq1BaE4XpPlUqObUq9UMdFVlcEvSA1kRJ4ShCdlKSSg49Pb9uk-vZQ>
    <xmx:mq1BaIicnFiouC1y687Nhts9fKzIseYaSmAQ9dk3sbKBCNOmSRYyfw>
    <xmx:mq1BaG5nTh-6ldHuimVvIptYDlOGn3CP4TiSKCRZ983USpl-cezgKQ>
    <xmx:mq1BaOb699teACsKzBp8qLhCykZG8TBB7JVLvPzxluhz-exmiTbCS84n>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Jun 2025 10:45:45 -0400 (EDT)
Date: Thu, 5 Jun 2025 16:45:39 +0200
From: Greg KH <greg@kroah.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Ilya Maximets <i.maximets@ovn.org>, Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev, stable@vger.kernel.org,
	Eelco Chaudron <echaudro@redhat.com>,
	Simon Horman <horms@kernel.org>, aconole@redhat.com,
	netdev@vger.kernel.org, dev@openvswitch.org
Subject: Re: [PATCH AUTOSEL 6.15 044/118] openvswitch: Stricter validation
 for the userspace action
Message-ID: <2025060520-slacking-swimmer-1b31@gregkh>
References: <20250604005049.4147522-1-sashal@kernel.org>
 <20250604005049.4147522-44-sashal@kernel.org>
 <38ef1815-5bc1-4391-b487-05a18e84c94e@ovn.org>
 <2025060449-arena-exceeding-a090@gregkh>
 <7bc258ad-3f65-4d6e-a9f5-840a6c174d90@ovn.org>
 <2025060440-gristle-viewable-ef6a@gregkh>
 <20250605072334.256dc524@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605072334.256dc524@kernel.org>

On Thu, Jun 05, 2025 at 07:23:34AM -0700, Jakub Kicinski wrote:
> On Wed, 4 Jun 2025 10:28:09 +0200 Greg KH wrote:
> > Nothing that ends up on Linus's tree should not be allowed also to be in
> > a stable kernel release as there is no difference in the "rule" that "we
> > will not break userspace".
> > 
> > So this isn't an issue here, if you need/want to make parsing more
> > strict, due to bugs or whatever, then great, let's make it more strict
> > as long as it doesn't break anyone's current system.  It doesn't matter
> > if this is in Linus's release or in a stable release, same rule holds
> > for both.
> 
> For sure, tho, I think the question is inverted here. We seem to be
> discussing arguments why something should not be backported, rather
> than arguments why something should be backported. You seem to be
> saying that the barrier of entry to stable is lower than what we'd
> normally send to Linus for an -rc, which perhaps makes sense in other
> parts of the kernel, but in networking that doesn't compute.
> 
> We go by simple logic of deciding if something is a fix. 
> This is not a fix. Neither is this:
> https://lore.kernel.org/all/20250604005049.4147522-54-sashal@kernel.org/

Ok, then that's a valid reason to drop it, that is not what I was
thinking was happening here at all, sorry.

greg k-h
