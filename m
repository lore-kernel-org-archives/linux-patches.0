Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A9B2115
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 14:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08EF8C433EF;
	Sun, 22 Jan 2023 14:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674396890;
	bh=cATNT2CveJBpedlCJrWtRaV+hTrV5pxK/j/b11KO34g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IQrzeB+h6aURE/Vnt5g1RNRF+wes8gzU0mI+TloS9Sfwn2HKjty6EPVqrcLywKZjd
	 aazkojqLd1QO61JcpWQos9YZ2kUGQod7b4dxydaR1TWBaQMTDquZfRM2ExGCVY+253
	 xtyNlzajVm1VfsRz+DkQRT473l5VnYkfEmRHvVyg=
Date: Sun, 22 Jan 2023 15:14:47 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eric Whitney <enwlinux@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>, stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 499/521] ext4: fix delayed allocation bug in
 ext4_clu_mapped for bigalloc + inline
Message-ID: <Y81E17kMowYd3naC@kroah.com>
References: <20230116154847.246743274@linuxfoundation.org>
 <20230116154909.507815847@linuxfoundation.org>
 <Y8mAe1SlcLD5fykg@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8mAe1SlcLD5fykg@debian-BULLSEYE-live-builder-AMD64>

On Thu, Jan 19, 2023 at 12:40:11PM -0500, Eric Whitney wrote:
> Hi:
> 
> I recommend not backporting this patch or the other three patches apparently
> intended to support it to 4.19 stable.  All these patches are related to
> ext4's bigalloc feature, which was experimental as of 4.19 (expressly noted by
> contemporary versions of e2fsprogs) and also suffered from a number of bugs.
> A significant number of additional patches that were applied to 5.X kernels
> over time would have to be backported to 4.19 for the patch below to function
> correctly. It's really not worth doing that given bigalloc's experimental
> status as of 4.19 and the very rare combination of the bigalloc and inline
> features.

All now reverted, thanks!

greg k-h
