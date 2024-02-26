Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A2212E1CB;
	Mon, 26 Feb 2024 14:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708959410; cv=none; b=rn4d2ZhEVHM0pXPDbF8x1PkagDp8z+ZfMcYuKvfo01yOofnnzrezFg9xEz2m6Gx8IcT5tZoZLKuZ06Xvpw3mbL5X5m7kWzSKsBGbLW63fjJzfHrjVTRvuLIQ3z9Kzf3Jo1OZJ8Zdiqi0YTZ8V/BzQRbAmBUdD1O+9NTHCva2gcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708959410; c=relaxed/simple;
	bh=owkQGuoxsDR/i7kpq2TppI5mT4N1EQ387SuY1iYgFy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fu8h5bTLDSJHZcDH71+yJU+N0boPwiR3YQPVMgV+QAXnx3pv6h+olRXN078LHq/3qJWM97oX23n7MVzKCNxI48OnZW8fLwutB5Cg4aHMXdzGzqhI7x6w6H3MjMQONhjbls2cv/zYT0X0xrqWp6hQqD4XKxhZCsECvvuJL/lRP/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBE/xxCS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBE/xxCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA94C433C7;
	Mon, 26 Feb 2024 14:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708959409;
	bh=owkQGuoxsDR/i7kpq2TppI5mT4N1EQ387SuY1iYgFy0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uBE/xxCSf9NtrptT7yFkvdvnIDxqWRFeJlV+NdnnaMsHI0rBQApYRUWQD/5plPxU+
	 nBfEAJfYvq4JKHFpyVuQgOQM5Vist4wcBPSDzRi0qBmEwTeXT+B8ndqGTOTr1JIA75
	 ECsevVxQATKhTwJnOe+v5dK8BP/MEXd/erlTeppA=
Date: Mon, 26 Feb 2024 15:56:47 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 372/476] i2c: i801: Remove i801_set_block_buffer_mode
Message-ID: <2024022630-scone-factoid-02e6@gregkh>
References: <20240221130007.738356493@linuxfoundation.org>
 <20240221130021.778800241@linuxfoundation.org>
 <20240226142935.62cac532@endymion.delvare>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226142935.62cac532@endymion.delvare>

On Mon, Feb 26, 2024 at 02:29:35PM +0100, Jean Delvare wrote:
> On Wed, 21 Feb 2024 14:07:03 +0100, Greg Kroah-Hartman wrote:
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Heiner Kallweit <hkallweit1@gmail.com>
> > 
> > [ Upstream commit 1e1d6582f483a4dba4ea03445e6f2f05d9de5bcf ]
> > 
> > If FEATURE_BLOCK_BUFFER is set then bit SMBAUXCTL_E32B is supported
> > and there's no benefit in reading it back. Origin of this check
> > seems to be 14 yrs ago when people were not completely sure which
> > chip versions support the block buffer mode.
> > 
> > Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> > Reviewed-by: Jean Delvare <jdelvare@suse.de>
> > Tested-by: Jean Delvare <jdelvare@suse.de>
> > Signed-off-by: Wolfram Sang <wsa@kernel.org>
> > Stable-dep-of: c1c9d0f6f7f1 ("i2c: i801: Fix block process call transactions")
> 
> There is no functional dependency between these 2 commits. The context
> change which causes the second commit to fail to apply without the
> first commit is trivial to fix. I can provide a patch for version 5.15
> and older. I think it is preferable to backporting an extra patch which
> wouldn't otherwise qualify for stable trees.

This is already in a released kernel.  We can revert them, if you want
us to, is it worth it?

thanks,

greg k-h
