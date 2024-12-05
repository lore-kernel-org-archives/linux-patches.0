Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741FE1CEEB6;
	Thu,  5 Dec 2024 08:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733385913; cv=none; b=ShPgNIpOhJvZjE6TG2uCPGiQ62juBqlCzt33LxJYIRz2qwgwF2gtC34rGQzSupwNBunpvvK5/TBQKP/QIlULsnF7KBZbOGDped9h1nItmkFOB1xi09RB9+frhCRrOyuxHq8mZnluIi8AFRdEOwUlARKghy8WAyaRiWJ2hIEfJuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733385913; c=relaxed/simple;
	bh=olkVMRPaTDYaEUdUouIrnlhdN/TCZuS4G4opFMBflj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h+HWFLbIpNZ9KXaYBtUcULY7kf0f2pqDme0zQP0mWLrIAKsGB3olv1qnodo4eoIYntopYwNzf+3pgtbAw79nq2wLHUm7YJ6GjM1ErYTFGvJtD+40iYL+2dmJR9OKb4W7Pr9JSQPY4P3rz9BxzKfVgeigPR3IbBGlCiyAhFWw35o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnJFy8bz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnJFy8bz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E1DC4CED1;
	Thu,  5 Dec 2024 08:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733385913;
	bh=olkVMRPaTDYaEUdUouIrnlhdN/TCZuS4G4opFMBflj4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wnJFy8bzcc2i+x1r8L1HIbSYiEK0x0vZhWR/DCMcmGPgtRPYVIq+jKlRoRkhUoWj1
	 1ByK+MOLeV/rhWmtA0Kolwpt1ysy6YoIkZzl7Havekz+3Cj466RMFa9PXZTw3OzSOU
	 KB5BIDwrsxkiJBgdO4DsjtHmrmGbBDyb6FQybsJQ=
Date: Thu, 5 Dec 2024 09:05:09 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Danny Tsen <dtsen@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 043/826] crypto: powerpc/p10-aes-gcm - Register
 modules as SIMD
Message-ID: <2024120555-arming-quicksand-49f0@gregkh>
References: <20241203144743.428732212@linuxfoundation.org>
 <20241203144745.143525056@linuxfoundation.org>
 <2a720dd0-56a0-4781-81d3-118368613792@kernel.org>
 <2024120417-flattop-unpaired-fcf8@gregkh>
 <92315b46-db52-4640-b8b9-c2ddbef38a17@kernel.org>
 <2024120421-coming-snore-e6fc@gregkh>
 <b04ee5e7-f654-4562-bc8e-2643f37f1ba3@kernel.org>
 <Z1EsHcz57kKoArCR@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1EsHcz57kKoArCR@gondor.apana.org.au>

On Thu, Dec 05, 2024 at 12:29:17PM +0800, Herbert Xu wrote:
> On Wed, Dec 04, 2024 at 05:22:19PM +0100, Jiri Slaby wrote:
> >
> > Not sure at all about this crypto stuff. But this failing patch introduces
> > SIMD and the above 8b6c1e466eec adds a dep to SIMD and makes the module
> > nonBROKEN at the same time. So I assume the failing one is a prereq to
> > unbreak the module. Maintainers?
> 
> Why not just leave it as BROKEN? The reason it was marked as BROKEN
> was because the fix was too invasive.  So I don't see any need to
> backport more patches to make it unBROKEN.

Fair enough, I've dropped this now from all stable queues, thanks!

greg k-h
