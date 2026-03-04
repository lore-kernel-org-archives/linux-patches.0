Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [194.59.206.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA46D346FC0;
	Wed,  4 Mar 2026 07:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.59.206.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772609369; cv=none; b=S3V9IgDHVO1DJ87s/L39Dd24iTmX0QqJe/ueHktQ1tsR34wKDissXKB/pZKX8lw+fJDskc7e46isHRt+nLLQ9JUb0ZdMzEqoPQ5Du91wrSK050S4Qt8i/OJNsKDtiSZ1eaZu0P3udxieqyMgbfdGWIA2HRxpDY0CrdHLaEEvrmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772609369; c=relaxed/simple;
	bh=04B3JZnKhLus9Vs7BYUo4VtB5RoET5nGlcy42+OAtPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MWyb/a5M7ZwZR4Ov0HD+MKh7rvJtxXQJeNoctZ1XtqV1rSKCeIFcafaLlRP2cIulzfG9W1UWEYDWT62tFJMYaxDfC5UfFcI3co9l5gJNzTqJQEGWSG9h0GRFMYRsw+j13eZanexXoUCeNBeqcB2TWERg1WnSJlP1pJy77bOymJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=Ch7fJxGY; arc=none smtp.client-ip=194.59.206.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="Ch7fJxGY"
Received: from relay02-mors.netcup.net (localhost [127.0.0.1])
	by relay02-mors.netcup.net (Postfix) with ESMTPS id 4fQknW3845z4Hpk;
	Wed,  4 Mar 2026 08:29:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1772609359;
	bh=04B3JZnKhLus9Vs7BYUo4VtB5RoET5nGlcy42+OAtPs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ch7fJxGYOjKX0hhvy1oD03iZMourtjiNzQEhUk14a1wyLsTROPpOukVyh7TE35mAe
	 vJCL18V8sitamowGWRqGa6Bl6y2kdWyTaBZC0BW59ERP72CJlYKOvlwGGT/80sqV21
	 9IQOT2mGSgTb1GUpSpmOb6u1tTEbOTnWnN/N0tbBtlN6j8OgroytzhrM4ODFglzcCl
	 bK6/UzfyPR2vW1ZNHQMZICM1rgOJHZ6C8U9+1nv+lfGOD0CUeH6CbuKLWphWTYqLTc
	 I1AixOnvlLtyevQkT0TOy9h825XM8sIplQ1FqJRKTQY5LvqdHY0Pld28bSuq6x9SBX
	 CjepsOrRBeutA==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by relay02-mors.netcup.net (Postfix) with ESMTPS id 4fQknW2Qyfz7w8D;
	Wed,  4 Mar 2026 08:29:19 +0100 (CET)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4fQknV5YK1z8sZw;
	Wed,  4 Mar 2026 08:29:18 +0100 (CET)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id E62ED6176B;
	Wed,  4 Mar 2026 08:29:17 +0100 (CET)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <69b9d4a7-166d-4f7e-9787-e1b96775ee19@leemhuis.info>
Date: Wed, 4 Mar 2026 08:29:16 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 315/641] netfilter: nft_set_rbtree: validate open
 interval overlap
To: Pablo Neira Ayuso <pablo@netfilter.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Florian Westphal <fw@strlen.de>,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: <20260225012348.915798704@linuxfoundation.org>
 <20260225012356.353371017@linuxfoundation.org> <aaeEd8UqYQ33Af7_@chamomile>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <aaeEd8UqYQ33Af7_@chamomile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <177260935828.3198914.4892368580495272802@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: E62ED6176B
X-NC-CID: YbfcO5GjGI8EMxy6a8YVo7E4minwGLRgxH4KR2jVc0vSMuXF2LM=

On 3/4/26 02:01, Pablo Neira Ayuso wrote:
> 
> Would it be possible to revert this patch in -stable 6.18?
> 
> There is a bug in userspace nftables 1.1.6 that gets amplified by this
> patch, resulting in rejecting large interval sets with -stable 6.18.

Sasha, I wonder if it might be worth the risk squeezing this revert into
6.18.16 and 6.19.6, as there are various reports coming in about the
regression that Pablo mentioned:

https://bugzilla.kernel.org/show_bug.cgi?id=221152
https://bugzilla.kernel.org/show_bug.cgi?id=221158
https://lore.kernel.org/all/9d110d860c0c7e110d018ea53a7666eba275da20.camel@gmail.com/
https://lore.kernel.org/all/2a780701-f1e4-4ff4-b796-889f7ee19ead@crc.id.au/

I think I saw a at least two more.

Ciao, Thorsten


> On Tue, Feb 24, 2026 at 05:20:41PM -0800, Greg Kroah-Hartman wrote:
>> 6.18-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Pablo Neira Ayuso <pablo@netfilter.org>
>>
>> [ Upstream commit 648946966a08e4cb1a71619e3d1b12bd7642de7b ]
>>
>> Open intervals do not have an end element, in particular an open
>> interval at the end of the set is hard to validate because of it is
>> lacking the end element, and interval validation relies on such end
>> element to perform the checks.
>>
>> This patch adds a new flag field to struct nft_set_elem, this is not an
>> issue because this is a temporary object that is allocated in the stack
>> from the insert/deactivate path. This flag field is used to specify that
>> this is the last element in this add/delete command.
>>
>> The last flag is used, in combination with the start element cookie, to
>> check if there is a partial overlap, eg.
>>
>>    Already exists:   255.255.255.0-255.255.255.254
>>    Add interval:     255.255.255.0-255.255.255.255
>>                      ~~~~~~~~~~~~~
>>              start element overlap
>>
>> Basically, the idea is to check for an existing end element in the set
>> if there is an overlap with an existing start element.
>>
>> However, the last open interval can come in any position in the add
>> command, the corner case can get a bit more complicated:
>>
>>    Already exists:   255.255.255.0-255.255.255.254
>>    Add intervals:    255.255.255.0-255.255.255.255,255.255.255.0-255.255.255.254
>>                      ~~~~~~~~~~~~~
>>              start element overlap
>>
>> To catch this overlap, annotate that the new start element is a possible
>> overlap, then report the overlap if the next element is another start
>> element that confirms that previous element in an open interval at the
>> end of the set.
>>
>> For deletions, do not update the start cookie when deleting an open
>> interval, otherwise this can trigger spurious EEXIST when adding new
>> elements.
>>
>> Unfortunately, there is no NFT_SET_ELEM_INTERVAL_OPEN flag which would
>> make easier to detect open interval overlaps.
>>
>> Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> Signed-off-by: Florian Westphal <fw@strlen.de>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  include/net/netfilter/nf_tables.h |  4 ++
>>  net/netfilter/nf_tables_api.c     | 21 +++++++--
>>  net/netfilter/nft_set_rbtree.c    | 71 ++++++++++++++++++++++++++-----
>>  3 files changed, 82 insertions(+), 14 deletions(-)
>>
>> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
>> index 0e266c2d0e7f0..7eac73f9b4ce3 100644
>> --- a/include/net/netfilter/nf_tables.h
>> +++ b/include/net/netfilter/nf_tables.h
>> @@ -278,6 +278,8 @@ struct nft_userdata {
>>  	unsigned char		data[];
>>  };
>>  
>> +#define NFT_SET_ELEM_INTERNAL_LAST	0x1
>> +
>>  /* placeholder structure for opaque set element backend representation. */
>>  struct nft_elem_priv { };
>>  
>> @@ -287,6 +289,7 @@ struct nft_elem_priv { };
>>   *	@key: element key
>>   *	@key_end: closing element key
>>   *	@data: element data
>> + * 	@flags: flags
>>   *	@priv: element private data and extensions
>>   */
>>  struct nft_set_elem {
>> @@ -302,6 +305,7 @@ struct nft_set_elem {
>>  		u32		buf[NFT_DATA_VALUE_MAXLEN / sizeof(u32)];
>>  		struct nft_data val;
>>  	} data;
>> +	u32			flags;
>>  	struct nft_elem_priv	*priv;
>>  };
>>  
>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>> index e3279179cd305..9051f2c3595a2 100644
>> --- a/net/netfilter/nf_tables_api.c
>> +++ b/net/netfilter/nf_tables_api.c
>> @@ -7271,7 +7271,8 @@ static u32 nft_set_maxsize(const struct nft_set *set)
>>  }
>>  
>>  static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>> -			    const struct nlattr *attr, u32 nlmsg_flags)
>> +			    const struct nlattr *attr, u32 nlmsg_flags,
>> +			    bool last)
>>  {
>>  	struct nft_expr *expr_array[NFT_SET_EXPR_MAX] = {};
>>  	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
>> @@ -7557,6 +7558,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>>  	if (flags)
>>  		*nft_set_ext_flags(ext) = flags;
>>  
>> +	if (last)
>> +		elem.flags = NFT_SET_ELEM_INTERNAL_LAST;
>> +	else
>> +		elem.flags = 0;
>> +
>>  	if (obj)
>>  		*nft_set_ext_obj(ext) = obj;
>>  
>> @@ -7720,7 +7726,8 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
>>  	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
>>  
>>  	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
>> -		err = nft_add_set_elem(&ctx, set, attr, info->nlh->nlmsg_flags);
>> +		err = nft_add_set_elem(&ctx, set, attr, info->nlh->nlmsg_flags,
>> +				       nla_is_last(attr, rem));
>>  		if (err < 0) {
>>  			NL_SET_BAD_ATTR(extack, attr);
>>  			return err;
>> @@ -7843,7 +7850,7 @@ static void nft_trans_elems_destroy_abort(const struct nft_ctx *ctx,
>>  }
>>  
>>  static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
>> -			   const struct nlattr *attr)
>> +			   const struct nlattr *attr, bool last)
>>  {
>>  	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
>>  	struct nft_set_ext_tmpl tmpl;
>> @@ -7911,6 +7918,11 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
>>  	if (flags)
>>  		*nft_set_ext_flags(ext) = flags;
>>  
>> +	if (last)
>> +		elem.flags = NFT_SET_ELEM_INTERNAL_LAST;
>> +	else
>> +		elem.flags = 0;
>> +
>>  	trans = nft_trans_elem_alloc(ctx, NFT_MSG_DELSETELEM, set);
>>  	if (trans == NULL)
>>  		goto fail_trans;
>> @@ -8058,7 +8070,8 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
>>  		return nft_set_flush(&ctx, set, genmask);
>>  
>>  	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
>> -		err = nft_del_setelem(&ctx, set, attr);
>> +		err = nft_del_setelem(&ctx, set, attr,
>> +				      nla_is_last(attr, rem));
>>  		if (err == -ENOENT &&
>>  		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYSETELEM)
>>  			continue;
>> diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
>> index a4fb5b517d9de..644d4b9167057 100644
>> --- a/net/netfilter/nft_set_rbtree.c
>> +++ b/net/netfilter/nft_set_rbtree.c
>> @@ -304,10 +304,19 @@ static void nft_rbtree_set_start_cookie(struct nft_rbtree *priv,
>>  	priv->start_rbe_cookie = (unsigned long)rbe;
>>  }
>>  
>> +static void nft_rbtree_set_start_cookie_open(struct nft_rbtree *priv,
>> +					     const struct nft_rbtree_elem *rbe,
>> +					     unsigned long open_interval)
>> +{
>> +	priv->start_rbe_cookie = (unsigned long)rbe | open_interval;
>> +}
>> +
>> +#define NFT_RBTREE_OPEN_INTERVAL	1UL
>> +
>>  static bool nft_rbtree_cmp_start_cookie(struct nft_rbtree *priv,
>>  					const struct nft_rbtree_elem *rbe)
>>  {
>> -	return priv->start_rbe_cookie == (unsigned long)rbe;
>> +	return (priv->start_rbe_cookie & ~NFT_RBTREE_OPEN_INTERVAL) == (unsigned long)rbe;
>>  }
>>  
>>  static bool nft_rbtree_insert_same_interval(const struct net *net,
>> @@ -337,13 +346,14 @@ static bool nft_rbtree_insert_same_interval(const struct net *net,
>>  
>>  static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
>>  			       struct nft_rbtree_elem *new,
>> -			       struct nft_elem_priv **elem_priv, u64 tstamp)
>> +			       struct nft_elem_priv **elem_priv, u64 tstamp, bool last)
>>  {
>>  	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL, *rbe_prev;
>>  	struct rb_node *node, *next, *parent, **p, *first = NULL;
>>  	struct nft_rbtree *priv = nft_set_priv(set);
>>  	u8 cur_genmask = nft_genmask_cur(net);
>>  	u8 genmask = nft_genmask_next(net);
>> +	unsigned long open_interval = 0;
>>  	int d;
>>  
>>  	/* Descend the tree to search for an existing element greater than the
>> @@ -449,10 +459,18 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
>>  		}
>>  	}
>>  
>> -	if (nft_rbtree_interval_null(set, new))
>> -		priv->start_rbe_cookie = 0;
>> -	else if (nft_rbtree_interval_start(new) && priv->start_rbe_cookie)
>> +	if (nft_rbtree_interval_null(set, new)) {
>>  		priv->start_rbe_cookie = 0;
>> +	} else if (nft_rbtree_interval_start(new) && priv->start_rbe_cookie) {
>> +		if (nft_set_is_anonymous(set)) {
>> +			priv->start_rbe_cookie = 0;
>> +		} else if (priv->start_rbe_cookie & NFT_RBTREE_OPEN_INTERVAL) {
>> +			/* Previous element is an open interval that partially
>> +			 * overlaps with an existing non-open interval.
>> +			 */
>> +			return -ENOTEMPTY;
>> +		}
>> +	}
>>  
>>  	/* - new start element matching existing start element: full overlap
>>  	 *   reported as -EEXIST, cleared by caller if NLM_F_EXCL is not given.
>> @@ -460,7 +478,27 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
>>  	if (rbe_ge && !nft_rbtree_cmp(set, new, rbe_ge) &&
>>  	    nft_rbtree_interval_start(rbe_ge) == nft_rbtree_interval_start(new)) {
>>  		*elem_priv = &rbe_ge->priv;
>> -		nft_rbtree_set_start_cookie(priv, rbe_ge);
>> +
>> +		/* - Corner case: new start element of open interval (which
>> +		 *   comes as last element in the batch) overlaps the start of
>> +		 *   an existing interval with an end element: partial overlap.
>> +		 */
>> +		node = rb_first(&priv->root);
>> +		rbe = __nft_rbtree_next_active(node, genmask);
>> +		if (rbe && nft_rbtree_interval_end(rbe)) {
>> +			rbe = nft_rbtree_next_active(rbe, genmask);
>> +			if (rbe &&
>> +			    nft_rbtree_interval_start(rbe) &&
>> +			    !nft_rbtree_cmp(set, new, rbe)) {
>> +				if (last)
>> +					return -ENOTEMPTY;
>> +
>> +				/* Maybe open interval? */
>> +				open_interval = NFT_RBTREE_OPEN_INTERVAL;
>> +			}
>> +		}
>> +		nft_rbtree_set_start_cookie_open(priv, rbe_ge, open_interval);
>> +
>>  		return -EEXIST;
>>  	}
>>  
>> @@ -515,6 +553,12 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
>>  	    nft_rbtree_interval_end(rbe_ge) && nft_rbtree_interval_end(new))
>>  		return -ENOTEMPTY;
>>  
>> +	/* - start element overlaps an open interval but end element is new:
>> +	 *   partial overlap, reported as -ENOEMPTY.
>> +	 */
>> +	if (!rbe_ge && priv->start_rbe_cookie && nft_rbtree_interval_end(new))
>> +		return -ENOTEMPTY;
>> +
>>  	/* Accepted element: pick insertion point depending on key value */
>>  	parent = NULL;
>>  	p = &priv->root.rb_node;
>> @@ -624,6 +668,7 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
>>  			     struct nft_elem_priv **elem_priv)
>>  {
>>  	struct nft_rbtree_elem *rbe = nft_elem_priv_cast(elem->priv);
>> +	bool last = !!(elem->flags & NFT_SET_ELEM_INTERNAL_LAST);
>>  	struct nft_rbtree *priv = nft_set_priv(set);
>>  	u64 tstamp = nft_net_tstamp(net);
>>  	int err;
>> @@ -640,8 +685,12 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
>>  		cond_resched();
>>  
>>  		write_lock_bh(&priv->lock);
>> -		err = __nft_rbtree_insert(net, set, rbe, elem_priv, tstamp);
>> +		err = __nft_rbtree_insert(net, set, rbe, elem_priv, tstamp, last);
>>  		write_unlock_bh(&priv->lock);
>> +
>> +		if (nft_rbtree_interval_end(rbe))
>> +			priv->start_rbe_cookie = 0;
>> +
>>  	} while (err == -EAGAIN);
>>  
>>  	return err;
>> @@ -729,6 +778,7 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
>>  		      const struct nft_set_elem *elem)
>>  {
>>  	struct nft_rbtree_elem *rbe, *this = nft_elem_priv_cast(elem->priv);
>> +	bool last = !!(elem->flags & NFT_SET_ELEM_INTERNAL_LAST);
>>  	struct nft_rbtree *priv = nft_set_priv(set);
>>  	const struct rb_node *parent = priv->root.rb_node;
>>  	u8 genmask = nft_genmask_next(net);
>> @@ -769,9 +819,10 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
>>  				continue;
>>  			}
>>  
>> -			if (nft_rbtree_interval_start(rbe))
>> -				nft_rbtree_set_start_cookie(priv, rbe);
>> -			else if (!nft_rbtree_deactivate_same_interval(net, priv, rbe))
>> +			if (nft_rbtree_interval_start(rbe)) {
>> +				if (!last)
>> +					nft_rbtree_set_start_cookie(priv, rbe);
>> +			} else if (!nft_rbtree_deactivate_same_interval(net, priv, rbe))
>>  				return NULL;
>>  
>>  			nft_rbtree_flush(net, set, &rbe->priv);
>> -- 
>> 2.51.0
>>
>>
>>

