Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E7E32C95
	for <patches@lists.linux.dev>; Thu, 19 Oct 2023 17:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="faHvt+AO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4FBC433CB;
	Thu, 19 Oct 2023 17:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697736238;
	bh=Rxqh903u0A4sdT96drARWgDv8MSls0oBQDuqLALNZ3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=faHvt+AOx5Vcf3zy/oEQdieoD7MTbCw2+UfqfIU69OD87n3OCC4HIEXB3zTl3aTrt
	 cAw44dLU/XdsEQzCmYht/lvTIR4K831VA80lu8fCnTQG6ylQUa8kq3YSuifJxT2ltm
	 SZ2h500AwmiwJE3i9iVD5xgaixTdo5UMgA7RAJHU=
Date: Thu, 19 Oct 2023 19:23:55 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Simon Horman <horms@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.5 082/191] ethtool: Fix mod state of verbose no_mask
 bitset
Message-ID: <2023101950-pogo-stoning-0d0d@gregkh>
References: <20231016084015.400031271@linuxfoundation.org>
 <20231016084017.315801421@linuxfoundation.org>
 <20231019092859.051ca34b@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019092859.051ca34b@kernel.org>

On Thu, Oct 19, 2023 at 09:28:59AM -0700, Jakub Kicinski wrote:
> On Mon, 16 Oct 2023 10:41:07 +0200 Greg Kroah-Hartman wrote:
> > A bitset without mask in a _SET request means we want exactly the bits in
> > the bitset to be set. This works correctly for compact format but when
> > verbose format is parsed, ethnl_update_bitset32_verbose() only sets the
> > bits present in the request bitset but does not clear the rest. The commit
> > 6699170376ab fixes this issue by clearing the whole target bitmap before we
> > start iterating. The solution proposed brought an issue with the behavior
> > of the mod variable. As the bitset is always cleared the old val will
> > always differ to the new val.
> > 
> > Fix it by adding a new temporary variable which save the state of the old
> > bitmap.
> 
> This one got reverted / needs more work. 
> Please drop across the branches.

Now dropped, thanks.

greg k-h
