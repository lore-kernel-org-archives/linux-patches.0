Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096B28F55
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 09:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4FCC3277C;
	Thu, 21 Sep 2023 09:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695288515;
	bh=G/72W3XROjiLdSNgpem2NRDz21XAzQQ3FBgC/VZh1ns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rcpSjpDf8bAjNr6mw/tuRsf7aUwg01DB8upwdLLC5epVhSnzSedmrb3CuVtVskfJg
	 rr8t7G1UqxNH6W1U9bDbTp6uv694aotNdQQ7f0AH1ynFfE+sMYwUjK8nqcJ0cj5bRG
	 b6rhr87LRwZvI7bgkivuAfwdgiMX8HmqWX5DEC/o=
Date: Thu, 21 Sep 2023 11:28:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 083/110] netfilter: nf_tables: GC transaction API to
 avoid race with control plane
Message-ID: <2023092151-broker-studio-f608@gregkh>
References: <20230920112830.377666128@linuxfoundation.org>
 <20230920112833.527435166@linuxfoundation.org>
 <ZQr7dfIjOom3PTX+@calendula>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQr7dfIjOom3PTX+@calendula>

On Wed, Sep 20, 2023 at 04:02:29PM +0200, Pablo Neira Ayuso wrote:
> Hi Greg,
> 
> On Wed, Sep 20, 2023 at 01:32:21PM +0200, Greg Kroah-Hartman wrote:
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> Please, keep this back from 5.15, I am preparing a more complete patch
> series which includes follow up fixes for this on top of this.

Thanks, I've dropped all of these netfilter patches from this tree/queue
now.

greg k-h
