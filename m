Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95916249F3;
	Fri,  5 Jan 2024 09:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeyLtzor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFD5C433C7;
	Fri,  5 Jan 2024 09:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704448358;
	bh=3dzwNA7Sokm1IVeJ+eyLxApIoBK8BPG6cvKDoe4/hG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QeyLtzorgLk5JvUYdL3/NmTiCpcMXu9BQHc1WeG0nNoccX7EXrFWEpV73tLf0W1s6
	 yS0JB8MsJPyoiQxnFag4tzlJuHIboyfRgZdCbAHgTFJPQvv17pPZO/eXVvNE9008Ab
	 mxDYVKhVmYI3A/NJptEcjx0U5KWjgZQvHOCvlnT8=
Date: Fri, 5 Jan 2024 10:52:35 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	David Wei <dw@davidwei.uk>, Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 055/156] bnxt_en: do not map packet buffers twice
Message-ID: <2024010553-colonist-elf-1b15@gregkh>
References: <20231230115812.333117904@linuxfoundation.org>
 <20231230115814.135415743@linuxfoundation.org>
 <ZZQqGtYqN3X9EuWo@C02YVCJELVCG.dhcp.broadcom.net>
 <2024010348-headroom-plating-1e2a@gregkh>
 <ZZcP9qZ0G0sS_IPK@C02YVCJELVCG.dhcp.broadcom.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZcP9qZ0G0sS_IPK@C02YVCJELVCG.dhcp.broadcom.net>

On Thu, Jan 04, 2024 at 03:07:18PM -0500, Andy Gospodarek wrote:
> On Wed, Jan 03, 2024 at 11:04:11AM +0100, Greg Kroah-Hartman wrote:
> > On Tue, Jan 02, 2024 at 10:22:02AM -0500, Andy Gospodarek wrote:
> > > On Sat, Dec 30, 2023 at 11:58:29AM +0000, Greg Kroah-Hartman wrote:
> > > > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > 
> > > No objections from me.
> > > 
> > > For reference I do have an implementation of this functionality to v6.1
> > > if/when it should be added.   It is different as the bnxt_en driver did
> > > not use the page pool to manage DMA mapping until v6.6.
> > > 
> > > The minimally disruptive patch to prevent this memory leak is below:
> > > 
> > > >From dc82f8b57e2692ec987628b53e6446ab9f4fa615 Mon Sep 17 00:00:00 2001
> > > From: Andy Gospodarek <andrew.gospodarek@broadcom.com>
> > > Date: Thu, 7 Dec 2023 16:23:21 -0500
> > > Subject: [PATCH] bnxt_en: unmap frag buffers before returning page to pool
> > > 
> > > If pages are not unmapped before calling page_pool_recycle_direct they
> > > will not be freed back to the pool.  This will lead to a memory leak and
> > > messages like the following in dmesg:
> > > 
> > > [ 8229.436920] page_pool_release_retry() stalled pool shutdown 340 inflight 5437 sec
> > > 
> > > Fixes: a7559bc8c17c ("bnxt: support transmit and free of aggregation buffers")
> > > Signed-off-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
> > > ---
> > >  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > 
> > I do not understand, what is this patch for?
> > 
> > Why not submit it for normal inclusion first?
> 
> Greg,
> 
> I wondered if my description was good enough -- it was not.  :)
> 
> The sole purpose for sending my last email was to let you know that this
> problem also occurs on v6.1 but in a different manner.
> 
> In the process of fixing this problem on the tip of tree I noted it was also an
> issue on older kernels, so that was why I brought it up.  
> 
> This is a bit confusing as the Fixes: tag was correctly set to changes that
> were made for v6.6 as it was the first kernel where this type of leak was
> noted.
> 
> Hopefully that resolves the confusion.

Nope, sorry, I still have no idea what to do with this change at all.
It's not submitted as a "normal" change so what should be done with it?

confused,

greg k-h
