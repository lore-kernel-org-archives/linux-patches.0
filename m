Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C4D34B43A;
	Fri, 31 Oct 2025 14:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919535; cv=none; b=hupiV5R7J1H12oq/4eim9JqWfaCqJ06EUTa1OSNyWs1h3/f5MEg0TJxFNqSkrLTv0g1PQim93YxhMLxj/FbXRJeEGasIJhVtroO40C4xKQ0+QkF01BK+UKedkoDTE+QH8W+wXYZEgHNTEsmY9sAXTIP7FfZgSdF9NTNKxPn6pf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919535; c=relaxed/simple;
	bh=g7n11iNOClODfrqU6IrBuI2wYTwKpcwJC8SmAlQH6x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZtrTK45npM01G1dg+7Hn+nbhrFOdeSw6uiyqzszyXKoHYHasRaxaruWJg2Jk7rPajqJeyoQRZ+P/M9yhKauI7novM8vXtPIh5DVAEgdTuhTp0G0SDMTxBpV+3ofVjS8Mx0GySC+hK/blZjI7OIVI3QNgNGP+KsFxQnIiUdNzc0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OA0UgyO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OA0UgyO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE22C4CEFD;
	Fri, 31 Oct 2025 14:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919535;
	bh=g7n11iNOClODfrqU6IrBuI2wYTwKpcwJC8SmAlQH6x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OA0UgyO3bsXcuaEwCm8pvYVBAWaJWApWx2dQiEgXwdfNnPrDQTfrPpkotLpnUOUyb
	 bjysCgD/uirkBisBQy5u0Nb1gjEERC+2jUhTEu7zekHzxtO6gP2ULjLSpiHyLirgB5
	 n6ay5gQF97fvIRJuhZ42XuTCb4n9UnESwkBofRCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Manna <kyle@kylemanna.com>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 11/35] EDAC/ie31200: Add two more Intel Alder Lake-S SoCs for EDAC support
Date: Fri, 31 Oct 2025 15:01:19 +0100
Message-ID: <20251031140043.827540695@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Manna <kyle@kylemanna.com>

[ Upstream commit 71b69f817e91b588030d7d47ddbdc4857a92eb4e ]

Host Device IDs (DID0) correspond to:
* Intel Core i7-12700K
* Intel Core i5-12600K

See documentation:
* 12th Generation Intel® Core™ Processors Datasheet
    * Volume 1 of 2, Doc. No.: 655258, Rev.: 011
    * https://edc.intel.com/output/DownloadPdfDocument?id=8297 (PDF)

Signed-off-by: Kyle Manna <kyle@kylemanna.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Link: https://lore.kernel.org/r/20250819161739.3241152-1-kyle@kylemanna.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/ie31200_edac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/edac/ie31200_edac.c b/drivers/edac/ie31200_edac.c
index 5c1fa1c0d12e3..5a080ab65476d 100644
--- a/drivers/edac/ie31200_edac.c
+++ b/drivers/edac/ie31200_edac.c
@@ -99,6 +99,8 @@
 
 /* Alder Lake-S */
 #define PCI_DEVICE_ID_INTEL_IE31200_ADL_S_1	0x4660
+#define PCI_DEVICE_ID_INTEL_IE31200_ADL_S_2	0x4668	/* 8P+4E, e.g. i7-12700K */
+#define PCI_DEVICE_ID_INTEL_IE31200_ADL_S_3	0x4648	/* 6P+4E, e.g. i5-12600K */
 
 /* Bartlett Lake-S */
 #define PCI_DEVICE_ID_INTEL_IE31200_BTL_S_1	0x4639
@@ -761,6 +763,8 @@ static const struct pci_device_id ie31200_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IE31200_RPL_S_6), (kernel_ulong_t)&rpl_s_cfg},
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IE31200_RPL_HX_1), (kernel_ulong_t)&rpl_s_cfg},
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IE31200_ADL_S_1), (kernel_ulong_t)&rpl_s_cfg},
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IE31200_ADL_S_2), (kernel_ulong_t)&rpl_s_cfg},
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IE31200_ADL_S_3), (kernel_ulong_t)&rpl_s_cfg},
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IE31200_BTL_S_1), (kernel_ulong_t)&rpl_s_cfg},
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IE31200_BTL_S_2), (kernel_ulong_t)&rpl_s_cfg},
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IE31200_BTL_S_3), (kernel_ulong_t)&rpl_s_cfg},
-- 
2.51.0



