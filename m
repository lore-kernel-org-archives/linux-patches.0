Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9051D7C
	for <patches@lists.linux.dev>; Wed, 26 Jul 2023 01:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDFAC433C8;
	Wed, 26 Jul 2023 01:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690334919;
	bh=QbpbwOxeGXq22fzhkwtyeotKCXt3QbovlkI5XBG2NYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ACbKBrd7zGLMCiiOL6UFfi/wtjIA/y4FkezgUjQ3PvviyuaV7MbuG+R/R/qfzEmPb
	 ZqlujrRNeGa22UdqjkA7RbwD+izzUMyGUoq6aXLJ5nhelzLYmtkAE2DA8dixAdLBgW
	 oDL69a6OXcbkIAcVYXBm96KtR93/GEzmms+BvdzF2g8jVJj50VK+AdQIi9EoeoCZXz
	 QbMbKxpXYocvXwc0psKsyX1n1gMMPWNJbWATAMafx0tAo5/mB97rEuvCbcZWM3HnnI
	 DSntF0y4EWVAte61wYRgqnzUP9d1vpW+qfuBoZy6FsfUqizZtROU4Y3MQ0fONrrWZe
	 OvFPbsGSS3Kuw==
Date: Tue, 25 Jul 2023 18:28:38 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5.4 113/313] crypto: skcipher - unify the
 crypto_has_skcipher*() functions
Message-ID: <20230726012838.GA7450@sol.localdomain>
References: <20230725104521.167250627@linuxfoundation.org>
 <20230725104525.907419883@linuxfoundation.org>
 <20230725161343.GA2295@sol.localdomain>
 <ZMB2GjK+PDkf3HIO@sashalap>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMB2GjK+PDkf3HIO@sashalap>

On Tue, Jul 25, 2023 at 09:25:46PM -0400, Sasha Levin wrote:
> On Tue, Jul 25, 2023 at 09:13:43AM -0700, Eric Biggers wrote:
> > On Tue, Jul 25, 2023 at 12:44:26PM +0200, Greg Kroah-Hartman wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > [ Upstream commit d3ca75a8b3d77f2788e6c119ea7c3e3a1ab1e1ca ]
> > > 
> > > crypto_has_skcipher() and crypto_has_skcipher2() do the same thing: they
> > > check for the availability of an algorithm of type skcipher, blkcipher,
> > > or ablkcipher, which also meets any non-type constraints the caller
> > > specified.  And they have exactly the same prototype.
> > > 
> > > Therefore, eliminate the redundancy by removing crypto_has_skcipher()
> > > and renaming crypto_has_skcipher2() to crypto_has_skcipher().
> > > 
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > > Stable-dep-of: efbc7764c444 ("crypto: marvell/cesa - Fix type mismatch warning")
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  crypto/skcipher.c         |  4 ++--
> > >  include/crypto/skcipher.h | 19 +------------------
> > >  2 files changed, 3 insertions(+), 20 deletions(-)
> > 
> > How is this a Stable-dep-of "crypto: marvell/cesa - Fix type mismatch warning"?
> > 
> > I don't understand why this is being backported.
> 
> You're right - it's not a dep on 5.15 but rather on 5.4, and my failed
> optimization attempt did the wrong thing here. Sorry.
> 

I don't see why it would be a dependency on any version.

- Eric
