Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26BF210B;
	Mon,  1 Jan 2024 12:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ReZ/q1jS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A5AC433C8;
	Mon,  1 Jan 2024 12:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704111396;
	bh=1fLPPa98FDcOiCAAWwLR+8jG0OzM8iPqPdEyWbVZ8Uw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ReZ/q1jSoepWl1HVQg6Qc1+JrbCMHOE2RDXuE/gl82gYrEs1INT+rWj4AjRZw65S7
	 ESMSddy0wdmUV+ZD08oU16ESzpckK0uBNb/Ol9X30EOYcpzdCGAH6p8m79P6ohZnOb
	 VcIgMseb4AXEs8DbcRfWZCPlVAqOGZa0Khqq2j1U=
Date: Mon, 1 Jan 2024 12:16:32 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sven Joachim <svenjoac@gmx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Mauricio Faria de Oliveira <mfo@canonical.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 089/112] loop: do not enforce max_loop hard limit by
 (new) default
Message-ID: <2024010125-scholar-unmovable-bebc@gregkh>
References: <20231230115806.714618407@linuxfoundation.org>
 <20231230115809.666462326@linuxfoundation.org>
 <87y1dape2z.fsf@turtle.gmx.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y1dape2z.fsf@turtle.gmx.de>

On Sun, Dec 31, 2023 at 04:49:08PM +0100, Sven Joachim wrote:
> On 2023-12-30 12:00 +0000, Greg Kroah-Hartman wrote:
> 
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> This failed to build here:
> 
> ,----
> |   CC [M]  drivers/block/loop.o
> | drivers/block/loop.c: In function 'loop_probe':
> | drivers/block/loop.c:2125:6: error: 'max_loop_specified' undeclared (first use in this function)
> |  2125 |  if (max_loop_specified && max_loop && idx >= max_loop)
> |       |      ^~~~~~~~~~~~~~~~~~
> | drivers/block/loop.c:2125:6: note: each undeclared identifier is reported only once for each function it appears in
> | make[6]: *** [scripts/Makefile.build:250: drivers/block/loop.o] Error 1
> `----
> 
> > @@ -2093,7 +2122,7 @@ static void loop_probe(dev_t dev)
> >  {
> >  	int idx = MINOR(dev) >> part_shift;
> >
> > -	if (max_loop && idx >= max_loop)
> > +	if (max_loop_specified && max_loop && idx >= max_loop)
> >  		return;
> >  	loop_add(idx);
> >  }
> 
> If CONFIG_BLOCK_LEGACY_AUTOLOAD is not set, max_loop_specified is
> undeclared.  Applying commit 23881aec85f3 ("loop: deprecate autoloading
> callback loop_probe()") fixes that.

Thanks, now queued up.

greg k-h
