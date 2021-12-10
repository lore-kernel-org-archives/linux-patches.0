Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D4429CA
	for <patches@lists.linux.dev>; Fri, 10 Dec 2021 11:44:41 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8EB83210FE;
	Fri, 10 Dec 2021 11:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1639136673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yGb/USmxos5P7pGsvFIo8v6uaNvecP7utpPhIEJdFDw=;
	b=crTA9j9jDfIl++/i637dbWKx7CbVUm/E80dnqWC6c7LzZ29gYSsZ+S1zV+zn36Eke5XE1N
	Lj9+7NXIYWL9CbqPGcYK7Tke1BUm/ZNrcHaONUzc7lQlywzopyxLmydy9nlFOEhDGqdrIa
	MSb9eYF+8sCuUqWDX3tn8Dk/pifccDk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1639136673;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yGb/USmxos5P7pGsvFIo8v6uaNvecP7utpPhIEJdFDw=;
	b=CfjIJ9Y8+ke2a5WVhvlOlXarXggW/meao2llasRqa1/d2Uhvro4dbwN0r03zug4A1QOn5P
	GxmHYsPCdtgXepDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5FB1C13DDE;
	Fri, 10 Dec 2021 11:44:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id VDanFqE9s2HwcwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Fri, 10 Dec 2021 11:44:33 +0000
Message-ID: <254ce648-2b1c-edbd-1e1f-4bfc6bf6a195@suse.cz>
Date: Fri, 10 Dec 2021 12:44:32 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 24/33] mm/slob: Convert SLOB to use struct slab
Content-Language: en-US
To: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-25-vbabka@suse.cz> <20211210104435.GA632117@odroid>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20211210104435.GA632117@odroid>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/10/21 11:44, Hyeonggon Yoo wrote:
> On Wed, Dec 01, 2021 at 07:15:01PM +0100, Vlastimil Babka wrote:
>> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>> 
>> Use struct slab throughout the slob allocator.
>> 
>> [ vbabka@suse.cz: don't introduce wrappers for PageSlobFree in mm/slab.h just
>>   for the single callers being wrappers in mm/slob.c ]
>> 
>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>  mm/slob.c | 34 +++++++++++++++++-----------------
>>  1 file changed, 17 insertions(+), 17 deletions(-)
>> 
>> diff --git a/mm/slob.c b/mm/slob.c
>> index d2d15e7f191c..d3512bcc3141 100644
>> --- a/mm/slob.c
>> +++ b/mm/slob.c
> 
> ...
> 
>>  		/* Enough room on this page? */
>> @@ -358,8 +358,8 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node,
>>  		b = slob_new_pages(gfp & ~__GFP_ZERO, 0, node);
>>  		if (!b)
>>  			return NULL;
>> -		sp = virt_to_page(b);
>> -		__SetPageSlab(sp);
>> +		sp = virt_to_slab(b);
>> +		__SetPageSlab(slab_page(sp));
> 
> Hello Vlastimil.
> 
> I've tested this patch on my machine and it causes NULL pointer dereference.
> that's because virt_to_slab returns NULL if folio_test_slab is false.
> and __SetPageSlab is called with sp = NULL.

Oops, thanks for catching this.

> diff below fixed bug.

Changed it to use folio and will push an updated branch
slab-struct_slab-v3r2

Thanks!

> diff --git a/mm/slob.c b/mm/slob.c
> index d3512bcc3141..cf669f03440f 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c
> @@ -358,8 +358,8 @@ static void *slob_alloc(size_t size, gfp_t gfp, int a
> lign, int node,
>                 b = slob_new_pages(gfp & ~__GFP_ZERO, 0, node);
>                 if (!b)
>                         return NULL;
> +               __SetPageSlab(virt_to_page(b));
>                 sp = virt_to_slab(b);
> -               __SetPageSlab(slab_page(sp));
> 
>                 spin_lock_irqsave(&slob_lock, flags);
>                 sp->units = SLOB_UNITS(PAGE_SIZE);
>  
>  Thanks,
>  Hyeonggon.
> 
>>  
>>  		spin_lock_irqsave(&slob_lock, flags);
>>  		sp->units = SLOB_UNITS(PAGE_SIZE);
>> @@ -381,7 +381,7 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node,
>>   */
>>  static void slob_free(void *block, int size)
>>  {
>> -	struct page *sp;
>> +	struct slab *sp;
>>  	slob_t *prev, *next, *b = (slob_t *)block;
>>  	slobidx_t units;
>>  	unsigned long flags;
>> @@ -391,7 +391,7 @@ static void slob_free(void *block, int size)
>>  		return;
>>  	BUG_ON(!size);
>>  
>> -	sp = virt_to_page(block);
>> +	sp = virt_to_slab(block);
>>  	units = SLOB_UNITS(size);
>>  
>>  	spin_lock_irqsave(&slob_lock, flags);
>> @@ -401,8 +401,8 @@ static void slob_free(void *block, int size)
>>  		if (slob_page_free(sp))
>>  			clear_slob_page_free(sp);
>>  		spin_unlock_irqrestore(&slob_lock, flags);
>> -		__ClearPageSlab(sp);
>> -		page_mapcount_reset(sp);
>> +		__ClearPageSlab(slab_page(sp));
>> +		page_mapcount_reset(slab_page(sp));
>>  		slob_free_pages(b, 0);
>>  		return;
>>  	}
>> -- 
>> 2.33.1
>> 
>> 

