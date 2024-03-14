Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796EC433A0;
	Thu, 14 Mar 2024 08:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710403859; cv=none; b=VwAeYIn+CgSs99bLXNy+hHULeUqLAzuw6gqguRByWB24Oew8B99hLfR1Ifz+BaOxkZ2TXlYcbYPURCRSI+6FjcR5ipwrsmUbazrGh+VQTqBDSsqbmIWa8C8HTPKdugKH5cz3njFZIdv7s299pm2r3ElR+j8iXk3BFMT5YH/u838=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710403859; c=relaxed/simple;
	bh=kAqwbF4WS8v4P/C04yeKspsY1g9wvYlu2ehoJVyB4H8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aa1mPwHL0OzeyhfBS2eU2+d3FibwAxCT9LGNBa9+snrvrHFMSQGRhvFQKGNqTy6zDaUefIRu1te0Iey/nc2l7jfxuX7vCipw20b+l/pvrn49uJ5w1ORSq1petnovxowjXZMAVnVM8IjGnyfEQNlqnTuV1MgXx7gMJZZicdPl2Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J/zIVMLR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J/zIVMLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008A3C433C7;
	Thu, 14 Mar 2024 08:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710403859;
	bh=kAqwbF4WS8v4P/C04yeKspsY1g9wvYlu2ehoJVyB4H8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J/zIVMLRtjKGNVB2uvBiQY6TnXoWk+MFP5otAZVS9UtqVKRDk9v1nRbJXBfx9pb/S
	 cfi7Z+dSDR6foZz19Ot8lQajPjojpG7DnbLnB5Yi3Aoma7ohNzjsPs1fn8gbFUJuTB
	 L4qW2ybzz8w7L3ilc3dw+Bpohvyj+3atxniFHbcHFRPyfz26wmyulBplkco/L3wMCj
	 r3XqaYemR9kexKmQlqka7H/xi116cYxNLLTdHPM+Wr1a7k/qmSGqTM+zM2agcn0a9a
	 uOdUR/5SejXYk3xlnsag66Q1fBqZbEIQJPu0cqUxSDOyqVyb01Uqr645IEHxZtaA3x
	 MaGC+D3ETDWfQ==
Received: from johan by xi.lan with local (Exim 4.97.1)
	(envelope-from <johan@kernel.org>)
	id 1rkgB7-000000008Eb-3quY;
	Thu, 14 Mar 2024 09:11:06 +0100
Date: Thu, 14 Mar 2024 09:11:05 +0100
From: Johan Hovold <johan@kernel.org>
To: Yongqin Liu <yongqin.liu@linaro.org>, Sasha Levin <sashal@kernel.org>
Cc: Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Bjorn Andersson <andersson@kernel.org>,
	amit.pundir@linaro.org, sumit.semwal@linaro.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5.4 015/267] arm64: dts: qcom: sdm845: fix USB wakeup
 interrupt types
Message-ID: <ZfKxGUmi_IXjA4wA@hovoldconsulting.com>
References: <20240221125940.058369148@linuxfoundation.org>
 <20240221125940.531673812@linuxfoundation.org>
 <77f1c6a6-7756-4168-a69d-583a35abd8ab@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <77f1c6a6-7756-4168-a69d-583a35abd8ab@linaro.org>

[ +TO: Sasha ]

On Thu, Mar 14, 2024 at 01:48:36AM +0800, Yongqin Liu wrote:
> On 2024/2/21 21:05, Greg Kroah-Hartman wrote:
> > 5.4-stable review patch.  If anyone has any objections, please let me know.

> > From: Johan Hovold <johan+linaro@kernel.org>
> >
> > commit 84ad9ac8d9ca29033d589e79a991866b38e23b85 upstream.
> >
> > The DP/DM wakeup interrupts are edge triggered and which edge to trigger
> > on depends on use-case and whether a Low speed or Full/High speed device
> > is connected.
> >
> > Fixes: ca4db2b538a1 ("arm64: dts: qcom: sdm845: Add USB-related nodes")
> > Cc: stable@vger.kernel.org      # 4.20
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > Link: https://lore.kernel.org/r/20231120164331.8116-9-johan+linaro@kernel.org
> > Signed-off-by: Bjorn Andersson <andersson@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

> > --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
> > +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> > @@ -2503,8 +2503,8 @@
> >   
> >   			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
> >   				     <GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
> > -				     <GIC_SPI 488 IRQ_TYPE_LEVEL_HIGH>,
> > -				     <GIC_SPI 489 IRQ_TYPE_LEVEL_HIGH>;
> > +				     <GIC_SPI 488 IRQ_TYPE_EDGE_BOTH>,
> > +				     <GIC_SPI 489 IRQ_TYPE_EDGE_BOTH>;
> >   			interrupt-names = "hs_phy_irq", "ss_phy_irq",
> >   					  "dm_hs_phy_irq", "dp_hs_phy_irq";

> This patch only causes the db845c Android builds to fail to have the adb 
> connection setup after boot.

Indeed.

> In the serial console, the following lines are printed:

>    [    0.779411][   T79] dwc3-qcom a6f8800.usb: dp_hs_phy_irq failed: -22
>    [    0.779418][   T79] dwc3-qcom a6f8800.usb: failed to setup IRQs, 
> err=-22

> After some investigation, it's found it will work again if the following 
> two patches are applied:
>    72b67ebf9d24 ("arm64: dts: qcom: add PDC interrupt controller for 
> SDM845")
>    204f9ed4bad6 ("arm64: dts: qcom: sdm845: fix USB DP/DM HS PHY 
> interrupts")

Correct, apparently the PDC controller was not added until 5.10, which I
should have noticed and indicated in the commit message of the follow up
fix. Sorry about that.

> Could you please help to have a check and give some suggestions on what 
> patches should be back ported to the 5.4 kernel, or are the above two
> patches only good enough?

Based on a quick look at the sdm845 dtsi, the PDC driver and their
history, I think the two commits above should be enough.

Sasha, could you pick the following two commits for 5.4:

	72b67ebf9d24 ("arm64: dts: qcom: add PDC interrupt controller for SDM845")
	204f9ed4bad6 ("arm64: dts: qcom: sdm845: fix USB DP/DM HS PHY interrupts")

to fix the regression?

Johan
