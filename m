Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AF613F429
	for <patches@lists.linux.dev>; Mon,  8 Apr 2024 15:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712588774; cv=none; b=fksdFt0W5qmEcJjmgmCGVjcKkeLTfLB9KIBC0UXkErmA5W8b9C3anRywwZB0JF0I3829nlF+OuC3jvz1jSG2Q0RydqbSBPZxW6QYcbOZpfWpetL3UFEKwTdI8PFbe/P22QG2vwU/PAnDto3ouIhTQliKIsEoCfvu6I4UMU2u9pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712588774; c=relaxed/simple;
	bh=AxaM9IJ1eMZF4kV59aPj1IUSPvYMrFTnkgjHKR39lsI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=a7HIO0rJgq5iJHOjnEb7+ZHPNASkrGSS29y96z6G9TQ/OXOog+9ZmX5rADGxTnosJ3ZMnprz1qOxLjE8808h9w4T8N5HTS+pm+RGnLldipkWXyrr+TYUz2TrRn3KtVizBZRdym7TGbp7UGqz5xjWfr90Wqotmr4SSWrYgAk1d/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=GQiP1/Nk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=IsM49bkA; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=GQiP1/Nk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=IsM49bkA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="GQiP1/Nk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="IsM49bkA";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="GQiP1/Nk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="IsM49bkA"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 47F53203FC;
	Mon,  8 Apr 2024 15:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1712588770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Smr26jQ6Gn56haVnRyrE/fgwnLHukFW1xllONowVvG0=;
	b=GQiP1/NkPg60s3fIzPaM1OAduUwAZ4sldJEpwOsIJvN5cmSw5gSDPcT+c5eOj3ARMfVQIW
	EybrOtQQ2mnp2JZH/Gqlvf27ZIocyl6WIT52ZpdzV5QTyHhN7abKK/yPqFIxd8QozKQH2S
	W0CYuK4xWU8CgBIpt/z+CavXOE4STYs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1712588770;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Smr26jQ6Gn56haVnRyrE/fgwnLHukFW1xllONowVvG0=;
	b=IsM49bkA35Y7+3/pbIZym4Q4RLuZjwKTrqjDBA8bGAfMLuxBVCAxQGNXgmTjcWuAsv7Ep0
	6OlOkLl07VM4EOCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="GQiP1/Nk";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IsM49bkA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1712588770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Smr26jQ6Gn56haVnRyrE/fgwnLHukFW1xllONowVvG0=;
	b=GQiP1/NkPg60s3fIzPaM1OAduUwAZ4sldJEpwOsIJvN5cmSw5gSDPcT+c5eOj3ARMfVQIW
	EybrOtQQ2mnp2JZH/Gqlvf27ZIocyl6WIT52ZpdzV5QTyHhN7abKK/yPqFIxd8QozKQH2S
	W0CYuK4xWU8CgBIpt/z+CavXOE4STYs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1712588770;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Smr26jQ6Gn56haVnRyrE/fgwnLHukFW1xllONowVvG0=;
	b=IsM49bkA35Y7+3/pbIZym4Q4RLuZjwKTrqjDBA8bGAfMLuxBVCAxQGNXgmTjcWuAsv7Ep0
	6OlOkLl07VM4EOCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B88C13675;
	Mon,  8 Apr 2024 15:06:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ro7vCeIHFGZrUgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 08 Apr 2024 15:06:10 +0000
Message-ID: <df52ca4c-2c7a-44b1-a973-4ef11c63c7a7@suse.cz>
Date: Mon, 8 Apr 2024 17:06:09 +0200
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
From: Vlastimil Babka <vbabka@suse.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Peter Collingbourne <pcc@google.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Oscar Salvador <osalvador@suse.de>, Andrey Konovalov <andreyknvl@gmail.com>,
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@fb.com>,
 Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <sashal@kernel.org>
References: <20240408125309.280181634@linuxfoundation.org>
 <20240408125315.310219564@linuxfoundation.org>
 <004e5635-56b3-4b63-8448-06c1c1931a54@suse.cz>
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
In-Reply-To: <004e5635-56b3-4b63-8448-06c1c1931a54@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -4.50
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 47F53203FC
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]

On 4/8/24 5:00 PM, Vlastimil Babka wrote:
> On 4/8/24 2:57 PM, Greg Kroah-Hartman wrote:
>> 6.8-stable review patch.  If anyone has any objections, please let me know.
>> 
>> ------------------
>> 
>> From: Peter Collingbourne <pcc@google.com>
>> 
>> [ Upstream commit a6c1d9cb9a68bfa4512248419c4f4d880d19fe90 ]
>> 
>> Commit 3ee34eabac2a ("lib/stackdepot: fix first entry having a 0-handle")
>> changed the meaning of the pool_index field to mean "the pool index plus
>> 1".  This made the code accessing this field less self-documenting, as
>> well as causing debuggers such as drgn to not be able to easily remain
>> compatible with both old and new kernels, because they typically do that
>> by testing for presence of the new field.  Because stackdepot is a
>> debugging tool, we should make sure that it is debugger friendly.
>> Therefore, give the field a different name to improve readability as well
>> as enabling debugger backwards compatibility.
>> 
>> This is needed in 6.9, which would otherwise become an odd release with
>> the new semantics and old name so debuggers wouldn't recognize the new
>> semantics there.
> 
> This got me curious so I did check what's going on, so mentioning the result
> here others don't need to repeat that.
> 
>> Fixes: 3ee34eabac2a ("lib/stackdepot: fix first entry having a 0-handle")
> 
> It's because this was backported to 6.8.2 despite:
> 
>>     This bug has been lurking since the very beginning of stackdepot, but no
>>     one really cared as it seems.  Because of that I am not adding a Fixes
>>     tag.

Nevermind, it was backported as

Stable-dep-of: dc24559472a6 ("lib/stackdepot: off by one in
depot_fetch_stack()")

https://lore.kernel.org/all/20240324223455.1342824-513-sashal@kernel.org/

