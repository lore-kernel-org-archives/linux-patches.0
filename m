Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11275213E84;
	Thu, 12 Dec 2024 13:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734011071; cv=none; b=DCeCkfv+kObvTQgJxWNuFItSk/KHe291VvexXrM18h3OniQ0YvkIcwrZCUjpGm2H0LU/0jQyJAJ0TEkMrUmvEzRhLPcmQXe1sOYcIR76b2GNBkbV2Z+B79KzD7FuVtzK3O66BfmbHulsQVIB/m3nL5S0iYm3HU1logn82GnsYSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734011071; c=relaxed/simple;
	bh=Lit1VK9jGMpBkGX999PGGuTFC0FXWDKqYxr+W2P+bB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oj0aMI2kF0B7ZnPIRaT0xelC9P0kYm33HPlH1km3/9W4Q/tCfb4qgqEqCiy53tc80o/BWr/NnC6KwXetaKjS4hC3FxSrqDZr3rXnxXwvLgzhSCEKJCxs5LyV3QHqnUK/idUsm5RmW3OqPb5O2gyRKijnNLQ1rUsvd2xTO7Reb/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4UuxzQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4UuxzQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289FFC4CECE;
	Thu, 12 Dec 2024 13:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734011070;
	bh=Lit1VK9jGMpBkGX999PGGuTFC0FXWDKqYxr+W2P+bB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l4UuxzQoU4a8h5vOWcd9w2BjIG2cfOYh+oaP5YMkQJcW5hzhtgyFi2DqoWKsvo5RY
	 Q+8EEZswMQClnmByB9ZrRgDOlQxXNWZ5dKvrwfdmXR95O1nhFFJiH/LbucZT210Sk+
	 hAdt6W6lYcqOiDupwqIAmlFPmB2OWaj5DK4xt/d4=
Date: Thu, 12 Dec 2024 14:44:27 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Hui Wang <hui.wang@canonical.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, sashal@kernel.org,
	hvilleneuve@dimonoff.com
Subject: Re: [stable-kernel][5.15.y][PATCH 0/5] Fix a regression on sc16is7xx
Message-ID: <2024121241-civil-diligence-dc09@gregkh>
References: <20241211042545.202482-1-hui.wang@canonical.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211042545.202482-1-hui.wang@canonical.com>

On Wed, Dec 11, 2024 at 12:25:39PM +0800, Hui Wang wrote:
> Recently we found the fifo_read() and fifo_write() are broken in our
> 5.15 kernel after rebase to the latest 5.15.y, the 5.15.y integrated
> the commit e635f652696e ("serial: sc16is7xx: convert from _raw_ to
> _noinc_ regmap functions for FIFO"), but it forgot to integrate a
> prerequisite commit 3837a0379533 ("serial: sc16is7xx: improve regmap
> debugfs by using one regmap per port").
> 
> And about the prerequisite commit, there are also 4 commits to fix it,
> So in total, I backported 5 patches to 5.15.y to fix this regression.
> 
> 0002-xxx and 0004-xxx could be cleanly applied to 5.15.y, the remaining
> 3 patches need to resolve some conflict.
> 
> Hugo Villeneuve (5):
>   serial: sc16is7xx: improve regmap debugfs by using one regmap per port
>   serial: sc16is7xx: remove wasteful static buffer in
>     sc16is7xx_regmap_name()
>   serial: sc16is7xx: remove global regmap from struct sc16is7xx_port
>   serial: sc16is7xx: remove unused line structure member
>   serial: sc16is7xx: change EFR lock to operate on each channels
> 
>  drivers/tty/serial/sc16is7xx.c | 185 +++++++++++++++++++--------------
>  1 file changed, 107 insertions(+), 78 deletions(-)

How well did you test this series?  It seems you forgot about commit
133f4c00b8b2 ("serial: sc16is7xx: fix TX fifo corruption"), right?

Please do better testing and resend a working set of patches.

thanks,

greg k-h
