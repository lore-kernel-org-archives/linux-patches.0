Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C099E23A6
	for <patches@lists.linux.dev>; Fri, 25 Nov 2022 07:55:58 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B381E21A59;
	Fri, 25 Nov 2022 07:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1669362956; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NWHka+bF7lvTsWy8NI8njBiXWBMpqAxPsNHk6MbD580=;
	b=sL5gO+QSy0VXv4iepJpCQn/d10xZcwLL+RxxMOoSVk6bzSzWOlUAUcsYIfiIEa16UhqPJ3
	pzijSpAqUE9xiCHVamfpdwDo2g4QtXXpWfmcsTU9L4iH33bCOOgOAtFYByMEH84QLiKZCf
	ZH7SSjvfSGEsYUt92hy1glkD/rlW8uM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1669362956;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NWHka+bF7lvTsWy8NI8njBiXWBMpqAxPsNHk6MbD580=;
	b=GAKnOiBNYiji1m/zJf+MPoFuzBEmKb9CYy4TJXUEic8JZ0M5CNWplL82/CQP1974dHz7bR
	+kwNAbcHRjeFR1CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 84EC713A08;
	Fri, 25 Nov 2022 07:55:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id SjG3Hwx1gGNeGAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Fri, 25 Nov 2022 07:55:56 +0000
Message-ID: <d70314d3-a274-8b64-3eb3-b8ac08e074da@suse.cz>
Date: Fri, 25 Nov 2022 08:55:56 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 02/12] mm, slub: add CONFIG_SLUB_TINY
Content-Language: en-US
To: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, patches@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20221121171202.22080-1-vbabka@suse.cz>
 <20221121171202.22080-3-vbabka@suse.cz> <Y39WeEpboF4u7pP6@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <Y39WeEpboF4u7pP6@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/24/22 12:33, Hyeonggon Yoo wrote:
> Acked-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

Thanks.

> small comment:
> SLAB || (SLUB && !SLUB_TINY) would be easier to interpret than
> SLAB || SLUB && !SLUB_TINY

OK, will do.

