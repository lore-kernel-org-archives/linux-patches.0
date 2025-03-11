Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EAA3C0B;
	Tue, 11 Mar 2025 15:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707540; cv=none; b=moNApTZDlid5KOqu0032bYctSlV7PA1uYrg8vBDxA16L+3tTvvD8CAW1GIEje0R5Vx+h0ouJsttyvxhYXOR0Xqqe5GhdiRQpS4E7gLZ8eL3J8MTsfYr9Fi5o39ggSHDJflsVzyoYQbthI8K3DzFtlPgdvteuibO3KoUf4lcDxVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707540; c=relaxed/simple;
	bh=yDlRH5PXSb4rjUXcfw0iqlrw1s2cflRBb0erFFVcLnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKdwG9b8rpTJoZyW1wUaglPbhhHARtZYc/vQsPOaM14HW7TmE16qJVp/hxpJd8WukPdTGKREPAetRrFVRh0B3W2H99UWOm1v+YQgpgNHmU+AT5PeibLn+e4tcjeUT6vp2sRnxC7qSCCjCjopQlut2LxQwgQ8Xp47BQbaHBeQ4ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJ1Fr5i0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJ1Fr5i0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA95C4CEE9;
	Tue, 11 Mar 2025 15:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707540;
	bh=yDlRH5PXSb4rjUXcfw0iqlrw1s2cflRBb0erFFVcLnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJ1Fr5i08S8v8tDsKpUMH33MmwVppu75SI0dhEOKCg2+i2TIV8cQNbxWrjwnpBINP
	 PaoVjrQrzgrVUHwhwkjArMYYmoicinrVVf0cu8PVbgOEyFWCV6Q43tPANW1FKI0yUd
	 zqgT61sRrm9F6vQ3ofB7r3A+PiIWJ2jfAbNPGo7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 424/462] gpio: rcar: Fix missing of_node_put() call
Date: Tue, 11 Mar 2025 16:01:30 +0100
Message-ID: <20250311145815.087837469@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3ef19cef8da9b..80bf2a84f296c 100644
--- a/drivers/gpio/gpio-rcar.c
+++ b/drivers/gpio/gpio-rcar.c
@@ -421,7 +421,12 @@ static int gpio_rcar_parse_dt(struct gpio_rcar_priv *p, unsigned int *npins)
 	p->has_both_edge_trigger = info->has_both_edge_trigger;
 
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



