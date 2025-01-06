Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784751D5149;
	Mon,  6 Jan 2025 07:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736147884; cv=none; b=I1aePu0Lcb2NXj91DdhI7r0ewHzO181z4XmQtrByBcph98K2uN3671AtwfGzlt1Mw+STYjV998Dk67eAT5ma3cZ9gutgeI0zaG7s0cNloomxbVVFXWBxGRCDUksve0fiHRqKnehpWeW7OIr4XJ0Hje9LSS4sZTkh1+svhNDPOB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736147884; c=relaxed/simple;
	bh=iCVBAmDJGuQ7L0qb4KshnfccErTrJX4g2OYIbINxqeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GRFTWECWDZ5OsPTtULnMixpokjZjbl2LY6Jpm5pSftReKVn+M7G70IliZRTX56PRgJU7qYtLiXUvNOwc8vLo3wXzDVW3Tq4xW3dAqpbNFraj1vf4xx4sjA3Z74drbEDZYFPI07FWumBMpKdk76MNj4fV8THM449tCKRfKtRmHaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCnrcnEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCnrcnEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9656AC4CED2;
	Mon,  6 Jan 2025 07:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736147884;
	bh=iCVBAmDJGuQ7L0qb4KshnfccErTrJX4g2OYIbINxqeY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XCnrcnExF+LX/CgvwTY/2oO3QCdf1kR7os6yKPPp81iJTJg5L7AOSULhMNGlceZhu
	 b3zajNkCxLACuWHJWKssGxwgMPVu9aqvoazp04JeGzS4E/Gb2m2sim/YFYOnKe++yl
	 1RdSTcwQuKIKPKwmjbbAgqleVyI8NE1FOJcmoSgM=
Date: Mon, 6 Jan 2025 08:18:01 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: jianqi.ren.cn@windriver.com
Cc: stable@vger.kernel.org, kxwang23@m.fudan.edu.cn,
	alexandre.belloni@bootlin.com, patches@lists.linux.dev,
	pgaj@cadence.com, linux-i3c@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1.y] i3c: master: cdns: Fix use after free
 vulnerability in cdns_i3c_master Driver Due to Race Condition
Message-ID: <2025010606-startling-cushy-d79c@gregkh>
References: <20250106022939.2197708-1-jianqi.ren.cn@windriver.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106022939.2197708-1-jianqi.ren.cn@windriver.com>

On Mon, Jan 06, 2025 at 10:29:39AM +0800, jianqi.ren.cn@windriver.com wrote:
> From: Kaixin Wang <kxwang23@m.fudan.edu.cn>
> 
> [ Upstream commit 609366e7a06d035990df78f1562291c3bf0d4a12 ]

Again, sorry, but no, I will not take any more stable backports from
your company at this point in time.  Please go tell your managers this
as somehow the previous emails from me seem to have been ignored.

greg k-h
