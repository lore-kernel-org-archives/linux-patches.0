Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CD68F68
	for <patches@lists.linux.dev>; Thu, 20 Apr 2023 19:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UXWoPplg6fSqmEcLz6yYPJoYhlqN+hzIgoCxz5ZOmqg=; b=T8FHT16rGh+NUyf/N4U3ERW0Ws
	SL+ClK2K1rEg3zs1+CaAo0QGdmjyGx2W1nsF7drejdegvpR8rFGILTde+NKVJSsDnVXKt+I/FUzVD
	WxaDoQ1a3zyDseOw5n1R5anZ2YdZobdc0cx3SvfG835AJ2AfjyU8SBFT+/ttIZuycOwOU/evADoDi
	B7IFwuRQxXdr2rGGXpVxcaabrj5n7TF2MiqjXWrz6pXI2BpPrLn5ZZMZHzC6Kd+V/QxiLHGGjDkui
	MvCeiI6grOr3CoWkU6+AdWEezxSNx6lGLoFTt/UNRRPl2/9XX81m12e4saDnaNo+KN2CtAk24C4yZ
	SyV1zHXQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1ppZnF-008qZm-0u;
	Thu, 20 Apr 2023 19:18:09 +0000
Date: Thu, 20 Apr 2023 12:18:09 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org,
	willy@infradead.org, linux-mm@kvack.org, p.raghav@samsung.com,
	da.gomez@samsung.com, a.manzanares@samsung.com, dave@stgolabs.net,
	yosryahmed@google.com, keescook@chromium.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shmem: restrict noswap option to initial user namespace
Message-ID: <ZEGP8fLlSDFw52F1@bombadil.infradead.org>
References: <ZD8Q2SzVr3xDmCgY@bombadil.infradead.org>
 <20230420-faxen-advokat-40abb4c1a152@brauner>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420-faxen-advokat-40abb4c1a152@brauner>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Thu, Apr 20, 2023 at 10:57:43AM +0200, Christian Brauner wrote:
> Prevent tmpfs instances mounted in an unprivileged namespaces from
> evading accounting of locked memory by using the "noswap" mount option.
> 
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Reported-by: Hugh Dickins <hughd@google.com>
> Link: https://lore.kernel.org/lkml/79eae9fe-7818-a65c-89c6-138b55d609a@google.com
> Signed-off-by: Christian Brauner <brauner@kernel.org>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
