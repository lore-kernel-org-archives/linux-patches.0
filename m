Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D141915AE8;
	Wed, 20 Sep 2023 11:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAEDC433C7;
	Wed, 20 Sep 2023 11:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695208564;
	bh=lnb0O1ksQMJ7rJw1NAKO+dUYTXlWkz3GfIFHZ4hjhYw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hRpFtbRooXyjFa0r5RNeNmIgeYTw6ZeBzweQfv2VXCt+CXluRcoGptjDCBFLqGNQE
	 rI+uyvPzuwHnB+vjJow0Oh53grNRxT8JIvmHwWR1+UR7lH/XBoMhaL/M67wMqmAUSo
	 ruPUpZGkpO0u7KjxmPUYyEZFa/aVb7nxkoxappq4=
Date: Wed, 20 Sep 2023 13:16:02 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Shakeel Butt <shakeelb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
	mathieu.tortuyaux@gmail.com
Subject: Re: [REGRESSION] Re: [PATCH 6.1 033/219] memcg: drop
 kmem.limit_in_bytes
Message-ID: <2023092016-shield-confused-0e12@gregkh>
References: <20230917191040.964416434@linuxfoundation.org>
 <20230917191042.204185566@linuxfoundation.org>
 <20230920081101.GA12096@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ZQqwzK/fDm+GLiKM@dhcp22.suse.cz>
 <2023092032-applied-gave-0bff@gregkh>
 <76525b1a-6857-434d-86ee-3c2ff4db0e4c@linux.microsoft.com>
 <2023092044-porthole-impeding-e539@gregkh>
 <ZQrSu8lfwkk/nNxi@dhcp22.suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQrSu8lfwkk/nNxi@dhcp22.suse.cz>

On Wed, Sep 20, 2023 at 01:08:43PM +0200, Michal Hocko wrote:
> On Wed 20-09-23 12:45:08, Greg KH wrote:
> [...]
> > Ok, then we should revert this, I'll go drop it in the stable trees, it
> > should also be reverted in Linus's tree too.
> 
> A simple revert would break other users as noted in other response so
> wait with sending reverts to Linus before we agreen on the least painful
> solution.

A revert should cause the systems that stopped working to start working
again, so I'll keep the revert in the stable trees and wait for you to
work out the real solution in Linus's tree and then backport all of them
as needed.

thanks,

greg k-h
