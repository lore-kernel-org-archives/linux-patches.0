Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D5D1363
	for <patches@lists.linux.dev>; Mon, 11 Apr 2022 09:00:33 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 00533212C2;
	Mon, 11 Apr 2022 09:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1649667632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UZRZq2BNI+gJGuuNOCZ+0G0H9vZfghchCCmW4z4a7Ak=;
	b=JsUwME53yEsTOnMPLIHnBmBFUoN9ocjrmRSn4koc2p0Zokp5HiLuWozS0pN+WIDi4TrsZS
	8IUMp6WA4HvKLlK04nvym//iRhDcFYSp9QFubSp2uYWP035khl45SahePhDWRfHNLHp4BF
	uKYqZH9D71vSLjWbFYJhEGk3RbKaMqI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1649667632;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UZRZq2BNI+gJGuuNOCZ+0G0H9vZfghchCCmW4z4a7Ak=;
	b=2a1i4DPs81ozF0+NYwPSV5oLxA7sKOILrxHOEEoVuJiAiUz8BWjdclTA7jLkM25UtJvwBs
	6ifHTzUCdMb/lQCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2423213A93;
	Mon, 11 Apr 2022 09:00:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 5AjWBC/uU2KxOwAAMHmgww
	(envelope-from <osalvador@suse.de>); Mon, 11 Apr 2022 09:00:31 +0000
Date: Mon, 11 Apr 2022 11:00:29 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@kernel.org, kirill.shutemov@linux.intel.com, jforbes@redhat.com,
	aquini@redhat.com, longman@redhat.com, patches@lists.linux.dev,
	linux-mm@kvack.org, mm-commits@vger.kernel.org,
	torvalds@linux-foundation.org
Subject: Re: [patch 4/9] mm/sparsemem: fix 'mem_section' will never be NULL
 gcc 12 warning
Message-ID: <YlPuLXI819omL1WR@localhost.localdomain>
References: <20220408130819.a89195e527ce58dfbe0700b9@linux-foundation.org>
 <20220408200902.A24A9C385A1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408200902.A24A9C385A1@smtp.kernel.org>

On Fri, Apr 08, 2022 at 01:09:01PM -0700, Andrew Morton wrote:
> From: Waiman Long <longman@redhat.com>
> Subject: mm/sparsemem: fix 'mem_section' will never be NULL gcc 12 warning
> 
 ...
> Link: https://lkml.kernel.org/r/20220331180246.2746210-1-longman@redhat.com
> Fixes: 3e347261a80b ("sparsemem extreme implementation")
> Signed-off-by: Waiman Long <longman@redhat.com>
> Reported-by: Justin Forbes <jforbes@redhat.com>
> Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Rafael Aquini <aquini@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs
