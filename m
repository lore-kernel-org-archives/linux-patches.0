Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822BB567E
	for <patches@lists.linux.dev>; Sun, 28 May 2023 17:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA068C433D2;
	Sun, 28 May 2023 17:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685295329;
	bh=YPrjMgTd0UJs8mXQk7CD4ANdMAgl9Ghx/lgIlx93Lno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CHNoDMRTocUskQNl6Rde69HYEiOBgjuPGqZ9PnICwirYkjs+UCLrORiqtSA+rkQjF
	 7hD4R7bqPAUfGCNEJaGUBhHL4nj6ax5tx5R44quP5O8h8rXj6vFdQCdtoGUiNWofQ4
	 mi3KwQ6NY7bLwA7Xmj4vAT/zksZfWIjlC1cfJEZo=
Date: Sun, 28 May 2023 18:35:26 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Liu Ying <victor.liu@nxp.com>, Marek Vasut <marex@denx.de>,
	Shawn Guo <shawnguo@kernel.org>, Sasha Levin <sashal@kernel.org>,
	kernel@pengutronix.de
Subject: Re: [PATCH 6.3 169/694] arm64: dts: imx8mp: Drop simple-bus from
 fsl,imx8mp-media-blk-ctrl
Message-ID: <2023052819-unnerve-raving-0f24@gregkh>
References: <20230508094432.603705160@linuxfoundation.org>
 <20230508094437.900924742@linuxfoundation.org>
 <20230523-justly-situated-317e792f4c1b-mkl@pengutronix.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523-justly-situated-317e792f4c1b-mkl@pengutronix.de>

On Tue, May 23, 2023 at 05:47:41PM +0200, Marc Kleine-Budde wrote:
> Hello Greg,
> 
> can you please revert this patch, without the corresponding driver patch
> [1] it breaks probing of the device, as no one populates the sub-nodes.
> 
> [1] 9cb6d1b39a8f ("soc: imx: imx8m-blk-ctrl: Scan subnodes and bind drivers to them")

Sorry for the delay, now reverted.

greg k-h
