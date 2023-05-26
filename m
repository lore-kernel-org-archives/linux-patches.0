Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C6D322B
	for <patches@lists.linux.dev>; Fri, 26 May 2023 08:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LPzCO3xWGBowU0ajceftsmznXkRp49QJy/R8CAeiRrA=; b=KAYxWBGAXtX8I8UbNVp2o6Apkb
	5LAlO3sf49+TG2wkCiVj5kvZS/Jo6XJSWrWQWq2U6gvd4vCiFERk6fznQF57bxEU4dh7ovUdTgaIn
	D1srjQKEhBQBhr4aaWwlO4S89I8dSC/bXwwOOzo6RVAy6kQ6MaXRBF+0p2q0JIdjf+dCkFsKWtzq+
	2jA258+4q9weUDmSKZOD69ywTogpa8dI5bKu90L7i3xE/tsn9nrZchmSMA/ua4a7YAwd6KfLnd/nA
	6vKzRBeKwBw76LtypA6Z/IJS4XGErN3BiUlLB5ibLI9YMSSOSUvdjAu1n1XrWol66ulCihd6slXnL
	q3Ym63jw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q2Snr-001bdJ-1t;
	Fri, 26 May 2023 08:28:03 +0000
Date: Fri, 26 May 2023 01:28:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, hughd@google.com,
	akpm@linux-foundation.org, willy@infradead.org, brauner@kernel.org,
	djwong@kernel.org, p.raghav@samsung.com, da.gomez@samsung.com,
	rohan.puri@samsung.com, rpuri.linux@gmail.com,
	a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
	keescook@chromium.org, hare@suse.de, kbusch@kernel.org,
	patches@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 0/8] add support for blocksize > PAGE_SIZE
Message-ID: <ZHBtk3mmupubbWyc@infradead.org>
References: <20230526075552.363524-1-mcgrof@kernel.org>
 <ZHBqfyPUR4B2GNsF@infradead.org>
 <ZHBrS4hTZZn3w4tF@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHBrS4hTZZn3w4tF@bombadil.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, May 26, 2023 at 01:18:19AM -0700, Luis Chamberlain wrote:
> On Fri, May 26, 2023 at 01:14:55AM -0700, Christoph Hellwig wrote:
> > On Fri, May 26, 2023 at 12:55:44AM -0700, Luis Chamberlain wrote:
> > > This is an initial attempt to add support for block size > PAGE_SIZE for tmpfs.
> > 
> > The concept of a block size doesn't make any sense for tmpfs.   What
> > are you actually trying to do here?
> 
> More of helping to test high order folios for tmpfs. Swap for instance
> would be one thing we could use to test.

I'm still not sure where the concept of a block size would come in here.
