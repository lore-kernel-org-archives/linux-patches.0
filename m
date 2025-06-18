Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7470E28A1F5;
	Wed, 18 Jun 2025 13:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750252144; cv=none; b=lZmX8DDc1WFQNDwPR8FJId7YzSRQjFLiSbDOhz6U1rf6R6ZWYmPzZbUgGQmOVAtCFFlxG+s/VF1ViYBVLDtzA1y6uOkwFqVLnmpmvrBEZpHf7QtcXVL7RfejYGQl/sIbsJxTl4pZJEr0MGpmVhULUcIA8eKELbDgDzB6SGU+ju0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750252144; c=relaxed/simple;
	bh=Kl4yzpZwdO2mxt+6hCeS5yfiotaSDBRU8+u1wkKHmsI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T+s6C/DdKTT2Z0xg2iPyUYulkkbLOrwrRMT5yGvcN0K6HTT4o4Xrb2tfGCu7FhiYf4FVQ/oezXLxC+H3hoYc50DM6U/4PX/2DSiXu6YPqYMUQEe5QolWzPWI9qPIDCmJtaqA2xxHVj9usl1uBTYZKmV3yrPtE8140LvD2u4UvAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJqx43rK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJqx43rK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A91C4CEE7;
	Wed, 18 Jun 2025 13:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750252143;
	bh=Kl4yzpZwdO2mxt+6hCeS5yfiotaSDBRU8+u1wkKHmsI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CJqx43rKVn1W8jwNXHoU2blLU1TzCxijuczaq88pfeFwx/AKpq6Ypn409J3lToTfF
	 BUKmxzI2PCcIO3/7misMGp3I+Y3Ddeg4tS/pDzEalkqVX9OvwLeJZ40TvBhsTKzOIf
	 y3PQ4Q92ZvVztrtJYDZ3Hk5/bjE+/bYMwfCZFp+M=
Date: Wed, 18 Jun 2025 15:09:01 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pieter Van Trappen <pieter.van.trappen@cern.ch>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 277/356] net: dsa: microchip: update tag_ksz masks
 for KSZ9477 family
Message-ID: <2025061846-valley-bloomers-2ff6@gregkh>
References: <20250617152338.212798615@linuxfoundation.org>
 <20250617152349.344636049@linuxfoundation.org>
 <f390d9ea-b752-4a56-b564-ccba928885bf@cern.ch>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f390d9ea-b752-4a56-b564-ccba928885bf@cern.ch>

On Tue, Jun 17, 2025 at 10:23:21PM +0200, Pieter Van Trappen wrote:
> On 6/17/25 17:26, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> Hi Greg, no objection since it's a cosmetic patch really. However there's
> two related commits from 6.12 upstream that are worth considering and do
> contain fixes, see below. I checked with stable linux-6.6.y and they don't
> apply cleanly but resolving the merge conflicts is easy enough; not sure if
> that's worth the hassle and how to go about it - let me know.
> 
> 6f2b72c04d58a40c16f3cd858776517f16226119
> 0d3edc90c4a0ac77332a25e1e6b709a39b202de9

Thanks for letting me know, I've just dropped this, and the patch after
this from all queues.

greg k-h
