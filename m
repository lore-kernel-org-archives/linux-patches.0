Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533BE2568
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:39 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C55891F390
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1645438837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:resent-to:
	 resent-from:resent-message-id:in-reply-to:in-reply-to:  references:references;
	bh=nZ+LogaVosFs70NdM+UF18N211fjcmXD8jaL8iHrlFQ=;
	b=EWA/DLlDrZFn7/kFUjRSWcRpfuCyG500sgFsyzU6Iru/a28EaLudtQR4MisYkGUzmx49Pt
	ut+UH48BBPn9pmtIwg9GerVJ/5QRzn0AGlfwEsvQhwU8hHjB5Vzusia1GveJqfgGGjezit
	JFcyfnVNIlVU1z+vtTzjQ5cmlpHodCI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1645438837;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:resent-to:
	 resent-from:resent-message-id:in-reply-to:in-reply-to:  references:references;
	bh=nZ+LogaVosFs70NdM+UF18N211fjcmXD8jaL8iHrlFQ=;
	b=9Kv184efPjmACly3cEpV9a4Afi4qaiPlnmEPtBPfO70NE/StOPY0gtbb8czsHf93QSKFzG
	frFLsJwCMsdd/6AQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B8C6813A8D
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id mbVkLHVnE2ICIQAAMHmgww
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:37 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: patches@lists.linux.dev
Resent-Date: Mon, 21 Feb 2022 11:20:37 +0100
Resent-Message-ID: <08eb7fe8-b467-bb2c-bea7-6958305d9d5f@suse.cz>
Message-ID: <00ca9ac6-0fd5-7cd1-7511-406eda292af3@suse.cz>
Date: Mon, 21 Feb 2022 10:19:16 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Content-Language: en-US
To: Vasily Averin <vvs@virtuozzo.com>, Roman Gushchin <guro@fb.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeelb@google.com>, Matthew Wilcox <willy@infradead.org>,
 Linux MM <linux-mm@kvack.org>
References: <Ygw3au+tPdg2MXYT@carbon.dhcp.thefacebook.com>
 <35486a00-791c-3b1b-14e0-476e6242709b@virtuozzo.com>
 <Yg1kFH3umdrvOhu1@carbon.dhcp.thefacebook.com>
 <Yg1ooYmX54j8l+Fz@casper.infradead.org>
 <Yg1wKkIJxIdN43qU@carbon.dhcp.thefacebook.com>
 <Yg1y0ax5bnjGLAqz@casper.infradead.org>
 <Yg16ClVQj8SLSlqV@carbon.DHCP.thefacebook.com>
 <Yg2EwqE07d97gmms@casper.infradead.org>
 <CALvZod5nqqt_9Xn0Yq4wiue_QePY5wz6BX6Vk2dH3P9qc92yPw@mail.gmail.com>
 <Yg2TQbpWen2SUP+l@casper.infradead.org>
 <Yg2cKKnIboNu7j+p@carbon.DHCP.thefacebook.com>
 <11060a75-98c2-f547-68eb-fcab404a2539@virtuozzo.com>
From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: tools/cgroup/memcg_slabinfo.py is broken
In-Reply-To: <11060a75-98c2-f547-68eb-fcab404a2539@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2/21/22 06:17, Vasily Averin wrote:
> On 17.02.2022 03:51, Roman Gushchin wrote:
>> On Thu, Feb 17, 2022 at 12:13:53AM +0000, Matthew Wilcox wrote:
>>> On Wed, Feb 16, 2022 at 03:57:39PM -0800, Shakeel Butt wrote:
>>>> On Wed, Feb 16, 2022 at 3:12 PM Matthew Wilcox <willy@infradead.org> wrote:
>>>>>
>>>> [...]
>>>>>> Here I'd keep _page (or _folio, if you want), because
>>>>>> it makes it clear that the function goes over all pages
>>>>>> (and is expensive therefore).
>>>>>
>>>>> But there's no intrinsic reason that it should.  If that's a
>>>>> performance problem, you could keep slabs on a separate list
>>>>> from, eg, file or anon memory.
>>>>>
>>>>
>>>> Is there enough space in the struct slab for that list or do you mean
>>>> something different?
>>>
>>> Well, I don't know what data structure your for_each_page() uses, so
>>> I don't know what to suggest exactly.
>>>
>>> If it's an iteration over the entirety of memmap, then maybe you'd
>>> rather iterate over each kmem_cache like /proc/slabinfo does?
>>
>> Anyway, here is v2. I hope you're fine with it.
> 
> It works well on my test node,
> Tested-by: Vasily Averin <vvs@virtuozzo.com>

Thanks all for fixing and testing!

> Andrew,
> this script was created in August 2020, broken in few months, repaired in
> April 2021,
> then broken again in October 2021 and I hope will be repaired soon.

Since it was me who broke it now in 5.17-rc1 and it's slab related, I'd take
the fix to slab tree and send to Linus so it's in 5.17 final.

> I think it would be useful to add smoke test with this script into checks
> of some build robots.
> 
> Could you please advise how to do it?

I guess ask the lkp maintainers?

BTW I'm a bit skeptical in general about maintaining drgn (or gdb) based
python scriplets within the kernel tree, that are supposed to work only with
that specific version. The model of the 'crash' tool which supports a range
of kernels seems more practical and sustainable to me.
