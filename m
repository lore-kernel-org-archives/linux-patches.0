Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC78EA1
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 05:25:38 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id E100A68AFE; Tue, 19 Apr 2022 07:19:08 +0200 (CEST)
Date: Tue, 19 Apr 2022 07:19:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-doc@vger.kernel.org, patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	linux-ide@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH] Drop Documentation/ide/
Message-ID: <20220419051908.GA31471@lst.de>
References: <20220419011021.15527-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419011021.15527-1-rdunlap@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 18, 2022 at 06:10:21PM -0700, Randy Dunlap wrote:
> Drop all Documentation/ide/ since IDE support was deleted by
> Christoph Hellwig <hch@lst.de>, Jun 16 2021.

Thanks, looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
