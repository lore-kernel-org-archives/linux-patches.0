Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010B8267B96;
	Tue,  8 Apr 2025 12:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114512; cv=none; b=EH4ZErntKRJyQsKkCiCj9GwNu9VKY+j6UfaOvy+Cj+C/oK/u7BAVTCmCBTSLPjNsSmC/fGjmoDYAz0YeuJGRdYvo/Gi0KPslDdFuh+g9jHkVhjcjb3+4NLetY9mdekD2bYbsPrxFx15hjJ1gQS1WmrITkft0H2ih8G3bey+OXYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114512; c=relaxed/simple;
	bh=g+tAUg1dtx0s3b6ffK98VJuRPHJ/Dc2I7QkCAh+5Y9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzlJJfQOW9UnT2Q0+LxiZbl8qxXmehexhWFXATFuVHLe9Rr8HmqFtziMhAaqlWRkPIDB5SYSPJdjgbBypqEp4W8L/AXOfCcwAJJPcuGWhVfBsf+zzEJiKf9c3efsckFChK9PvVxX7FDdYjcAlX8rtV0kqlv8fLV8DX5FLFqEV1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zse7D89X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zse7D89X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783C9C4CEE5;
	Tue,  8 Apr 2025 12:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114511;
	bh=g+tAUg1dtx0s3b6ffK98VJuRPHJ/Dc2I7QkCAh+5Y9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zse7D89XvI1Qmzf2zUPXivwtz0woNqvcJmAPXAQbFCv9c5TTxTyQcL7m31nUoGIgg
	 svikohJwZVzQPDjohPJukkghOEHjP4m21JL0/IM8AFZ0o0XZSwQjvVuT8htUzPk0LN
	 KmWE7zAudro2wH2fBH53M3Xh3c/dNs8mwo02XfGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 135/499] pinctrl: renesas: rzg2l: Suppress binding attributes
Date: Tue,  8 Apr 2025 12:45:47 +0200
Message-ID: <20250408104854.558301415@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 515c38de445a9..3501535f5818f 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -3210,6 +3210,7 @@ static struct platform_driver rzg2l_pinctrl_driver = {
 		.name = DRV_NAME,
 		.of_match_table = of_match_ptr(rzg2l_pinctrl_of_table),
 		.pm = pm_sleep_ptr(&rzg2l_pinctrl_pm_ops),
+		.suppress_bind_attrs = true,
 	},
 	.probe = rzg2l_pinctrl_probe,
 };
-- 
2.39.5



