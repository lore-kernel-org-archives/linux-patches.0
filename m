Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39C71AC896;
	Thu, 15 Aug 2024 14:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731975; cv=none; b=elOvbRNI5DTvAifL7TI7Y8c0wLLauo/XTYVF/xUnfmMuRVGsqsW2ndqRT6G7ogT5UHPAMgN8Wec247JvueF/3eQG3MJi8EKT5/lMtN2hlr8217fQs23tgoKmXgTfhlpf9hLwlUncB0aZKx6PLKnDwF/0ihcHLdKTcBoCvm0k4OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731975; c=relaxed/simple;
	bh=XdnoDNZKclU1RATxN+c7dtnjc3MM8Ct6TWscvfq2DBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/kxc8WjylO/ke1nf31gPBzsPh4EIE50xK2bMtgpjVbzddI/Yj9+R5MUV+cZcoyFzzNyLOoTpNFVRn5kCjP+MHkzRDOji2AGjKV6d2zvV1/x7AcBL87C/0pZFas+PwMZ/yXBojBlavWgVSK6/HgB9E1iKNOsTnUYE5isjFZEm24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lnc2h/WT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lnc2h/WT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1DFC32786;
	Thu, 15 Aug 2024 14:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731975;
	bh=XdnoDNZKclU1RATxN+c7dtnjc3MM8Ct6TWscvfq2DBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lnc2h/WT06jN71VD6hpzPVI1vtr1GC+VQ1lJVXJYSU+V6T9GOVijArln/l1CtS7HS
	 HBuZpLdmy3gbsp6CkV9ViP3G/cKzXkuVyx1R4EPL5XxvRhzWQ45tA1ZzhgLraAeSwa
	 YNy522ddMz+xgruJG1SxNx0zB+TBvzrUpvcV1QK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/352] wifi: brcmsmac: LCN PHY code is used for BCM4313 2G-only device
Date: Thu, 15 Aug 2024 15:21:41 +0200
Message-ID: <20240815131920.586605486@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7717eb85a1db6..47c0e8e429e54 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -2567,7 +2567,6 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 
 	struct lcnphy_txgains cal_gains, temp_gains;
 	u16 hash;
-	u8 band_idx;
 	int j;
 	u16 ncorr_override[5];
 	u16 syst_coeffs[] = { 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
@@ -2599,6 +2598,9 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 	u16 *values_to_save;
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
+	if (WARN_ON(CHSPEC_IS5G(pi->radio_chanspec)))
+		return;
+
 	values_to_save = kmalloc_array(20, sizeof(u16), GFP_ATOMIC);
 	if (NULL == values_to_save)
 		return;
@@ -2662,20 +2664,18 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
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



