Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68E2148FE8
	for <patches@lists.linux.dev>; Fri, 22 Nov 2024 17:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732297072; cv=none; b=ugpo2K/8nyqxnFZwrkOZ8wDvK9PEO9gHhkwhj+ncXAeGhexXP2LScz+7SRh0GXgd0+iRtLRBRMH/MsfzYpt+wyhGOl3NCV4CSfznmUAF7Cj+8rSiW0LL4sfDJeR4lp7hcCSm2Xx87D+4rmzlCUnKCjtCQtycFTZBi1p+OskccM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732297072; c=relaxed/simple;
	bh=LkZb1tK7x3oRNiiGggdtEfgKlwgURZJ1YDK1cO5QrfQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=V2rbYsR39qSdKrHpln1CZ8qhLP4EpaoZ4PiX6GswUa4+Fhtrtb1APP8rCyZAgV76SHwB3Po+u9iC33F0nM7sLz+9xqfbvetKGSnL1wWzPwnu+NPURO4wKkoib2a99lZkpx3qJHoYI9C3vEkobPZ5eQ4v2x7xEWDiFD0bpHN6RF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=if5oKBvA; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="if5oKBvA"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 1036C403E9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1732297070; bh=lF7ayOZ+zbKfPF9ZjedqR53rwTPlwZsxVbqKF5+vV0Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=if5oKBvAS0QzG8Awe7Rg6mnbfafgjLZC+rCPTYARpJMw+mTXOR2OFfkPP8MXxuAd0
	 la9JwZ6kk1mwiuQNgyFBouaQEiJlmMywkGqfP4zOg4P8apZCJg1xImV+VSaKtLb1Cd
	 DDqdPtxSSpWufTObXL6xT9ijDl/F9TA2fqbZse3TEPOwXjsby9owInxF5Pq6SNntJg
	 p6Wg7lDMCU62BvHdc430s7DqEWlDBowAccdedtp9s8wXSZREyGXOTs8+Rd3cf7Tmhx
	 t6vu68HBLcvIJBTJZFbeyNMiWV8WltYvgG0deFJ8ClPvhR1OLdtr1dxUZTGExoJRfV
	 7mhyIPdkzsTsw==
Received: from localhost (unknown [IPv6:2601:280:5e00:625::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 1036C403E9;
	Fri, 22 Nov 2024 17:37:50 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Cc: patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] Documentation: kernel-doc: enumerate identifier *type*s
In-Reply-To: <20241119203201.110953-1-rdunlap@infradead.org>
References: <20241119203201.110953-1-rdunlap@infradead.org>
Date: Fri, 22 Nov 2024 10:37:49 -0700
Message-ID: <87v7wf2mqa.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Randy Dunlap <rdunlap@infradead.org> writes:

> Explain that a kernel-doc :identifiers: line can refer to a struct,
> union, enum, or typedef as well as functions.
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> ---
>  Documentation/doc-guide/kernel-doc.rst |    1 +
>  1 file changed, 1 insertion(+)
>
> --- linux-next-20241118.orig/Documentation/doc-guide/kernel-doc.rst
> +++ linux-next-20241118/Documentation/doc-guide/kernel-doc.rst
> @@ -533,6 +533,7 @@ identifiers: *[ function/type ...]*
>    Include documentation for each *function* and *type* in *source*.
>    If no *function* is specified, the documentation for all functions
>    and types in the *source* will be included.
> +  *type* can be a struct, union, enum, or typedef identifier.

Applied, thanks.

jon
