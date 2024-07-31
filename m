Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC112946F;
	Wed, 31 Jul 2024 05:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722404789; cv=none; b=m+UKfy3IPTtFRtNjxiqAJADPhlJlCTJoxKL/gdHE+FOZDuaRKqHfVeF13fi1OJ1n5pLOs6QrJ7Gre938XrpjcecufymQKRZ/FjlRAWoh5x5Eh9eSRXDTMkqxr5OFZLJ5XgdGMlP0b6+0I9Ot0RBaKrX2eFZ7wkc9KiB+wGbOMgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722404789; c=relaxed/simple;
	bh=AYf7Rp+ExjXXveWaylltspquL/pn6LYHTRfVUNAcWVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hue5OisPtl93xaV7Mrma+PGezwhRQOgnecY6AuEjJK4OYDNnrs0K12jiw+RxNp5UW7bTYV1tNsKqUx1FumjpnUDY7gEjOoo817Va8llYPZhZEQOo7furNCFZNz2RI7J85dmJItAfMCMyCBZK9QkgXR1rFiObjFeSjdUS1ZpBgso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HfVA3CuI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HfVA3CuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00FCC116B1;
	Wed, 31 Jul 2024 05:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722404789;
	bh=AYf7Rp+ExjXXveWaylltspquL/pn6LYHTRfVUNAcWVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HfVA3CuIUjg8pslGMOE2R+drub5VurTmZqFr/wwpkfj0B+a8ZPYSE+fsoULEhOtrd
	 Wo7TxF8Mc1RpkrR5brVJthrBEEObORUW5tAi+gJEIXsacXN5LiLEgyOirDVdzYsDK1
	 X9O2tQ0B8ssRZAELhOEiXLoNK6tIdy2UeiBD6/JM=
Date: Wed, 31 Jul 2024 07:46:26 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.10 259/809] virtio_net: add support for Byte Queue
 Limits
Message-ID: <2024073119-gentleman-busybody-8091@gregkh>
References: <20240730151724.637682316@linuxfoundation.org>
 <20240730151734.824711848@linuxfoundation.org>
 <20240730153217-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240730153217-mutt-send-email-mst@kernel.org>

On Tue, Jul 30, 2024 at 03:33:18PM -0400, Michael S. Tsirkin wrote:
> On Tue, Jul 30, 2024 at 05:42:15PM +0200, Greg Kroah-Hartman wrote:
> > 6.10-stable review patch.  If anyone has any objections, please let me know.
> 
> Wow.
> 
> It's clearly a feature, not a bugfix. And a risky one, at that.
> 
> Applies to any stable tree.

Now dropped, thanks.

greg k-h
