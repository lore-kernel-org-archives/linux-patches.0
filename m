Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD5D1C3C05;
	Wed, 22 Jan 2025 08:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737533151; cv=none; b=j0aHs1QL6qlNMo5OHB8l1Y9T0s/GuKr35yErV5LQFDKCiywrF3L6KyLoORDPVnDmGFxiyAamoz5wqbkIA5CHBRszylewD7PivG9mPl1nZl5NgedLQX9CQeivACRLMIo0CxkS693z9jmEf8rg7ppEGMWoHIbx5LBRGrhn0ZfCyUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737533151; c=relaxed/simple;
	bh=Ssuh11iJ4NtkmtHrghP5zrU7Jhn24FfclP0o0vOkqqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ruKPysqJqEYRMJ/oELkjv4GPY8Axlk4iVYgA64loBW2N0bojKhnwNiA064fNZVSa7lxz3o3zUKmcn0KALGdTJN5utXjkn7p93/Jm8hvY/fzKF2Pe/kv+fwNHalQ9pBVydEzVuiFcmBQO9K15jexyRsX7gIY5Jfy9o983z8swWWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RW5lBauS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RW5lBauS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7BAC4CED6;
	Wed, 22 Jan 2025 08:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737533150;
	bh=Ssuh11iJ4NtkmtHrghP5zrU7Jhn24FfclP0o0vOkqqo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RW5lBauSF/a7MrUa02yd9cfrjOBX0DGPBRON4QHAxVxSGHY42dlpEH+6inGaxv3yj
	 umELATpD0pU+6i68SzypAv5R0SXc7NXvmF9D3fP8sWxkIi7GcM4zKRQKtHOqz9Q34G
	 P92QnbhKLq9KerYOjbppU0ehiDyiWrNK1IKWNElA=
Date: Wed, 22 Jan 2025 09:05:47 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 034/127] drivers/block/zram/zram_drv.c: do not keep
 dangling zcomp pointer after zram reset
Message-ID: <2025012238-earpiece-wobbly-94a8@gregkh>
References: <20250121174529.674452028@linuxfoundation.org>
 <20250121174530.999716773@linuxfoundation.org>
 <Z5A59tcFS22YMZAt@atmark-techno.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5A59tcFS22YMZAt@atmark-techno.com>

On Wed, Jan 22, 2025 at 09:21:10AM +0900, Dominique Martinet wrote:
> Greg Kroah-Hartman wrote on Tue, Jan 21, 2025 at 06:51:46PM +0100:
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Sergey Senozhatsky <senozhatsky@chromium.org>
> > 
> > commit 6d2453c3dbc5f70eafc1c866289a90a1fc57ce18 upstream.
> >
> > We do all reset operations under write lock, so we don't need to save
> 
> This branch does not have said write lock, please either also pick
> 6f1637795f28 ("zram: fix race between zram_reset_device() and
> disksize_store()") or drop the 3 zram patches from 5.15
> (see https://lore.kernel.org/all/Z4YUmMI5e2yPmzHl@atmark-techno.com/T/#u ;
> sorry I didn't follow up more thoroughly. As said there, I believe that
> with the extra patch this backport is now sound, but given this isn't a
> security fix my opinion is that this was too complex of a backport for
> an uninvolved party like me to do)

Now all dropped, thanks for reminding me.

greg k-h
