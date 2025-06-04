Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E17288CAA
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 08:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749025695; cv=none; b=IghA6BfdIuLlfaanGhsp2uTdV5hYK+OiPc6qoAkLSN/5vBBDAejI47TLEr/jfZ1mHJCRuQdq7CyyyJkY5BF8k502EWH6/6UQB46p+sONTI5jIzgNKFA/hMl5rXL2Vz67MQwz4H/4/s5med8nlA/fUO0Grj1XMqIENG7ujX0NBkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749025695; c=relaxed/simple;
	bh=IAu9069MlDY11KvkCRivzKNwq2jb2lY+pQIFqYoFmFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aMbOCv4URziSxVGJkgor2QIYrIJ2MrnV5k3/2Oa5IdQzuqB41TRH7Pp6Mya9gsczU4lVMSEWdhm/OLEdM68SEIPhRUzDiNkS3Ll6DGLbeCCiNob7r6H2O7+3BqFRR1Ew41tMRq94EARAaQb8TIAHBv+ZeuiwxayBd9Qb+tmKSus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=ZTLGAGTQ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=VffKvdNP; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="ZTLGAGTQ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="VffKvdNP"
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id E5D171140129;
	Wed,  4 Jun 2025 04:28:11 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Wed, 04 Jun 2025 04:28:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1749025691; x=1749112091; bh=ZHzKIFBTor
	3RBiZqC5ZGFVvqq+Bdb/sPWcMYDxZye1w=; b=ZTLGAGTQjFvbFwdEQoXKCtUAQJ
	Y7v1KKjtGtIFGuTDOlQZQ1qe1dPnAFz1Ic+zdMQBbirm9b0gGa7euFC4nt79nas5
	BH6PtViccDmXT68WWj2G+9s6C2wHbhBcP2t4TvslUE07dnd9PU37//DjCrBsEqpx
	wbe8D4OvsvwXtx3fnJZiX2/tiaNhGpmsm/v21xIXqD8h0X/7w99353VYnSmyPMPF
	IUAwn8lc8gv0EXnF4taNOK07h/pBxe+Fj+M0CuU7+cwGKPVmCCvDPd36l6JDcAO0
	EugscJvtzQZW0kpBVWxS4KVp+U8Pw/jp1tovsDkQ29xjoW7p+Mjzjdkevueg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1749025691; x=1749112091; bh=ZHzKIFBTor3RBiZqC5ZGFVvqq+Bdb/sPWcM
	YDxZye1w=; b=VffKvdNPBG09xxwi6ldbXGOoAlQunYP7sF2K5nOpOitTG51mPlo
	mw1lxxxEEzVS+eaTdCb7rwXDHyCDCl3a/WZzUmuMRNDE2Jt3qU8IYWul4n3/Uf7z
	Wpmre7lBAhm9w7IpkILwxRTBLNE2QXNDsNnFKgKkZt9TpJRi2RJdNORbY7UF59cZ
	fuk/UlRWPxWfQKmVcMzVUiok0lHS4PDNtnEPQGIdPIbzQqQjoO5VQGSS9Ib6B4v6
	i5FP1MzDE3opwyZ2LQRR7MLhQNBDJL/mghhl014I24Vl3S29usR/NutDPiqoz9Vb
	YGFtUClPRELG7PJ4PtgvJEGCjX4KzZ1E0fA==
X-ME-Sender: <xms:mwNAaC0BDY0jhxcmZ-VuPS6bspv9FDG-e_5kH89kLEgJ9GBb7T3pnQ>
    <xme:mwNAaFEKCiGg_QjqOQIWhAN13MgSghaKIepja7jL5tsJnCmZhGYHHSDxsYL2pwvuS
    WJ1u-ZCk_vJSg>
X-ME-Received: <xmr:mwNAaK6Cl84ZORYGlgRAGHAdSNhNAaN2A8qlAYy-NbtlDy4Y9v0zMfvC>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddugddukeefucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:mwNAaD1kNre2XA1dwDHkOxId67JamopJYv8yClCXNUj79oBuAKC6pw>
    <xmx:mwNAaFFAt2qTuvuLuRBfCp6ot45Q-h462wfZOLZn4ueYZtpNxFcW9w>
    <xmx:mwNAaM_EYR34nBGvv3tThZwancBd8PwV_eKuYFN52LTttbmdaoS79w>
    <xmx:mwNAaKlX5LwqH65zNCPNVGS_ByEYvAjzEU5wpMdFfqgbbPXfcbGPKg>
    <xmx:mwNAaMkp9BqNe9LPmz0Yvxv35zCxV5x4CRtkfCXCRRlHoJq8VQngirY6>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Jun 2025 04:28:10 -0400 (EDT)
Date: Wed, 4 Jun 2025 10:28:09 +0200
From: Greg KH <greg@kroah.com>
To: Ilya Maximets <i.maximets@ovn.org>
Cc: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
	stable@vger.kernel.org, Eelco Chaudron <echaudro@redhat.com>,
	Simon Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	aconole@redhat.com, netdev@vger.kernel.org, dev@openvswitch.org
Subject: Re: [PATCH AUTOSEL 6.15 044/118] openvswitch: Stricter validation
 for the userspace action
Message-ID: <2025060440-gristle-viewable-ef6a@gregkh>
References: <20250604005049.4147522-1-sashal@kernel.org>
 <20250604005049.4147522-44-sashal@kernel.org>
 <38ef1815-5bc1-4391-b487-05a18e84c94e@ovn.org>
 <2025060449-arena-exceeding-a090@gregkh>
 <7bc258ad-3f65-4d6e-a9f5-840a6c174d90@ovn.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bc258ad-3f65-4d6e-a9f5-840a6c174d90@ovn.org>

On Wed, Jun 04, 2025 at 10:19:45AM +0200, Ilya Maximets wrote:
> On 6/4/25 10:03 AM, Greg KH wrote:
> > On Wed, Jun 04, 2025 at 09:57:20AM +0200, Ilya Maximets wrote:
> >> On 6/4/25 2:49 AM, Sasha Levin wrote:
> >>> From: Eelco Chaudron <echaudro@redhat.com>
> >>>
> >>> [ Upstream commit 88906f55954131ed2d3974e044b7fb48129b86ae ]
> >>>
> >>> This change enhances the robustness of validate_userspace() by ensuring
> >>> that all Netlink attributes are fully contained within the parent
> >>> attribute. The previous use of nla_parse_nested_deprecated() could
> >>> silently skip trailing or malformed attributes, as it stops parsing at
> >>> the first invalid entry.
> >>>
> >>> By switching to nla_parse_deprecated_strict(), we make sure only fully
> >>> validated attributes are copied for later use.
> >>>
> >>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> >>> Reviewed-by: Simon Horman <horms@kernel.org>
> >>> Acked-by: Ilya Maximets <i.maximets@ovn.org>
> >>> Link: https://patch.msgid.link/67eb414e2d250e8408bb8afeb982deca2ff2b10b.1747037304.git.echaudro@redhat.com
> >>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> >>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >>> ---
> >>>
> >>> **YES** This commit should be backported to stable kernel trees. ##
> >>> Analysis **Commit Overview:** The commit changes `validate_userspace()`
> >>> function in `net/openvswitch/flow_netlink.c` by replacing
> >>> `nla_parse_nested_deprecated()` with `nla_parse_deprecated_strict()` to
> >>> ensure stricter validation of Netlink attributes for the userspace
> >>> action. **Specific Code Changes:** The key change is on lines 3052-3054:
> >>> ```c // Before: error = nla_parse_nested_deprecated(a,
> >>> OVS_USERSPACE_ATTR_MAX, attr, userspace_policy, NULL); // After: error =
> >>> nla_parse_deprecated_strict(a, OVS_USERSPACE_ATTR_MAX, nla_data(attr),
> >>> nla_len(attr), userspace_policy, NULL); ``` **Why This Should Be
> >>> Backported:** 1. **Security Enhancement:** This commit addresses a
> >>> parsing vulnerability where malformed attributes could be silently
> >>> ignored. The original `nla_parse_nested_deprecated()` stops parsing at
> >>> the first invalid entry, potentially allowing trailing malformed data to
> >>> bypass validation. 2. **Robustness Fix:** The change ensures all netlink
> >>> attributes are fully contained within the parent attribute bounds,
> >>> preventing potential buffer over-reads or under-reads that could lead to
> >>> security issues. 3. **Pattern Consistency:** Looking at the git blame
> >>> output (lines 3085-3087), we can see that
> >>> `nla_parse_deprecated_strict()` was already introduced in 2019 by commit
> >>> 8cb081746c031 and is used elsewhere in the same file for similar
> >>> validation (e.g., `validate_and_copy_check_pkt_len()` function). 4.
> >>> **Low Risk:** This is a small, contained change that only affects input
> >>> validation - it doesn't change functionality or introduce new features.
> >>> The change is defensive and follows existing patterns in the codebase.
> >>> 5. **Similar Precedent:** This commit is very similar to the validated
> >>> "Similar Commit #2" which was marked for backporting (status: YES). That
> >>> commit also dealt with netlink attribute validation safety in
> >>> openvswitch (`validate_set()` function) and was considered suitable for
> >>> stable trees. 6. **Critical Subsystem:** Open vSwitch is a critical
> >>> networking component used in virtualization and container environments.
> >>> Input validation issues in this subsystem could potentially be exploited
> >>> for privilege escalation or denial of service. 7. **Clear Intent:** The
> >>> commit message explicitly states this "enhances robustness" and ensures
> >>> "only fully validated attributes are copied for later use," indicating
> >>> this is a defensive security improvement. **Risk Assessment:** - Very
> >>> low regression risk - No API changes - Only affects error handling paths
> >>> - Follows established validation patterns in the same codebase This
> >>> commit fits perfectly into the stable tree criteria: it's an important
> >>> security/robustness fix, has minimal risk of regression, is well-
> >>> contained, and addresses a clear validation vulnerability in a critical
> >>> kernel subsystem.
> >>
> >> This change is one of two patches created for userspace action.  With an
> >> intentional split - one for net and one for net-next  First one was the
> >> actual fix that addressed a real bug:
> >>   6beb6835c1fb ("openvswitch: Fix unsafe attribute parsing in output_userspace()")
> >>   https://lore.kernel.org/netdev/0bd65949df61591d9171c0dc13e42cea8941da10.1746541734.git.echaudro@redhat.com/
> >>
> >> This second change (this patch) was intended for -next only as it doesn't
> >> fix any real issue, but affects uAPI, and so should NOT be backported.
> > 
> > Why would you break the user api in a newer kernel?  That feels wrong,
> > as any change should be able to be backported without any problems.
> > 
> > If this is a userspace break, why isn't it reverted?
> 
> It doesn't break existing userspace that we know of.  However, it does make
> the parsing of messages from userspace a bit more strict, and some messages
> that would've worked fine before (e.g. having extra unrecognized attributes)
> will no longer work.  There is no reason for userspace to ever rely on such
> behavior, but AFAICT, historically, different parts of kernel networking
> (e.g. tc-flower) introduced similar changes (making netlink stricter) on
> net-next without backporting them.  Maybe Jakub can comment on that.
> 
> All in all, I do not expect any existing applications to break, but it seems
> a little strange to touch uAPI in stable trees.

Nothing that ends up on Linus's tree should not be allowed also to be in
a stable kernel release as there is no difference in the "rule" that "we
will not break userspace".

So this isn't an issue here, if you need/want to make parsing more
strict, due to bugs or whatever, then great, let's make it more strict
as long as it doesn't break anyone's current system.  It doesn't matter
if this is in Linus's release or in a stable release, same rule holds
for both.

thanks,

greg k-h
