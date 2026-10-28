Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213617;
	b=zUO19bg9PktawZOHg3zQSS+t7ovP1q4zdIhFzwVq5ht7Caz1nRCA/HvQiQzGIyqYL8yl
	 cx28xp9/elCYW5BBj+pKHK4ZglYX0mo+EsPh4w46TmMnjrBdXuKCRkLjxPJAZNWILWwLN
	 FePhCMAEuPVDrL1nuZ6IjWpt2gq0BZ6/PegvQyM43tfmhHWjOEZevVQnb9nxXIv8bxj4T
	 3v8gtCgc6vsagHkZI3e7mT6vMENv7v53zoDclc8Os5sh/vK5yhtaC7geQL29MGVBiTSgG
	 bwEMms4irf79CQ+eiNyGPn4DfrPhRWy/v/m26JVqQ3T0IELbzHNhLuofZWm0kzRY4UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J6L7Bm0pbM2bdoeVJUE/TV5uwhCC6bR28K69qo56a6M=;
	b=toDkXyC/UrAHd+AfhOkLOyUPT9JkfUi5bPWrB0sthY0TIXcvf4qsZEd3y60MkVlcbhO3
	 nQu4jPUO5eCa96bKs9g3AchvBBt4F35gZH7jRbj/nFml7O5h0Au+qvHytsraLDFwQKzgM
	 wnKPwj3xDqmSIGSCDxlbz3GhNu1E6yfd7r5tCtIVJ9QHA6pb6HerH7V3oPNGmL/yPhppM
	 szHiprCs32F4ff1V4+VzW9z5mLTF0L5IXdPB44G+mKcphBAeeaIQYQc4zpvr/hZUPUzAd
	 mpWbnpBeP7kj1GYEJ/eKcgbJdfocdnPk57+G3WZqItIqkQ0GWxMpqUdcKwJxARyT77A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eji0TuOm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C354606A31E;
	Wed, 28 Oct 2026 18:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eji0TuOm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD1E1F01825;
	Wed, 28 Oct 2026 18:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213617;
	bh=J6L7Bm0pbM2bdoeVJUE/TV5uwhCC6bR28K69qo56a6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eji0TuOmSn/p4bCAc0s//V1Xala5NTZ3enzEjO7yMr91QPRtieXD2u2yTj8d4JvMC
	 K7Ncj5H9hywQazJTOm0LiHtOS0idZFK/ImMWkmJpzkrRRZWuQ+ayJMGzdX5FdQKf3R
	 dh2bu0JISUk0jCqTzacBpVlkAGzIwlXEcYeGGImg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0532/1887] pmdomain: imx8m-blk-ctrl: Serialize power on/off across sibling domains
Date: Wed, 28 Oct 2026 17:43:48 +0100
Message-ID: <20261028170511.447871775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@oss.nxp.com>

[ Upstream commit 51c2db3ef0cb89a49ab7f47a40efd5d5b074ce8d ]

On i.MX8MP the VPU blk-ctrl exposes G1, G2 and VC8000E as three separate
genpds, each serialized only by its own genpd lock, so their power_on and
power_off callbacks can run concurrently on SMP.

The sequences are not independent: they share the VPUMIX bus domain, the
VPU_NOC and the ADB400 handshake. On power up the GPC cannot ack-verify
the ADB400 handshake - the ack only completes once blk-ctrl sets the bus
clk-en bit - so it just waits a fixed delay instead of polling hskack. A
sibling transition landing inside another domain's reset window disturbs
that shared clock and handshake timing, the victim's reset does not take
effect, and its block registers read back all zeros: the decoder times
out or the encoder fails its format check.

Serialize the blk-ctrl reset sequence with a per-blk-ctrl mutex; the
driver deliberately avoids a genpd hierarchy, so the genpd core gives no
cross-sibling serialization.

Fixes: a1a5f15f7f6c ("soc: imx: imx8m-blk-ctrl: add i.MX8MP VPU blk ctrl")
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/imx8m-blk-ctrl.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/soc/imx/imx8m-blk-ctrl.c b/drivers/soc/imx/imx8m-blk-ctrl.c
index 1b87823d835d3..65315bf908b36 100644
--- a/drivers/soc/imx/imx8m-blk-ctrl.c
+++ b/drivers/soc/imx/imx8m-blk-ctrl.c
@@ -13,6 +13,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/clk.h>
+#include <linux/mutex.h>
 
 #include <dt-bindings/power/imx8mm-power.h>
 #include <dt-bindings/power/imx8mn-power.h>
@@ -32,6 +33,12 @@ struct imx8m_blk_ctrl {
 	struct regmap *regmap;
 	struct imx8m_blk_ctrl_domain *domains;
 	struct genpd_onecell_data onecell_data;
+	/*
+	 * Serializes the blk-ctrl reset/clock sequence across sibling domains;
+	 * their transitions interact through the shared VPUMIX bus domain,
+	 * VPU_NOC and the not-ack-verified ADB400 handshake (ERR050531).
+	 */
+	struct mutex power_lock;
 };
 
 struct imx8m_blk_ctrl_domain_data {
@@ -87,6 +94,8 @@ static int imx8m_blk_ctrl_power_on(struct generic_pm_domain *genpd)
 	struct imx8m_blk_ctrl *bc = domain->bc;
 	int ret;
 
+	guard(mutex)(&bc->power_lock);
+
 	/* make sure bus domain is awake */
 	ret = pm_runtime_get_sync(bc->bus_power_dev);
 	if (ret < 0) {
@@ -146,6 +155,8 @@ static int imx8m_blk_ctrl_power_off(struct generic_pm_domain *genpd)
 	const struct imx8m_blk_ctrl_domain_data *data = domain->data;
 	struct imx8m_blk_ctrl *bc = domain->bc;
 
+	guard(mutex)(&bc->power_lock);
+
 	/* put devices into reset and disable clocks */
 	if (data->mipi_phy_rst_mask)
 		regmap_clear_bits(bc->regmap, BLK_MIPI_RESET_DIV, data->mipi_phy_rst_mask);
@@ -184,6 +195,10 @@ static int imx8m_blk_ctrl_probe(struct platform_device *pdev)
 
 	bc->dev = dev;
 
+	ret = devm_mutex_init(dev, &bc->power_lock);
+	if (ret)
+		return ret;
+
 	bc_data = of_device_get_match_data(dev);
 
 	base = devm_platform_ioremap_resource(pdev, 0);
-- 
2.53.0



