Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B52620E8
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 09:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78008C433EF;
	Tue,  7 Feb 2023 09:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675762817;
	bh=6/9Lj6y5xOYeQxMAtMK/R5NOKE91tchlanJE3TNhY0Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wbv0j0LJIRptJbPHFgf8AtEMVWNRFyQSD5BypsLDNQj9iRSnhZR0q+ZpSwXuPXI6p
	 8qxhe4L8Kz0WNnFEO0H1sfCLzhhReRhtD4uWfKDWAgmgh2BsNQ0ncBEPnNZSWJjN5/
	 /EsL6RBFQQUTXRYcxsvLpcJvsUcl38G7YGczLL0c=
Date: Tue, 7 Feb 2023 10:40:10 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Shaoying Xu <shaoyi@amazon.com>
Cc: dsahern@kernel.org, idosch@nvidia.com, kuba@kernel.org,
	patches@lists.linux.dev, sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH stable 5.4 1/2] Revert "ipv4: Fix incorrect route
 flushing when source address is deleted"
Message-ID: <Y+IcelCxZufB92VE@kroah.com>
References: <20221212130920.482075438@linuxfoundation.org>
 <20230205053100.15903-1-shaoyi@amazon.com>
 <20230205053100.15903-2-shaoyi@amazon.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230205053100.15903-2-shaoyi@amazon.com>

On Sun, Feb 05, 2023 at 05:30:59AM +0000, Shaoying Xu wrote:
> This reverts commit 2537b637eac0bd546f63e1492a34edd30878e8d4.
> 
> Signed-off-by: Shaoying Xu <shaoyi@amazon.com>

We need a reason why this revert happens please.  Perhaps put the
information you have in the previous email in this thread in here?

thanks,

greg k-h
