Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2062179A3
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 08:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749024216; cv=none; b=YNnvIwYdjp0UDtfxBzD5GPTAdNWhRgPEFxfZMyzCqCiu/otRyDykHlFM2RjXstYeAB8iiOJRJKjlrI1G8TWy2XNHMgMiKska1gOmZ5IbS9RubW2mDZKcUF0PQuekxSdG+/afAL3hTCc3+YjOZJy/3BQGRngIAh0qecoL/CGRj2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749024216; c=relaxed/simple;
	bh=wjfzhqrBPODRSE8RYfiGeS2o/7JAHL/Dr5+Vci1seWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gki623K8X7OiL8QwNirPmtzIUmWsg3wPdkDE5vi6fbUFejgtSqNhuxubC6eo4tuTJmY1hK4Srgv6P0VXhpzFXYXoGMMK0r0TeckoIL6GmQv0MQ3eSTOB+aqPZ+dgwdBeP7tr7503SJKWNDYmBI43PIZgONh7JB2NGd7hysbfIz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=G8lfm4MR; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=rQwmN9bb; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="G8lfm4MR";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rQwmN9bb"
Received: from phl-compute-12.internal (phl-compute-12.phl.internal [10.202.2.52])
	by mailfout.stl.internal (Postfix) with ESMTP id 59A5711400D1;
	Wed,  4 Jun 2025 04:03:32 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Wed, 04 Jun 2025 04:03:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1749024212; x=1749110612; bh=nN8Fc49WUE
	+N2x9qM0p7pP7gZnp0Kb/U4L4WHyccsao=; b=G8lfm4MRSrlMBizYsl0Qfdsveg
	qOoyF3EqIRVou35cf4CZDrvwkVSHULp97U2N711Suk7x5vrFrQgv1/fgIlp/5Vgw
	ebUysklHTte1FLAoCiHfYIBluhiArxiSSrzv8Si8g+1ZbKiCY8ErE3nIkzGIXX50
	VpOJiay/XjZ1gUP7MEERm5rM+6jJqGdB7KmV3Rh5LzSd385ViLlDyBs7UgjHEMcT
	PuACiXx8AVxvwL7PSDl55nKd4VlP64ZYD0pe0EDNXayixi9Ci4MFzca42dyJqUB1
	L1xk2QZ76AbfCHUfekGxcIvUkP3gRENumlYdTe8dT6+SOUq5cMCmIVTmKKmA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1749024212; x=1749110612; bh=nN8Fc49WUE+N2x9qM0p7pP7gZnp0Kb/U4L4
	WHyccsao=; b=rQwmN9bbFV4RBdSTcbNaL8SKgKSbasgPvvpQuIhEsAPAAGmmXnl
	zGacttvIV66vDYwgKjno27j6FAxP0Gy8os70Na3Kda6K4uCuyoo3WXkV5mHRcAym
	96RUmFzgB3ddRylglhev7U8hNxQ8zAEt7YU9FfKxofZTysihujN1gDTu8yh/6Z0Y
	fgth63Tnz7FnR1bF7ZuPY/Ly1tIZr5d3Go20vjJSvdd1WX5GRLWFirr3isI45LJi
	is3ofA1TfAHZM+55za9FCDT4NGZHICOlLXsr01u6pbXw0YbQKz9ZKLc3lMS4cWzx
	6JM/q56A9JshmLI5w2X5P+PP0vHPUhXCK4Q==
X-ME-Sender: <xms:0_0_aCighfJHE9wZ_K0McvoE8VvhOWru0veFLEH3SV5-JKwg4WuSXQ>
    <xme:0_0_aDA9n-2fCcNYJBP5kiBIfnawdzwENb4abJeiZjZa0trAqt4nOtYYJAoIc5i1V
    YCBrVaQPuLg8A>
X-ME-Received: <xmr:0_0_aKGFZj22nRDI6GKNYsXsiQSCVSUGy1_Ck3GTWGzt27es_5b4XAHa>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddugddukedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvden
    ucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrf
    grthhtvghrnhepueegledvgfeuffetffehfffgkeegtddtudejudeiiedvuedtteelleej
    vddtgfefnecuffhomhgrihhnpehmshhgihgurdhlihhnkhdpkhgvrhhnvghlrdhorhhgne
    cuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghg
    sehkrhhorghhrdgtohhmpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouh
    htpdhrtghpthhtohepihdrmhgrgihimhgvthhssehovhhnrdhorhhgpdhrtghpthhtohep
    shgrshhhrghlsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehprghttghhvghssehlih
    hsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvggthhgruhgurhhosehrvgguhhgrthdrtghomh
    dprhgtphhtthhopehhohhrmhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehkuhgs
    rgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprggtohhnohhlvgesrhgvughhrghtrd
    gtohhmpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:0_0_aLT3BFSEezen8cxMHj_qXnqrkkFk2V2O582FwM21IXg1Fi-xGA>
    <xmx:1P0_aPzz3Oo_RSuaTm0mQQLwL9P-BjDWPhpMRPjMxv8Sdvtu04--HA>
    <xmx:1P0_aJ7mfngfbbzimfLS1opZjAPURp2aLIiLpxneYnzh6dfvIvyKtA>
    <xmx:1P0_aMy2f2EL2BQnTZRrRPj17DY7isFql5ldz-wwPYqph34IwxTqfw>
    <xmx:1P0_aJedQQxTSAnKNn-eRcw3yFo3mTqJ38-uLdrgPzyb3BQid_sRWN1b>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Jun 2025 04:03:31 -0400 (EDT)
Date: Wed, 4 Jun 2025 10:03:29 +0200
From: Greg KH <greg@kroah.com>
To: Ilya Maximets <i.maximets@ovn.org>
Cc: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
	stable@vger.kernel.org, Eelco Chaudron <echaudro@redhat.com>,
	Simon Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	aconole@redhat.com, netdev@vger.kernel.org, dev@openvswitch.org
Subject: Re: [PATCH AUTOSEL 6.15 044/118] openvswitch: Stricter validation
 for the userspace action
Message-ID: <2025060449-arena-exceeding-a090@gregkh>
References: <20250604005049.4147522-1-sashal@kernel.org>
 <20250604005049.4147522-44-sashal@kernel.org>
 <38ef1815-5bc1-4391-b487-05a18e84c94e@ovn.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38ef1815-5bc1-4391-b487-05a18e84c94e@ovn.org>

On Wed, Jun 04, 2025 at 09:57:20AM +0200, Ilya Maximets wrote:
> On 6/4/25 2:49 AM, Sasha Levin wrote:
> > From: Eelco Chaudron <echaudro@redhat.com>
> > 
> > [ Upstream commit 88906f55954131ed2d3974e044b7fb48129b86ae ]
> > 
> > This change enhances the robustness of validate_userspace() by ensuring
> > that all Netlink attributes are fully contained within the parent
> > attribute. The previous use of nla_parse_nested_deprecated() could
> > silently skip trailing or malformed attributes, as it stops parsing at
> > the first invalid entry.
> > 
> > By switching to nla_parse_deprecated_strict(), we make sure only fully
> > validated attributes are copied for later use.
> > 
> > Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> > Reviewed-by: Simon Horman <horms@kernel.org>
> > Acked-by: Ilya Maximets <i.maximets@ovn.org>
> > Link: https://patch.msgid.link/67eb414e2d250e8408bb8afeb982deca2ff2b10b.1747037304.git.echaudro@redhat.com
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> > 
> > **YES** This commit should be backported to stable kernel trees. ##
> > Analysis **Commit Overview:** The commit changes `validate_userspace()`
> > function in `net/openvswitch/flow_netlink.c` by replacing
> > `nla_parse_nested_deprecated()` with `nla_parse_deprecated_strict()` to
> > ensure stricter validation of Netlink attributes for the userspace
> > action. **Specific Code Changes:** The key change is on lines 3052-3054:
> > ```c // Before: error = nla_parse_nested_deprecated(a,
> > OVS_USERSPACE_ATTR_MAX, attr, userspace_policy, NULL); // After: error =
> > nla_parse_deprecated_strict(a, OVS_USERSPACE_ATTR_MAX, nla_data(attr),
> > nla_len(attr), userspace_policy, NULL); ``` **Why This Should Be
> > Backported:** 1. **Security Enhancement:** This commit addresses a
> > parsing vulnerability where malformed attributes could be silently
> > ignored. The original `nla_parse_nested_deprecated()` stops parsing at
> > the first invalid entry, potentially allowing trailing malformed data to
> > bypass validation. 2. **Robustness Fix:** The change ensures all netlink
> > attributes are fully contained within the parent attribute bounds,
> > preventing potential buffer over-reads or under-reads that could lead to
> > security issues. 3. **Pattern Consistency:** Looking at the git blame
> > output (lines 3085-3087), we can see that
> > `nla_parse_deprecated_strict()` was already introduced in 2019 by commit
> > 8cb081746c031 and is used elsewhere in the same file for similar
> > validation (e.g., `validate_and_copy_check_pkt_len()` function). 4.
> > **Low Risk:** This is a small, contained change that only affects input
> > validation - it doesn't change functionality or introduce new features.
> > The change is defensive and follows existing patterns in the codebase.
> > 5. **Similar Precedent:** This commit is very similar to the validated
> > "Similar Commit #2" which was marked for backporting (status: YES). That
> > commit also dealt with netlink attribute validation safety in
> > openvswitch (`validate_set()` function) and was considered suitable for
> > stable trees. 6. **Critical Subsystem:** Open vSwitch is a critical
> > networking component used in virtualization and container environments.
> > Input validation issues in this subsystem could potentially be exploited
> > for privilege escalation or denial of service. 7. **Clear Intent:** The
> > commit message explicitly states this "enhances robustness" and ensures
> > "only fully validated attributes are copied for later use," indicating
> > this is a defensive security improvement. **Risk Assessment:** - Very
> > low regression risk - No API changes - Only affects error handling paths
> > - Follows established validation patterns in the same codebase This
> > commit fits perfectly into the stable tree criteria: it's an important
> > security/robustness fix, has minimal risk of regression, is well-
> > contained, and addresses a clear validation vulnerability in a critical
> > kernel subsystem.
> 
> This change is one of two patches created for userspace action.  With an
> intentional split - one for net and one for net-next  First one was the
> actual fix that addressed a real bug:
>   6beb6835c1fb ("openvswitch: Fix unsafe attribute parsing in output_userspace()")
>   https://lore.kernel.org/netdev/0bd65949df61591d9171c0dc13e42cea8941da10.1746541734.git.echaudro@redhat.com/
> 
> This second change (this patch) was intended for -next only as it doesn't
> fix any real issue, but affects uAPI, and so should NOT be backported.

Why would you break the user api in a newer kernel?  That feels wrong,
as any change should be able to be backported without any problems.

If this is a userspace break, why isn't it reverted?

confused,

greg k-h
