Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42111476CC4
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 09:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788255412; cv=none; b=Cp5xNn9gvrE7Isy6oryggIJmmtvnnTg3HrQCav0LCq6PLCJsMfp7hhH7qsMKIWfmOMZdRRvwakpkNe/y//l0wZqOBs5Nl05vWqRZSKyYhO9jIbk+jiP6K30LsS6CE7T743HFDCZyxtyI/mhgvBN+nXjSiHKEZB5q1MuHlWHQS6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788255412; c=relaxed/simple;
	bh=PEWzitqT1v12vigw6Xw4rm05tYiA9pI41FiezO8JMdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kF5SixjWW+xtOxXgP5hGoDPEXKzGJWlcH3uPtTjyBMhmQjpL0Hw1Rn1W/XRwXP7rEUevOMx0dX8S2yR/UX5DHd0ZQry7+91TuQ/kbJzI94mnSOdapLKo3lJ2IwKZsT3J+LPG/D7bP9YTUhFScQsCr/yDOdD2vaVNFxVZ29DtowI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=queasysnail.net; spf=pass smtp.mailfrom=queasysnail.net; dkim=pass (2048-bit key) header.d=queasysnail.net header.i=@queasysnail.net header.b=PNDBA02k; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OBEdQ0rP; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=queasysnail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=queasysnail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=queasysnail.net header.i=@queasysnail.net header.b="PNDBA02k";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OBEdQ0rP"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 3A21B1D000B5;
	Tue,  1 Sep 2026 05:36:34 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 01 Sep 2026 05:36:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=queasysnail.net;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1788255394; x=1788341794; bh=F3soTVpgk+I32+/X1XRas5lmoapMmWr2
	KZFitMfUEA4=; b=PNDBA02k83dYZ9xHAcbJ4Mcu0+n+1AXc1TZKacNJYO1HgwEU
	kTkwMLb1rkei759ILgP/73TW8tT9JTaMw0+XRTMNP+/nZxxzCSc7l7QeVp0gtYDJ
	LNGz917cIGegGDxp2VoxB758N0MtPG0kcWSpEqQaPFNHGshni5sR8eSAHThV74bX
	Nt6xzdj2jtgtcnPXRhf3r8ZrpzBYNwS2CVobDIMNR2vazuoZizPkN0bX635KwfOL
	L0ysUuURTJnQChmiB7IZhNfEa/0YGwMrRxRRVY6aVDpGux9Y1we66MzPD61otJX5
	7ZKAFHWxUaIvbwtNXfxOaJ/tNFu+Z6tvc+CRaQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1788255394; x=
	1788341794; bh=F3soTVpgk+I32+/X1XRas5lmoapMmWr2KZFitMfUEA4=; b=O
	BEdQ0rPKLkD/gi5BDWY0OSa4/whynDZg5AQPcaa/D2C3E1CCzuRlN5UStjtQTTi9
	0XpfUty4LdTgZua4g8Vw4Y/R7OdeZTIUKHGul1OczJfLq5PU94nkcfv4JqpZdY2G
	Q4mNAdYFDP8bP/oU8BU8KJrb4FwqxOcWc0khoYEAf6QBpROACHt0dV3fd7SQfjRU
	b2ANHQldhAay7Ktkwbf1OvUGNsmeqkyYD3pRI84fdcnJSacmQG1esg63eEAGYmYF
	iEJuFbBr6HqYlqUHPYj/InOd+XnQ9oHXTmJg04WBhEMgGCxjHpvCO8sm9zWQvrLp
	wWmUfyGZYYHSa/lbSLTXA==
X-ME-Sender: <xms:oZyWatczOkIak00p_nsog4z0RusxvlGNoxI40rZM_ot0kHy6iL7Rgg>
    <xme:oZyWanCnwHbUc3PsIIo2nRiXa2TOVfAGTehSfgCnHGS2foTXs-B551pavtpGvSFXy
    njJb1ckA-MCqUYct0LxM6w5AIULCjtMOyLXtr0iNml9xi3hrV1rIqYu>
X-ME-Received: <xmr:oZyWah4kB-p18HNsM5BAr8a8k6io-V9-jQ5BRDK7EJIx0PKSdX3B206jcQs>
X-ME-Proxy-Cause: dmFkZTEMlaE8QXW3F9NNy7+L387hDqgbtUuldLBmUpJNAB/i2C65ypqft4VZ464icipY/B
    7g96MAIYMfbfOx4dOV54fCGPYsnUwzpnt+B5tglu5IWrlYr4D+vyy6nktRctov7dQ7WZ7d
    t91iK7zINnFriGdXddQCKBeeiOo8D5wKrA6krmb6bOtzuDORQO8Ny5ZIjhFQqSeVWAYlZm
    8vt7EIapFnsOJ9741qLyBl+LsiO9YlQ0Bx9mNlTcMTg/OglX9Q/157hHeMvnBrzGadG2Q/
    RxwWlQw2RjpszWz2LPL/HaKKpvUNGrK6yN+qioyGZGP0f0p8c3BEkfFJdFLwzHur5BJ2na
    JM8YLbeJV++HMZKDPYhyTqjQkgh4rakAlM8DtsnbdVk8ZNFXt//IjqC/x+7u83S+NZKspa
    ZEqKvY9TmAWX2fMg6T5MUuu/K0pv8cGF5wCrSkUXBjEAyOlTaeGK9AJWdYcyu1D5tAx0Jh
    fGzvH6W4oupNoghVy3aMwg2bEOhQ6WO6J9jI7OMnf6ohOd85WljCysxXjqY+ZldegYHajq
    P8OCZJmiNQCBqv3VVnBP4zndz5TGKFao3IUcyHvO9U16CANPBt7BFYkaZqGpPY7/zLMmiV
    UUs5gTPlaQaLt9nLnj3QULb6tERs63i06xiXRCIrSBz8v3S6/a1Oa6/BXMaA
X-ME-Proxy: <xmx:oZyWageS05GHQmd5be-E9NP6wWPKxFOQEJoxhM-XJ9YwWSwRsJMW1w>
    <xmx:oZyWansNRiOkHLkHFmVwNdeJmAApIEIGk-WSyEheCKh7iVj_DSK1yQ>
    <xmx:oZyWagkRUzfh0iG5yeRLZxcd7n7k7h4iDhT-S34HbJDnMXEsTxCpGA>
    <xmx:oZyWaqRkkXsN7QXokmkjE2YolPE6y9qCfPfDA7ckA8_bUxxLThoDMQ>
    <xmx:opyWakCeQVwreItFLd1e9DzWaaas2-9sTVBmL2KpSz-_bUeKuWIVE0cO>
Feedback-ID: i934648bf:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Sep 2026 05:36:33 -0400 (EDT)
Date: Tue, 1 Sep 2026 11:36:31 +0200
From: Sabrina Dubroca <sd@queasysnail.net>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Jakub Sitnicki <jakub@cloudflare.com>, john.fastabend@gmail.com,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-6.1] tls: reject the combination of TLS and
 sockmap
Message-ID: <apacn0u4092axmXy@krikkit>
References: <20260831133314.4125787-1-sashal@kernel.org>
 <20260831133314.4125787-596-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260831133314.4125787-596-sashal@kernel.org>

2026-08-31, 09:30:24 -0400, Sasha Levin wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> 
> [ Upstream commit 460e6486617c17dd19abe8f3fc67d9a6fa25f8ca ]
> 
> TLS and sockmap (BPF psock) integration hides a lot of latent bugs.
> Bugs which may be more or less relevant for real users but they
> are definitely exploitable.
> 
> We could not find anyone actively using this integration so let's
> reject this config. Adding a TLS socket to a sockmap was already
> rejected by sk_psock_init() through the inet_csk_has_ulp() check.
> We need to reject the attempts to configure the TLS keys (rather
> than adding the ULP itself) because checking prior to the ULP
> installation is tricky without risking a race with sockmap getting
> added in parallel (sockmap does not hold the socket lock).
> 
> This patch is a minimal rejection of the feature. Subsequent patch
> in the series will do a light dead code removal. Full cleanup would
> require a major rewrite of the Tx path, we don't need skmsg any more.
> 
> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
> Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
> Link: https://patch.msgid.link/20260614014102.461064-2-kuba@kernel.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> LLM Generated explanations, may be completely bogus:

330L... wow.

> ## Phase 1: Commit Message Forensics
> 
> ### Step 1.1: Subject line
> **Record:** `[tls]` / `reject` — reject the unsupported TLS + sockmap
> (BPF psock) configuration.
> 
> ### Step 1.2: Tags
> **Record:**
> - **Reviewed-by:** Jakub Sitnicki `<jakub@cloudflare.com>`
> - **Reviewed-by:** Sabrina Dubroca `<sd@queasysnail.net>`
> - **Link:**
>   https://patch.msgid.link/20260614014102.461064-2-kuba@kernel.org
> - **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>`
> - No Fixes:, Reported-by:, Cc: stable@vger.kernel.org, or syzbot tags

Yes, this was intentionally sent to net-next without a Fixes tag,
because it's a "feature-level" change, so it kind of feels wrong to
send that to stable (even if it's removing a feature that nobody seems
to be using). OTOH the code is broken and not really fixable...

-- 
Sabrina
