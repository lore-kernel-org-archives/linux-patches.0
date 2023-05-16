Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A870C29B0
	for <patches@lists.linux.dev>; Tue, 16 May 2023 04:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6288C433D2;
	Tue, 16 May 2023 04:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684212541;
	bh=Xbx8PULHORvZXN3UWYw62kYfwMaP2SvXcXvPKP1XE4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0CR+vgtnjfZDqgYsyL3L97FVNU7MrUTbZbW0ce7O/8v82yYM3uf/T7t6OmHbFAuGM
	 1xcMBor3ytKymKUQiey9ejqe+n1Jhr1uTD1wj5qHQmXyq91ZIfhTbqVUTLhWeQCjSi
	 3t/M4gvYrs7EXjv+BV0k+jozvUXBgl7TbK9BG+tM=
Date: Tue, 16 May 2023 06:48:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.2 092/242] net: bcmgenet: Remove phy_stop() from
 bcmgenet_netif_stop()
Message-ID: <2023051640-collision-slouchy-30bf@gregkh>
References: <20230515161721.802179972@linuxfoundation.org>
 <20230515161724.671015328@linuxfoundation.org>
 <a7843640-7fc9-379f-8a21-a2e599f742d8@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7843640-7fc9-379f-8a21-a2e599f742d8@gmail.com>

On Mon, May 15, 2023 at 08:42:31PM -0700, Florian Fainelli wrote:
> 
> 
> On 5/15/2023 9:26 AM, Greg Kroah-Hartman wrote:
> > From: Florian Fainelli <f.fainelli@gmail.com>
> > 
> > [ Upstream commit 93e0401e0fc0c54b0ac05b687cd135c2ac38187c ]
> > 
> > The call to phy_stop() races with the later call to phy_disconnect(),
> > resulting in concurrent phy_suspend() calls being run from different
> > CPUs. The final call to phy_disconnect() ensures that the PHY is
> > stopped and suspended, too.
> > 
> > Fixes: c96e731c93ff ("net: bcmgenet: connect and disconnect from the PHY state machine")
> > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Please drop this patch until
> https://lore.kernel.org/lkml/20230515025608.2587012-1-f.fainelli@gmail.com/
> is merged, thanks!

Now dropped from all queues.  Let us know when this fix is merged so we
can queue them both up.

thanks,

greg k-h
