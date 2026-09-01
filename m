Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42B93546D0
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 09:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788254070; cv=none; b=Qes6LDHVybFHfrw0XV6BzzlrJDX8t6A9kXxVd98UpJvHySJSBOWKabKvrtjfLW5eNe64HhG37zdkKUU4X5mUZCxZ939VuPK/tVAfc33+tRcqiMPiMlgE2tet/v79Bl+GpFotRpOqvg9p13MTKBC4yNKQ5pe7EuRK3x+rNYGwuBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788254070; c=relaxed/simple;
	bh=HrEzVi6UC+nKW4y6u+K3vXWwGQzLfaoB/qItWJAy7j8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pC9EarLFATR5FtAHz8lXUDX++BjkRsgw7AeiXU6VTeUu5NywS7qJ1oCj6wdyyGuSOTSHKjCwie+nfguHjs+D6kOmh2AAxSqA1xVJSbiYhbA+LFhTgkILlugB+8ToEdwwYcRqTXT+G2/7mWU03H2kKrzzfinP2Cay7vtm+WBr4e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=queasysnail.net; spf=pass smtp.mailfrom=queasysnail.net; dkim=pass (2048-bit key) header.d=queasysnail.net header.i=@queasysnail.net header.b=YcUhEONm; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Y34DdxnQ; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=queasysnail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=queasysnail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=queasysnail.net header.i=@queasysnail.net header.b="YcUhEONm";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Y34DdxnQ"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 79A171D000C2;
	Tue,  1 Sep 2026 05:14:25 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 01 Sep 2026 05:14:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=queasysnail.net;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788254065; x=
	1788340465; bh=GzQVU5iQI7iMD57zVYoJAsEQ7likp2NttqMBLMHDxAI=; b=Y
	cUhEONm69jDX20LXtmjhUSlV1wFGk28emaJiENiYeWWaXhnxZrWNPnawUAlr+siE
	sc8r8ENnzBD9zS6i6MQ4YuBFOghBX9M6L36tTT2EVanYvwP7/z6g+2ONDWE1MD15
	y7gDY8RX89zLamvtMck5DPeslwHKjPTPaZpK8aTo5/NYqyjcAd/OYgmda3TlmYoJ
	+WYzInfLHflRLxLNN0AGDnsCPu5Dw8HMDvsEuz2/PGvYhNBdopJFKmzOX7kN/89T
	jsRaAjiI/qcRwWowmxfvn4sypLYTxqlpPFbWvOURSLQbA4Wwu3RTDktsLpH+WHev
	cqxPp4/h6RflY+ZmMXjTw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1788254065; x=1788340465; bh=GzQVU5iQI7iMD57zVYoJAsEQ7likp2NttqM
	BLMHDxAI=; b=Y34DdxnQqmQ74j4LWx9jtmcGe2qBS8EpbFE4HzdD/0cpQjqNuSq
	So2/gNd7CuQG+s4yyZm2F1atWcuKZT9lq93bBfEva3gJf0xvuj8ZFomMTaC/tiA0
	92R47GGqpf/wVtgtVO5+TXtDZHT3nnupTTakBOqbA3lKJr+ZRzfbhVf7s78YLcah
	jrROfrr2eqRMTiUkePjfvmzFd33jxQU3mrIlDn9xDJPvwi0suqIAggqrBxizZicA
	5F58AickYZuTcRZxjYfIoX7s5VJwh5h+Mgfgj8LFbnKWzTZF9leEkjobDphATDrW
	SOO3sMFATVeokfJXOd9lYHsVgPmBVJxk3UQ==
X-ME-Sender: <xms:cJeWapeuvzf-SbdGxJLooGmsPQLsZkiLh8hOLgc9p9tLdJiwAJIV1Q>
    <xme:cJeWatl-FyujeueOVXO1mYl9y5Az8MLPnbrBaMJX-6SABk1kslDIxtSSPyAP92ZnR
    aRX6GCsNaKzvgLChiuQ-onE3mVEpOB6em1X3zBmQwQFBZ4D3i3POVgR>
X-ME-Received: <xmr:cJeWauwZ9A8lJ7JvuY6Saa4ZI8AlbDVYD4CI3GuAK0nAgsJJ5rS4i3whGfU>
X-ME-Proxy-Cause: dmFkZTGxrwGyHjpR3lkAS7F3IAuECdv+NuVNkUwKf4xDHT4SEKAEMF9ZKNI0sX3ji/4APE
    Lk+z2rtPMrY4RLr8mW2i2hLOUlPnr1/5POFWOug8uYDoXQZ5hOjt237hp4vbWdJYnlaTUs
    LVcvXsR4zQXPDGT3UIJmm/TdJY9ujmY+mU1/4ft5HQnDbUn5ohrPhHAaJ2wdBFaRLIEbSV
    8lMkXrzqaF4V+FzHbTGP26IKYKwWtJ08BsGhjABnAGDg5MYVv6+YZJoo3F4JCJ73auFj2w
    v+yPTmEmRqjZ9bqEBx8nr3pZAryH4HqUpPhecIz//oJw0cyxERje42YvYHr4ReDUWniQqB
    qp8MPX0iuEu6/75mYH9q2MdS5/YcanbZ9v0sJpTbjcIi6+mbisXvp0Whyg/EBvas0nnkzc
    KvYiMThBo6e7lq0eWRao+yDtsvfhjmLIvVv2XqzsZFDhRvljFXUi9QZjWI3tCvukBlbfvm
    xx+Bh8WFNqXzgdRAsJAZSwk4J8jJHdKvOz1EoKD/l34ONrK4sLJ4sZZExcLJrtjTWmXukj
    Jqv72h6A7O44+ivfG9XJKMyuiUOUp8vM+0K1ioooExCKBQMdsXXII37QyARc7yduXRqFqy
    NXJsWba9mvTL+JNJrHTYdutZMlrxDzKROqNsJFWVBI/WZeGpeNfGqSTfs2nA
X-ME-Proxy: <xmx:cJeWagyxNg0WFaSR_5p6pfFAG8BJk7BqQMKoB4NYeB9n1DmWaSAOXQ>
    <xmx:cJeWauU0VPtK8vMRQqEOr6At4O6XtpX9eG_CXGKEgYi2ai6DtFQeNA>
    <xmx:cJeWanSPJhElvSaDVfLwnP5eaHBB-jRIbIADNF9C0ESxVlQkFkJ3RQ>
    <xmx:cJeWamQvK0NLRPYp8Ezsxn0BA1I31R89P6MO3LvKwsebTYTiP6QiEg>
    <xmx:cZeWalzLSdk82DgTunCsEQH_wRSXzXcw5OgtvHB2dUJio7ufD2O-g_4y>
Feedback-ID: i934648bf:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Sep 2026 05:14:24 -0400 (EDT)
Date: Tue, 1 Sep 2026 11:14:22 +0200
From: Sabrina Dubroca <sd@queasysnail.net>
To: Antony Antony <antony.antony@secunet.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	patches@lists.linux.dev, stable@vger.kernel.org,
	Yan Yan <evitayan@google.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-5.10] xfrm: allow migration from UDP
 encapsulated to non-encapsulated ESP
Message-ID: <apaXbsED5LwoaZSs@krikkit>
References: <20260831133314.4125787-1-sashal@kernel.org>
 <20260831133314.4125787-428-sashal@kernel.org>
 <apaDxC5gBw7G2zMc@moon.secunet.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <apaDxC5gBw7G2zMc@moon.secunet.de>

2026-09-01, 09:50:28 +0200, Antony Antony wrote:
> Hi,
> 
> I am thinking of not to back port this patch.
> As it may become a surprise behavior change on older kernels.
> 
> I vote not to backport!  Anyone vote to be back port it?

Yeah, I'm also not convinced that this should go to stable. It's more
a "feature" than a "bug fix" for me.

-- 
Sabrina
