Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC07920EA
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 22:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ghNzYmLGX+1I8uXA3rrjX5OsOiaSJqPCR/IWY1J+MJA=; b=OSBNmZ3SuxJ2jiz8l0Z76oktDH
	3vBMBZJDzvYF7SurRNCkTKEn8LuX2IGNUlXQY+vOjbvaBWoKN2uEJEENTu3AX2z4ocjT2kepNTD1f
	8knZt42XWwyfzfO1SHsHSViKi8KHTx7PiqEOONjTCuKs/avLtLj0QGao15dYd5O73/i/R7LxinLUG
	fajiCNIK9ufHUNT/Zvw1UmY80/q1sMXJeuiNrmA998GpOFjjzAnyadt7jcffxwUHWF+90xs1cMOxp
	zcDLI32rgSeK0FduWKo0QyDzK4FEC/MChLCsUwyPXj6LLADxwR8yVMuDaYm85t9ZXQTxBoomLX7BE
	qqCtktHg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1p2g6O-003lyu-2G; Tue, 06 Dec 2022 22:07:48 +0000
Date: Tue, 6 Dec 2022 14:07:48 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	linux-modules@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Piotr Gorski <lucjan.lucjanov@gmail.com>,
	Nick Terrell <terrelln@fb.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] module/decompress: Support zstd in-kernel decompression
Message-ID: <Y4+9NJStMzI+9/nO@bombadil.infradead.org>
References: <20221206215318.3955400-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206215318.3955400-1-swboyd@chromium.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Tue, Dec 06, 2022 at 01:53:18PM -0800, Stephen Boyd wrote:
> Add support for zstd compressed modules to the in-kernel decompression
> code. This allows zstd compressed modules to be decompressed by the
> kernel, similar to the existing support for gzip and xz compressed
> modules.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Piotr Gorski <lucjan.lucjanov@gmail.com>
> Cc: Nick Terrell <terrelln@fb.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Thanks, might as well get the bots to start testing this, so queued up for
modules-next.

  Luis
