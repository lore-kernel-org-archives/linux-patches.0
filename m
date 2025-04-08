Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E120224F6;
	Tue,  8 Apr 2025 11:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111261; cv=none; b=Ft4H0MV5i5ZUlMTvdalnMY9hPvUuqqZbx5UoaIR3MgVCj+5q489KCNvxvx/+G6v/lUajKJfbTdjlGmq6filAHc+80B+SvR9A4lpgJXrp+wdWmvEflrVMYlwnHkDm8bGDKQrwNIM3nx4pYn/K90znb/pXf6zr4HFJyjuSx6miSzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111261; c=relaxed/simple;
	bh=KKwT68bJTtGoWfela8J2SvoFe7Wjd8AD1kmDfJbMIpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GeO6s5duARFwjMD75YYB0hzA5KIJxIX7RSND5UUjhDH4+0v+UKnJGs36El1flPcF11gARXMQuPBVgclcgvqR4W6PsV+At+buQEEMlxql2IjGfsPfS4/N+1ZJWbGnLVibTcVLIwX2zyNQq8CNL5QsxLMwd5yYOuf2iL9kRQ1uOdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11OBIB70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11OBIB70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30D1C4CEE5;
	Tue,  8 Apr 2025 11:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111261;
	bh=KKwT68bJTtGoWfela8J2SvoFe7Wjd8AD1kmDfJbMIpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11OBIB70PxcPD/y1kNPBa+voES41H/ZzpCIzxHWc2IXS3CE5tF9KSI08CfNJPtk3u
	 3PHBfNsruGeTgK8iY0vAog04IaRx1kG+rbAXFW2AOjZ8jwDH44ZQX3jWTL1DTc9BEB
	 MIy6IIT62qUOwRUzaLNYd1/fg3BeJ1lq72Lj/ftA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 366/731] pinctrl: renesas: rzg2l: Suppress binding attributes
Date: Tue,  8 Apr 2025 12:44:23 +0200
Message-ID: <20250408104922.789222178@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit ea4065345643f3163e812e58ed8add2c75c3ee46 ]

Suppress binding attributes for the rzg2l pinctrl driver, as it is an
essential block for Renesas SoCs.  Unbinding the driver leads to
warnings from __device_links_no_driver() and can eventually render the
system inaccessible.

Fixes: c4c4637eb57f ("pinctrl: renesas: Add RZ/G2L pin and gpio controller driver")
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250215131235.228274-1-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index ce4a07a3df49a..5f006a059d9c2 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -3386,6 +3386,7 @@ static struct platform_driver rzg2l_pinctrl_driver = {
 		.name = DRV_NAME,
 		.of_match_table = of_match_ptr(rzg2l_pinctrl_of_table),
 		.pm = pm_sleep_ptr(&rzg2l_pinctrl_pm_ops),
+		.suppress_bind_attrs = true,
 	},
 	.probe = rzg2l_pinctrl_probe,
 };
-- 
2.39.5



