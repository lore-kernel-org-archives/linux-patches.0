Received: from hall.aurel32.net (hall.aurel32.net [195.154.113.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D216148304;
	Sun,  9 Feb 2025 13:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.154.113.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739108757; cv=none; b=dDntkgtrrFi1xyxzPcFnJ2r7SThBSyf5cK81yTY3aN4ETtwuJamv+heMQ/7DzOzztheyOLWcuW9VO1ppWFnZfdWEeUibJ4scDWPIxCk+Gu/1K1Mt0NnrBcR7J1PISfbiGb59V8qWG8KrxsdTv2+xmzWV8VdYsOGuuZkf62/Bm2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739108757; c=relaxed/simple;
	bh=mpadslC3Y18hp4rMCA9uDRUbrl9f+GH5PCw3OLZAj/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a3lqsUauuTc8Xu3YmHbewjVUxIqndVSuDiPqdheTbpeL88x8NA+ZhrToQa8s8Z3OfTx/awTN6Wb8r5RIHERm2TcDesyRO8bIGHlAUz5UYP82vPqbfN9kRjpqk0VjH3gkzHcQPr5RrjtpNEXuKFVICrboCU7frIjyT/SkpCNlcOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net; spf=pass smtp.mailfrom=aurel32.net; dkim=pass (2048-bit key) header.d=aurel32.net header.i=@aurel32.net header.b=y0KFlruF; arc=none smtp.client-ip=195.154.113.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aurel32.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aurel32.net header.i=@aurel32.net header.b="y0KFlruF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
	; s=202004.hall; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:From:Reply-To:
	Subject:Content-ID:Content-Description:X-Debbugs-Cc;
	bh=SnH+OYnhYIkCU2RM7qdGCNaQEjHiMO33pJewhtlNxe8=; b=y0KFlruFPBfUP160CyUMfjGOIT
	MInQVI2/dlxQFksjTzLzpi4/fVVX7HAVFywvBLkvDWGxvt7e7orwNJBwVwXpfI19CZ0lERgtvY+zd
	x9KVhz6Uf3flDzptxLonEy2pjWs4mU5+BUwWTz6yTMoEnu2ghh3xcX8rvPIITitkrGqKkZ21vy7pO
	HShbBSqTp/pEBWPBAoX3tBeD+0W7Ac2GbMWcdADlaXmBXKYkI2BCv68OWU2H/vf209QyRgQQBQvf+
	Vn67RZ4qZ15BKHVNNNZhaXYOb4JGq8alyFOIPQOCbxpqG65ofJDxkq5etxiCvAbhkjxAMAAIShz8t
	xO2emA4A==;
Received: from [2a01:e34:ec5d:a741:1ee1:92ff:feb4:5ec0] (helo=ohm.rr44.fr)
	by hall.aurel32.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <aurelien@aurel32.net>)
	id 1th7MR-00BMal-20;
	Sun, 09 Feb 2025 14:28:35 +0100
Date: Sun, 9 Feb 2025 14:28:34 +0100
From: Aurelien Jarno <aurelien@aurel32.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Michael Zimmermann <sigmaepsilon92@gmail.com>,
	Chukun Pan <amadeus@jmu.edu.cn>, Heiko Stuebner <heiko@sntech.de>,
	Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 6.12 026/114] phy: rockchip: naneng-combphy: fix phy reset
Message-ID: <Z6itgi4kAoNWi0y_@aurel32.net>
References: <20241230154218.044787220@linuxfoundation.org>
 <20241230154219.070199198@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241230154219.070199198@linuxfoundation.org>
User-Agent: Mutt/2.2.13 (2024-03-09)

On 2024-12-30 16:42, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.

It probably comes a bit late, but this patch broke usb and pcie on
rk356x. The other commit from the same series, commit 8b9c12757f91
("arm64: dts: rockchip: add reset-names for combphy on rk3568"), also
needs to be backported.

Regards
Aurelien

> ------------------
> 
> From: Chukun Pan <amadeus@jmu.edu.cn>
> 
> commit fbcbffbac994aca1264e3c14da96ac9bfd90466e upstream.
> 
> Currently, the USB port via combophy on the RK3528/RK3588 SoC is broken.
> 
>   usb usb8-port1: Cannot enable. Maybe the USB cable is bad?
> 
> This is due to the combphy of RK3528/RK3588 SoC has multiple resets, but
> only "phy resets" need assert and deassert, "apb resets" don't need.
> So change the driver to only match the phy resets, which is also what
> the vendor kernel does.
> 
> Fixes: 7160820d742a ("phy: rockchip: add naneng combo phy for RK3568")
> Cc: FUKAUMI Naoki <naoki@radxa.com>
> Cc: Michael Zimmermann <sigmaepsilon92@gmail.com>
> Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> Tested-by: FUKAUMI Naoki <naoki@radxa.com>
> Link: https://lore.kernel.org/r/20241122073006.99309-2-amadeus@jmu.edu.cn
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/phy/rockchip/phy-rockchip-naneng-combphy.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
> +++ b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
> @@ -309,7 +309,7 @@ static int rockchip_combphy_parse_dt(str
>  
>  	priv->ext_refclk = device_property_present(dev, "rockchip,ext-refclk");
>  
> -	priv->phy_rst = devm_reset_control_array_get_exclusive(dev);
> +	priv->phy_rst = devm_reset_control_get(dev, "phy");
>  	if (IS_ERR(priv->phy_rst))
>  		return dev_err_probe(dev, PTR_ERR(priv->phy_rst), "failed to get phy reset\n");
>  
> 
> 

-- 
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                     http://aurel32.net
