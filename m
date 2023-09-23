Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC75CA68
	for <patches@lists.linux.dev>; Sat, 23 Sep 2023 08:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E37C433C8;
	Sat, 23 Sep 2023 08:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695456882;
	bh=WvgyNFNZBu/cYYw8P3bLJ8movCPzdtbT9Bj899QTBuc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KQq/CTr5zRa491De7Za4oYCC7LP+0ycCXDZFyKV4L0onNUJsB2pa9OunoC+IHn0aL
	 4rJKUgPXzJ7yVimc9Rx5EirwcDofvjEbq+dfc0UQUO26db/fPthm+O0cdTMufJkTX1
	 X6wm8KsQzbz7KTrmy1YT0IMJZiUS0eRnqeawCiKw=
Date: Sat, 23 Sep 2023 10:14:40 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.5 025/211] net: stmmac: use per-queue 64 bit statistics
 where necessary
Message-ID: <2023092321-announcer-punctured-2f9f@gregkh>
References: <20230920112845.859868994@linuxfoundation.org>
 <20230920112846.582111163@linuxfoundation.org>
 <c54b9b67-96c7-cdbc-5910-61b1d267fbd2@leemhuis.info>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c54b9b67-96c7-cdbc-5910-61b1d267fbd2@leemhuis.info>

On Wed, Sep 20, 2023 at 02:53:38PM +0200, Thorsten Leemhuis wrote:
> On 20.09.23 13:27, Greg Kroah-Hartman wrote:
> > 6.5-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jisheng Zhang <jszhang@kernel.org>
> > 
> > [ Upstream commit 133466c3bbe171f826294161db203f7670bb30c8 ]
> 
> This patch causes a regression in mainline:
> https://lore.kernel.org/all/20230911171102.cwieugrpthm7ywbm@pengutronix.de/
> 
> A fix is heading towards mainline now:
> https://lore.kernel.org/all/20230917165328.3403-1-jszhang@kernel.org/
> 
> Jisheng Zhang already mentioned this and also mentioned that the change
> depends on another commit not yet backported:
> https://lore.kernel.org/all/ZQHKiU6SNtq7t1Fi@xhacker/
> 
> Something feels wrong here; not sure if it is or if I'm missing something.
> 
> Ciao, Thorsten (who only noticed this by chance)

Thanks, I've dropped this now from the 6.5.y queue.

greg k-h
