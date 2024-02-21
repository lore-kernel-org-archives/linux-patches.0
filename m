Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF793C493;
	Wed, 21 Feb 2024 11:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708513260; cv=none; b=kZXh9rzeagir0wl1ucVwRKJW7rdY5PAxTjA/GwMPzqKlLRYzU7Qx12B3dLcbLImaP3bdQOm+kbQZrQ/8Kd3IB5rMzXYx0dvOJmaFvBEx8qtBNENNEc0vvn+35OvOEeQbRr/2o08eT8bdvGVakw+j+jIFp9gcAkwDdRUdszf8eb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708513260; c=relaxed/simple;
	bh=oJUXBVVY+vVx1UyN31Vre1Dkgow45biC3Dpaor0ifBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eLXPVs9RauprtAuh7vXVjcEJqjj0PTZyyU5rD2JdF4JQAxYASKTWhKzl2ac30W50vRS6V1PnDDVeWlhAuy5UvxHzCdMBhk315hWUbHGLVakdyT7zdCPpWKveVtsv0zsB4CU+UcTR8VFRUAUL1YadhLHMjO8BWthzdmmp+X2Fxj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p8EGoMto; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p8EGoMto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A33C433C7;
	Wed, 21 Feb 2024 11:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708513260;
	bh=oJUXBVVY+vVx1UyN31Vre1Dkgow45biC3Dpaor0ifBw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p8EGoMto2GGvZ3giIazo/7t0byjEUCrn9wkrxEXwjdooLYVSpG8MdEVgLtN+VbnMz
	 RFmRwAElSeYvhD2Rv/4MzakNoQUizTgHvxSmdZJkSJN6/wJz34Jhco1h8X1Oyzn2NO
	 jJkmgH9jW/2tJKUmdAyYv9Ie00rVRiFj9Rub9oPc=
Date: Wed, 21 Feb 2024 12:00:56 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: max.oss.09@gmail.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev, s.hauer@pengutronix.de,
	han.xu@nxp.com, tomasz.mon@camlingroup.com, richard@nod.at,
	tharvey@gateworks.com, linux-mtd@lists.infradead.org,
	Max Krummenacher <max.krummenacher@toradex.com>
Subject: Re: [regression 5.4.y][RFC][PATCH 0/1]  mtd: rawnand: gpmi:
 busy_timeout_cycles
Message-ID: <2024022151-tinker-sprang-5fa2@gregkh>
References: <20240207174911.870822-1-max.oss.09@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240207174911.870822-1-max.oss.09@gmail.com>

On Wed, Feb 07, 2024 at 06:49:10PM +0100, max.oss.09@gmail.com wrote:
> From: Max Krummenacher <max.krummenacher@toradex.com>
> 
> Hello
> 
> With the backported commit e09ff743e30b ("mtd: rawnand: gpmi: Set
> WAIT_FOR_READY timeout based on program/erase times") in kernel 5.4.y
> I see corruption of the NAND content during kernel boot.
> Reverting said commit on top of current 5.4.y fixes the issue.
> 
> It seems that the commit relies on commit 71c76f56b97c ("mtd:
> rawnand: gpmi: Fix setting busy timeout setting"), but its
> backport got reverted.
> One should either backport both commits or none, having only one
> results in potential bugs.
> 
> I've seen it in 5.4.y, however in 5.10.y and 5.15.y there one of
> the two backports is also reverted and likely the same regression
> exists.
> 
> Any comments?
> 
> Max
> 
> Max Krummenacher (1):
>   Revert "Revert "mtd: rawnand: gpmi: Fix setting busy timeout setting""
> 
>  drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> -- 
> 2.42.0
> 
> 

Now queeud up, thanks.

greg k-h
