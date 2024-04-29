Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B25D3FBA3;
	Mon, 29 Apr 2024 11:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714389019; cv=none; b=mi7JZw4pS9mbe5VItvkqRIlxWZ308ulmjFHr9BPITco36ZBxMTi60x3YFoKwICSus2kEH3VTVoq15P/E9iZKLTfrxH1Cdq+yY0FgjY83KndJMhxGs8mnohasWAzn+enY3jd5en8sAd8by4lA+SNrgJjqohaKVZp9uptFurKymdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714389019; c=relaxed/simple;
	bh=k8Kc8BDqp8J9fS36GCCjCL4uxA0evx0hvlSUkJPZdeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qx1D93rTNBYvCw3/JzdfKBz0ssnXqNX5Qe0KQnM1kK8+ccvPRN0Zci0TR9RT+yazTLlj7+fe2rcSiq+bFcNJK9Aq2JU8JKc0/s1VkJDXcge7G0ZPzCNZKZi7V3PrluMl7ngktvALvk9OLvnT0nWvwzZZTUTEpMabY8kDvoKcbSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeLW3Frp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeLW3Frp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6C2C4AF1A;
	Mon, 29 Apr 2024 11:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714389018;
	bh=k8Kc8BDqp8J9fS36GCCjCL4uxA0evx0hvlSUkJPZdeo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GeLW3FrpQNcm2FlhG13iZ8vtvSZXLN2/uuyzlIkW4eetKVB0lHdTFIR49i0WbOT8P
	 7xGa9o4M/5AYe45If6VtG7naEhMo02Nyu2sh1dDaEXUNw0a32E4DCrbzMZdZU7XstG
	 S/hts5K5DuOOLeDvKtTW3lUGLnlMNfSE49v9sFNw=
Date: Mon, 29 Apr 2024 13:10:15 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Martijn Coenen <maco@android.com>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Genjian Zhang <zhanggenjian@kylinos.cn>
Subject: Re: [PATCH 4.19 091/175] loop: Remove sector_t truncation checks
Message-ID: <2024042948-banjo-stuck-0067@gregkh>
References: <20240411095419.532012976@linuxfoundation.org>
 <20240411095422.304818113@linuxfoundation.org>
 <c8ac24aef38a0f9fab3f029b464fd396ee51bfcd.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8ac24aef38a0f9fab3f029b464fd396ee51bfcd.camel@decadent.org.uk>

On Fri, Apr 26, 2024 at 06:56:40PM +0200, Ben Hutchings wrote:
> On Thu, 2024-04-11 at 11:55 +0200, Greg Kroah-Hartman wrote:
> > 4.19-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Martijn Coenen <maco@android.com>
> > 
> > [ Upstream commit 083a6a50783ef54256eec3499e6575237e0e3d53 ]
> > 
> > sector_t is now always u64, so we don't need to check for truncation.
> 
> This needs to be reverted for 4.19, because sector_t wasn't always u64
> until 5.2.

Ah, ick.  Ok, let me go revert all of these, that should also solve the
build issue for Alpha that Guenter was reporting.

thanks for letting me know.

greg k-h
