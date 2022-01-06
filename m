Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB08168
	for <patches@lists.linux.dev>; Thu,  6 Jan 2022 17:26:08 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D33EE1F385;
	Thu,  6 Jan 2022 17:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641489966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uVaSzjfZpGkaAuEVEGES2CPozXp4YrFzHRLqYAww+cc=;
	b=LQfncRqUZRR4Xwo70xszyNk3wFg7OU/+dPATxQI+mczxd8AXyqAFbV7q0Np2ZqktrXK78/
	ImKEgvUANvS7V3l+fTBYcv30o18a5XXUtlJdLZHVWZVTsvMdCNkDHpD1kNSoFRJ/u+HX74
	Ah6RoS2RHezJwYksNgsP1X5E6N5D7zw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641489966;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uVaSzjfZpGkaAuEVEGES2CPozXp4YrFzHRLqYAww+cc=;
	b=/ln33fgAMgSrJrXtAAEqLC1FJ4PYIJOCqFTGgXjYk2GPPQOuCbEc+vzGkIO3fzSIcici09
	wSslaw8yzWM6EdBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A585513C61;
	Thu,  6 Jan 2022 17:26:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id oYGvJy4m12GAJQAAMHmgww
	(envelope-from <vbabka@suse.cz>); Thu, 06 Jan 2022 17:26:06 +0000
Message-ID: <48ab4217-a0c4-19ba-2335-1154086a562d@suse.cz>
Date: Thu, 6 Jan 2022 18:26:06 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v4 07/32] mm: Convert __ksize() to struct slab
Content-Language: en-US
To: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>,
 patches@lists.linux.dev
References: <20220104001046.12263-1-vbabka@suse.cz>
 <20220104001046.12263-8-vbabka@suse.cz>
 <YdbxuCMUz9l1TW8e@ip-172-31-30-232.ap-northeast-1.compute.internal>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <YdbxuCMUz9l1TW8e@ip-172-31-30-232.ap-northeast-1.compute.internal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/6/22 14:42, Hyeonggon Yoo wrote:
> On Tue, Jan 04, 2022 at 01:10:21AM +0100, Vlastimil Babka wrote:
> 
> This patch Looks good.
> Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

Thanks!

> BTW, I see no reason to implement SLAB version of __ksize separately.
> And there are no modules that use __ksize. EXPORT_SYMBOL is unnecessary.

OK, I'll look at a cleanup later. Or you can try?

> BTW, Until when can I review your patches? until next week before starting
> window?

I will send it tomorrow already, so records of any further review will be
archived in the mailing list only, but not git. Thanks again!

> Thanks!
> 
>> -- 
>> 2.34.1
>> 

