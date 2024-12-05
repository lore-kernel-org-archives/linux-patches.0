Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EF215B54C;
	Thu,  5 Dec 2024 04:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733372973; cv=none; b=AtrgrdsRzBksAYppQP/fkAP48/MWoX0at5giAzwOsF81RDveZtuMG77kRkespJnqWp/jqXhgLDWgFKA+Tc/dHr64HGMH22sI+Qr4h/dUxDbYrNdcs6AExJCPvJ4wIir0I0XB8w2eOeYmOlV1F+qS8RjyhN1Yyfp8bgHjkZ7Uy9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733372973; c=relaxed/simple;
	bh=79/LqLma1lY+zjMNnDXeGme80c3sOqbrWrCpNT8UnsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=shyzTtZlYZO81tXqX7AMaChlYUczchmlHRLjvzTMC6Nxv++tLjYdKHocawlmVbOmCBrKOYnpUbT9vPcTS3vc3fNIX4PUlb+fy9u3HMDpLVWS5bfNQ+MwzjbUB9As3n4JPBYoDqX1EHLoTR7DtZPHbpdtwvwBdoPfWu5D8FcLinE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Q0FWDBxv; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Q0FWDBxv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QvKy+UZr2t0OcAAdZLGtG1cVqgwSBnFneCPyMu3tf0g=; b=Q0FWDBxvY2eO4eZRP0V52Pps3/
	X0JDaqbwG7DbIKxEYI7EliXw3SiS9vorrs5XITi6xEK44UQoC7YxF3kcl6cQpx3CZ6apw1fi3jH/Q
	f+9SDwJRwgwdYDWsaHv6xYH9vYyNCNX5s9HxM+8xzPREYI3kwQ0LG29FRHhKtp/8vn5T3eozetrnz
	VrYFqvcSNZnaEXMRY52wM5tgqEkUdVNujhBmWqdX7h1WnOHcOTiMJrsjY0J6nxrfQ8+6JaJdSna/5
	f9JpGtQynAGzNn4lYLiQXpPYj04OmtpfKCxbhhZS/BdgIYIFlWCTf/hIGh09vUjMaUSGdHmbIlqgm
	oD9/XQqw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tJ3HY-0001EF-2p;
	Thu, 05 Dec 2024 12:29:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 05 Dec 2024 12:29:17 +0800
Date: Thu, 5 Dec 2024 12:29:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Danny Tsen <dtsen@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 043/826] crypto: powerpc/p10-aes-gcm - Register
 modules as SIMD
Message-ID: <Z1EsHcz57kKoArCR@gondor.apana.org.au>
References: <20241203144743.428732212@linuxfoundation.org>
 <20241203144745.143525056@linuxfoundation.org>
 <2a720dd0-56a0-4781-81d3-118368613792@kernel.org>
 <2024120417-flattop-unpaired-fcf8@gregkh>
 <92315b46-db52-4640-b8b9-c2ddbef38a17@kernel.org>
 <2024120421-coming-snore-e6fc@gregkh>
 <b04ee5e7-f654-4562-bc8e-2643f37f1ba3@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b04ee5e7-f654-4562-bc8e-2643f37f1ba3@kernel.org>

On Wed, Dec 04, 2024 at 05:22:19PM +0100, Jiri Slaby wrote:
>
> Not sure at all about this crypto stuff. But this failing patch introduces
> SIMD and the above 8b6c1e466eec adds a dep to SIMD and makes the module
> nonBROKEN at the same time. So I assume the failing one is a prereq to
> unbreak the module. Maintainers?

Why not just leave it as BROKEN? The reason it was marked as BROKEN
was because the fix was too invasive.  So I don't see any need to
backport more patches to make it unBROKEN.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
