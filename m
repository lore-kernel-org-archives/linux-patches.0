Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444D9626
	for <patches@lists.linux.dev>; Thu, 13 Apr 2023 16:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SiAvXIwUCiDRn7X/zVCIOWNEa8hkl/f6/T4KHDaYrfA=; b=AtpOvMGl59YlIWsPr0KJLB/Rs/
	Arvbb+ogkRT7S8QPT5azeBWIJF6S6JAk4Sg6qh7aXkb8D4DncrDNgtMURvYpzWf0yLlbo6TzsLva9
	e9vln472OX3I384SfaVucMChr3bBar26vxbBbN5sDyUVCwA2OkV567jp4LbMXIelFK7c7YJfX9uRd
	MF5dqN82Lp2ZxYnBixPh8GQWEOL3435gzxRrLUQMnwaCkI4udtS6CkEv6FB4ZhdRnsuYH5skULX5y
	zD0METmT3EFAodInUnRrZpl52sYbjXFbyGkXPmhFPR5+IUyS5X9HLLrEDjov6F4p+jXCP1kIT/aYR
	Wn8Ind0g==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pmzxq-006hJo-1o;
	Thu, 13 Apr 2023 16:38:26 +0000
Date: Thu, 13 Apr 2023 09:38:26 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Miroslav Benes <mbenes@suse.cz>
Cc: david@redhat.com, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com,
	prarit@redhat.com, torvalds@linux-foundation.org,
	gregkh@linuxfoundation.org, rafael@kernel.org,
	christophe.leroy@csgroup.eu, tglx@linutronix.de,
	peterz@infradead.org, song@kernel.org, rppt@kernel.org,
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com,
	colin.i.king@gmail.com, jim.cromie@gmail.com,
	catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com
Subject: Re: [PATCH v2 2/2] modules/kmod: replace implementation with a
 sempahore
Message-ID: <ZDgwAiayuj0lCId5@bombadil.infradead.org>
References: <20230405203505.1343562-1-mcgrof@kernel.org>
 <20230405203505.1343562-3-mcgrof@kernel.org>
 <alpine.LSU.2.21.2304131136580.27633@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2304131136580.27633@pobox.suse.cz>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Thu, Apr 13, 2023 at 11:44:51AM +0200, Miroslav Benes wrote:
> Hi,

<spell checks>

Thanks, fixed!

> MAX_KMOD_ALL_BUSY_TIMEOUT * HZ ?

Yes! In the end schedule_timeout() is used so yup, thanks!

  Luis
