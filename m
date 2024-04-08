Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6D513E8AB
	for <patches@lists.linux.dev>; Mon,  8 Apr 2024 15:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712588445; cv=none; b=H2G5OFWLI0wx5O9qnTe8nU1FnQfqBCDeUbyZTSqqLmX5h3gk2POe7CQ7v08bnTdoe4WC/kDNdxWo0vd8BRUWQfye9CfwsrpVNhXO5z7iEVxexJ3+2d90SnSTQOHpuoOkLZuljrxSKfL9ilH119X1t4LkC8Fb9I3ic+Mk/CjcLj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712588445; c=relaxed/simple;
	bh=lHBKLimfLujhLS21Jb1gu3fyBOieNfo8wdRcWqFSIKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XrwK6MgmyhTLpY7ER206zpU84gNhaTTJK3QVvsPmCP3JSsqFSdjmS6swWgnkBsT68AkA3Tu4BsVI2EBsWS9JLegayaYn0frcISnAkjrUG6YJLrxNwL99g6gO4/r89ryki/oIBWdaO8Snbp8LoE34vlMDPYK3Z5VqhccIYxXal+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BxhFQsAz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zMqWiSve; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BxhFQsAz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zMqWiSve; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BxhFQsAz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zMqWiSve";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BxhFQsAz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zMqWiSve"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 02531229FD;
	Mon,  8 Apr 2024 15:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1712588442; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rnn5Xv0fSIvD/SZUlx+4mIH1XqyrUmAG8JrvHAgQVDo=;
	b=BxhFQsAzEGagZaRo9aY6NlgHvELUoOgUJgoBtixm0DAwIG6rCvFgYjz5RTzGWsBynbETAZ
	eslo8Su6roJsJkSoa8Edc536m8xAsQDZ/A1MlPVQqUt7P4GV6LFlBC8hsqFOGu36qUHNPY
	3TQ7BYKPLAP8Ypv6IJwOJhnVq1wvaTc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1712588442;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rnn5Xv0fSIvD/SZUlx+4mIH1XqyrUmAG8JrvHAgQVDo=;
	b=zMqWiSvemJTA31qb9N64IhWUKjEGLfFv6fXfDNiGLj+BfiCjlDUUDYxjLjMwVCPjlrLrTG
	E4GCg7ue/yukSXBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BxhFQsAz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zMqWiSve
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1712588442; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rnn5Xv0fSIvD/SZUlx+4mIH1XqyrUmAG8JrvHAgQVDo=;
	b=BxhFQsAzEGagZaRo9aY6NlgHvELUoOgUJgoBtixm0DAwIG6rCvFgYjz5RTzGWsBynbETAZ
	eslo8Su6roJsJkSoa8Edc536m8xAsQDZ/A1MlPVQqUt7P4GV6LFlBC8hsqFOGu36qUHNPY
	3TQ7BYKPLAP8Ypv6IJwOJhnVq1wvaTc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1712588442;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rnn5Xv0fSIvD/SZUlx+4mIH1XqyrUmAG8JrvHAgQVDo=;
	b=zMqWiSvemJTA31qb9N64IhWUKjEGLfFv6fXfDNiGLj+BfiCjlDUUDYxjLjMwVCPjlrLrTG
	E4GCg7ue/yukSXBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DB50813675;
	Mon,  8 Apr 2024 15:00:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fEU5NZkGFGYUUQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 08 Apr 2024 15:00:41 +0000
Message-ID: <004e5635-56b3-4b63-8448-06c1c1931a54@suse.cz>
Date: Mon, 8 Apr 2024 17:00:41 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 193/273] stackdepot: rename pool_index to
 pool_index_plus_1
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Peter Collingbourne <pcc@google.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Oscar Salvador <osalvador@suse.de>, Andrey Konovalov <andreyknvl@gmail.com>,
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@fb.com>,
 Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <sashal@kernel.org>
References: <20240408125309.280181634@linuxfoundation.org>
 <20240408125315.310219564@linuxfoundation.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSBWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBzdXNlLmN6PsLBlAQTAQoAPgIbAwULCQgHAwUVCgkICwUWAgMBAAIe
 AQIXgBYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJkBREIBQkRadznAAoJECJPp+fMgqZkNxIQ
 ALZRqwdUGzqL2aeSavbum/VF/+td+nZfuH0xeWiO2w8mG0+nPd5j9ujYeHcUP1edE7uQrjOC
 Gs9sm8+W1xYnbClMJTsXiAV88D2btFUdU1mCXURAL9wWZ8Jsmz5ZH2V6AUszvNezsS/VIT87
 AmTtj31TLDGwdxaZTSYLwAOOOtyqafOEq+gJB30RxTRE3h3G1zpO7OM9K6ysLdAlwAGYWgJJ
 V4JqGsQ/lyEtxxFpUCjb5Pztp7cQxhlkil0oBYHkudiG8j1U3DG8iC6rnB4yJaLphKx57NuQ
 PIY0Bccg+r9gIQ4XeSK2PQhdXdy3UWBr913ZQ9AI2usid3s5vabo4iBvpJNFLgUmxFnr73SJ
 KsRh/2OBsg1XXF/wRQGBO9vRuJUAbnaIVcmGOUogdBVS9Sun/Sy4GNA++KtFZK95U7J417/J
 Hub2xV6Ehc7UGW6fIvIQmzJ3zaTEfuriU1P8ayfddrAgZb25JnOW7L1zdYL8rXiezOyYZ8Fm
 ZyXjzWdO0RpxcUEp6GsJr11Bc4F3aae9OZtwtLL/jxc7y6pUugB00PodgnQ6CMcfR/HjXlae
 h2VS3zl9+tQWHu6s1R58t5BuMS2FNA58wU/IazImc/ZQA+slDBfhRDGYlExjg19UXWe/gMcl
 De3P1kxYPgZdGE2eZpRLIbt+rYnqQKy8UxlszsBNBFsZNTUBCACfQfpSsWJZyi+SHoRdVyX5
 J6rI7okc4+b571a7RXD5UhS9dlVRVVAtrU9ANSLqPTQKGVxHrqD39XSw8hxK61pw8p90pg4G
 /N3iuWEvyt+t0SxDDkClnGsDyRhlUyEWYFEoBrrCizbmahOUwqkJbNMfzj5Y7n7OIJOxNRkB
 IBOjPdF26dMP69BwePQao1M8Acrrex9sAHYjQGyVmReRjVEtv9iG4DoTsnIR3amKVk6si4Ea
 X/mrapJqSCcBUVYUFH8M7bsm4CSxier5ofy8jTEa/CfvkqpKThTMCQPNZKY7hke5qEq1CBk2
 wxhX48ZrJEFf1v3NuV3OimgsF2odzieNABEBAAHCwXwEGAEKACYCGwwWIQSpQNQ0mSwujpkQ
 PVAiT6fnzIKmZAUCZAUSmwUJDK5EZgAKCRAiT6fnzIKmZOJGEACOKABgo9wJXsbWhGWYO7mD
 8R8mUyJHqbvaz+yTLnvRwfe/VwafFfDMx5GYVYzMY9TWpA8psFTKTUIIQmx2scYsRBUwm5VI
 EurRWKqENcDRjyo+ol59j0FViYysjQQeobXBDDE31t5SBg++veI6tXfpco/UiKEsDswL1WAr
 tEAZaruo7254TyH+gydURl2wJuzo/aZ7Y7PpqaODbYv727Dvm5eX64HCyyAH0s6sOCyGF5/p
 eIhrOn24oBf67KtdAN3H9JoFNUVTYJc1VJU3R1JtVdgwEdr+NEciEfYl0O19VpLE/PZxP4wX
 PWnhf5WjdoNI1Xec+RcJ5p/pSel0jnvBX8L2cmniYnmI883NhtGZsEWj++wyKiS4NranDFlA
 HdDM3b4lUth1pTtABKQ1YuTvehj7EfoWD3bv9kuGZGPrAeFNiHPdOT7DaXKeHpW9homgtBxj
 8aX/UkSvEGJKUEbFL9cVa5tzyialGkSiZJNkWgeHe+jEcfRT6pJZOJidSCdzvJpbdJmm+eED
 w9XOLH1IIWh7RURU7G1iOfEfmImFeC3cbbS73LQEFGe1urxvIH5K/7vX+FkNcr9ujwWuPE9b
 1C2o4i/yZPLXIVy387EjA6GZMqvQUFuSTs/GeBcv0NjIQi8867H3uLjz+mQy63fAitsDwLmR
 EP+ylKVEKb0Q2A==
In-Reply-To: <20240408125315.310219564@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -4.50
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 02531229FD
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[12];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[lists.linux.dev,google.com,suse.de,gmail.com,suse.com,fb.com,linux-foundation.org,kernel.org];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]

On 4/8/24 2:57 PM, Greg Kroah-Hartman wrote:
> 6.8-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Peter Collingbourne <pcc@google.com>
> 
> [ Upstream commit a6c1d9cb9a68bfa4512248419c4f4d880d19fe90 ]
> 
> Commit 3ee34eabac2a ("lib/stackdepot: fix first entry having a 0-handle")
> changed the meaning of the pool_index field to mean "the pool index plus
> 1".  This made the code accessing this field less self-documenting, as
> well as causing debuggers such as drgn to not be able to easily remain
> compatible with both old and new kernels, because they typically do that
> by testing for presence of the new field.  Because stackdepot is a
> debugging tool, we should make sure that it is debugger friendly.
> Therefore, give the field a different name to improve readability as well
> as enabling debugger backwards compatibility.
> 
> This is needed in 6.9, which would otherwise become an odd release with
> the new semantics and old name so debuggers wouldn't recognize the new
> semantics there.

This got me curious so I did check what's going on, so mentioning the result
here others don't need to repeat that.

> Fixes: 3ee34eabac2a ("lib/stackdepot: fix first entry having a 0-handle")

It's because this was backported to 6.8.2 despite:

>     This bug has been lurking since the very beginning of stackdepot, but no
>     one really cared as it seems.  Because of that I am not adding a Fixes
>     tag.

Then indeed this commit would be needed too in 6.8.y in order to not confuse
drgn and co.

I forgot that the stable MM extemption is based on source code paths, not
commits going through the mm tree, so it didn't cover stackdepot itself.

> Link: https://lkml.kernel.org/r/20240402001500.53533-1-pcc@google.com
> Link: https://linux-review.googlesource.com/id/Ib3e70c36c1d230dd0a118dc22649b33e768b9f88
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Alexander Potapenko <glider@google.com>
> Acked-by: Marco Elver <elver@google.com>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Omar Sandoval <osandov@fb.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/linux/stackdepot.h | 7 +++----
>  lib/stackdepot.c           | 4 ++--
>  2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/stackdepot.h b/include/linux/stackdepot.h
> index c4b5ad57c0660..bf0136891a0f2 100644
> --- a/include/linux/stackdepot.h
> +++ b/include/linux/stackdepot.h
> @@ -44,10 +44,9 @@ typedef u32 depot_stack_handle_t;
>  union handle_parts {
>  	depot_stack_handle_t handle;
>  	struct {
> -		/* pool_index is offset by 1 */
> -		u32 pool_index	: DEPOT_POOL_INDEX_BITS;
> -		u32 offset	: DEPOT_OFFSET_BITS;
> -		u32 extra	: STACK_DEPOT_EXTRA_BITS;
> +		u32 pool_index_plus_1	: DEPOT_POOL_INDEX_BITS;
> +		u32 offset		: DEPOT_OFFSET_BITS;
> +		u32 extra		: STACK_DEPOT_EXTRA_BITS;
>  	};
>  };
>  
> diff --git a/lib/stackdepot.c b/lib/stackdepot.c
> index ee4bbe6513aa4..ee830f14afb78 100644
> --- a/lib/stackdepot.c
> +++ b/lib/stackdepot.c
> @@ -330,7 +330,7 @@ static struct stack_record *depot_pop_free_pool(void **prealloc, size_t size)
>  	stack = current_pool + pool_offset;
>  
>  	/* Pre-initialize handle once. */
> -	stack->handle.pool_index = pool_index + 1;
> +	stack->handle.pool_index_plus_1 = pool_index + 1;
>  	stack->handle.offset = pool_offset >> DEPOT_STACK_ALIGN;
>  	stack->handle.extra = 0;
>  	INIT_LIST_HEAD(&stack->hash_list);
> @@ -441,7 +441,7 @@ static struct stack_record *depot_fetch_stack(depot_stack_handle_t handle)
>  	const int pools_num_cached = READ_ONCE(pools_num);
>  	union handle_parts parts = { .handle = handle };
>  	void *pool;
> -	u32 pool_index = parts.pool_index - 1;
> +	u32 pool_index = parts.pool_index_plus_1 - 1;
>  	size_t offset = parts.offset << DEPOT_STACK_ALIGN;
>  	struct stack_record *stack;
>  

