Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB21128ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B45C433EF;
	Mon, 12 Dec 2022 13:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670853481;
	bh=94O6Wvu8COpy34NL6o58r1KGacvX/62TIF1XKbaHzIA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dkau/FApDY799xZPSE4qcu2e6NZrMesQqmO8e5iqd07yPOZN0sNlyXGT11RcOP1Nv
	 DwkiMbyNupoAnwr0EhHwIimLoZIByaSXTFKZxS0jKQCLX8LpscXqGpTpLB3z9/F6dG
	 cHHhVB29V+1haeOPRasxfOJRiPhObLpzSusYWWqM=
Date: Mon, 12 Dec 2022 14:57:57 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Darren Kenny <darren.kenny@oracle.com>
Subject: Re: [PATCH 5.15 122/123] io_uring: move to separate directory
Message-ID: <Y5czZTxUh7/FIay+@kroah.com>
References: <20221212130926.811961601@linuxfoundation.org>
 <20221212130932.488197218@linuxfoundation.org>
 <e2565faa-4853-2d90-4fa2-e97fe26a96f6@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2565faa-4853-2d90-4fa2-e97fe26a96f6@oracle.com>

On Mon, Dec 12, 2022 at 07:16:11PM +0530, Harshit Mogalapalli wrote:
> 
> 
> On 12/12/22 6:48 pm, Greg Kroah-Hartman wrote:
> > From: Jens Axboe <axboe@kernel.dk>
> > 
> > [ Upstream commit ed29b0b4fd835b058ddd151c49d021e28d631ee6 ]
> > 
> > In preparation for splitting io_uring up a bit, move it into its own
> > top level directory. It didn't really belong in fs/ anyway, as it's
> > not a file system only API.
> > 
> > This adds io_uring/ and moves the core files in there, and updates the
> > MAINTAINERS file for the new location.
> > 
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Stable-dep-of: 998b30c3948e ("io_uring: Fix a null-ptr-deref in io_tctx_exit_cb()")
> 
> Hi,
> 
> Just wanted to add a note: This change moved io_uring code to a different
> folder, this change is brought in to backport 998b30c3948e ("io_uring: Fix a
> null-ptr-deref in io_tctx_exit_cb()") for which we have a backport provided
> by Jens here:
> https://lore.kernel.org/all/24918edb-e6eb-a093-51cf-519c7ece88a3@kernel.dk/
> 
> I am not sure which is the preferred way, but just want to inform about
> this.

Moving the file is fine, it will make it easier over time to backport
changes.

thanks,

greg k-h
