Received: from manchmal.in-ulm.de (manchmal.in-ulm.de [217.10.9.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A93C5662
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 08:43:43 +0000 (UTC)
Date: Mon, 14 Aug 2023 10:36:13 +0200
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 6.4 028/206] io_uring/parisc: Adjust pgoff in io_uring
 mmap() for parisc
Message-ID: <1692002074@msgid.manchmal.in-ulm.de>
References: <20230813211724.969019629@linuxfoundation.org>
 <20230813211725.807909427@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230813211725.807909427@linuxfoundation.org>

Greg Kroah-Hartman wrote...

> From: Helge Deller <deller@gmx.de>
> 
> commit 56675f8b9f9b15b024b8e3145fa289b004916ab7 upstream.
(...)
> This patch has no effect on other architectures (SHM_COLOUR is only
> defined on parisc), and the liburing testcase stil passes on parisc.

Confirmed: Both issues reported to linux-parisc earlier are fixed
now.

    Christoph (very busy fighting time thieves)
