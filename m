Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C038AC943
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 20:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1gVMuS9EKtGcIRrRl/Odp4GU0naBD6jze+OHwpW6A+8=; b=12T/Pu5st14xkjhJxseP7HyJJC
	uAkjyI+P74hc0pziwUyn3cAHKkFtqsCiYzrMUrhyl3izViy2JyzRUAHK7xsJQ+2ASaSOcoqmxksgv
	EOGaDch53zorEiLXa1X2eY2BoaTQUd8mWYV2MXvPD3uMl5CZ2Fg+42Kdlzv9o9wNES7CmOtATM4Zl
	ZIkrwPlGz0kUg++EFgBS45SdSpX72eDWEZUzEEfz9uVJwdxDB6zDUHpZYpYg+WLrmKNYN6MiIH9N4
	6E/oc2eXe0IqXgwv6YkzVMIcNkVNYkMpinIqHtNYSd9RnYwMDUG6G/QXm4BnNyxDNh9FibthM99up
	zjfedfNg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1posMo-003L56-0A;
	Tue, 18 Apr 2023 20:55:58 +0000
Date: Tue, 18 Apr 2023 13:55:58 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, brauner@kernel.org,
	linux-mm@kvack.org, p.raghav@samsung.com, da.gomez@samsung.com,
	a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
	keescook@chromium.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] tmpfs: add the option to disable swap
Message-ID: <ZD8D3kdVALbWvgYU@bombadil.infradead.org>
References: <20230309230545.2930737-1-mcgrof@kernel.org>
 <3382819f-4a4-8622-5642-78c03ecfb878@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3382819f-4a4-8622-5642-78c03ecfb878@google.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Mon, Apr 17, 2023 at 09:31:20PM -0700, Hugh Dickins wrote:
> On Thu, 9 Mar 2023, Luis Chamberlain wrote:
> 
> > I'm doing this work as part of future experimentation with tmpfs and the
> > page cache, but given a common complaint found about tmpfs is the
> > innability to work without the page cache I figured this might be useful
> > to others. It turns out it is -- at least Christian Brauner indicates
> > systemd uses ramfs for a few use-cases because they don't want to use
> > swap and so having this option would let them move over to using tmpfs
> > for those small use cases, see systemd-creds(1).
> 
> Thanks for your thorough work on tmpfs "noswap": seems well-received
> by quite a few others, that's good.
> 
> I've just a few comments on later patches (I don't understand why you
> went into those little rearrangements at the start of shmem_writepage(),
> but they seem harmless so I don't object),

Because the devil is in the details as you noted too!

> but wanted to ask here:
> 
> You say "a common complaint about tmpfs is the inability to work without
> the page cache".  Ehh?

That was a mistake! s/page cache/swap.

  Luis
