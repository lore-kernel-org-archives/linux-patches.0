Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C59230BC5;
	Mon, 10 Mar 2025 17:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628448; cv=none; b=L4dy5k8hvEGHiN4YBTWH5hgDoXvhUdTj9XeJBdiUkfIvybrW9FeB37l5l2qbHjgWw4ujV+h8E6hrYeLTJAyvr4T5zbCDJR14Tm+G2WP/gwnNXsChkQUnmm2PrOwD8F+ApAqsuuim6h3ssRWtaoldi5zytKRcR1i7pQ54MiI+69A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628448; c=relaxed/simple;
	bh=i1K1Pw6+hdlvAQa3mSbnnWMkrSgv/WUKhlRMES4gUJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZU9ff1VixlSM4ba5B3l/VtkOQaj+KG/q4jYjFo7IfpUM88d3AgiH7InSH+i+zRUUXJVneTVPmQDBcwOEdDwxBqxi6chkkpjnn9DMYc9kO+12C97521ZQ7wdrO2VAON5ibI8XBo8p9iZfxS6gnTPS0EjHYQftpyp4GhYke2E1xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H4I0h8rP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H4I0h8rP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9A4C4CEE5;
	Mon, 10 Mar 2025 17:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628448;
	bh=i1K1Pw6+hdlvAQa3mSbnnWMkrSgv/WUKhlRMES4gUJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4I0h8rPs8ye6zcOeWIP5o2CuQGbKfCJSq/202MSt1mOhg8G9teuBULGEhFCMT50n
	 KVUPZSk20raqDMgThtF112GD0JzWiieTn5GDS1PzjmJnYEF3jQDddVgaAtLU5ouNFk
	 j1GWBSSn8MEYAuLPIsU7j3Us5IbQF0DZwlQWwX7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/109] gpio: rcar: Fix missing of_node_put() call
Date: Mon, 10 Mar 2025 18:06:46 +0100
Message-ID: <20250310170430.035828173@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabrizio Castro <fabrizio.castro.jz@renesas.com>

[ Upstream commit 391b41f983bf7ff853de44704d8e14e7cc648a9b ]

of_parse_phandle_with_fixed_args() requires its caller to
call into of_node_put() on the node pointer from the output
structure, but such a call is currently missing.

Call into of_node_put() to rectify that.

Fixes: 159f8a0209af ("gpio-rcar: Add DT support")
Signed-off-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20250305163753.34913-2-fabrizio.castro.jz@renesas.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-rcar.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-rcar.c b/drivers/gpio/gpio-rcar.c
index fd35e4611cc6d..ab200e6250108 100644
--- a/drivers/gpio/gpio-rcar.c
+++ b/drivers/gpio/gpio-rcar.c
@@ -469,7 +469,12 @@ static int gpio_rcar_parse_dt(struct gpio_rcar_priv *p, unsigned int *npins)
 	p->info = *info;
 
 	ret = of_parse_phandle_with_fixed_args(np, "gpio-ranges", 3, 0, &args);
-	*npins = ret == 0 ? args.args[2] : RCAR_MAX_GPIO_PER_BANK;
+	if (ret) {
+		*npins = RCAR_MAX_GPIO_PER_BANK;
+	} else {
+		*npins = args.args[2];
+		of_node_put(args.np);
+	}
 
 	if (*npins == 0 || *npins > RCAR_MAX_GPIO_PER_BANK) {
 		dev_warn(p->dev, "Invalid number of gpio lines %u, using %u\n",
-- 
2.39.5



