Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045010;
	b=r104y9m/73gYAdEsEugXAYpm/Hkd+eh/3YJOqsqObvPKy9ZG4DPZcMc7szNsmJ0W9Q4a
	 dYUF30CdggmrN5yHBsDtt4P8+FK7RzgB8dU4cedMuxR6EGVkerTPR4nwnzO/4tdskrrHK
	 OS+9A5rl8v4roVbpAfxgejqS6i+f+L3PAEN12Zwsyvw3a1V3W1I1UzmwUkZkVVxpgp7jz
	 MLiL8hYLxSj3Fr4pocKNB73rpDWmrw5Sa3LGzrhIcfsbHUtNjGvll6HZIDJuiH4F0nJoo
	 E+w0blwhAceUZWZlSaNWXLvQWuqACl/9cuwRzRWrGOptTDiFt9d+gbcpK1nUz7cP7ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L7hHq+VuNTNnegZXPIWF27gL2l+x7WKKrTb/zPNvLGM=;
	b=xby+gCEIZfmvcscOftm33k8Pf/q9Yst5L9XyERQo8xOpAZfcN3NPoo3xMynvnfkVoa+p
	 qYv4+D6IsG3R6gboAzUNF12ywwanYaOwIGFGq+RZ+8+XWos2JAgvBlcwESMXWVWewM9Kh
	 m0XPZdrmcXhOMFZxbrTwf1l20ujmKAFR4o0bHxmOetvKMJlq/GSx2t7GekkeW1A3Ithlr
	 4jqndufhzXbHI8uRrhRVHj7jHPwIs3YqCM1hWxcBctzXSMgSqcWJQ10uNvyHkE822odbe
	 1X0EfaXIJOx++Xmb70EdN74KicjRa4B9usVyEP7iJST7wZWf2aejtZmThk6kRYAUQyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KL1Hs+tY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77972606A32A;
	Wed, 18 Nov 2026 23:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KL1Hs+tY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C1E1F000C5;
	Wed, 18 Nov 2026 23:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045010;
	bh=L7hHq+VuNTNnegZXPIWF27gL2l+x7WKKrTb/zPNvLGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KL1Hs+tYDngTYVKGM5kR7wF4kPLT+FvSR9r2FyID1V7yRMag8IwwdVoqAtQfxav/k
	 HgX0AuYRdXk9z9xRMefhU6Y5DI6nT4V4BJ8s0yYeT7Xtmu+X1NJLII9GtjaAaPfb7o
	 9wt7DaBvOWRayhy5nHCc4RHOrSj3Z6Ucm8ft4JO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0769/2857] ata: ahci_st: Do not ignore errors when getting the reset controls
Date: Wed, 18 Nov 2026 15:30:03 +0100
Message-ID: <20261118150229.252960423@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 8607b68eee532..8da0b769fc0d3 100644
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



