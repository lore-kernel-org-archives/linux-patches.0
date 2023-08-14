Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE07A923
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 15:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFB4C433C8;
	Mon, 14 Aug 2023 15:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692026090;
	bh=g9SZlKOPWWnC6NmGW13v2jdDr2kwqfhBFZBSUHkDY0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yqFYS0KhAzz7SMTnc/UtpvttJHIfGuVOELqnTQsEoG9RCM2dp7JvRfKCQ8c0s6YDL
	 D0AldwN2wDfGolrlr5z8b6L/6b28ti3hkqhHFTNYTHaDUCWvDUhEVBerEO+FrduYel
	 /DeD0VOMCl6CDqfvK1Ud5Ea769vYna0kvT+ddQW4=
Date: Mon, 14 Aug 2023 17:14:48 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Westphal <fw@strlen.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 6.4 090/206] netfilter: nf_tables: dont skip expired
 elements during walk
Message-ID: <2023081418-goes-vitally-3c6f@gregkh>
References: <20230813211724.969019629@linuxfoundation.org>
 <20230813211727.651202695@linuxfoundation.org>
 <20230813221730.GA22068@breakpoint.cc>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230813221730.GA22068@breakpoint.cc>

On Mon, Aug 14, 2023 at 12:17:30AM +0200, Florian Westphal wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > From: Florian Westphal <fw@strlen.de>
> > 
> > commit 24138933b97b055d486e8064b4a1721702442a9b upstream.
> 
> Just FYI, this change is not correct.
> 
> > There is an asymmetry between commit/abort and preparation phase if the
> > following conditions are met:
> 
> > 1. set is a verdict map ("1.2.3.4 : jump foo")
> > 2. timeouts are enabled
> 
> [..]
> 
> > --- a/net/netfilter/nft_set_pipapo.c
> > +++ b/net/netfilter/nft_set_pipapo.c
> > @@ -566,8 +566,7 @@ next_match:
> >  			goto out;
> >  
> >  		if (last) {
> > -			if (nft_set_elem_expired(&f->mt[b].e->ext) ||
> > -			    (genmask &&
> > +			if ((genmask &&
> >  			     !nft_set_elem_active(&f->mt[b].e->ext, genmask)))
> >  				goto next_match;
> 
> This part is bonkers, it papers over the real issue and introduces
> another bug while at it (insertions for key K will fail if we have
> a key K that is already expired).
> 
> A patch to resolve it is queued on the mailing list and I'll make sure
> it gets passed to the net tree by this wednesday.
> 
> Sorry for the inconvenience, I hope this doesn't interefere with
> -stable release plans and this is leaves enough time for
> the fix to make it to -stable too.

Is there an upstream fix for this yet?  If so, I can pull it into the
stable tree, or should I drop this one for now and wait for the real
fix?  It's your call.

thanks,

greg k-h
