Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4A529CA
	for <patches@lists.linux.dev>; Tue, 14 Dec 2021 14:28:04 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1A26A212B6;
	Tue, 14 Dec 2021 14:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1639492077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=afwLggD4Snr2QFuVXkU4+5D1cUnL8xMB0CBSJI6vyFM=;
	b=HgK85HiFH90CWfiW0rF577kQP+aA76PfgMIlYz4L/yzYjxPxQYQiolNOuceyvFfitMWekZ
	6IzVd4qVCfbyp+q1kftAZeiD4Z4mzWMxV4uiW2Qd7mizAmS3cSgQosRj2OQem9l4ZwjMPr
	t0tKBmwXDGfkhg5/dHuE9qXQ7Wai2Oc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1639492077;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=afwLggD4Snr2QFuVXkU4+5D1cUnL8xMB0CBSJI6vyFM=;
	b=evpWjB3DVagYW1OumfE/KLs6cHhsi+bLP9Q5Rnho64RjoE/st+Miv4pthNEc9kQg89sDYb
	JBi/g+oPkLd57VDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E84F813EA2;
	Tue, 14 Dec 2021 14:27:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id wy2dN+ypuGGcRwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 14 Dec 2021 14:27:56 +0000
Message-ID: <11e44db8-3d01-743b-7bb2-2ef0317864d8@suse.cz>
Date: Tue, 14 Dec 2021 15:27:56 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 01/33] mm: add virt_to_folio() and folio_address()
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-2-vbabka@suse.cz> <YbioM6V+j5+R2Dah@cmpxchg.org>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <YbioM6V+j5+R2Dah@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/14/21 15:20, Johannes Weiner wrote:
> On Wed, Dec 01, 2021 at 07:14:38PM +0100, Vlastimil Babka wrote:
>> These two wrappers around their respective struct page variants will be useful
>> in the following patches.
>> 
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks!

> Slight reviewer preference: introduce helpers when they're first used,
> as it's a little easier to understand the application without having
> to chase new folio_address() -> new slab_address() -> first user of
> slab_address() through the patchset.

Yeah would normally do that but with the current folio work going on there
was a chance the helpers would be useful to somebody else too and
cherry-picking a patch that adds them without user is simpler. And indeed
Matthew just asked about virt_to_folio() few days ago :)
