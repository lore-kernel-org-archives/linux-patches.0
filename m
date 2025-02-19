Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50AC1DE2CE;
	Wed, 19 Feb 2025 09:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957618; cv=none; b=YUSck6bk/MLYzriopIflSQ/UrXVKCY07hn+IboyGvd9QzQN9VohupHJc66VVnUXI+EbYdFOTIw1IgqejNVWcN8yYCJb2p+Uvz6MdUeEXYd1P4zSaJaoQIzRnxCHjrwNlo4qBGQIwhR2OMYjl+O2GB8Q9lRJsLNPujlQ7XjuCTCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957618; c=relaxed/simple;
	bh=9R0y3yeoS+AheQWZTkPuFpEYVnJpEy9OY4NRatWANy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MeI9Hr9aYrSrfj3G+g8PaGXMz0k5q2hqfAXEOQmvrtb4WV2tlBrq2zSZXMMqGErs8xsPcQ3XpzeC/ck7vX5Ok0lg1JflUgCNaeJJof0qw37pJvi55LVvzWBAeD4fgzYl3J1+COd9aPxRdcJ+TewSxyhXDFbRp8KodV3DqepowNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PiuTnvH6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PiuTnvH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB19EC4CED1;
	Wed, 19 Feb 2025 09:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957618;
	bh=9R0y3yeoS+AheQWZTkPuFpEYVnJpEy9OY4NRatWANy0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PiuTnvH6gI2Q4QNzs7Qo9fWlcPQoCKk6WuZ0ku1wZt/UPj5upQv+HabEhNx7blkdX
	 xV1GZIcu2dW7rUYkI8oc+N7h59cB4VFkn21630PSWcsU4K07+dVdknk7VHQyDF7CLa
	 1ty4J72qqi3uH38liTT3JRZXQ4tt4n2JFk7UQkTM=
Date: Wed, 19 Feb 2025 10:09:00 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>, Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.13 098/274] vfio/nvgrace-gpu: Read dvsec register to
 determine need for uncached resmem
Message-ID: <2025021942-scariness-quarters-03b2@gregkh>
References: <20250219082609.533585153@linuxfoundation.org>
 <20250219082613.458476146@linuxfoundation.org>
 <SA1PR12MB719961A0F0CFBF6AD3561D94B0C52@SA1PR12MB7199.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR12MB719961A0F0CFBF6AD3561D94B0C52@SA1PR12MB7199.namprd12.prod.outlook.com>

On Wed, Feb 19, 2025 at 09:00:19AM +0000, Ankit Agrawal wrote:
> Hi Greg, thanks for sending this out. One thing is that this was part
> of a 4 patch series. However, I only see 2 patches here. Are you planning
> to include them later? Following are the other 2 patches for reference:
> 3/4: https://lore.kernel.org/all/20250124183102.3976-4-ankita@nvidia.com/
> 4/4: https://lore.kernel.org/all/20250124183102.3976-5-ankita@nvidia.com/

What are the git commit ids for these changes in Linus's tree?

thanks,

greg k-h
