Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A76C16423;
	Tue, 27 Feb 2024 14:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042551; cv=none; b=QF0D3cIUuFmPW8+iHTE5/C4bp1yUDhxrA/YSNavntF0fQk4aCYPDO1dZtvK18CCnL9AyoLy4PDJrKl2RvwOnJuc1/WD0XrLC+wYlNQCzn4cNua1OslfZdMUhEC8LsH9tGjOQ0Kpj2Kuvn01EFAWXEERlspy1e1oAgyiIeyqM6GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042551; c=relaxed/simple;
	bh=VnHSnlfvV21hIq7tWrweshDeCboUZncTJBFjOYPrny4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l76RyHXN8v57GPt/4Jj77S+S76JqRHzsD4NSe7nxhrVDGQZ4Bx6taQ+ZxwSb3vNoJnLNbPZ7MVwULN+rBoaNHPjic8xr4nTCEt5g4M5DuETFTGOgHmIW+jrWm0LMtybCxqspa2n6hryxjqj2hgCNQ6T6JxtTNg3tmWwr/Wb6mgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wE89x0TS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wE89x0TS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFDDC433F1;
	Tue, 27 Feb 2024 14:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042551;
	bh=VnHSnlfvV21hIq7tWrweshDeCboUZncTJBFjOYPrny4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wE89x0TSakqcFpHfHMpCtA3VMl65ObHJSdjuCCTkU4k9cWimGs8VeSw3dwQfV5dE4
	 R/3L/3h8gK3nbE2CbnJW5J7rFTDRCHRp6+A+PtPcfrIrSfVxsAFx5D7l9qln8eYubn
	 ByatpEgowovmw+NqCNg+bKpQ4ZVljCQhFVtTz1OE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@csie.org>,
	Andre Przywara <andre.przywara@arm.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/245] ASoC: sunxi: sun4i-spdif: Add support for Allwinner H616
Date: Tue, 27 Feb 2024 14:23:45 +0100
Message-ID: <20240227131616.325507404@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a10949bf0ca1e..dd8d13f3fd121 100644
--- a/sound/soc/sunxi/sun4i-spdif.c
+++ b/sound/soc/sunxi/sun4i-spdif.c
@@ -464,6 +464,11 @@ static const struct of_device_id sun4i_spdif_of_match[] = {
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



