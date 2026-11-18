Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023012;
	b=E2EqlX8GJFRusPAIw7kTqApCzOXUf/WzKA8JAy5wDTajhlXCY9gfIB6JccSm2Zkx5sfK
	 mKMzr00wULXQ+4KU2qwsoRpscQyMVQQowymFTWoOzGbyhaZWrwd1Z0tp3L4bt0jSgQcKo
	 Dg7eK4WotryuLCC2ckFIT8N8EtAGVwanTI8e7X1PphTAddDH1xeGXThJmJias6U6Byrgi
	 IFVfNGjpnWJB1JuGotVMrgG4vrDNJ7H4imuu29ZuOM+n30Z3MT7O/nXipUeyJtkX57GbI
	 uGLZblX34rqNzdRF+Ffk1bXIYfIb3n5W/40Y7pXFbzBOYE6ozwiufAlqwW1zd+Ykszw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q/g6V6YuqLLW4S4o2RoqmCGnFfxCB/yuHgRQ5oW5Opc=;
	b=5i7uTBn8QTsTs9dolOnZKDlcnjzmdwKeqU3gKtgLR8WLzDxVlB29dVE0dq1Lvm6xpuf5
	 isO1fRz7xixVZMO5dvBRhOUt7uhpzvnky7r9JTPmczZoPW6vHzfl+PaO9XMrHGLfOY7vc
	 ogWVCVLGkkoS7tA8RJS+860hV2hQco2XK8VbWS7VWgIAg5qqe/93XmkodKrHA30gvmSCg
	 PIFHv+GwuYAFK/YsVBW32z0K4pBKHYag/Pm5vYgRl1ARK/gIL4tWL3yyddLus1ED6W8VY
	 SF2Ez6APkbgRFaAGdXtrjgZdMFX+ndzxZE8PjFiLqP5lLDmSLuQ+Tr7EYI4Nxm4InMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uEERA57i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4661606A325;
	Wed, 18 Nov 2026 17:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uEERA57i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AF41F000C4;
	Wed, 18 Nov 2026 17:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023012;
	bh=Q/g6V6YuqLLW4S4o2RoqmCGnFfxCB/yuHgRQ5oW5Opc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uEERA57i+EOiCqQakGZ+q+tZX6QKutTMq2pO7VA69MxOIQwK/niICrCBAu5DUfxyq
	 DQzYoX5vHkDVLpjDh4sSz04hMuEATaBO6AFio8/KbpjDVQLfTZEW86jgvMmqEOGt05
	 xuPrpPUNngk0682tfJJ+8bsnOTtEbC+yD6tg9xsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0216/2151] wifi: ath11k: fix NULL dereference in ahb remove when QMI init incomplete
Date: Wed, 18 Nov 2026 15:32:31 +0100
Message-ID: <20261118150129.650133797@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>

[ Upstream commit 1a7bcf5324c8e2de6512eca5b028b6b283181d3f ]

On WCN6750, if QMI messages never arrive (for example when qrtr_smd
is not ready), WLAN initialization stops before the device is fully
registered. In this case ATH11K_FLAG_QMI_FAIL is not set because no
QMI event handler is executed.

When the driver is removed, ath11k_ahb_remove() still calls
ath11k_core_deinit(), which eventually triggers
ath11k_ce_cleanup_pipes() on uninitialized CE pipes and results in a
NULL pointer dereference in ath11k_hal_srng_access_begin():

  ath11k_hal_srng_access_begin+0x14/0x68 [ath11k]
  ath11k_ce_cleanup_pipes+0x184/0x190 [ath11k]
  ath11k_pcic_stop+0x24/0x38 [ath11k]
  ath11k_core_deinit+0xfc/0x1c0 [ath11k]
  ath11k_ahb_remove+0x38/0xa0 [ath11k_ahb]

Fix this by invoking ath11k_ahb_remove_prepare() before the state
check and skipping ath11k_core_deinit() if ATH11K_FLAG_REGISTERED
is not set, core initialization did not complete and CE pipes may
remain uninitialized, making ath11k_core_deinit() unsafe.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.2.0.c2-00204-QCAMSLSWPLZ-1

Fixes: 00402f49d26f ("ath11k: Add support for WCN6750 device")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260806101331.484063-3-miaoqing.pan@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index b6a146e9abf8a..db7a762dcf62b 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1300,14 +1300,15 @@ static void ath11k_ahb_remove(struct platform_device *pdev)
 {
 	struct ath11k_base *ab = platform_get_drvdata(pdev);
 
-	if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags)) {
+	ath11k_ahb_remove_prepare(ab);
+
+	if (!test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags)) {
 		ath11k_ahb_power_down(ab, false);
 		ath11k_debugfs_soc_destroy(ab);
 		ath11k_qmi_deinit_service(ab);
 		goto qmi_fail;
 	}
 
-	ath11k_ahb_remove_prepare(ab);
 	ath11k_core_deinit(ab);
 
 qmi_fail:
-- 
2.53.0



