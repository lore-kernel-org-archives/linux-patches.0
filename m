Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1FB25A634;
	Wed,  9 Apr 2025 07:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185572; cv=none; b=m0bsyzonE1gfFBqNi7lQAHBaW/l5rzXKuhzq9ajsIICWbiW3Kb5Y4a30Lv4A799vmeeHO3WHc8ToFHGJmq0OOT5s/W1hx6z7KCAz4HqKWzrzxREaxyesStJllqOFnlX4G4dv7ErMN5ATQnxNH4rMY4/DDcDpawnwkVGe9lebXqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185572; c=relaxed/simple;
	bh=XDIuw2eA39Y1DwGDBE09n9tOcS+PpzVXTc2Xi1f16CM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wwagj1H5lVTkArJmNziGlU0yUE7t28ilrs+e9ckQL/VKhbuifRpgF6pvHLhU4B+BLA31EP2tSaumQUkAMIu+rZmLKZLujrUH5NsjdYchRMIwCJ7FJ2x+ItkIQGUG7qUB+iZmflUUfeiGjpRT17BtdQ4PwnG1b6m6UK8YTAlgZD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bcgeCiW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bcgeCiW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A25C4CEE3;
	Wed,  9 Apr 2025 07:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744185571;
	bh=XDIuw2eA39Y1DwGDBE09n9tOcS+PpzVXTc2Xi1f16CM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bcgeCiW6etYmu653IWZILTIGmWnifuR0L5GBjsgLmeWs7XMi+snzn3w1I46DQWzXf
	 F+yCxcBBqw6MXkvOiIB0bg1IQxAPwMBOTiPi6adxMMGpwxfV5U7pBPloF4maZ73YgR
	 wH/fCGGBqCq0SinltmSQrwIDylFiVS4giUpbqlfw=
Date: Wed, 9 Apr 2025 09:57:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 103/731] arm64: dts: mediatek: mt6359: fix
 dtbs_check error for audio-codec
Message-ID: <2025040938-improve-stylishly-1759@gregkh>
References: <20250408104914.247897328@linuxfoundation.org>
 <20250408104916.668060636@linuxfoundation.org>
 <850ee9aa-a41f-4bbb-9b60-6b2e84ba9b0f@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <850ee9aa-a41f-4bbb-9b60-6b2e84ba9b0f@kernel.org>

On Wed, Apr 09, 2025 at 09:04:40AM +0200, Jiri Slaby wrote:
> On 08. 04. 25, 12:40, Greg Kroah-Hartman wrote:
> > 6.14-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Macpaul Lin <macpaul.lin@mediatek.com>
> > 
> > [ Upstream commit 76b35f59bbe66d3eda8a98021bc01f9200131f09 ]
> > 
> > This change fixes these dtbs_check errors for audio-codec:
> > 1. pmic: 'mt6359codec' does not match any of the regexes: 'pinctrl-[0-9]+'
> >   - Replace device node name to generic 'audio-codec'
> > 2. pmic: regulators: 'compatible' is a required property
> >   - Add 'mediatek,mt6359-codec' to compatible.
> > 
> > Fixes: 3b7d143be4b7 ("arm64: dts: mt6359: add PMIC MT6359 related nodes")
> > Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> > Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> > Link: https://lore.kernel.org/r/20250217113736.1867808-1-macpaul.lin@mediatek.com
> > Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   arch/arm64/boot/dts/mediatek/mt6359.dtsi | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/boot/dts/mediatek/mt6359.dtsi b/arch/arm64/boot/dts/mediatek/mt6359.dtsi
> > index 150ad84d5d2b3..7b10f9c59819a 100644
> > --- a/arch/arm64/boot/dts/mediatek/mt6359.dtsi
> > +++ b/arch/arm64/boot/dts/mediatek/mt6359.dtsi
> > @@ -15,7 +15,8 @@
> >   			#io-channel-cells = <1>;
> >   		};
> > -		mt6359codec: mt6359codec {
> > +		mt6359codec: audio-codec {
> 
> This needs a change in the driver too:
>   79c080c75cdd ASoC: mediatek: mt6359: Fix DT parse error due to wrong child
> node name
> 
> to actually fix it.

Yes, good catch, I forgot to update my kernel commit database, I've now
caught this, thanks!

greg k-h
