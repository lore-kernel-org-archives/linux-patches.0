Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FD3A23
	for <patches@lists.linux.dev>; Wed, 26 Jul 2023 04:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7407C433C8;
	Wed, 26 Jul 2023 04:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690346178;
	bh=9UdJXmRkE5hJb7cKI5WOG7r81qkm9HlVQ9VaRZ9HTQM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=joC7gKc5kbfFC7ZWx1Qn9BVorSj2Cq6wpr8oNA/Yrjj6gCDeR548QQG6KmMh4W04P
	 txk/DZdXsQPpDi+VNrLqtfK0orUFYQ0qgE/wR0YEW0IURZvwGOdCQVKzvzqU5tDTdM
	 jnLFkRbIjml54vD+cKQ3nKTUkl3lBvqyrAMgbQtk=
Date: Wed, 26 Jul 2023 06:36:15 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5.4 113/313] crypto: skcipher - unify the
 crypto_has_skcipher*() functions
Message-ID: <2023072656-balsamic-playlist-536f@gregkh>
References: <20230725104521.167250627@linuxfoundation.org>
 <20230725104525.907419883@linuxfoundation.org>
 <20230725161343.GA2295@sol.localdomain>
 <ZMB2GjK+PDkf3HIO@sashalap>
 <20230726012838.GA7450@sol.localdomain>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726012838.GA7450@sol.localdomain>

On Tue, Jul 25, 2023 at 06:28:38PM -0700, Eric Biggers wrote:
> On Tue, Jul 25, 2023 at 09:25:46PM -0400, Sasha Levin wrote:
> > On Tue, Jul 25, 2023 at 09:13:43AM -0700, Eric Biggers wrote:
> > > On Tue, Jul 25, 2023 at 12:44:26PM +0200, Greg Kroah-Hartman wrote:
> > > > From: Eric Biggers <ebiggers@google.com>
> > > > 
> > > > [ Upstream commit d3ca75a8b3d77f2788e6c119ea7c3e3a1ab1e1ca ]
> > > > 
> > > > crypto_has_skcipher() and crypto_has_skcipher2() do the same thing: they
> > > > check for the availability of an algorithm of type skcipher, blkcipher,
> > > > or ablkcipher, which also meets any non-type constraints the caller
> > > > specified.  And they have exactly the same prototype.
> > > > 
> > > > Therefore, eliminate the redundancy by removing crypto_has_skcipher()
> > > > and renaming crypto_has_skcipher2() to crypto_has_skcipher().
> > > > 
> > > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > > > Stable-dep-of: efbc7764c444 ("crypto: marvell/cesa - Fix type mismatch warning")
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > > >  crypto/skcipher.c         |  4 ++--
> > > >  include/crypto/skcipher.h | 19 +------------------
> > > >  2 files changed, 3 insertions(+), 20 deletions(-)
> > > 
> > > How is this a Stable-dep-of "crypto: marvell/cesa - Fix type mismatch warning"?
> > > 
> > > I don't understand why this is being backported.
> > 
> > You're right - it's not a dep on 5.15 but rather on 5.4, and my failed
> > optimization attempt did the wrong thing here. Sorry.
> > 
> 
> I don't see why it would be a dependency on any version.

Yeah, something went wrong here, I've dropped both of these crypto
patches now, thanks for pointing it out.

greg k-h
