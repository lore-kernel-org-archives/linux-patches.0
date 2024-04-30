Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDE114AB7;
	Tue, 30 Apr 2024 07:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714463455; cv=none; b=Ooi2d206A8XKubVJ4ywAg6xfyXcaZeaSFz2AQfzK9zRuXHp4Y41C7Zeaz8dUG/fzluxQXukWjHhatYBdW79HJ8RRXy9n/6YwhqjSqvex/EYljyF7hWUZTN3Cc5CL01jneq+rRxGM7b4cEoGBpSI8ksZJ6IYw58ELn0jDvLxWKB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714463455; c=relaxed/simple;
	bh=Hz1ZgvHpYULY+kIy7eFI9BiDKMMj0EzDJmGcsXcjvLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jKmPOhmz8Fud59Plf5VKYtQHl2+ggi8d94VICvwAYvTq9NfNquECvLUEw8Q96maajP/uUH3BxRKpzoVoffd0nTN7oRWFM5deZoRg3oD+sWkT25Pu36uhbl2JOL6lsLpwzNcAH6cbDK9BBAmCfii1/xv0Cc74rcztzFdfzTgLmJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cymnZ8rV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cymnZ8rV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4CFC2BBFC;
	Tue, 30 Apr 2024 07:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714463455;
	bh=Hz1ZgvHpYULY+kIy7eFI9BiDKMMj0EzDJmGcsXcjvLY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cymnZ8rVbwtJL4Tqsp/3dyqUT4yjeDdeM0BpJs1/nIVuxEMwQiUEwAEk9l5dXn7xh
	 l6/Fqejfp+RRUr8DeaHPcT73gHDISa8owcGjz2thVvci1Pgn+qjleyrJPQ12qUB8kE
	 wXie7FFvNBN5BVY6VhYRsup7hoWf8h1GcTTukM0E=
Date: Tue, 30 Apr 2024 09:50:52 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Martijn Coenen <maco@android.com>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Genjian Zhang <zhanggenjian@kylinos.cn>
Subject: Re: [PATCH 4.19] Revert "loop: Remove sector_t truncation checks"
Message-ID: <2024043043-scandal-silicon-7009@gregkh>
References: <496c59ccd7eefd9cd27f6454f6271f96e66f1da7.camel@decadent.org.uk>
 <ZjAT5UeQ8fc7CY0w@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjAT5UeQ8fc7CY0w@decadent.org.uk>

On Mon, Apr 29, 2024 at 11:40:53PM +0200, Ben Hutchings wrote:
> This reverts commit f92a3b0d003b9f7eb1f452598966a08802183f47, which
> was commit 083a6a50783ef54256eec3499e6575237e0e3d53 upstream.  In 4.19
> there is still an option to use 32-bit sector_t on 32-bit
> architectures, so we need to keep checking for truncation.
> 
> Since loop_set_status() was refactored by subsequent patches, this
> reintroduces its truncation check in loop_set_status_from_info()
> instead.
> 
> I tested that the loop ioctl operations have the expected behaviour on
> x86_64, x86_32 with CONFIG_LBDAF=y, and (the special case) x86_32 with
> CONFIG_LBDAF=n.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/block/loop.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)

Thanks, both reverts now queued up.

greg k-h
