Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346F128C876
	for <patches@lists.linux.dev>; Fri, 20 Jun 2025 15:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750434454; cv=none; b=XeMDfR6dXaxBoojs8cIym3ea+qHwsKHPQG1r5JJWs56/ActdLfkn5oJxBUwMqyhEjuKAQwsUXmiHIx+y24Rwz9giTWFWkIHk4ptOjVCtv/Y9reVv6ehCH+vbKPzXAkkNBq2IOy52RpriksxsyQELyA9lMJ/MZFsVcIcSvm1l2BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750434454; c=relaxed/simple;
	bh=KJ3YoIahMDQz5n+Tgkh1SibMIwQb8dsmwTcJ+nMnqtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ezYfxBTo1Y96BmN3J7K/AAIp0xNy/A7FnhIhUUG5SPYKIU8LFAD3iQRwURFB4IITHL1SQ4YNZWdLtKyqYTScbk+/M9MGBekchGefPd7kkryKM+KXBWrRa8sv34CQYEYFAD+IUy01+zH6c+F7Yeu1XV6gIEy73t8vMcoVvRBRtwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=We7kBjFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="We7kBjFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0F3C4CEE3;
	Fri, 20 Jun 2025 15:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750434454;
	bh=KJ3YoIahMDQz5n+Tgkh1SibMIwQb8dsmwTcJ+nMnqtQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=We7kBjFELHuBCIOD+CTNEFCbDrmX/cdMLBClY/UN7FWrmJRQ9D3bCRCzTz6q6+5bF
	 e60S0Ag2+HY2p/OkcA7ciG5PEPmNsPV2K4UKQfcWTh5kE3mV2Qc461gRwaqNba1Beh
	 V69rUzT8Ju4lIwlIHyqOCOJWg6D9YQilViFkqvKI=
Date: Fri, 20 Jun 2025 17:47:30 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: patches@lists.linux.dev, stable <stable@kernel.org>
Subject: Re: stable-queue.git: queue-6.15/series corrupted (duplicate
 temporary patches)
Message-ID: <2025062044-delta-agreeably-c663@gregkh>
References: <20250619025021.0ee12258@mir>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250619025021.0ee12258@mir>

On Thu, Jun 19, 2025 at 02:50:21AM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> While trying to bisect a potential issue in v6.15.3-rc1, I noticed that 
> queue-6.15/series of the current (v6.15.2-74-g344d39fc8d)
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
> 
> seems to contain artifacts of duplicate patch entries:
> 
> upstream/drm-msm-dpu-remove-dsc-feature-bit-for-pingpong-on-m.patch-13942
> upstream/drm-msm-dpu-remove-dsc-feature-bit-for-pingpong-on-m.patch-8756

These are fine, did you look at the contents?  It's an artifact of how
git format-patch works for names that are "too long".

> upstream/arm64-dts-rockchip-disable-unrouted-usb-controllers-.patch-25959

Same here, this is fine.

thanks for the review.

greg k-h
