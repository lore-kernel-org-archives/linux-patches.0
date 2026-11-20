Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.210.214.84
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795146933;
	b=rrrsTK4IvWVpLFz3pawhwPM2b4emmJvhVP+kPqgl31UGkRgxZfA7myRYCsfnkJW2okVh
	 lpJ9V5QoiYwxHLWi0meaVe+yXn0OAnWgm8GgysEgJOeWRK4h8NRnoaRLrpQSwwKiPCGyf
	 eWNYL9Ty3Pm1WHw8iF1xQR2JG7/8tRFofWosTO9nDz4pfMmRVfiTNlpxYyuTGcYT2cPvm
	 ZwAzEnt0ecCmjS0eF0JnNveHA71RaZ2hpiHXvUWXZHmY/kOUdS3zkr15kS394Ghfuofwx
	 gEu2fI5VksRrCEJ1LxQR3ogpqJu6P26CeA9lWQ3m5fP/2eoyecVeQo+Mu0Di/iJD38A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795146933;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Wmcb4dTMJFIsR3cB+IE3EGHuT+3Q3Ct6EhJsH00YYO4=;
	b=ryroLh/ElvQQpN8Qz5j+fywauso2/Tye6GuvU65bCKHcHzGmth5BSzHXsqx6GEYUXZ22
	 g4gkVGEOl3SKbcOvqn/eiWs51n6vmFg+/sY+pqo+Ek0Knmgz/VpeWgudArichwBIOWXGf
	 rP4QwRfwLxTBCfoekY1+yP6TUm3aUsu8jAZSagj/PlqYakIqcEpEF4RFUaUg4pxArTTtA
	 YA8KQxhx//4FFMyp4hOb9AYQj/crX0JKIIrC40P016yVyVyilRpvyuQfoQ2y1sj4Bc1qY
	 IuA+1CnB2kpxWocr9aLc6xjXr3V2oa85FaWbghnV343tU7KAcDnaxXMe+DuxaYpX8/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=codewreck.org;
	spf=pass smtp.mailfrom=codewreck.org;
	dkim=pass header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b=zR7qOTyT;
	arc=none smtp.remote-ip=62.210.214.84
Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85D4606A325
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 03:55:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A85D4606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b=zR7qOTyT
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id ACC4114C2D6;
	Fri, 20 Nov 2026 04:55:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1795146922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Wmcb4dTMJFIsR3cB+IE3EGHuT+3Q3Ct6EhJsH00YYO4=;
	b=zR7qOTyT9luajpwgtLj2ZUzHQtw0UHTUOIs2yCvXGcUhCYB93vXne4Vu2lZuxACxdS4BZN
	K5nxVDH9V39RxbHIp4QoIGMbOl0g//izPSZgLYcC6QCQO2ZL0JQKdF9NYzTFs9Y4hpR9Pi
	aBg9dx+0hvnC8IRKdMcfcJBx58ZjkQmecOJ//ae0chUoRFO37TdJSTTE52NfUYQZddMvto
	lLPXPJ06UFR565k2o8AK2BvdVJzn2S4L/blun8SAwurOaApDD2WsA4g91sz7fvwv6gbcg0
	2NVZmygUHNvLmPejotYdbzd+wdVYGG76IxqxkRoXHEarty1uUqAac7FOykhNKw==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 2193485e;
	Fri, 20 Nov 2026 03:55:18 +0000 (UTC)
Date: Fri, 20 Nov 2026 12:55:03 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Aristo Chen <aristo.chen@canonical.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 7.3 1238/2651] phy: freescale: fsl-samsung-hdmi:
 initialize default rate
Message-ID: <av_El2-tHN0DJRC5@codewreck.org>
References: <20261118150247.972732815@linuxfoundation.org>
 <20261118150332.571312313@linuxfoundation.org>
 <20261118223142.GA597634@francesco-nb>
 <20261120020908.2320910-1-sashal@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261120020908.2320910-1-sashal@kernel.org>

Sasha Levin wrote on Thu, Nov 19, 2026 at 09:08:58PM -0500:
> Dominique, the 6.12 NULL dereference you bisected is this same patch:
> 6.12 does not set cur_cfg before the clock is registered.

Yes!

Adding commit 41db46233467 ("phy: freescale: fsl-samsung-hdmi: Refactor
finding PHY settings") on top sets cur_cfg correctly and also fixes the
NULL deref, but I definitely agree with dropping patches at this point
(this cycle has been big enough!!), thank you for all the work!

-- 
Dominique Martinet | Asmadeus
