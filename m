Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A2D33F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301088; cv=none; b=BZy5xxkPha14/tIBHHDbciVc6BQyZSbJK9uqv9+3mTb9w4M/6tobtEeRE9LGudf28/8n+HmHoQXOEVpgFba+3GWM0mh/7szf+2qk0Md1AlkfTZxXeG6ch8tFa9Ia77LERBrzPBhbFRLlqGptoIhLA4sMoULJgMO1ZKJLPDGrBhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301088; c=relaxed/simple;
	bh=lcDeFNBWSFo8oY08B/UekAKMABrcudq9S4nux/vEcbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=deXqpEcpTANggwLX9daTisKH3fMe+65qFNIX0maneQsT9UKYoxcQYnt5M6oE2h1ObUxmuvJo3i9sKT4YZOpfIpgsGyjpf9qSEtRAT6QQCQi20LfcOKx3RY7Nhnb13MIVqw1dCRxFy2rgmxB0LmU5uFp5UaXZzjONGNYBg6PP03w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OVCP8FJH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OVCP8FJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC813C116D0;
	Sat, 28 Feb 2026 17:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301088;
	bh=lcDeFNBWSFo8oY08B/UekAKMABrcudq9S4nux/vEcbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVCP8FJHKMNIGZqNHipbD/Dzf8KCBIuYelEeuAwQOEr1Za7l00/32SH+M6ZeA6dzu
	 IwNMijbTle+BfRqbwIrnvvmmlt+aKcwYrYZ0Z62kAtSBKViMaFp2YqDcNwE5SacWpZ
	 tlay4Hy8rvkCcG6opnmwuzwxTr2ujBDjs+7jaPZb5ReoIB4wn5Gr1KYtT/HScbWGI8
	 2sDAWoYoaRhpcrQktRzo9M0nCmswS7T+++sF6KfV6tZYCkdmL3tUF9mauke3Eid72G
	 TZBO3ZshxvOZo8VXOMlh0G2kXDkdlb2vbBlbQwirRyZovps71rBm35TqIVAOk4Bvg9
	 QY54kj325VzmA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ross Vandegrift <ross@kallisti.us>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 238/752] wifi: ath11k: add pm quirk for Thinkpad Z13/Z16 Gen1
Date: Sat, 28 Feb 2026 12:39:09 -0500
Message-ID: <20260228174750.1542406-238-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ross Vandegrift <ross@kallisti.us>

[ Upstream commit 4015b1972763d7d513172276e51439f37e622a92 ]

Z16 Gen1 has the wakeup-from-suspend issues from [1] but was never added
to the appropriate quirk list.  I've tested this patch on top of 6.18.2,
it fixes the issue for me on 21D4

Mark Pearson provided the other product IDs covering the second Z16 Gen1
and both Z13 Gen1 identifiers.  They share the same firmware, and folks
in the bugzilla report do indeed see the problem on Z13.

[1] - https://bugzilla.kernel.org/show_bug.cgi?id=219196

Signed-off-by: Ross Vandegrift <ross@kallisti.us>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Tested-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://patch.msgid.link/wj7o2kmb7g54stdjvxp2hjqrnutnq3jbf4s2uh4ctvmlxdq7tf@nbkj2ebakhrd
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c | 28 ++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 06b4df2370e95..78a1b0edd8b45 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -994,6 +994,34 @@ static const struct dmi_system_id ath11k_pm_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21F9"),
 		},
 	},
+	{
+		.driver_data = (void *)ATH11K_PM_WOW,
+		.matches = { /* Z13 G1 */
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21D2"),
+		},
+	},
+	{
+		.driver_data = (void *)ATH11K_PM_WOW,
+		.matches = { /* Z13 G1 */
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21D3"),
+		},
+	},
+	{
+		.driver_data = (void *)ATH11K_PM_WOW,
+		.matches = { /* Z16 G1 */
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21D4"),
+		},
+	},
+	{
+		.driver_data = (void *)ATH11K_PM_WOW,
+		.matches = { /* Z16 G1 */
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21D5"),
+		},
+	},
 	{}
 };
 
-- 
2.51.0

