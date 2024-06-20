Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B798820B35;
	Thu, 20 Jun 2024 16:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718901535; cv=none; b=GpVN1TyKzMWkILPrtXMELpcEg5W+l3+WPctdAQ6+bFGgKgGlFdQcGUSVnG0d+9AWdZ37mYkG2LddXPo9gGaGAL0kfBk0HPucCtslhjLXIt/uUQ6vRmQdVGYEi5KDid4yAV8yeEqcv2+bgl4ylR56H6mgJ+a5Mh/aXMceZr4hHMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718901535; c=relaxed/simple;
	bh=vhy5M7zlHVNgDl+MuSd5eVL0wMhSo8/DXGAueZ30huc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=MrFXFDPLq01s6E4cGscCuMWVzVTvjQryRfk6UVzbUa40W5tPTtAcqmNbILsJhhR3h7QVPYeu4f8gOs1scFJn1KUrFAEhpzZQZeXl9Kdzqs54rPuwq1RDBq1d3whiK8PSTcV/WgWrNgQHEs5dJSWn5yjqjabv/fxpu352FVrRfqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FLV1xGEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FLV1xGEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008E3C4AF0D;
	Thu, 20 Jun 2024 16:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718901535;
	bh=vhy5M7zlHVNgDl+MuSd5eVL0wMhSo8/DXGAueZ30huc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=FLV1xGECaLMGc0QBdBtHod/nyM41QR4hWvPhKzXHZLX57aqJ/BbYrzeY0JIa1rX0v
	 PebxGHjVepPx6uWlu2lqqjz5cxa/5G1sLPV+nLM4IOuOpxOZjBEZ9GJ1UN23dkZD5E
	 CbhlMvubFwj2X6+P6I7RATiFbhJesvFOb3K/XVIL5XX3siKObhTk6Kx6eH9RwUH2nt
	 rLgwImMSAPUVhWMVM+ikRBf0ZvqBkA89ETAfyyE4w1oTlKV8tsBzIna5OUv9GY5sA5
	 9+9WeZAiCgrgJs1uVg1ss40ZL5K8K6Su9gg/TGmQETyrIYtuoX+lMhhnXudfIYnIZF
	 tYaPlMXnb8Wzw==
From: Vinod Koul <vkoul@kernel.org>
To: Kishon Vijay Abraham I <kishon@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>
Cc: Shawn Guo <shawnguo@kernel.org>, Sascha Hauer <s.hauer@pengutronix.de>, 
 Pengutronix Kernel Team <kernel@pengutronix.de>, 
 Fabio Estevam <festevam@gmail.com>, Frank Li <Frank.Li@nxp.com>, 
 Richard Zhu <hongxing.zhu@nxp.com>, linux-phy@lists.infradead.org, 
 imx@lists.linux.dev, patches@lists.linux.dev
In-Reply-To: <20240620-phy-fsl-imx8qm-hsio-add-bitfield-include-v1-1-5c7c09ed87e6@kernel.org>
References: <20240620-phy-fsl-imx8qm-hsio-add-bitfield-include-v1-1-5c7c09ed87e6@kernel.org>
Subject: Re: [PATCH] phy: freescale: imx8qm-hsio: Include bitfield.h for
 FIELD_PREP
Message-Id: <171890153156.219744.4144352903595964774.b4-ty@kernel.org>
Date: Thu, 20 Jun 2024 22:08:51 +0530
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13.0


On Thu, 20 Jun 2024 08:21:15 -0700, Nathan Chancellor wrote:
> In various configurations/architectures, bitfield.h may not be
> transitively included, which results in a compiler error because
> FIELD_PREP is an unexpanded macro:
> 
>   drivers/phy/freescale/phy-fsl-imx8qm-hsio.c:459:8: error: call to undeclared function 'FIELD_PREP'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     459 |         val = FIELD_PREP(HSIO_MODE_MASK, val);
>         |               ^
>   1 error generated.
> 
> [...]

Applied, thanks!

[1/1] phy: freescale: imx8qm-hsio: Include bitfield.h for FIELD_PREP
      commit: aefa036be8c216c8b344d34c9f35ff907b9c315a

Best regards,
-- 
Vinod Koul <vkoul@kernel.org>

