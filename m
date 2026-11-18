Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052232;
	b=ZEpdk+d8xq/SV+4bi9+NzP5FYhIEavSN72ytELQ9YHMFvCGY8IBva3oF/kVCNbgpWO3e
	 2Wrb+nE6NNEdNKxJyzU8AnjMHJkRkSPm2OwGtVhjtac9eu5VgaOe/AKAFPHuDt05poJ7O
	 xxWN2i+P/vUSDf88RIFLmX3McMGQUsNRHqHsK+vGOVHUy8hzRKFY0twoe1aD8fDiawBa1
	 9Zh/NuL4974Uw1cAwSYms8LMjd3WIfnxhoS1d7mmH5JcyInUynoJ1k8YMIAchXxrOYs33
	 8CGaFUw3k+C81xVfAiL6Pc7JmGg6A1miNrTZXxsINftvG95BLm3kjFhBvqgQMMXP0HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G9uDW0+SYz+hK1GPKBUKb4MLDzJcs1uCj6zt+Uc4bSc=;
	b=SKaAs305QZh2jXUjHrn5g91pKVzVg5B556m9pdAgPA9wm7eVhaNzCOinIA5FN2S7vz3O
	 w/SQR7OFGYmmUDzv/D4FY5as7dNLhUrsOLQrBntYvsdEsxT3SoFjor9+shKBg8+YSL9Wf
	 RG5LE5jeVOQw4S6bPdyn5YddcvAnKx14nDfrFlOhY6PyP6lJ3C/JyAVkKXwy/XnQM2VpR
	 mdZQh3Oefg46VCeQGDPIE2liB65sUjSJ1ua3iQYuz1G2sAxZ1qEOnJ47WHavGJMiobHQq
	 5N763SCnwoS1Srl6KJEekaU+1ZmpSj+/GjpdZoWlyw4p4KQ4cHiAgdOrgovSGH4AVHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fm9WJAx1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5709606A325;
	Thu, 19 Nov 2026 01:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fm9WJAx1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DDB1F000C4;
	Thu, 19 Nov 2026 01:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052232;
	bh=G9uDW0+SYz+hK1GPKBUKb4MLDzJcs1uCj6zt+Uc4bSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fm9WJAx14Z/xaBIedmI1yQgBoLoAaAktzZviJrGjN4hnjswZD/WGold+lRP2EO4jT
	 nCnecXrtNMt+cjK+vhbLWnD/MdoE+/U1Cv87j6vIFGh9PdNGkNsmcBNvHKeMH1YH+S
	 rd/VlKBH+mM0GAMfx/+HQXU0vsOCEKlcK5WfdPfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0490/2214] ata: ahci_st: Do not ignore errors when getting the reset controls
Date: Wed, 18 Nov 2026 15:36:06 +0100
Message-ID: <20261118150030.795814876@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c268264c2129c..98ec746d4a2ca 100644
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



