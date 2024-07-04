Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D36197A6C;
	Thu,  4 Jul 2024 07:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720079014; cv=none; b=uKqjDo+GGUjsryyXgn28ss55tPL4zsczsBgHHas0nb8uMcmC+TB24Om4jNNNpRpZb5tATKyAn8moDFJD3OU2tKXCI82UIPUdTQvo8SheUYzX4CXVhCaWzeBOR3bDiRoBM596a7evSib5Kq5pCRRyQfrQXjnUMiaiTejQXxrHkhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720079014; c=relaxed/simple;
	bh=1N21mT8rZqrdgr1573uOKgMj6iqc6Xq6LGr8r+D/DKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GdzdcEnmMPyEdkh6v0r+fW+0mSR2OZtPEx1mZ2GuHNTF66m/mnR4pD1YC9LvjfalGdKlhoybUI1XtJh2cKTqrppPtGrddJy4uog1a1y6b+DCRWnGzdPekeOW4FHeYVvIhgEub3VkozlAA7SdvNcmUMPkRESSFByk0Y5PIssjMt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqO0WNUn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqO0WNUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC34C3277B;
	Thu,  4 Jul 2024 07:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720079014;
	bh=1N21mT8rZqrdgr1573uOKgMj6iqc6Xq6LGr8r+D/DKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xqO0WNUnYNAeBraWtziuU6NqGgUUJ92SrASPYanJGkbVUB9QaqF6RN+7ozMJSUM6T
	 ZkGDl+rCfV4CgvBhMarYT5asw2zlUevPEAmoaMXkmjaH5E8tnhiYehZxtkw+gbZ4iQ
	 n9D62UYJBLBinXZBstJ/it5Av9rPRhpAD9ZLF6ks=
Date: Thu, 4 Jul 2024 09:43:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>
Subject: Re: [PATCH 6.1 091/128] serial: imx: set receiver level before
 starting uart
Message-ID: <2024070411-saddlebag-dedicate-0c4f@gregkh>
References: <20240702170226.231899085@linuxfoundation.org>
 <20240702170229.664632784@linuxfoundation.org>
 <20240704071859.GA4355@francesco-nb>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240704071859.GA4355@francesco-nb>

On Thu, Jul 04, 2024 at 09:18:59AM +0200, Francesco Dolcini wrote:
> Hello Greg,
> 
> On Tue, Jul 02, 2024 at 07:04:52PM +0200, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> just a head-up on this patch since from my understanding you are going to have
> a release soon and you did not ack the previous email from Stefan.
> 
> This patch must not be backport to any stable branch, it introduces a
> regression when the driver is using DMA (a fix for this is already in
> your mailbox, but of course, it's not in mainline yet).

The fix for this is in linux-next AND already in the -rc queue as well,
so all should be good.

thanks,

greg k-h
