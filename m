Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FF8218EBA;
	Fri, 21 Aug 2026 15:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787324514; cv=none; b=l9Frkub+LiugVywZP0HYuI42MSYS0tMrNUP8q5zP7Eu8axly786Fpt1yNiF+rR7L9oySRbrkVWX6lsnWx9KUsa7KYR97P7Pe4Zrtqe06V+hrEcyDeS7MBX3dxTRiiZh4SPwn2rWatEAEBCWgCQ1WeoCes5GTyARZn26tEQKz2KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787324514; c=relaxed/simple;
	bh=lebYBaaoe1sSszAtcqItfLJ4gInKL2JGGmrYz37nQN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HdCNZpOrK0G66wixlE/y/+gOtpC3HWnfpV9rS7EHf3OPrltPZfi4o3yoCHjnykaNk572S4zt6u0rs0F91TG+t8nISG1sGQB7FSxOd3Ptx5h5NYlgPgSl4MjPI0wJcNTj9gyaaAsDvX62sMWUbzLmgt+vqtTjr+tM6CV3I5vzuGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whtxBnb7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whtxBnb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4862B1F000E9;
	Fri, 21 Aug 2026 15:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787324512;
	bh=yhm9pHibImin5CCGKH9Yxy37lgHNWcPxfnpWo+gh/BA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=whtxBnb7eHfBz+akT9DW54xchExOTYqm819jSWX/xC857Ma3xApfvaOX1Wu7bCdmZ
	 k6Qk/aqaqmTqHChUxA3tJLFsJPc2rLGkD99aMb10Qdwc/s72BLFvxfT5Get8RALAK+
	 vRtImQhiiVKiME6G/Dimg5jkCT64hM/vcqEh+dcw=
Date: Fri, 21 Aug 2026 17:01:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Gazquez <miguel.gazquez@bootlin.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 6.12 189/220] ipv4: start using dst_dev_rcu()
Message-ID: <2026082140-chug-riches-f2ec@gregkh>
References: <20260820145223.480031205@linuxfoundation.org>
 <20260820145229.195230707@linuxfoundation.org>
 <9342b269-9362-49ba-b9c8-a0df9ff1102e@bootlin.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9342b269-9362-49ba-b9c8-a0df9ff1102e@bootlin.com>

On Fri, Aug 21, 2026 at 11:45:50AM +0200, Miguel Gazquez wrote:
> Hi,
> 
> I think I made a mistake on my backport :
> 
> Le 20/08/2026 à 16:56, Greg Kroah-Hartman a écrit :
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > [ Upstream commit 6ad8de3cefdb6ffa6708b21c567df0dbf82c43a8 ]
> > 
> > Change icmpv4_xrlim_allow(), ip_defrag() to prevent possible UAF.
> > 
> > Change ipmr_prepare_xmit(), ipmr_queue_fwd_xmit(), ip_mr_output(),
> > ipv4_neigh_lookup() to use lockdep enabled dst_dev_rcu().
> > 
> > Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reviewed-by: David Ahern <dsahern@kernel.org>
> > Link: https://patch.msgid.link/20250828195823.3958522-9-edumazet@google.com
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > [ minor modifications to fix conflict ]
> > Signed-off-by: Miguel Gazquez <miguel.gazquez@bootlin.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   net/ipv4/icmp.c        |    6 +++---
> >   net/ipv4/ip_fragment.c |    6 ++++--
> >   net/ipv4/ipmr.c        |    4 ++--
> >   net/ipv4/route.c       |    4 ++--
> >   4 files changed, 11 insertions(+), 9 deletions(-)
> > 
> > --- a/net/ipv4/icmp.c
> > +++ b/net/ipv4/icmp.c
> > @@ -320,17 +320,17 @@ static bool icmpv4_xrlim_allow(struct ne
> >   		return true;
> >   	/* No rate limit on loopback */
> > -	dev = dst_dev(dst);
> > +	rcu_read_lock();
> > +	dev = dst_dev_rcu(dst);
> >   	if (dev && (dev->flags & IFF_LOOPBACK))
> >   		goto out;
> > -	rcu_read_lock();
> >   	peer = inet_getpeer_v4(net->ipv4.peers, fl4->daddr,
> >   			       l3mdev_master_ifindex_rcu(dev));
> >   	rc = inet_peer_xrlim_allow(peer,
> >   				   READ_ONCE(net->ipv4.sysctl_icmp_ratelimit));
> > -	rcu_read_unlock();
> >   out:
> > +	rcu_read_unlock();
> >   	if (!rc)
> >   		__ICMP_INC_STATS(net, ICMP_MIB_RATELIMITHOST);
> >   	else
> > --- a/net/ipv4/ip_fragment.c
> > +++ b/net/ipv4/ip_fragment.c
> > @@ -483,13 +483,15 @@ out_fail:
> >   /* Process an incoming IP datagram fragment. */
> >   int ip_defrag(struct net *net, struct sk_buff *skb, u32 user)
> >   {
> > -	struct net_device *dev = skb->dev ? : skb_dst_dev(skb);
> > -	int vif = l3mdev_master_ifindex_rcu(dev);
> > +	struct net_device *dev;
> >   	struct ipq *qp;
> > +	int vif;
> >   	__IP_INC_STATS(net, IPSTATS_MIB_REASMREQDS);
> >   	/* Lookup (or create) queue header */
> > +	dev = skb->dev ? : skb_dst_dev_rcu(skb);
> > +	vif = l3mdev_master_ifindex_rcu(dev);
> 
> Here, the upstream version has a `rcu_read_lock();` that I think should be
> added. I will send an updated version.

I will drop this now, thanks.

greg k-h
