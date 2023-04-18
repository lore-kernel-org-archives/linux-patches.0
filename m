Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F50C944
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 21:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=x6fCn8oqf/tgVfxgVBRtXPhUANRwOD7q1Hdq1ZO04nw=; b=Bn1i01YpTw/8vTDES1+DSjRPEe
	ApA+UTK7vJj7tF5v36DiK+X+VKABThsuH0+6Xk+G50iWXwXaPGehDNS1m5nWMvZytFqDjWRfgozcE
	rm3ecbYU1KeAZCHYSEKKgXLeMejHGNCvMidPhj9mPh8j/v8B2KPugWm3OW7TzxTLKZqvQ4VzDaQay
	rPprotDvQAeii5e9XnOLLl++IAe8mB4B3C/U4RwqKCyV4EcZO6Z0qsjZArKYDEDdp7FxKkqZVvQYn
	Ka+Pk7gIMeRzVcCyDddjPhsrqGTUbnTF5ElEmLx1+9vKBMub01uEytpS4R/vCEy+msdQopfbsfzwh
	Vj11yMdw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1posm0-003N0h-3B;
	Tue, 18 Apr 2023 21:22:01 +0000
Date: Tue, 18 Apr 2023 14:22:00 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, brauner@kernel.org,
	linux-mm@kvack.org, p.raghav@samsung.com, da.gomez@samsung.com,
	a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
	keescook@chromium.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] shmem: add support to ignore swap
Message-ID: <ZD8J+I6uCqfp31sv@bombadil.infradead.org>
References: <20230309230545.2930737-1-mcgrof@kernel.org>
 <20230309230545.2930737-7-mcgrof@kernel.org>
 <79eae9fe-7818-a65c-89c6-138b55d609a@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79eae9fe-7818-a65c-89c6-138b55d609a@google.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Mon, Apr 17, 2023 at 10:50:59PM -0700, Hugh Dickins wrote:
> You'll be sending a manpage update to Alejandro in due course, I think.

Sure thing! Just need a git tree. I can send the updates as we reach
a consensus on where to store / share huge page shmem updates.

  Luis
