Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF8B6A34F;
	Tue,  5 Dec 2023 18:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNJTIJzj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EB3C433AD;
	Tue,  5 Dec 2023 18:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701800931;
	bh=qxqatAuXT0zH3n40PDThi6SP7FGeQ6fGbmVKCwpEUeI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JNJTIJzj4tfbzlTr4Y2hp+N7mAs3aQyEWZt4c/JjGd0qCeOcPOzuU5v8TMJ2C9PhX
	 gmZfQ0QvXCkJY+cUBvezLHtMOXphDQ0jNpOZGQUqVFiHR6c/E17yZ+keRbpAYMiyyB
	 AFOw35bSD0SRVgKhGs5KH3kjBHTeGe7/rCxlffdY=
Date: Wed, 6 Dec 2023 03:28:48 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sergey Shtylyov <s.shtylyov@omp.ru>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Phil Edworthy <phil.edworthy@renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 44/67] ravb: Separate handling of irq enable/disable
 regs into feature
Message-ID: <2023120635-flavored-unrelated-ce39@gregkh>
References: <20231205031519.853779502@linuxfoundation.org>
 <20231205031522.365127466@linuxfoundation.org>
 <d33f2fef-4623-1f74-0765-6998c2a65999@omp.ru>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d33f2fef-4623-1f74-0765-6998c2a65999@omp.ru>

On Tue, Dec 05, 2023 at 12:04:37PM +0300, Sergey Shtylyov wrote:
> On 12/5/23 6:17 AM, Greg Kroah-Hartman wrote:
> 
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Phil Edworthy <phil.edworthy@renesas.com>
> > 
> > [ Upstream commit cb99badde146c327f150773921ffe080abe1eb44 ]
> > 
> > Currently, when the HW has a single interrupt, the driver uses the
> > GIC, TIC, RIC0 registers to enable and disable interrupts.
> > When the HW has multiple interrupts, it uses the GIE, GID, TIE, TID,
> > RIE0, RID0 registers.
> > 
> > However, other devices, e.g. RZ/V2M, have multiple irqs and only have
> > the GIC, TIC, RIC0 registers.
> > Therefore, split this into a separate feature.
> > 
> > Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
> > Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> > Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Stable-dep-of: eac16a733427 ("net: ravb: Stop DMA in case of failures on ravb_open()")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> [...]
> 
>    This and the following patch shouldn't be necessary If you have troubles
> backporting the actual fix to 5.15, please ask me to look at it instead...

I've dropped these and did the backport myself, thanks for letting us
know.

greg k-h
