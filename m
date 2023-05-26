Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB14AD27
	for <patches@lists.linux.dev>; Fri, 26 May 2023 08:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/LDnVeeKch0nDkcJiHzeVDWqC1m/deVrVItZ5d48J7o=; b=dAbz9GGYrExV5edRPunAjolEZQ
	WFKsZKWAZJnuLleTCz/VVj+eXCWAn8UxjUjoZM/uAJnWTkKaLYj0udaFwvKzQ8zaCuAkZr3AjAbAq
	W31Grs1G99VSdxdCeYMCpfMXju0ATeHlGmheau2YJMbkEiC+AsOWFt+whU13yilOPwQtnGgVNMANc
	0W1EPe+6LJLc659gPmJ0Tjb51SF8xSxiMdKnvVKN//GdqK+ZA5DAt3Nm+qkt7Djn7OnCOzUHFXXbo
	j74Mbl5MTGc3hdGMXXDolWqxh1kGOK8vTtJceJFTxtd3DsAm0QXgMIU497B2hgLaTZ9mFJsGDcFh/
	5YpoXT+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q2Sb9-001ZLi-1W;
	Fri, 26 May 2023 08:14:55 +0000
Date: Fri, 26 May 2023 01:14:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: hughd@google.com, akpm@linux-foundation.org, willy@infradead.org,
	brauner@kernel.org, djwong@kernel.org, p.raghav@samsung.com,
	da.gomez@samsung.com, rohan.puri@samsung.com, rpuri.linux@gmail.com,
	a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
	keescook@chromium.org, hare@suse.de, kbusch@kernel.org,
	patches@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 0/8] add support for blocksize > PAGE_SIZE
Message-ID: <ZHBqfyPUR4B2GNsF@infradead.org>
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, May 26, 2023 at 12:55:44AM -0700, Luis Chamberlain wrote:
> This is an initial attempt to add support for block size > PAGE_SIZE for tmpfs.

The concept of a block size doesn't make any sense for tmpfs.   What
are you actually trying to do here?

