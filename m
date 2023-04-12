Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892BE362
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 04:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jaf8TVcaCoY+gXRI/VJ8dcjLvYvyn0Wf6eDT01i5qTU=; b=gV/Q8PhBJfKEwrm7QUc3Nj/RkV
	SdSL5cwKeC0Plg0b6mwejcTDoMjZarfDiNAgQplXpqYWFesGNsx9Ly1iS6lsQsOGJ+pmFjNCyYBZf
	iTxAWnMJJISxhizo+817ILIZ4QnD9GsCTv7+ptWdl3GhN2mkaCUshKhLgpYXIWL6hRXulCkBhdaqR
	xAasSAx0b9s9kawlt7zz92GU+EBueFmLjNPSh92Ny2DYBUxQ8C626EYy8rD6dI2n+LAlqcCd2bwnj
	qtaTHNNsdcvpr+FmnPzCRFCLdstHHWMLyCna3D7TkKLo6UwdqvD2aTrs6jMv7YKU2iQnB2ZHFHxEy
	KNQzlAXw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pmRjM-001jmc-1R;
	Wed, 12 Apr 2023 04:05:12 +0000
Date: Tue, 11 Apr 2023 21:05:12 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: david@redhat.com, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com,
	prarit@redhat.com, torvalds@linux-foundation.org,
	gregkh@linuxfoundation.org, rafael@kernel.org,
	christophe.leroy@csgroup.eu, tglx@linutronix.de,
	peterz@infradead.org, song@kernel.org, rppt@kernel.org,
	dave@stgolabs.net, vbabka@suse.cz, mhocko@suse.com,
	dave.hansen@linux.intel.com, colin.i.king@gmail.com,
	jim.cromie@gmail.com, catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com
Subject: Re: [PATCH v2 1/2] Change DEFINE_SEMAPHORE() to take a number
 argument
Message-ID: <ZDYt+PwRjr+BzeBz@bombadil.infradead.org>
References: <20230405203505.1343562-1-mcgrof@kernel.org>
 <20230405203505.1343562-2-mcgrof@kernel.org>
 <ZDB+zn3X4sac9DFU@casper.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDB+zn3X4sac9DFU@casper.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, Apr 07, 2023 at 09:36:30PM +0100, Matthew Wilcox wrote:
> Or this:
> 
> /*
>  * Unlike mutexes, binary semaphores do not have an owner, so up() can
>  * be called in a different thread from the one which called down().
>  * It is also safe to call down_trylock() and up() from interrupt
>  * context.
>  */

I went with that. Thanks for helping me paint this shed!

  Luis
