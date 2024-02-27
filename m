Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4989054BD4;
	Tue, 27 Feb 2024 13:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041720; cv=none; b=AvFa2TnJhvge7yGsyInDNTmuj5/JjC5/rwSazZfxR/dVpIeCMCJVGwsx1eP0oYOJ0XhVXsc4YEvaX/Vg6WmbuRvYfHt4OtkZIOlQ4LNnrtgPCduOKTPNMgCbcn6smCzldki/t6uX3Kpai9wt+RCrSkS/ByZaY1yVVKnkr9GcTDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041720; c=relaxed/simple;
	bh=IDyqorgghNYh+ppySs1kiUtJUx960pVejTXPMbb8/EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKzyhpBcZdAAMrdjhrCUkkSBvhW7TmJ6osjF0XKqFQf1B5knxNL2RRPEQ4x06WBNNUyAGKp6lCIey3gme6hyJWZ2YjFiEJ3UxohEf2lK6bG7JKPwbYHA4mrgylOyDqHtX8KfNYjo4JKJiPHrlSvi+EwCzzFDjrAUSLVmJUwn+VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dwnJ7Xp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dwnJ7Xp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC92EC43390;
	Tue, 27 Feb 2024 13:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041720;
	bh=IDyqorgghNYh+ppySs1kiUtJUx960pVejTXPMbb8/EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwnJ7Xp6rvgmoMGsBtIuxalFvFjPc2VvxAwX/6gNdnzjReOJn6aDhbt0KfjQqquGm
	 omFM/0RTErVWHbwblOcCNXdKRrk2J9h7d/doYAdzOvTwOp0D+n5jF5vBYm57Mh/jzu
	 z2YLr9sgjtq49VNYiPXjZ1PID1orb0mMU900TzyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@csie.org>,
	Andre Przywara <andre.przywara@arm.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/299] ASoC: sunxi: sun4i-spdif: Add support for Allwinner H616
Date: Tue, 27 Feb 2024 14:22:38 +0100
Message-ID: <20240227131627.493744503@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b849bb7cf58e2..2347aeb049bcc 100644
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



