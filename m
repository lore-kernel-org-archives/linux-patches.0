Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799B7A93B
	for <patches@lists.linux.dev>; Fri, 26 May 2023 08:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=duGFbAowC1KQY1XQWxM1uOSTtieb578ebsbd050lnjE=; b=YpL8THZ7nxBj5uTx98hHNP6+70
	53TZnyxhUD2rqC2WkJvLZSaKJkoo1yR57I+0vBHWc6nP1YUSKEV5aEDi1mgkqwDDOJH0GZrX1HIGu
	ZlGHqDMkJwmE9Y2GvO0EMobdC6Uz/BwG9OrIABIq2gI4PSvCWqG9fghHW2C/7r/xQzmuHpobt5o2R
	Hlq0nusfc4qP2phCYboNJltgkEtaUSM1YRK0n1H21JjIR3KIEkBvU8T7w4ISsK1mLDa1tIbaF6HYN
	g/cbsthoLnMpaXTP+IjjaHW7eKiMR78YNlMeP2ulETt/PI2Ab5a1zQ8RXuZWVfYyH5OKMuO3WxCKy
	t5p0bjDQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q2SeR-001ZwW-2d;
	Fri, 26 May 2023 08:18:19 +0000
Date: Fri, 26 May 2023 01:18:19 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hughd@google.com, akpm@linux-foundation.org, willy@infradead.org,
	brauner@kernel.org, djwong@kernel.org, p.raghav@samsung.com,
	da.gomez@samsung.com, rohan.puri@samsung.com, rpuri.linux@gmail.com,
	a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
	keescook@chromium.org, hare@suse.de, kbusch@kernel.org,
	patches@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 0/8] add support for blocksize > PAGE_SIZE
Message-ID: <ZHBrS4hTZZn3w4tF@bombadil.infradead.org>
References: <20230526075552.363524-1-mcgrof@kernel.org>
 <ZHBqfyPUR4B2GNsF@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHBqfyPUR4B2GNsF@infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, May 26, 2023 at 01:14:55AM -0700, Christoph Hellwig wrote:
> On Fri, May 26, 2023 at 12:55:44AM -0700, Luis Chamberlain wrote:
> > This is an initial attempt to add support for block size > PAGE_SIZE for tmpfs.
> 
> The concept of a block size doesn't make any sense for tmpfs.   What
> are you actually trying to do here?

More of helping to test high order folios for tmpfs. Swap for instance
would be one thing we could use to test.

  Luis
