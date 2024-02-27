Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5115F13B2B8;
	Tue, 27 Feb 2024 13:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040617; cv=none; b=Nnu2RtWyKNm+WdJLhGDmtQgTtfzycRz/zSUqWWlmgMdtyBC6NtzBloe0K0yQBVKsP9Scy3Ci1vtsl3G9E2FLACBvbOoAP5njNRy0IpW6bMm+Vy5TxadlEZ+H/LjZZpwZhoRr9CzhnWSCcIpPdXqbKsQg99wHnMaOx9cpTib1AUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040617; c=relaxed/simple;
	bh=mM8sRygUV0q4FoHx9HID+Xv9BcE3ytl2wNdaB8DuPxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSrrffm0m5qPGtEEBgyHiJv+z4KVwPSufE/T+rJsuxW+MKhwNw8fjXWsBBPPHqYDd3B3rKhN78fI+hU2DACSZYR3EO6RQ1U/PcLw7VsXZ3+zXd4zkQiiAZdPwSdngpTYFUDADTJ25tytAG5HhB1YdVO6Mq8BAflgTjjdp6Nl80c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/5H25mc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/5H25mc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F441C433C7;
	Tue, 27 Feb 2024 13:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040616;
	bh=mM8sRygUV0q4FoHx9HID+Xv9BcE3ytl2wNdaB8DuPxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/5H25mcN0uGBMF+fy7l0zqKYeIcHid+qEYzOKrJvei6dev+NGJQGDxxn36+IezW1
	 om2wGCn397P1S0uisoC+j/5R+stj+tkrr67G4+W/Nt3tQz2kC6bjUx0oWjj8POlDOk
	 1Yx7CFP9RTnKzJYq/xWiLOm6v9zi7mfspV7070u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@csie.org>,
	Andre Przywara <andre.przywara@arm.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 048/334] ASoC: sunxi: sun4i-spdif: Add support for Allwinner H616
Date: Tue, 27 Feb 2024 14:18:26 +0100
Message-ID: <20240227131632.137426122@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 0adf963b8463faa44653e22e56ce55f747e68868 ]

The SPDIF hardware block found in the H616 SoC has the same layout as
the one found in the H6 SoC, except that it is missing the receiver
side.

Since the driver currently only supports the transmit function, support
for the H616 is identical to what is currently done for the H6.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://msgid.link/r/20240127163247.384439-4-wens@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sunxi/sun4i-spdif.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/sunxi/sun4i-spdif.c b/sound/soc/sunxi/sun4i-spdif.c
index 702386823d172..f41c309558579 100644
--- a/sound/soc/sunxi/sun4i-spdif.c
+++ b/sound/soc/sunxi/sun4i-spdif.c
@@ -577,6 +577,11 @@ static const struct of_device_id sun4i_spdif_of_match[] = {
 		.compatible = "allwinner,sun50i-h6-spdif",
 		.data = &sun50i_h6_spdif_quirks,
 	},
+	{
+		.compatible = "allwinner,sun50i-h616-spdif",
+		/* Essentially the same as the H6, but without RX */
+		.data = &sun50i_h6_spdif_quirks,
+	},
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, sun4i_spdif_of_match);
-- 
2.43.0



