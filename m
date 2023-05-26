Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5338918B0F
	for <patches@lists.linux.dev>; Fri, 26 May 2023 13:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MVg67d6tqd4lwkRaTe+6MM98KoWSEd2dKs7M6jq9Edk=; b=ojX1a7ro2uIIFc9IZPCrb7T1P/
	t98E3papAcFBLMw6gNNkOqjJbTbgzGnPaubXEi20RLHCoNArWLZ6Z01g9JQ+d1E1jT8D5Ty91i+fM
	NkL2Zdb7Ir4BiD4zZlwg3T0Fl2LjFrZz6TkWE0F8EkWR+1sOHib00qqhITphgLPVzDKqn8Q+SNutN
	C1yAvozRrYQNiQLmJ6pt+w0SJgjs0v7bImmpDUSwrqVFNY4aLYr7X7U6my8u8/k731yjsyJ2rf7is
	zTHjmuR0s9CdWwdc70Rl7VBuw3TtNHG/rT6e8LB9xjPBSCjPy0M2RUS2N2wYn4hWGUD4lT8HBUK4y
	BIIEXmmA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1q2XtU-002pxk-64; Fri, 26 May 2023 13:54:12 +0000
Date: Fri, 26 May 2023 14:54:12 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: hughd@google.com, akpm@linux-foundation.org, brauner@kernel.org,
	djwong@kernel.org, p.raghav@samsung.com, da.gomez@samsung.com,
	rohan.puri@samsung.com, rpuri.linux@gmail.com,
	a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
	keescook@chromium.org, hare@suse.de, kbusch@kernel.org,
	patches@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 0/8] add support for blocksize > PAGE_SIZE
Message-ID: <ZHC6BM+ehSC5Atv8@casper.infradead.org>
References: <20230526075552.363524-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526075552.363524-1-mcgrof@kernel.org>

On Fri, May 26, 2023 at 12:55:44AM -0700, Luis Chamberlain wrote:
> This is an initial attempt to add support for block size > PAGE_SIZE for tmpfs.
> Why would you want this? It helps us experiment with higher order folio uses
> with fs APIS and helps us test out corner cases which would likely need
> to be accounted for sooner or later if and when filesystems enable support
> for this. Better review early and burn early than continue on in the wrong
> direction so looking for early feedback.

I think this is entirely the wrong direction to go in.

You're coming at this from a block layer perspective, and we have two
ways of doing large block devices -- qemu nvme and brd.  tmpfs should
be like other filesystems and opportunistically use folios of whatever
size makes sense.

Don't add a mount option to specify what size folios to use.

