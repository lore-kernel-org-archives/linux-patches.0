Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0673C27
	for <patches@lists.linux.dev>; Wed,  3 May 2023 16:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=48XGDRTu5lC8Uq10mtv4Awaa56oho69zyl02Hq2NT4Y=; b=qo7q+PA//KUaWkz8gKt1od2gj4
	Ml9SHSN/AxdU84MJW9bdwUvo1WrYcfx4S1D07dNh9zFEXOMZLXYa/QFJof7vtqY9D4SFTDisOuXNt
	8XQUwf1vkKxzR8G8vqXUWY1G0Vj+McrwfrfDLq6IUxwHQzCP/SmS4mCEFejJwEYkicZm4G9vzSZA8
	822dGR0B5pBvO5ZGjiuMO7aaRrS9r+j9z5jeLpRKjb2f76D52YlHixOA7dYvkIUKePpkbpLm3H0hH
	DOfh5sg/13Up2MkIHb3GqWseg59GjHx7tgkQDksiZ4vIgfb2eQ53PFJ16Q4BTcSbqtLqmgzevlmYu
	v1IiMqVQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1puFGv-0054hC-0x;
	Wed, 03 May 2023 16:24:05 +0000
Date: Wed, 3 May 2023 09:24:05 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: torvalds@linux-foundation.org
Cc: ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com,
	j.granados@samsung.com, patches@lists.linux.dev,
	ebiggers@kernel.org, jeffxu@google.com, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] sysctl: death to register_sysctl_paths()
Message-ID: <ZFKKpQdx4nO8gWUT@bombadil.infradead.org>
References: <20230503023329.752123-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503023329.752123-1-mcgrof@kernel.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Tue, May 02, 2023 at 07:33:27PM -0700, Luis Chamberlain wrote:
> You can give it a day for a warm fuzzy build test result.

0-day gives its blessings.

  Luis
