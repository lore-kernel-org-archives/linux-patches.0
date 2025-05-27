Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2191FB3;
	Tue, 27 May 2025 17:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367924; cv=none; b=TkNev3qrjleDn9aVbvH6gtIGj+PpWdUjCmjj5+qOyrLQ1ZWBLdvpBby6HFJJqBJLopHJdq2IZrws6seEST5aVZvc8TSVAnnGkDucnNhatj+V4rU2xH9SgfWdZhlz+5+jKTj3n7fboNx0kBWh0oOCDd3+Cu5PoX8WSDSlBBmLkUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367924; c=relaxed/simple;
	bh=6zg9yQtG0tB8WkGAD1sKGoh7hoz09HnV48rU/mgx7Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9UB9W6jxKGpI01lsQ0T9ZA3wa5kY1bDUnNdgsSXnjBogxsBVXgWmeD73p3llfZuPh4nayEBYnz1dTnxJQ9CrxK6Ud6hIea0Ay67f8e5akK2y8iKD1WgC8T4BKdDZGZ5B5sl8NezhBdFgE+e5J10ccLqvuE6tAempSuRd7228Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0PMD2GZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0PMD2GZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E60C4CEE9;
	Tue, 27 May 2025 17:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367924;
	bh=6zg9yQtG0tB8WkGAD1sKGoh7hoz09HnV48rU/mgx7Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0PMD2GZwpLyKaPN8KKpYMBfn+Dpv+jjx61I0PyetSgUIuYhJ0BTVXb7ENSo58wb5
	 TA1uRAC9AKwYpbaxqBhuvyivua4X2PsRA+1rpaXjxcj9ScgUla/n3oHzld8cA/4B9V
	 i4Q7D7DJc4K8vv3vR5YyfzsGbLmwKaCEcxU7mB+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <quic_aarasahu@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 513/783] wifi: ath12k: Enable MLO setup ready and teardown commands for single split-phy device
Date: Tue, 27 May 2025 18:25:10 +0200
Message-ID: <20250527162534.033048522@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaradhana Sahu <quic_aarasahu@quicinc.com>

[ Upstream commit 5cec2d86c7f4242fb30a696d8e6fd48109bf3e8f ]

When multi-link operation(MLO) is enabled through follow-up patches in
the single split-phy device, the firmware expects hardware links
(hw_links) information from the driver.

If driver does not send WMI multi-link setup and ready command to the
firmware during MLO setup for single split-phy device, the firmware will
be unaware of the hw_links component of the multi-link operation. This may
lead to firmware assert during multi-link association.

Therefore, enable WMI setup, ready and teardown commands for single
split-phy PCI device.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Signed-off-by: Aaradhana Sahu <quic_aarasahu@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250207050327.360987-2-quic_aarasahu@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.c | 33 +++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath12k/core.h |  1 +
 drivers/net/wireless/ath/ath12k/mac.c  |  9 +++++++
 3 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 212cd935e60a0..ffd173ff7b08c 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -887,10 +887,41 @@ static void ath12k_core_hw_group_stop(struct ath12k_hw_group *ag)
 	ath12k_mac_destroy(ag);
 }
 
+u8 ath12k_get_num_partner_link(struct ath12k *ar)
+{
+	struct ath12k_base *partner_ab, *ab = ar->ab;
+	struct ath12k_hw_group *ag = ab->ag;
+	struct ath12k_pdev *pdev;
+	u8 num_link = 0;
+	int i, j;
+
+	lockdep_assert_held(&ag->mutex);
+
+	for (i = 0; i < ag->num_devices; i++) {
+		partner_ab = ag->ab[i];
+
+		for (j = 0; j < partner_ab->num_radios; j++) {
+			pdev = &partner_ab->pdevs[j];
+
+			/* Avoid the self link */
+			if (ar == pdev->ar)
+				continue;
+
+			num_link++;
+		}
+	}
+
+	return num_link;
+}
+
 static int __ath12k_mac_mlo_ready(struct ath12k *ar)
 {
+	u8 num_link = ath12k_get_num_partner_link(ar);
 	int ret;
 
+	if (num_link == 0)
+		return 0;
+
 	ret = ath12k_wmi_mlo_ready(ar);
 	if (ret) {
 		ath12k_err(ar->ab, "MLO ready failed for pdev %d: %d\n",
@@ -932,7 +963,7 @@ static int ath12k_core_mlo_setup(struct ath12k_hw_group *ag)
 {
 	int ret, i;
 
-	if (!ag->mlo_capable || ag->num_devices == 1)
+	if (!ag->mlo_capable)
 		return 0;
 
 	ret = ath12k_mac_mlo_setup(ag);
diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index ee595794a7aee..6325ac493f82c 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -1084,6 +1084,7 @@ int ath12k_core_resume(struct ath12k_base *ab);
 int ath12k_core_suspend(struct ath12k_base *ab);
 int ath12k_core_suspend_late(struct ath12k_base *ab);
 void ath12k_core_hw_group_unassign(struct ath12k_base *ab);
+u8 ath12k_get_num_partner_link(struct ath12k *ar);
 
 const struct firmware *ath12k_core_firmware_request(struct ath12k_base *ab,
 						    const char *filename);
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 9c3e66dbe0c3b..9123ffab55b52 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -11140,6 +11140,9 @@ static int __ath12k_mac_mlo_setup(struct ath12k *ar)
 		}
 	}
 
+	if (num_link == 0)
+		return 0;
+
 	mlo.group_id = cpu_to_le32(ag->id);
 	mlo.partner_link_id = partner_link_id;
 	mlo.num_partner_links = num_link;
@@ -11169,10 +11172,16 @@ static int __ath12k_mac_mlo_teardown(struct ath12k *ar)
 {
 	struct ath12k_base *ab = ar->ab;
 	int ret;
+	u8 num_link;
 
 	if (test_bit(ATH12K_FLAG_RECOVERY, &ab->dev_flags))
 		return 0;
 
+	num_link = ath12k_get_num_partner_link(ar);
+
+	if (num_link == 0)
+		return 0;
+
 	ret = ath12k_wmi_mlo_teardown(ar);
 	if (ret) {
 		ath12k_warn(ab, "failed to send MLO teardown WMI command for pdev %d: %d\n",
-- 
2.39.5



