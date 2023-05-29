Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FD77C
	for <patches@lists.linux.dev>; Mon, 29 May 2023 08:38:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16216C433EF;
	Mon, 29 May 2023 08:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685349496;
	bh=co0Q5zSVrFl2R8yhgOALbtMZ6WJdNRvM4cPONKbisjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sJEz0EfKvlHFBE3CMcN+7UXaQSNw3J8oFI+JP4rnu3mi3zs3J6SN6t0BLM3MDrIM+
	 JFZjPTMU2TS3Rh94x+N0CoOdwznKcoFQ8zHvF9LS30lDM0Lp9SPC8DPDLzI/Ot6MwO
	 ntpOy4Vubz20ZPaFc3tXptGg0ubC4Qj4sjPIXXNw=
Date: Mon, 29 May 2023 09:38:14 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Marek Vasut <marex@denx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Liu Ying <victor.liu@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.3 127/127] Revert "arm64: dts: imx8mp: Drop simple-bus
 from fsl,imx8mp-media-blk-ctrl"
Message-ID: <2023052956-aroma-attach-88d3@gregkh>
References: <20230528190836.161231414@linuxfoundation.org>
 <20230528190840.351644456@linuxfoundation.org>
 <511be6c7-7e58-02a9-46fa-e9a134eac8af@denx.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511be6c7-7e58-02a9-46fa-e9a134eac8af@denx.de>

On Mon, May 29, 2023 at 01:48:05AM +0200, Marek Vasut wrote:
> On 5/28/23 21:11, Greg Kroah-Hartman wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This reverts commit bd2573ee0f91c0e6d2bee8599110453e2909060e which is
> > commit 5a51e1f2b083423f75145c512ee284862ab33854 upstream.
> > 
> > Marc writes:
> > 	can you please revert this patch, without the corresponding driver patch
> > 	[1] it breaks probing of the device, as no one populates the sub-nodes.
> > 
> > 	[1] 9cb6d1b39a8f ("soc: imx: imx8m-blk-ctrl: Scan subnodes and bind
> > 	drivers to them")
> 
> Would it make more sense to pick the missing blk-ctrl patch instead ?

If you want that to happen, sure, but it seems like a new feature to me,
right?

thanks,

greg k-h
