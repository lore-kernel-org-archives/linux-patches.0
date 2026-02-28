Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCF636E475
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300972; cv=none; b=muIVRxB5nimFEDokiKXezbhtCs8wh/H+axp7gvfa3SCNCOvMYwVvpO080sfYelrSwgJBBd0PE4mRDVlTtYGYI4zQ5nb/cdeOOxjbWR/YiDS4GibIAdJLPD75tL8ljif1yBY/ExVymt8dytc0XLdy3vJUhHeouR6KIGxCKLs7nP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300972; c=relaxed/simple;
	bh=LuI33bgiqRzgyD0cSy4CWOiV+N3FunkXLe//Bqkj0P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYAU6gvjCjv1HPZECqX7mb8HC0+8cU3x9A0sEq8Hg83OTJYFfyhoagvyTNRI/N0acOigKryOyxiqpqFYNXoNzgqgPJYWVTrDiOhQkki2M7mEOw5KjKBqMhQZFM2Lyo+b4MIOwi7+hcI3/8tjIfSRI4qYZz3cNJ1nhK59XtZz2Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kI1ZTErc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kI1ZTErc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF0BC19423;
	Sat, 28 Feb 2026 17:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300972;
	bh=LuI33bgiqRzgyD0cSy4CWOiV+N3FunkXLe//Bqkj0P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kI1ZTErcPhtL52/4NIset1l0dFdiEZU7Twubj+EUN4XCDxFOkVGZAuMD3FiEafn5y
	 cT8drvaibP22BiYTGHtUqqWREf9GgdICZBhoNt8nU2FEdJXeHuty9puLVD96+74UTA
	 KFJ7smRzHrTKBQ81qe++ug4JUrknCdqP1sp2fwucWUCAd72qL9FzqkTXUblLv06JlG
	 RqsIL+GsqNsiy0A+LMqEK5mwQPtQ1LbT57UiW2RIMTy1WlUNdTFe/Ln1vBjDpXNKAB
	 ZokmeSZu4QaI16Gv1dLjQl2pKMrJ9P/MbtVjbR2BVGNUnJFmy03dyr8v4dbWivZ+Wt
	 jSsuKLCJUUUMQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Lili Li <lili.li@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 099/752] EDAC/igen6: Add more Intel Panther Lake-H SoCs support
Date: Sat, 28 Feb 2026 12:36:50 -0500
Message-ID: <20260228174750.1542406-99-sashal@kernel.org>
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

From: Lili Li <lili.li@intel.com>

[ Upstream commit 4c36e6106997b6ad8f4a279b4bdbca3ed6f53c6c ]

Add more Intel Panther Lake-H SoC compute die IDs for EDAC support.

Signed-off-by: Lili Li <lili.li@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Link: https://patch.msgid.link/20251124131537.3633983-1-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/igen6_edac.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index 2fc59f9eed691..9202e6e2daf4e 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -274,6 +274,16 @@ static struct work_struct ecclog_work;
 #define DID_PTL_H_SKU1	0xb000
 #define DID_PTL_H_SKU2	0xb001
 #define DID_PTL_H_SKU3	0xb002
+#define DID_PTL_H_SKU4	0xb003
+#define DID_PTL_H_SKU5	0xb004
+#define DID_PTL_H_SKU6	0xb005
+#define DID_PTL_H_SKU7	0xb008
+#define DID_PTL_H_SKU8	0xb011
+#define DID_PTL_H_SKU9	0xb014
+#define DID_PTL_H_SKU10	0xb015
+#define DID_PTL_H_SKU11	0xb028
+#define DID_PTL_H_SKU12	0xb029
+#define DID_PTL_H_SKU13	0xb02a
 
 /* Compute die IDs for Wildcat Lake with IBECC */
 #define DID_WCL_SKU1	0xfd00
@@ -636,6 +646,16 @@ static struct pci_device_id igen6_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, DID_PTL_H_SKU1), (kernel_ulong_t)&mtl_p_cfg },
 	{ PCI_VDEVICE(INTEL, DID_PTL_H_SKU2), (kernel_ulong_t)&mtl_p_cfg },
 	{ PCI_VDEVICE(INTEL, DID_PTL_H_SKU3), (kernel_ulong_t)&mtl_p_cfg },
+	{ PCI_VDEVICE(INTEL, DID_PTL_H_SKU4), (kernel_ulong_t)&mtl_p_cfg },
+	{ PCI_VDEVICE(INTEL, DID_PTL_H_SKU5), (kernel_ulong_t)&mtl_p_cfg },
+	{ PCI_VDEVICE(INTEL, DID_PTL_H_SKU6), (kernel_ulong_t)&mtl_p_cfg },
+	{ PCI_VDEVICE(INTEL, DID_PTL_H_SKU7), (kernel_ulong_t)&mtl_p_cfg },
+	{ PCI_VDEVICE(INTEL, DID_PTL_H_SKU8), (kernel_ulong_t)&mtl_p_cfg },
+	{ PCI_VDEVICE(INTEL, DID_PTL_H_SKU9), (kernel_ulong_t)&mtl_p_cfg },
+	{ PCI_VDEVICE(INTEL, DID_PTL_H_SKU10), (kernel_ulong_t)&mtl_p_cfg },
+	{ PCI_VDEVICE(INTEL, DID_PTL_H_SKU11), (kernel_ulong_t)&mtl_p_cfg },
+	{ PCI_VDEVICE(INTEL, DID_PTL_H_SKU12), (kernel_ulong_t)&mtl_p_cfg },
+	{ PCI_VDEVICE(INTEL, DID_PTL_H_SKU13), (kernel_ulong_t)&mtl_p_cfg },
 	{ PCI_VDEVICE(INTEL, DID_WCL_SKU1), (kernel_ulong_t)&wcl_cfg },
 	{ },
 };
-- 
2.51.0

