Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC191419A0;
	Tue, 27 Feb 2024 14:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043241; cv=none; b=Psb+NxqnUmsYbl2V7VPAswcnFJ06bf1kTR4F3Y2RYzzleFF/6RxEWw5UKPM/XAZeWRoub/wMcn75kapWEZ6UFsB8P8ZbeX6UaV8jQ5PZ6UqchQibVfWKvlgPTLDNrsFDEkWxiWVO/HE+4w3nwNH98loRuKJABLc8NLSOiWXedio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043241; c=relaxed/simple;
	bh=LBuDpYgiD1S+BPhgN7yH9dBNlFpXak5js+TtLj397OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRBYS2OHfHElknDXv94ErJOnJAJp7BLX844hCGo31A1mzvOH8dgU9slysBZ1WZ4rDcuxhKtKMEy+a/jSP6KFDBp0P6F/nK3/DnO6TfIoIhkarftByrZN6Jbk3LTC+GEuUiYhmEtGSozHm4+JMmVRn8TjYQtXSvJTKvu7VF1Byj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlUSwznH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlUSwznH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0032C433F1;
	Tue, 27 Feb 2024 14:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043241;
	bh=LBuDpYgiD1S+BPhgN7yH9dBNlFpXak5js+TtLj397OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlUSwznH8RZHC5eqfrOHGFyuiJVDESlmlrnFbw842jhhz3tLyLLn8YWOImLAS7iRb
	 qWBLc92KYMp6jqUyA5Es6DgrcbkM61cJak9vDRzbSncEN/NmUmzjV+AAlGH/t8M7BD
	 cssoMvk6KwKcN4nlSAjkSZmSrcQWtf3yTfZ3cx6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@csie.org>,
	Andre Przywara <andre.przywara@arm.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/195] ASoC: sunxi: sun4i-spdif: Add support for Allwinner H616
Date: Tue, 27 Feb 2024 14:24:56 +0100
Message-ID: <20240227131611.550589187@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bcceebca915ac..484b0e7c2defa 100644
--- a/sound/soc/sunxi/sun4i-spdif.c
+++ b/sound/soc/sunxi/sun4i-spdif.c
@@ -578,6 +578,11 @@ static const struct of_device_id sun4i_spdif_of_match[] = {
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



