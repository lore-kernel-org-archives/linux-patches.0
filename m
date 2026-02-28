Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BF043636C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301160; cv=none; b=VQwStP4eXHgGv3AEvzoiITFSvZY4weaQf1rvJvzDyQ2Zc6Cd9CpUY0UrV+JMBWJ95hGskPGNgKLP/Upfo9RwtYeUqgt7Ltmp1lc+aXQyEeHdeADE4mchzWONB+/uxq8TPBE90wFhqUyFXQ8XRUOpokaVcyQtZxwNisJJsVk91qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301160; c=relaxed/simple;
	bh=NTHk+Aj+yk0JQZSMKMquAes9wACrqJ8bnwzA5E35qOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtZs2+2jN3RX/qa3lFzXW2Gm48GBbBQZoO/EQ2V0J+8Zss6p0AnKiSsOL9A6KRtvf6ce7eD4VVglU6zo8lD7XZh1q0egjzr3ZwRsXcrk+K2AG4BPMn8IH7FbTMjis+kqTPIvu9gCHU2bypcCpIpv/u/lIC97aIcN1211iCLavB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RkjM0QBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RkjM0QBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342EFC19423;
	Sat, 28 Feb 2026 17:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301159;
	bh=NTHk+Aj+yk0JQZSMKMquAes9wACrqJ8bnwzA5E35qOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkjM0QBNUYB4Nj9U/jrT6VIEZm+KtBYGWEzoR6Wp2VzPoyUEneNAAI5kGRgSoj5Nj
	 IwleltK9e458/+2UJrUqvtP64+PXxNJSxpHgOyaKUg+Hdb03F0WGAq1bxmrvbe7HBd
	 h86SjyyXuq/B3qglZqOv00Ox4kpuStrKDm2FUHACIrtir0AmsA9Bp0bYQ1hY+rBUd+
	 3QFGN/ZCio/4oagnDSl/3b/9ud24wslc/bonCAfDH0Nkh9ZV3N5OojvLCasDgt0Wdt
	 R86THnCpKvYYJo4SjD5zgWErJfNNlUxLS1UXAGStIYDgeAZ0B7D/aFnu0oxOHsigdm
	 OZRjQ6Y+OawcA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 324/752] soundwire: dmi-quirks: add mapping for Avell B.ON (OEM rebranded of NUC15)
Date: Sat, 28 Feb 2026 12:40:35 -0500
Message-ID: <20260228174750.1542406-324-sashal@kernel.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 59946373755d71dbd7614ba235e0093159f80b69 ]

Avell B.ON is an OEM re-branded NUC15 'Bishop County' LAPBC510 and
LAPBC710.

Link: https://github.com/thesofproject/linux/issues/5529
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20251215130947.31385-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 91ab97a456fa9..5854218e1a274 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -122,6 +122,17 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)intel_tgl_bios,
 	},
+	{
+		/*
+		 * quirk used for Avell B.ON (OEM rebrand of NUC15 'Bishop County'
+		 * LAPBC510 and LAPBC710)
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Avell High Performance"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "B.ON"),
+		},
+		.driver_data = (void *)intel_tgl_bios,
+	},
 	{
 		/* quirk used for NUC15 'Rooks County' LAPRC510 and LAPRC710 skews */
 		.matches = {
-- 
2.51.0

