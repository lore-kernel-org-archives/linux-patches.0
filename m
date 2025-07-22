Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68BF23AB9D;
	Tue, 22 Jul 2025 14:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193035; cv=none; b=L/vANBTjMasPPGmhi6dY2gIbacFeJwQdPRK50c7AH9bbEWy1msGyRkpiEDJKEqFqspQXhS6NZnAvH7LM78v35YsA+AvMANVIiGaqU7jSuDe6SOiSSUoqAW750PWVd19JV5yNxRoSDGMbi9brLNPXKLrkx0I9HFEbChdR5D2w1E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193035; c=relaxed/simple;
	bh=1tWHVFaD9iP1J0lU9kPqvNNlm8uak/b2WaHXOGvnWXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWV1bHVn2bXScMbI46hNN0BUHB3mcZxId4UzrC2V/ZNQdXiG/I0SDPGCV7/8Hj4o5H5v3Vt3/KnrLV5V8dxYCVVu51p4TWWugEaH4mQ1vzr4k5HdxGWTWz0nbR4ty+cgkfsqCqHvphscpLnsopFXzFBaGeFzTiCt0RraTU62kHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXR9xF2w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXR9xF2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904FAC4CEEB;
	Tue, 22 Jul 2025 14:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193034;
	bh=1tWHVFaD9iP1J0lU9kPqvNNlm8uak/b2WaHXOGvnWXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXR9xF2wWdXcZhdL3/E0bJEIZtJXP+9Bv17C3DfQQoQf1h/XDvsKYew0j6iLaXI0z
	 cJSLN4ZVBNlYuko/i5Fifta8Ki+m7EKM4clThMTJh2A6EsmzgNzvuGUK5YnIILiEHr
	 ARa34IjDVdHS25tDu94/EpRVYKRlqxQ1Nm6mqIis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/158] can: tcan4x5x: add option for selecting nWKRQ voltage
Date: Tue, 22 Jul 2025 15:44:47 +0200
Message-ID: <20250722134344.586195740@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: Sean Nyekjaer <sean@geanix.com>

[ Upstream commit 36131b72fb1c62bc61e86068618de304763b8ac7 ]

The nWKRQ pin supports an output voltage of either the internal reference
voltage (3.6V) or the reference voltage of
the digital interface 0-6V (VIO).
Add the devicetree option ti,nwkrq-voltage-vio to set it to VIO.

If this property is omitted the reset default, the internal reference
voltage, is used.

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Reviewed-by: Marc Kleine-Budde <mkl@pengutronix.de>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://patch.msgid.link/20241114-tcan-wkrqv-v5-2-a2d50833ed71@geanix.com
[mkl: remove unused variable in tcan4x5x_get_dt_data()]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 0f97a7588db7 ("can: tcan4x5x: fix reset gpio usage during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/tcan4x5x-core.c | 19 +++++++++++++++++++
 drivers/net/can/m_can/tcan4x5x.h      |  2 ++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/can/m_can/tcan4x5x-core.c b/drivers/net/can/m_can/tcan4x5x-core.c
index b6c5c8bab7390..7062a2939f501 100644
--- a/drivers/net/can/m_can/tcan4x5x-core.c
+++ b/drivers/net/can/m_can/tcan4x5x-core.c
@@ -92,6 +92,8 @@
 #define TCAN4X5X_MODE_STANDBY BIT(6)
 #define TCAN4X5X_MODE_NORMAL BIT(7)
 
+#define TCAN4X5X_NWKRQ_VOLTAGE_VIO BIT(19)
+
 #define TCAN4X5X_DISABLE_WAKE_MSK	(BIT(31) | BIT(30))
 #define TCAN4X5X_DISABLE_INH_MSK	BIT(9)
 
@@ -267,6 +269,13 @@ static int tcan4x5x_init(struct m_can_classdev *cdev)
 	if (ret)
 		return ret;
 
+	if (tcan4x5x->nwkrq_voltage_vio) {
+		ret = regmap_set_bits(tcan4x5x->regmap, TCAN4X5X_CONFIG,
+				      TCAN4X5X_NWKRQ_VOLTAGE_VIO);
+		if (ret)
+			return ret;
+	}
+
 	return ret;
 }
 
@@ -318,6 +327,14 @@ static const struct tcan4x5x_version_info
 	return &tcan4x5x_versions[TCAN4X5X];
 }
 
+static void tcan4x5x_get_dt_data(struct m_can_classdev *cdev)
+{
+	struct tcan4x5x_priv *tcan4x5x = cdev_to_priv(cdev);
+
+	tcan4x5x->nwkrq_voltage_vio =
+		of_property_read_bool(cdev->dev->of_node, "ti,nwkrq-voltage-vio");
+}
+
 static int tcan4x5x_get_gpios(struct m_can_classdev *cdev,
 			      const struct tcan4x5x_version_info *version_info)
 {
@@ -454,6 +471,8 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 		goto out_power;
 	}
 
+	tcan4x5x_get_dt_data(mcan_class);
+
 	tcan4x5x_check_wake(priv);
 
 	ret = tcan4x5x_write_tcan_reg(mcan_class, TCAN4X5X_INT_EN, 0);
diff --git a/drivers/net/can/m_can/tcan4x5x.h b/drivers/net/can/m_can/tcan4x5x.h
index e62c030d3e1e5..203399d5e8ccf 100644
--- a/drivers/net/can/m_can/tcan4x5x.h
+++ b/drivers/net/can/m_can/tcan4x5x.h
@@ -42,6 +42,8 @@ struct tcan4x5x_priv {
 
 	struct tcan4x5x_map_buf map_buf_rx;
 	struct tcan4x5x_map_buf map_buf_tx;
+
+	bool nwkrq_voltage_vio;
 };
 
 static inline void
-- 
2.39.5



