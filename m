Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1391DDF5;
	Thu, 15 Aug 2024 13:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728590; cv=none; b=N1qyGE5OvgU3b4gpj1Z4vYrueuYmTiKLPox5s4D0tS4EDcPfIuyFYLIN5mJ9BrL4AU/hAwgRr6B9x44ZuK7ntoHwhvNUsOyp7sH/1C9VEzgcvdWnIikc+2Cckonx1tW3gnZFsLt8dPM1tKWx/inZVV0mA51bZ2YsSn6Y3uCrL4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728590; c=relaxed/simple;
	bh=6QfXSLwtD145mjdiNlBvs/Jc/FYN+/brw5moTMrMzlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJk/kKpNQchPaa551nnYoyk4s3dBc0MqeTTWQETNnZyuEJt7BG3GyG64m/XMwzOob8nkr3cnZ8YfLnAXTCw+U0qabvAOgBLZ/7vsVnSdFrm4fMwEQVc7Wbn+CfHh9O+qAq2EncNkrtddExMnPQ8JdZvyvZBCQ7IeuUuU+fxopZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jb0sC96; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jb0sC96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E567C4AF0D;
	Thu, 15 Aug 2024 13:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728590;
	bh=6QfXSLwtD145mjdiNlBvs/Jc/FYN+/brw5moTMrMzlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0jb0sC96Rq7ChYkmJWUb8Kf82Fejpm05q60YeGtd/v7r58aF5j7Xd1IBV2vC52lpd
	 OzIrfuxsZjdG6BhRK1rLXdAk44A/4xtCneSqK9xtk3dAw3mJuH8aevjDEU015lcE5f
	 ai0d95Hkf9+2SlFKIFCtSf7te47KaD098bc4S0mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 017/196] wifi: brcmsmac: LCN PHY code is used for BCM4313 2G-only device
Date: Thu, 15 Aug 2024 15:22:14 +0200
Message-ID: <20240815131852.736257649@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

[ Upstream commit c636fa85feb450ca414a10010ed05361a73c93a6 ]

The band_idx variable in the function wlc_lcnphy_tx_iqlo_cal() will
never be set to 1 as BCM4313 is the only device for which the LCN PHY
code is used. This is a 2G-only device.

Fixes: 5b435de0d786 ("net: wireless: add brcm80211 drivers")
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240509231037.2014109-1-samasth.norway.ananda@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c  | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
index d532decc15383..071dee3c3deda 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -2638,7 +2638,6 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 
 	struct lcnphy_txgains cal_gains, temp_gains;
 	u16 hash;
-	u8 band_idx;
 	int j;
 	u16 ncorr_override[5];
 	u16 syst_coeffs[] = { 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
@@ -2670,6 +2669,9 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 	u16 *values_to_save;
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
+	if (WARN_ON(CHSPEC_IS5G(pi->radio_chanspec)))
+		return;
+
 	values_to_save = kmalloc_array(20, sizeof(u16), GFP_ATOMIC);
 	if (NULL == values_to_save)
 		return;
@@ -2733,20 +2735,18 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 	hash = (target_gains->gm_gain << 8) |
 	       (target_gains->pga_gain << 4) | (target_gains->pad_gain);
 
-	band_idx = (CHSPEC_IS5G(pi->radio_chanspec) ? 1 : 0);
-
 	cal_gains = *target_gains;
 	memset(ncorr_override, 0, sizeof(ncorr_override));
-	for (j = 0; j < iqcal_gainparams_numgains_lcnphy[band_idx]; j++) {
-		if (hash == tbl_iqcal_gainparams_lcnphy[band_idx][j][0]) {
+	for (j = 0; j < iqcal_gainparams_numgains_lcnphy[0]; j++) {
+		if (hash == tbl_iqcal_gainparams_lcnphy[0][j][0]) {
 			cal_gains.gm_gain =
-				tbl_iqcal_gainparams_lcnphy[band_idx][j][1];
+				tbl_iqcal_gainparams_lcnphy[0][j][1];
 			cal_gains.pga_gain =
-				tbl_iqcal_gainparams_lcnphy[band_idx][j][2];
+				tbl_iqcal_gainparams_lcnphy[0][j][2];
 			cal_gains.pad_gain =
-				tbl_iqcal_gainparams_lcnphy[band_idx][j][3];
+				tbl_iqcal_gainparams_lcnphy[0][j][3];
 			memcpy(ncorr_override,
-			       &tbl_iqcal_gainparams_lcnphy[band_idx][j][3],
+			       &tbl_iqcal_gainparams_lcnphy[0][j][3],
 			       sizeof(ncorr_override));
 			break;
 		}
-- 
2.43.0



