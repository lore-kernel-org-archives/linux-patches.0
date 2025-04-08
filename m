Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BBB26989E;
	Tue,  8 Apr 2025 12:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115541; cv=none; b=hxUfp50+L8dMbDsHbHEwADSufikt8/7DNEg4W3/W4PxVPd1TiokMZh4CcD0fbHGRTHGqnx/vyjWaK63KhijUx9ug8nWHYTpWPoFWu4hOEqyGv0jM1OvgXo1X45Q3Op5Bvwy6MN4M+j1jcSgs0nQL7R9dptifU4dI7FnlnDf7250=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115541; c=relaxed/simple;
	bh=shpgbdOJ88iBSIzaL1D5QORN/TlUz6XdLYyY3v+X2EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHIpRLGlgePy2DgT6s9iEJxDtkXI77jYPcD/Kwg/eK4Q8hIRr6rFCGpykiKTAjlDwOrC4uwqBP2+fXnsVh5g1g1ey+U5baYDyFBDf83bII2raPybsmnN9vHMoJDhfFqQOxR8BNqa9HoGox2gmCol78oOwNOx1v00EBg+jBFEttE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phHWGpiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phHWGpiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B90C4CEE5;
	Tue,  8 Apr 2025 12:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115541;
	bh=shpgbdOJ88iBSIzaL1D5QORN/TlUz6XdLYyY3v+X2EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=phHWGpiFV15tPJPQzexzDeRh8m/CyzEX9611z2QkkaRuIydubRIaNniUEM58orW1w
	 WcJliRT2AWRNWNLn858RCXkr0/9OApoyZcX/O0CpCodnizPkjb7icJQYNEL7vcjGo3
	 cnFpK3u0iNjg/ZKS5yW77DmjWGb79O6ez5BsUiXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Gary Wang <gary.c.wang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/204] EDAC/ie31200: Fix the DIMM size mask for several SoCs
Date: Tue,  8 Apr 2025 12:49:04 +0200
Message-ID: <20250408104820.732292496@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 3427befbbca6b19fe0e37f91d66ce5221de70bf1 ]

The DIMM size mask for {Sky, Kaby, Coffee} Lake is not bits{7:0},
but bits{5:0}. Fix it.

Fixes: 953dee9bbd24 ("EDAC, ie31200_edac: Add Skylake support")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Tested-by: Gary Wang <gary.c.wang@intel.com>
Link: https://lore.kernel.org/r/20250310011411.31685-3-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/ie31200_edac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/ie31200_edac.c b/drivers/edac/ie31200_edac.c
index 98d74c604d726..92714dd88b3f6 100644
--- a/drivers/edac/ie31200_edac.c
+++ b/drivers/edac/ie31200_edac.c
@@ -162,6 +162,7 @@
 #define IE31200_MAD_DIMM_0_OFFSET		0x5004
 #define IE31200_MAD_DIMM_0_OFFSET_SKL		0x500C
 #define IE31200_MAD_DIMM_SIZE			GENMASK_ULL(7, 0)
+#define IE31200_MAD_DIMM_SIZE_SKL		GENMASK_ULL(5, 0)
 #define IE31200_MAD_DIMM_A_RANK			BIT(17)
 #define IE31200_MAD_DIMM_A_RANK_SHIFT		17
 #define IE31200_MAD_DIMM_A_RANK_SKL		BIT(10)
@@ -375,7 +376,7 @@ static void __iomem *ie31200_map_mchbar(struct pci_dev *pdev)
 static void __skl_populate_dimm_info(struct dimm_data *dd, u32 addr_decode,
 				     int chan)
 {
-	dd->size = (addr_decode >> (chan << 4)) & IE31200_MAD_DIMM_SIZE;
+	dd->size = (addr_decode >> (chan << 4)) & IE31200_MAD_DIMM_SIZE_SKL;
 	dd->dual_rank = (addr_decode & (IE31200_MAD_DIMM_A_RANK_SKL << (chan << 4))) ? 1 : 0;
 	dd->x16_width = ((addr_decode & (IE31200_MAD_DIMM_A_WIDTH_SKL << (chan << 4))) >>
 				(IE31200_MAD_DIMM_A_WIDTH_SKL_SHIFT + (chan << 4)));
-- 
2.39.5



