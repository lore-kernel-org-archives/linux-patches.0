Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD64E23371B;
	Mon, 10 Mar 2025 17:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627660; cv=none; b=pB32G6gZx8l1SoCRBK50Ci2dOmaeCqlEXyxLZaPc9G467YRpYyJajvj90gZmhVd3PNNCYYdSdACpwyt+iL4P0XgMvuD2E7RhvIPxRGV7kmM0epFkBlxICGZLZGE9khVg20+GUy/1+yt0G88zxg+O4HazEAzj3m9meE03251jnP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627660; c=relaxed/simple;
	bh=aVuosg6rkt6ofnTv9rCToyJhd494//QYxnfuVoIKKZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kW+0mWOvd2n81Pjiboc+6ksIOgy5yHiIdN7hKdoaNZg/SlfYw1VS00aCCya4CB0xn6RPgz5rTZ0hEp+QGeV89XQGRvGmn82trJPRLG0BpFyjD/AQx3HwOR5mm5Z4n7Wn9/KnBhZaM8iGebhmnKE4HkEr6vxRVVFZfQRxgKPot2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5mO7VeL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5mO7VeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D183C4CEE5;
	Mon, 10 Mar 2025 17:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627659;
	bh=aVuosg6rkt6ofnTv9rCToyJhd494//QYxnfuVoIKKZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U5mO7VeLrNzk+3FZw2TFFRXgBHadVIwHkxQPNWrATaRKMahKIu/qMpa80/jVY5ydX
	 wHPVvbkJTTTr7umJIztRgsJtqcmofLRTHa9G2RTtzLYIWliJvD+0ZWQQKGJjWo0pTd
	 y4x6j334ES1paFQH72xtHO4lj0Wk/jfRD1iDk4fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 205/269] gpio: rcar: Fix missing of_node_put() call
Date: Mon, 10 Mar 2025 18:05:58 +0100
Message-ID: <20250310170505.868896272@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 436ff763341ae..6641ed5cd8e1c 100644
--- a/drivers/gpio/gpio-rcar.c
+++ b/drivers/gpio/gpio-rcar.c
@@ -468,7 +468,12 @@ static int gpio_rcar_parse_dt(struct gpio_rcar_priv *p, unsigned int *npins)
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



