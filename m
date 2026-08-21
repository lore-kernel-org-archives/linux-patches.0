Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360C646AF2D
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 09:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787305569; cv=none; b=Tjxx6T6QWIPBWNFsYBuOo7fL8vh4gutBrAiJBDPVt4+DewnOYb0Fq1D1JKBAS3HpVBYbzirXycNuMweX/MO9wwA9nOae6nVIsxKPhPQs4+PNHtP/N1uTXCWA5NcvRYH07jIOAAZDrZ/VZAXLAtrTGliC6H8xh4/5Oi9kVERYs70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787305569; c=relaxed/simple;
	bh=yXhgGGDCgyg4dLVCmx8eNYy7SK4ry3cP+0+nQ5KSu9I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lG7HgRTenoBInLNs72LwQ/5fStrNUwmT0odYzMwdVFIe22VspnDLO0PSx8ITAIUr33+t+uE3dRUzWvrkBFtkpFYCXoWAkfCCcQJct/zri2EzhVuK8QqSsNJ4a8ygx/sQn6pymBDv8tiSlVbZ4Yf/VDh/sCpkFZuuMOpKwNVDrS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=cQsqMv+L; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="cQsqMv+L"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 39A801A1779;
	Fri, 21 Aug 2026 09:45:57 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 054ED604AA;
	Fri, 21 Aug 2026 09:45:57 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A171611C76E41;
	Fri, 21 Aug 2026 11:45:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1787305552; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=BLs1Sjfon5uOCuEYmjVEH57wzxOpl/pk3AAvEDrinlw=;
	b=cQsqMv+LpSoYyF55CcZyTzGRWgPiwlZRv2cGUe5GIMK9hMZ0w+Qv0KCkGFAHctw03p6Yl7
	xb0ZypQNoG+FEtdtRKPl97CcyQPEcRl7hGevNT/LoJa/6dzgX721HLnuWwvCpovVqNXW8O
	dkwp4hPCTVtQfTErn8fubEe6dP6VVlwyXrvPPG0tf6vfU6imIQV5ReZ9b05Fdesxc2PeUT
	0ptuZZFzTmw9opjkF/5+fCFMveeUhzIjECnTU6l82ooUkFlBediPcWOFhsLUR7VmQuJPHB
	mt5XfuZQS8FG/uxCLDQ5fFUOCrP9qDbZj2ocUZDk8h8uMW164O035wDPR4Pjdg==
Message-ID: <9342b269-9362-49ba-b9c8-a0df9ff1102e@bootlin.com>
Date: Fri, 21 Aug 2026 11:45:50 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 189/220] ipv4: start using dst_dev_rcu()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
 David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>
References: <20260820145223.480031205@linuxfoundation.org>
 <20260820145229.195230707@linuxfoundation.org>
Content-Language: en-US
From: Miguel Gazquez <miguel.gazquez@bootlin.com>
In-Reply-To: <20260820145229.195230707@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

Hi,

I think I made a mistake on my backport :

Le 20/08/2026 à 16:56, Greg Kroah-Hartman a écrit :
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Eric Dumazet <edumazet@google.com>
> 
> [ Upstream commit 6ad8de3cefdb6ffa6708b21c567df0dbf82c43a8 ]
> 
> Change icmpv4_xrlim_allow(), ip_defrag() to prevent possible UAF.
> 
> Change ipmr_prepare_xmit(), ipmr_queue_fwd_xmit(), ip_mr_output(),
> ipv4_neigh_lookup() to use lockdep enabled dst_dev_rcu().
> 
> Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: David Ahern <dsahern@kernel.org>
> Link: https://patch.msgid.link/20250828195823.3958522-9-edumazet@google.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> [ minor modifications to fix conflict ]
> Signed-off-by: Miguel Gazquez <miguel.gazquez@bootlin.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   net/ipv4/icmp.c        |    6 +++---
>   net/ipv4/ip_fragment.c |    6 ++++--
>   net/ipv4/ipmr.c        |    4 ++--
>   net/ipv4/route.c       |    4 ++--
>   4 files changed, 11 insertions(+), 9 deletions(-)
> 
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -320,17 +320,17 @@ static bool icmpv4_xrlim_allow(struct ne
>   		return true;
>   
>   	/* No rate limit on loopback */
> -	dev = dst_dev(dst);
> +	rcu_read_lock();
> +	dev = dst_dev_rcu(dst);
>   	if (dev && (dev->flags & IFF_LOOPBACK))
>   		goto out;
>   
> -	rcu_read_lock();
>   	peer = inet_getpeer_v4(net->ipv4.peers, fl4->daddr,
>   			       l3mdev_master_ifindex_rcu(dev));
>   	rc = inet_peer_xrlim_allow(peer,
>   				   READ_ONCE(net->ipv4.sysctl_icmp_ratelimit));
> -	rcu_read_unlock();
>   out:
> +	rcu_read_unlock();
>   	if (!rc)
>   		__ICMP_INC_STATS(net, ICMP_MIB_RATELIMITHOST);
>   	else
> --- a/net/ipv4/ip_fragment.c
> +++ b/net/ipv4/ip_fragment.c
> @@ -483,13 +483,15 @@ out_fail:
>   /* Process an incoming IP datagram fragment. */
>   int ip_defrag(struct net *net, struct sk_buff *skb, u32 user)
>   {
> -	struct net_device *dev = skb->dev ? : skb_dst_dev(skb);
> -	int vif = l3mdev_master_ifindex_rcu(dev);
> +	struct net_device *dev;
>   	struct ipq *qp;
> +	int vif;
>   
>   	__IP_INC_STATS(net, IPSTATS_MIB_REASMREQDS);
>   
>   	/* Lookup (or create) queue header */
> +	dev = skb->dev ? : skb_dst_dev_rcu(skb);
> +	vif = l3mdev_master_ifindex_rcu(dev);

Here, the upstream version has a `rcu_read_lock();` that I think should 
be added. I will send an updated version.

>   	qp = ip_find(net, ip_hdr(skb), user, vif);
>   	if (qp) {
>   		int ret;
> --- a/net/ipv4/ipmr.c
> +++ b/net/ipv4/ipmr.c
> @@ -1906,7 +1906,7 @@ static void ipmr_queue_xmit(struct net *
>   		goto out_free;
>   	}
>   
> -	encap += LL_RESERVED_SPACE(dev) + rt->dst.header_len;
> +	encap += LL_RESERVED_SPACE(dst_dev_rcu(&rt->dst)) + rt->dst.header_len;
>   
>   	if (skb_cow(skb, encap)) {
>   		ip_rt_put(rt);
> @@ -1943,7 +1943,7 @@ static void ipmr_queue_xmit(struct net *
>   	 * result in receiving multiple packets.
>   	 */
>   	NF_HOOK(NFPROTO_IPV4, NF_INET_FORWARD,
> -		net, NULL, skb, skb->dev, dev,
> +		net, NULL, skb, skb->dev, dst_dev_rcu(&rt->dst),
>   		ipmr_forward_finish);
>   	return;
>   
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -413,11 +413,11 @@ static struct neighbour *ipv4_neigh_look
>   					   const void *daddr)
>   {
>   	const struct rtable *rt = container_of(dst, struct rtable, dst);
> -	struct net_device *dev = dst_dev(dst);
> +	struct net_device *dev;
>   	struct neighbour *n;
>   
>   	rcu_read_lock();
> -
> +	dev = dst_dev_rcu(dst);
>   	if (likely(rt->rt_gw_family == AF_INET)) {
>   		n = ip_neigh_gw4(dev, rt->rt_gw4);
>   	} else if (rt->rt_gw_family == AF_INET6) {
> 
> 

-- 
Miguel Gazquez, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

