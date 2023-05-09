Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF8F392
	for <patches@lists.linux.dev>; Tue,  9 May 2023 02:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC49C433EF;
	Tue,  9 May 2023 02:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683600878;
	bh=Pm3swEpylNNAzrRsJmjnPHjEk2Ho0phvdiqPLP3EWzQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HQ0vievGJQ+KDjvDQiMMD7ZvCf1LEwfcCO/g4ZMUFRKunsVTpjsTCau5yNd5uqYqI
	 w4tiDECUF69m0bt8FJlqG42UlSSK9YnLs0krmAmlYQy8dtnV2u9V+X39IKbNMIWnSM
	 +C2arxzXhqyaPNc/E1ks3yQNqhA6misRg/wkGYNE=
Date: Tue, 9 May 2023 04:54:35 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Conor Dooley <conor@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>, Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.2 500/663] spi: bcm63xx: remove PM_SLEEP based
 conditional compilation
Message-ID: <2023050915-iphone-frustrate-3b20@gregkh>
References: <20230508094428.384831245@linuxfoundation.org>
 <20230508094444.763317964@linuxfoundation.org>
 <20230508-curtsy-vision-018e07a7ff85@spud>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508-curtsy-vision-018e07a7ff85@spud>

On Mon, May 08, 2023 at 11:25:13PM +0100, Conor Dooley wrote:
> On Mon, May 08, 2023 at 11:45:26AM +0200, Greg Kroah-Hartman wrote:
> > From: Dhruva Gole <d-gole@ti.com>
> > 
> > [ Upstream commit 25f0617109496e1aff49594fbae5644286447a0f ]
> > 
> > Get rid of conditional compilation based on CONFIG_PM_SLEEP because
> > it may introduce build issues with certain configs where it maybe disabled
> > This is because if above config is not enabled the suspend-resume
> > functions are never part of the code but the bcm63xx_spi_pm_ops struct
> > still inits them to non-existent suspend-resume functions.
> > 
> > Fixes: b42dfed83d95 ("spi: add Broadcom BCM63xx SPI controller driver")
> > 
> > Signed-off-by: Dhruva Gole <d-gole@ti.com>
> > Link: https://lore.kernel.org/r/20230420121615.967487-1-d-gole@ti.com
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This breaks the build on RISC-V.
> 
> Seems to be messing around happening on the same patch in 6.1 w/ a fixup
> patch, but sounds like the fixup didn't apply properly either:
> https://lore.kernel.org/stable/2023050845-pancreas-postage-5769@gregkh/

Ok, let me drop this patch, and the add-on one, from all branches now
and push out a -rc2.

thanks,

greg k-h
