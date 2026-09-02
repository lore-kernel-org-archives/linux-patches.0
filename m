Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEBD4A8FF2
	for <patches@lists.linux.dev>; Wed,  2 Sep 2026 15:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788363334; cv=none; b=hFWkZSpPH3EdiD9UTg0ADTu/S7xEdBPA3XUQBjT8qCGUPvzULkozJfHEU1q3sFHLAZBomE5rUb8drvJC5LANs1D0R1r5ihMdSQXSN/bNSyeEnZnOPlgRja1Ey5S4tcBxfEYR3ITMcyOuojHw6VWEWRhwdJizU3Blo3rgrK5iXho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788363334; c=relaxed/simple;
	bh=4/zkLDvK82JU6Q6Tw2RpZsP6R/Iy2acCK0Y+c7mxREM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1I4TlupLEKj89VtriDVD6upyJ2Blo5KEUAmKDBk07jdagV2Cr3Y77gMbhcoC0EaHsRX4nYgjRzBYnF2+CWU3K0qJWBLCScdw9Nx7VgYjrwQRW+bzs/sv1FrYQe/tisukOxwMFlulAPA8zI9O5Zrm0Bqlq8Az4HZfFMjisEu234=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=queasysnail.net; spf=pass smtp.mailfrom=queasysnail.net; dkim=pass (2048-bit key) header.d=queasysnail.net header.i=@queasysnail.net header.b=J9JFdUcU; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=tSL+WAXj; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=queasysnail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=queasysnail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=queasysnail.net header.i=@queasysnail.net header.b="J9JFdUcU";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="tSL+WAXj"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 16ED47A0149;
	Wed,  2 Sep 2026 11:35:27 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 02 Sep 2026 11:35:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=queasysnail.net;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1788363326; x=1788449726; bh=WClryFH/uykhLTwGrswB2IbjE2NVUlJb
	Xpw7qCV2yQQ=; b=J9JFdUcUvGR2jn0Cz0R5bDpmoY2/7CwXnryN0ONPCwFkYBzD
	zdDGYTls0frTCFJ7s4S6Kwceafhk4J124bnlBZZkvhvty0lKIbm9NfXX06rYZLeN
	j6kKJ9p8Sz73+76ku3eOxepWN/f6XcFjItWo8skfPV5HhsskC1/VeKnN8Tv3j6Fq
	mwdgZ8CBBLovXc6qQectX5eqBP+5rGeWTbP6WS/Fx4fsRYLMPfyaIoS7URbNWxy9
	CHrpl+20LpEFuoL1zZZ8/n2Ypc7TrnNKzulDkak+nuNMVVm+tTf+AIpH0Mr19kka
	jIq+QBA5xRUGh9mBuFfgVn40+x/KV5GgzEMQfg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1788363326; x=
	1788449726; bh=WClryFH/uykhLTwGrswB2IbjE2NVUlJbXpw7qCV2yQQ=; b=t
	SL+WAXjD6Oz+jMKIWEuB5ns+eqdiolbTbx/M5w97qjtyFtOOeVKG1Tcob13EPRyG
	GGfla5WkIkDkQmJHFEtKnym7RFfdlkTDA5VklpOKxH5fUfsPFJMOKi7epcW7RM/q
	sgBoZxsS9rTk3l85GJEoQzOFZbR2OiUJV+sjYJdRqZKcxPZWO4jrCZKeVA1+Xf+F
	rjlxCLe3nqwnODDmHbB0Y9U6Ii79anL0ZIFBrqJw2MQJiziL653HZAGX+S1IhbaW
	QnDeqSPG9u8GzPdStjPB+pV/BBFw0bLTrwz454k3SjLJxZsKsn1dL5U7mJdLxwyb
	cz6aLp5OwJrcNdK0igsOQ==
X-ME-Sender: <xms:PkKYajecV2bl94Ydq8S4vdX6ZwZKkYSei_UgHNWiZeqwSp2pNPH5CQ>
    <xme:PkKYalBYjLupgqBvMJZeHqay-uqNJFKW1kUqWS79Ymga2EUXJ54oG6dtHTFXVbPZP
    toV5s3n0XKCbunuZTrWXoOl0qYrVJmUWvwjNdLxWRLPRiSWbBuDJpY>
X-ME-Received: <xmr:PkKYan6zKoSDm8Kfp7sgWEBDGsjGuI66RbRzovJ679zm9ZwenvCZfzciFow>
X-ME-Proxy-Cause: dmFkZTEf4k+3+JnIrFCzoGXzs89B6GwbkUyP8MFu2olz4AHzC29gDOrIDb4S1aFZs4Vr0Q
    Gi5yw83Uj/+D38UBBcGcMaAYGhWF9Q4iy5kA+ScqAPy2xndWfFU91RifL3hapLRrs3F/ya
    f1cJax7diydBCIWG4mjJgya75KzCaJyd0dMAmn08K/kfoDSQIDo+MN+ZzpVT5mjYSB2EDT
    kINyn3/SCpMC62mdfcr8RiYIsapHEDqyjwtZXqavViZ0iJJtxwcTY7I7Wurh+4asGxWNxs
    8VuhMWKXDj+A3qbDYZFmezTh40dEGT2hcbPXn3e+icvkpcinglKglJAQqkSkH6L96yg4eN
    u8F7yRp1dC24c9fz41j8Ygf/2AxG5hL3UcC10in/nYNDqjuGODXwOvbsICTLD0WSJRdwKA
    mgnaK/Gjpr6T9Z1d7ie3CQjJgNlVaVt4HV341LBIbVINlvABh+JPk89QIaH7/2F2f715XK
    uxNaLNAaXjV82q9S+o6iPlHHK+LN7vAwx8q9l5fnjs9MTifrmrpCi2SH6fZAi4P0AxLMm2
    XzAN6wLLqgaXVoDFMZ9ScdgueDpldN4ZqvhSoXF2CYsQWYWJdaDZzjES0rWmX7fU5309Pw
    do391yGPtyO5nK36l4eKjtDAdCwTKGPyme54xBD5KRiGgz7vmrqAsGAB4UyQ
X-ME-Proxy: <xmx:PkKYaufdR5IRxqdVL91Ff9_7km6lkS-QmLrLoYnoFAPJyv2L1TcuRA>
    <xmx:PkKYatubdQOFRK1kwUEQSu-iBEyleeoX207N0qO8jpyvd9CvCJVEgw>
    <xmx:PkKYaunv_OV_bfb_GWuWNKy5rDqnbwsjD2ssrx7EwedOoSLsDAjMeA>
    <xmx:PkKYagSKoi5AiAMLjkj6PCwn72Ck_OehEbNhk7IBsR_nw-DS0cIa1Q>
    <xmx:PkKYaiAtuEkwyY3s0ACABoyfDXFtUoAjO2N_AXJL3JNBNHQkeaMkDTFq>
Feedback-ID: i934648bf:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 2 Sep 2026 11:35:25 -0400 (EDT)
Date: Wed, 2 Sep 2026 17:35:23 +0200
From: Sabrina Dubroca <sd@queasysnail.net>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Jakub Sitnicki <jakub@cloudflare.com>, john.fastabend@gmail.com,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-6.1] tls: reject the combination of TLS and
 sockmap
Message-ID: <aphCOxhmFLqpjqvs@krikkit>
References: <20260831133314.4125787-1-sashal@kernel.org>
 <20260831133314.4125787-596-sashal@kernel.org>
 <apacn0u4092axmXy@krikkit>
 <apbqjuv6l20bTjQI@laps>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <apbqjuv6l20bTjQI@laps>

2026-09-01, 11:09:02 -0400, Sasha Levin wrote:
> On Tue, Sep 01, 2026 at 11:36:31AM +0200, Sabrina Dubroca wrote:
> > 2026-08-31, 09:30:24 -0400, Sasha Levin wrote:
> > > From: Jakub Kicinski <kuba@kernel.org>
> > > 
> > > [ Upstream commit 460e6486617c17dd19abe8f3fc67d9a6fa25f8ca ]
> > > 
> > > TLS and sockmap (BPF psock) integration hides a lot of latent bugs.
> > > Bugs which may be more or less relevant for real users but they
> > > are definitely exploitable.
> > > 
> > > We could not find anyone actively using this integration so let's
> > > reject this config. Adding a TLS socket to a sockmap was already
> > > rejected by sk_psock_init() through the inet_csk_has_ulp() check.
> > > We need to reject the attempts to configure the TLS keys (rather
> > > than adding the ULP itself) because checking prior to the ULP
> > > installation is tricky without risking a race with sockmap getting
> > > added in parallel (sockmap does not hold the socket lock).
> > > 
> > > This patch is a minimal rejection of the feature. Subsequent patch
> > > in the series will do a light dead code removal. Full cleanup would
> > > require a major rewrite of the Tx path, we don't need skmsg any more.
> > > 
> > > Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
> > > Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
> > > Link: https://patch.msgid.link/20260614014102.461064-2-kuba@kernel.org
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > > 
> > > LLM Generated explanations, may be completely bogus:
> > 
> > 330L... wow.
> > 
> > > ## Phase 1: Commit Message Forensics
> > > 
> > > ### Step 1.1: Subject line
> > > **Record:** `[tls]` / `reject` — reject the unsupported TLS + sockmap
> > > (BPF psock) configuration.
> > > 
> > > ### Step 1.2: Tags
> > > **Record:**
> > > - **Reviewed-by:** Jakub Sitnicki `<jakub@cloudflare.com>`
> > > - **Reviewed-by:** Sabrina Dubroca `<sd@queasysnail.net>`
> > > - **Link:**
> > >   https://patch.msgid.link/20260614014102.461064-2-kuba@kernel.org
> > > - **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>`
> > > - No Fixes:, Reported-by:, Cc: stable@vger.kernel.org, or syzbot tags
> > 
> > Yes, this was intentionally sent to net-next without a Fixes tag,
> > because it's a "feature-level" change, so it kind of feels wrong to
> > send that to stable (even if it's removing a feature that nobody seems
> > to be using). OTOH the code is broken and not really fixable...
> 
> We have plenty of "fixes" that just drop a bunch of broken code :)
> 
> Happy to do either, just let me know.

Alright, if that's ok for you, no objection.

-- 
Sabrina
