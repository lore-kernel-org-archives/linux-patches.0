Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216694;
	b=O3QuVlN09EGBnq3HhWEYduG7bWCg0cP9m1Z0ca58b0Vu9kL5DUylymRjnV/Pv0GyH04p
	 /Ss0j4h8kMNpnxIlgC5Hh5CpQ4WUbhleNl31tmRwM70/X1oYXBgKmQmWKTeFcrkP1Kpr8
	 6KGNvE8cHa8xnUyfBzsf9/sYIgvsmPQRQp5Ee//UaR69+Ko+3BROc98T+ZeLW6zkc6TjA
	 Uuwv7S8wEGEbpltfpW9HJmLJ9fpQErJgCyjMjQiB6/zKzRLNfGXAA+tagD1/84m/IXn73
	 aYfGBI5mQbGGXfz0cD8ceYRcqOoH8n897eZz03cNQRUR/nYv3KczvLDl4EngVJROayw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4YAJevXQgYGEs9FU/0fDJjdU4mKiw2IAygqvacDgDHk=;
	b=XVj88bVJq/XHv74IKp7CQ7ISUXd3E/bdwJv17+gJlcPSpv0SLsD0HUumAxez+XJrhWNy
	 8IFYZRzvcOitHg3lBtw6GZ2fbz2li+Pk6TVtztgIix7nbQ7cXIyNDg9YlMSlydKNEYzqZ
	 pNuKxvD2pL4uPBZ7daQnlLpWflflgqHuPEyrkEzlYXb/j5iZLbnDGnpBz6UM2uTZ5+Hn9
	 gIIn7RpEbnAX9pDR5XQ7eGrQ02RxzIlwaGGIylyv14bvARLZc62XCaxbmB6P3QJebE8GY
	 ZS0j/gRBwU/GE68Lx6aJo7U5/7zRYVxSE8UNnh3nZt+goU9gRb/0EeinsdFueoh/Wrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kv2d5Uot;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037AD606A31A;
	Wed, 28 Oct 2026 19:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kv2d5Uot
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D291F01825;
	Wed, 28 Oct 2026 19:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216693;
	bh=4YAJevXQgYGEs9FU/0fDJjdU4mKiw2IAygqvacDgDHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kv2d5Uot/k8aLFRkwmasbMz3M6INouWw0BkavlV3FOAvN+QGPklTcwVHEbDkTeSlB
	 1W3Px1oGDsvlwGMHYpTsWtv37huOust8q0Cj05b1M2wLGFEY/8Hq1H6VsRNHhDvt8x
	 kxObaB0JhpQ7XTsq6vbE5H75sC7buB/mZ+iQqa04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1603/1887] wifi: ath11k: fix overreads in ath11k_wmi_process_csa_switch_count_event()
Date: Wed, 28 Oct 2026 18:01:39 +0100
Message-ID: <20261028170535.947639754@linuxfoundation.org>
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

From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

[ Upstream commit 208d7fdb85976a737a715b81d54efaff6703880c ]

There is no policy entry for WMI_TAG_PDEV_CSA_SWITCH_COUNT_STATUS_EVENT, so
the parse infrastructure does not enforce a minimum length for the event
struct. Additionally, the num_vdevs field is taken directly from firmware
and used as a loop bound over the vdev_ids array without checking that it
fits within the TLV payload. Either condition can cause an out-of-bounds
read.

Add a TLV policy entry for WMI_TAG_PDEV_CSA_SWITCH_COUNT_STATUS_EVENT so
the parse infrastructure enforces a minimum length for the fixed-size event
struct. Add a helper ath11k_wmi_tlv_data_len() to recover the payload
length of a parsed TLV from the header preceding its data pointer. Use it
in ath11k_wmi_process_csa_switch_count_event() to bound num_vdevs before
the loop.

Compile tested only.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260724-ath12k_wmi_process_csa_switch_count_event-cleanup-v2-2-02a45d7246c0@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index b58c84c2f9dd3..579cd7a2d4279 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -145,6 +145,8 @@ static const struct wmi_tlv_policy wmi_tlv_policies[] = {
 		.min_len = sizeof(struct wmi_per_chain_rssi_stats) },
 	[WMI_TAG_TWT_ADD_DIALOG_COMPLETE_EVENT] = {
 		.min_len = sizeof(struct wmi_twt_add_dialog_event) },
+	[WMI_TAG_PDEV_CSA_SWITCH_COUNT_STATUS_EVENT] = {
+		.min_len = sizeof(struct wmi_pdev_csa_switch_ev) },
 };
 
 #define PRIMAP(_hw_mode_) \
@@ -249,6 +251,13 @@ ath11k_wmi_tlv_parse_alloc(struct ath11k_base *ab, const void *ptr,
 	return tb;
 }
 
+static u32 ath11k_wmi_tlv_data_len(const void *data)
+{
+	const struct wmi_tlv *tlv = (const struct wmi_tlv *)data - 1;
+
+	return FIELD_GET(WMI_TLV_LEN, tlv->header);
+}
+
 static int ath11k_wmi_cmd_send_nowait(struct ath11k_pdev_wmi *wmi, struct sk_buff *skb,
 				      u32 cmd_id)
 {
@@ -7656,15 +7665,23 @@ ath11k_wmi_process_csa_switch_count_event(struct ath11k_base *ab,
 					  const struct wmi_pdev_csa_switch_ev *ev,
 					  const u32 *vdev_ids)
 {
-	int i;
+	u32 vdev_ids_len = ath11k_wmi_tlv_data_len(vdev_ids);
+	u32 num_vdevs = ev->num_vdevs;
 	struct ath11k_vif *arvif;
+	int i;
 
 	/* Finish CSA once the switch count becomes NULL */
 	if (ev->current_switch_count)
 		return;
 
+	if (num_vdevs > vdev_ids_len / sizeof(*vdev_ids)) {
+		ath11k_warn(ab, "csa switch count num_vdevs %u exceeds tlv array length %u\n",
+			    num_vdevs, vdev_ids_len);
+		return;
+	}
+
 	rcu_read_lock();
-	for (i = 0; i < ev->num_vdevs; i++) {
+	for (i = 0; i < num_vdevs; i++) {
 		arvif = ath11k_mac_get_arvif_by_vdev_id(ab, vdev_ids[i]);
 
 		if (!arvif) {
-- 
2.53.0



