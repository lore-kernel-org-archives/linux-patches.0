Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035925;
	b=rZggkd+8wOYPb6yBsHeNwRyEegASxahEIRKYAxEtOaOnY/Bp3atMBb9Ob1vyXO9ak2DO
	 xWN7MF7kNoQc2FfL46Jr8wyAAXA0rqn8k5vEzxwHW5bKY1bryB9iYw4mmhn7K1+U/Ql6i
	 0JQidUPpplmEnkJFhmB270S36lFfmX4nJOJTAjSqrE7K8gCCTFT98b22WmVhjO1p/s0VW
	 p15lESrnj+MW3ewPX6itc4xR4qdCMgmb+nHNao84t0NQ6x3+fnNe43PojUobz9T45R4Yr
	 b381fOVpyE8Ju1gcbYPyds3u8khYK+CN3VhJybbrdz+IAtBy17dfnBrrqL25guXeE6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6O8BFA1HU+8eF2v+nYLN/Mn35z1emJV7EnNeU8hitmA=;
	b=wvKQBiOy8wg03xnmcuLqx8xduOp1RZQLRFp4DXpVzHKp+LRjJPrKQwpBQCm0+2juWlBD
	 8cNSsLJSgkNX6ZHHLffx0oK4FvyLIOw6H5Zw6ZZF9v85QWB1DkE0G35LR1lz8dBzlTWBP
	 rYu1wqN2o0+F0pvRbbVgDhdZAXyXOMoU2uErszyYD3/LIZ3GKEMMY603WdU5xyv81Qn3F
	 MiNhPf4Vs7LSpf3N0S2MoiOkcTn5NnMWhJ/1SbHlgdLSvPN04Sd1dFUORNKUPIELL9YyR
	 MOkN9Gg9d9UNQRoEaiJ6bZzhLtbIhL1gxbaIYa4Cg9CxkF4wOHp9ljKHjgJAWJnQkjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HQsS8kaf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96085606A338;
	Wed, 18 Nov 2026 21:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HQsS8kaf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3951F000C4;
	Wed, 18 Nov 2026 21:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035925;
	bh=6O8BFA1HU+8eF2v+nYLN/Mn35z1emJV7EnNeU8hitmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQsS8kafCoKU+QvVZ40kCP7ptzFrnCoPmRxWaWcWZGuVC0jiIh10yUSgGX+S5a4pr
	 VII4gQvGTuhvmTS78vn1cpaseSGR2WHVaSiUxa50Bc00fPDZIWo1PUG1srbDYqJPsf
	 PqYT+W3Ot4ybrZ2aJ3vftqy7o1FH9qyGFZrGK63I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0874/3318] ata: ahci_st: Do not ignore errors when getting the reset controls
Date: Wed, 18 Nov 2026 15:24:56 +0100
Message-ID: <20261118150345.522841925@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit c74ee9230a8d1d2f6fcbceff55f56f7dd9b9cccd ]

st_ahci_probe_resets() treats any error from devm_reset_control_get() as
"reset control not defined" and continues with a NULL reset control:

	drv_data->pwr = devm_reset_control_get(dev, "pwr-dwn");
	if (IS_ERR(drv_data->pwr)) {
		dev_info(dev, "power reset control not defined\n");
		drv_data->pwr = NULL;
	}

This also swallows -EPROBE_DEFER, which is returned when the reset
controller providing the reset has not been probed yet. probe() then
continues as if the device tree did not specify any reset, so the resets
of the SATA IP are never deasserted, and st_ahci_configure_oob() and
ahci_platform_init_host() access the MMIO of an IP which is still held in
reset and powered down, which can result in an external abort.

The resets are optional in the binding, as they are not part of its
required properties, so use devm_reset_control_get_optional(), which
returns NULL if the reset is not specified in the device tree, and
propagate all other errors.

Note that an absent reset is now indicated by a NULL reset control
instead of an error, so the "reset control not defined" messages are
dropped.

Fixes: 76884cb2f7da ("ahci: st: Add support for ST's SATA IP")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20260915084127.692494-9-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci_st.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/ata/ahci_st.c b/drivers/ata/ahci_st.c
index d4a626f87963b..39775429c8c0c 100644
--- a/drivers/ata/ahci_st.c
+++ b/drivers/ata/ahci_st.c
@@ -105,23 +105,20 @@ static int st_ahci_probe_resets(struct ahci_host_priv *hpriv,
 {
 	struct st_ahci_drv_data *drv_data = hpriv->plat_data;
 
-	drv_data->pwr = devm_reset_control_get(dev, "pwr-dwn");
-	if (IS_ERR(drv_data->pwr)) {
-		dev_info(dev, "power reset control not defined\n");
-		drv_data->pwr = NULL;
-	}
-
-	drv_data->sw_rst = devm_reset_control_get(dev, "sw-rst");
-	if (IS_ERR(drv_data->sw_rst)) {
-		dev_info(dev, "soft reset control not defined\n");
-		drv_data->sw_rst = NULL;
-	}
-
-	drv_data->pwr_rst = devm_reset_control_get(dev, "pwr-rst");
-	if (IS_ERR(drv_data->pwr_rst)) {
-		dev_dbg(dev, "power soft reset control not defined\n");
-		drv_data->pwr_rst = NULL;
-	}
+	drv_data->pwr = devm_reset_control_get_optional(dev, "pwr-dwn");
+	if (IS_ERR(drv_data->pwr))
+		return dev_err_probe(dev, PTR_ERR(drv_data->pwr),
+				     "failed to get pwr-dwn reset\n");
+
+	drv_data->sw_rst = devm_reset_control_get_optional(dev, "sw-rst");
+	if (IS_ERR(drv_data->sw_rst))
+		return dev_err_probe(dev, PTR_ERR(drv_data->sw_rst),
+				     "failed to get sw-rst reset\n");
+
+	drv_data->pwr_rst = devm_reset_control_get_optional(dev, "pwr-rst");
+	if (IS_ERR(drv_data->pwr_rst))
+		return dev_err_probe(dev, PTR_ERR(drv_data->pwr_rst),
+				     "failed to get pwr-rst reset\n");
 
 	return st_ahci_deassert_resets(hpriv, dev);
 }
-- 
2.53.0



