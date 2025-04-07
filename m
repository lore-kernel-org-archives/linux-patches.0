Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3312222D1
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 20:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744056846; cv=none; b=FzHVnvUlrdWSRd47uklAxpHWseHkLWNpLOhBjG07hzwiouA7whyiVaTgzBlP8OUrfPt90WmAU15kGc/oPVcibrKuJNovMFbMOWNxVEFiWrRCbYD/7k5ik5c4g48GSsuBMcg0Jg1dNC3OVd0X/hNBU1eX/lmczxR5mbfPzAdNcWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744056846; c=relaxed/simple;
	bh=m2r4l3UGzxwc1/hUk7+vO4U3JDWDIQ3dvvFsqPHtTBQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lO0lfKBGjwBsagFfPvTM6qSqg5EbZoGmCgeDB4BuX4Tv20sBi89a+AkahbdbVae34zIolnKtID7OReL2b995BM3y/0gpAxWGbBypwen1GDAJfIH4JzwDuWgLxS8OxtT+KX85sZf7YIKuucZoqSXywKoxCBrI6JGBmmZl8lzmXG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UkfsFdNv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=li9kf7/6; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UkfsFdNv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=li9kf7/6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UkfsFdNv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="li9kf7/6";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UkfsFdNv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="li9kf7/6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 165871F388;
	Mon,  7 Apr 2025 20:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1744056843; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wl7zU7FUr+GdZUdm7QvfE7yoCiEaOjw64gYZQZ0dkMk=;
	b=UkfsFdNv6NGHjDuJhfhNZsh6CQKPN+sT0FHNmOYad0yPajxjxOk2Z80TvGKshOH1b2RgF1
	3sIzIYIgUfPgF52GF9wr3Xkf6q5Ox04LkUh0JqheWxDEiOvPh4dOpwqh7ZEbUvA5TBL3u6
	y1rPURHfj4F77jkdiboeZAo+ZN6xDZ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1744056843;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wl7zU7FUr+GdZUdm7QvfE7yoCiEaOjw64gYZQZ0dkMk=;
	b=li9kf7/6GPwwgB3Wheb0q1rgaX8nTdMtSwJ/v5OJM4pLgpoOFUt79OByuL1VxoDRFWV/HJ
	cZR+9wxySm+aFKAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UkfsFdNv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="li9kf7/6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1744056843; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wl7zU7FUr+GdZUdm7QvfE7yoCiEaOjw64gYZQZ0dkMk=;
	b=UkfsFdNv6NGHjDuJhfhNZsh6CQKPN+sT0FHNmOYad0yPajxjxOk2Z80TvGKshOH1b2RgF1
	3sIzIYIgUfPgF52GF9wr3Xkf6q5Ox04LkUh0JqheWxDEiOvPh4dOpwqh7ZEbUvA5TBL3u6
	y1rPURHfj4F77jkdiboeZAo+ZN6xDZ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1744056843;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wl7zU7FUr+GdZUdm7QvfE7yoCiEaOjw64gYZQZ0dkMk=;
	b=li9kf7/6GPwwgB3Wheb0q1rgaX8nTdMtSwJ/v5OJM4pLgpoOFUt79OByuL1VxoDRFWV/HJ
	cZR+9wxySm+aFKAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E89D313691;
	Mon,  7 Apr 2025 20:14:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id siEhOAoy9Gd6DwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 07 Apr 2025 20:14:02 +0000
Message-ID: <d6b4a68d-b2bc-4f85-8e53-e3460a37974c@suse.cz>
Date: Mon, 7 Apr 2025 22:14:02 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] MAINTAINERS: add MM subsection for the page
 allocator
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 David Hildenbrand <david@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Mel Gorman <mgorman@techsingularity.net>,
 Suren Baghdasaryan <surenb@google.com>, Brendan Jackman
 <jackmanb@google.com>, Michal Hocko <mhocko@kernel.org>
References: <20250407200508.121357-3-vbabka@suse.cz>
 <20250407200508.121357-4-vbabka@suse.cz>
 <E7917C18-F3FC-41DC-AABD-1C0DF2367EAB@nvidia.com>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <E7917C18-F3FC-41DC-AABD-1C0DF2367EAB@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 165871F388
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,cmpxchg.org:email,nvidia.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On 4/7/25 22:12, Zi Yan wrote:
> On 7 Apr 2025, at 16:05, Vlastimil Babka wrote:
> 
>> Add a subsection for the page allocator, including compaction as it's
>> crucial for high-order allocations and works together with the
>> anti-fragmentation features. Volunteer myself as a reviewer.
>>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>> Cc: Mel Gorman <mgorman@techsingularity.net>
>> Cc: Suren Baghdasaryan <surenb@google.com>
>> Cc: Brendan Jackman <jackmanb@google.com>
>> Cc: Michal Hocko <mhocko@kernel.org>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>> Extra reviewers would be welcome, including/not limited the people I
>> Cc'd based on my recollection and get_maintainers --git
>> Also if I missed any related file please lmk. Thanks.
>>
>>  MAINTAINERS | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
> 
> Acked-by: Zi Yan <ziy@nvidia.com>

Thanks.

> I am happy to help review patches for page allocator and
> compaction too. Should I send a separate patch to add myself?
> Or you can add
> 
> R:    Zi Yan <ziy@nvidia.com>
> 
> in your next version?

Sure, will do, thanks!

>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 4fe7cf5fc4ea..610636f622b1 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -15511,6 +15511,16 @@ F:	mm/numa.c
>>  F:	mm/numa_emulation.c
>>  F:	mm/numa_memblks.c
>>
>> +MEMORY MANAGEMENT - PAGE ALLOCATOR
>> +M:	Andrew Morton <akpm@linux-foundation.org>
>> +R:	Vlastimil Babka <vbabka@suse.cz>
>> +L:	linux-mm@kvack.org
>> +S:	Maintained
>> +F:	mm/compaction.c
>> +F:	mm/page_alloc.c
>> +F:	include/linux/gfp.h
>> +F:	include/linux/compaction.h
>> +
>>  MEMORY MANAGEMENT - SECRETMEM
>>  M:	Andrew Morton <akpm@linux-foundation.org>
>>  M:	Mike Rapoport <rppt@kernel.org>
>> -- 
>> 2.49.0
> 
> 
> Best Regards,
> Yan, Zi

