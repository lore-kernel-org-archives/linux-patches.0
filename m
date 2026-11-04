Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826796;
	b=vMk2BeP4BewYlsCo58YaI/Cc7cqGKknUl/k1QZQIqpos08EzYKXB9LmzrhVm6dTg1tGo
	 d9as6Di1KZuMfy+24qB7p768Z6+qmw72C3D6QM/UIHTn3M/sWkdntCMv0Dr0qZ5keCMk8
	 TCmL1KwARENasosUEeqzDV5DfYxOExnpwlHRiKwxVigOXKwLJFjxj0QRFDIuIF9tvzw4k
	 bKOxG1rQooxvxCC3dpaH5dc1/9m1J7VCRds4wmJswMyv3f1iFWgFoU3YvL6NRY5GtgpqQ
	 lfIOEBdRQNqnlq37aB0JGpTXOGxLOVmGhcHFW/xS0Rn2HAHcnJnGspENqE1fVlUw0sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=htHNrrwC9UidU5IrS2/x+6IDwC52zh+HzcpeYuhTb9k=;
	b=4dYO2Y679q/OgC6bd0OhBjm3Kn3/CJXaToD2DqMzUhAeoi/JWFoliK4DUrbtI7ZqDmjq
	 wVvFIwKfDtVSyOJZuI1ezfSufT1xnrT0Cg/KXq61kXXvNQhwj8gk/kJy1M2qqoga+Khbi
	 U1ae4p6IpLYKmthP1nVgVudjeNq17AQrvMFIxYg7NLETFgGzHVLWOJhKaDXPeyYX4Yz38
	 3ydmyhm6EoolLviHmqzFnZ0ivsnX/W0upyCBL7nVVok44RIrAPcgMTmVfVb1ujUPGwfCr
	 Y8fXDS2NAYWlAXf7GmqNYu3j7IiPFz/Gt4LmfU0mZkea0kCynvxQ+6LpM8Ziy3dPBeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C9XuxRnl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F10606D822;
	Wed,  4 Nov 2026 21:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C9XuxRnl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38AF61F00919;
	Wed,  4 Nov 2026 21:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826795;
	bh=htHNrrwC9UidU5IrS2/x+6IDwC52zh+HzcpeYuhTb9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9XuxRnlMLst0iuOuEEXUtqPsf9QP5eKliVAKpcfo8EMcq3WKTHaTXOX3kx0jyrjz
	 zERoAYOhD+IlXl+Te1JpRIf+HC3lN0kwxAHt3L8TW0XMxUgzQZcuaxh446DPg9TXtO
	 s03kRPguo0tpIFHMWVeIGqlni0+wR6906r7THmd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 013/547] wifi: ath12k: convert DP_RX_RELEASE_RING_SIZE to inline helper
Date: Wed,  4 Nov 2026 16:03:17 -0500
Message-ID: <20261104211038.758230448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>

[ Upstream commit 897d2e0046f941d8956f655f5ffc5d75c788558d ]

Replace DP_RX_RELEASE_RING_SIZE macro with ath12k_dp_rx_release_ring_size()
static inline helper. Pass the DP profile parameters explicitly to
improve type safety and make the interface explicit.

No functional change intended.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260820054804.3222296-8-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.c | 2 +-
 drivers/net/wireless/ath/ath12k/dp.h | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index 417d960bbd07d..779529d189f8a 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -488,7 +488,7 @@ static int ath12k_dp_srng_common_setup(struct ath12k_base *ab)
 
 	ret = ath12k_dp_srng_setup(ab, &dp->rx_rel_ring, HAL_WBM2SW_RELEASE,
 				   HAL_WBM2SW_REL_ERR_RING_NUM, 0,
-				   DP_RX_RELEASE_RING_SIZE(ab));
+				   ath12k_dp_rx_release_ring_size(dp_params));
 	if (ret) {
 		ath12k_warn(ab, "failed to set up rx_rel ring :%d\n", ret);
 		goto err;
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index c8ca3ab4d5e1a..ff62773cfa9ab 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -206,8 +206,6 @@ struct ath12k_pdev_dp {
 #define DP_REO_DST_RING_MAX		8
 #define DP_REO_DST_RING_SIZE		2048
 #define DP_REO_REINJECT_RING_SIZE	32
-#define DP_RX_RELEASE_RING_SIZE(ab) \
-	((ab)->profile_param->dp_params.rx_release_ring_size)
 #define DP_REO_EXCEPTION_RING_SIZE	128
 #define DP_REO_CMD_RING_SIZE		256
 #define DP_REO_STATUS_RING_SIZE		2048
@@ -716,6 +714,12 @@ ath12k_dp_num_rx_spt_pages(const struct ath12k_dp_profile_params *p)
 	return ath12k_dp_rx_desc_count(p) / ATH12K_MAX_SPT_ENTRIES;
 }
 
+static inline u32
+ath12k_dp_rx_release_ring_size(const struct ath12k_dp_profile_params *p)
+{
+	return p->rx_release_ring_size;
+}
+
 void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif);
 void ath12k_dp_partner_cc_init(struct ath12k_base *ab);
 int ath12k_dp_pdev_alloc(struct ath12k_base *ab);
-- 
2.53.0



