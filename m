Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74652690CB;
	Tue,  8 Apr 2025 11:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110358; cv=none; b=fh2amoPoGcZ45DXTn49XfeYuZQEDY2EEMHQz4LNdCd3kYCP+ABXkuzvSGX9zHT+pmj/aDB/a6VYGKspjg4D5ZlVv3qMuWixPgqI4g9kWvlO5FnjKRRKkYsCCZb7uUFVXH0P0hXG3X1XKuGNj+zepRbw7Ef8suulmcTnG8TKdnHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110358; c=relaxed/simple;
	bh=k2u0l8DZ+w1aWWxmPKlLusjFBlM1HHYZ1hDufpC2Nv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUfpu7h37KWenyBCtaM/NfGfSehaBDt6MgHSaibjeVJk3MpnYTtQwU/+X7fykyyqBNiBviMmkIrMOWwVEw+LAN8dm8ZiO3kj8ZaOE2OBfffUrr0R2pBJ3EDF5l5aFfArnGTSCplHVjNTtjWpIUNIGihxvF9TDsTxj2mWlOV1qHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUkOMiAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUkOMiAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E95C4CEE5;
	Tue,  8 Apr 2025 11:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110358;
	bh=k2u0l8DZ+w1aWWxmPKlLusjFBlM1HHYZ1hDufpC2Nv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUkOMiAqdx14k/ekSLU+SIuzU1DXeC4eFLDRIh3vX6uqbQjkm/qZQgcIVTHPeW29p
	 MzEfBWUeYKA+AlthM0Jpe7z7g4k2T7XXbJCGf2LLaWpU/J/6k89Y05/t5MTndaw8YG
	 QqJCd35eTQgdfvarLXdc562MGtL3DZVlrodyQRyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Gary Wang <gary.c.wang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 033/731] EDAC/ie31200: Fix the size of EDAC_MC_LAYER_CHIP_SELECT layer
Date: Tue,  8 Apr 2025 12:38:50 +0200
Message-ID: <20250408104915.040510588@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit d59d844e319d97682c8de29b88d2d60922a683b3 ]

The EDAC_MC_LAYER_CHIP_SELECT layer pertains to the rank, not the DIMM.
Fix its size to reflect the number of ranks instead of the number of DIMMs.
Also delete the unused macros IE31200_{DIMMS,RANKS}.

Fixes: 7ee40b897d18 ("ie31200_edac: Introduce the driver")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Tested-by: Gary Wang <gary.c.wang@intel.com>
Link: https://lore.kernel.org/r/20250310011411.31685-2-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/ie31200_edac.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/edac/ie31200_edac.c b/drivers/edac/ie31200_edac.c
index 4fc16922dc1af..c3d34d1fc9ad7 100644
--- a/drivers/edac/ie31200_edac.c
+++ b/drivers/edac/ie31200_edac.c
@@ -94,8 +94,6 @@
 	 (((did) & PCI_DEVICE_ID_INTEL_IE31200_HB_CFL_MASK) ==                 \
 	  PCI_DEVICE_ID_INTEL_IE31200_HB_CFL_MASK))
 
-#define IE31200_DIMMS			4
-#define IE31200_RANKS			8
 #define IE31200_RANKS_PER_CHANNEL	4
 #define IE31200_DIMMS_PER_CHANNEL	2
 #define IE31200_CHANNELS		2
@@ -429,7 +427,7 @@ static int ie31200_probe1(struct pci_dev *pdev, int dev_idx)
 
 	nr_channels = how_many_channels(pdev);
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
-	layers[0].size = IE31200_DIMMS;
+	layers[0].size = IE31200_RANKS_PER_CHANNEL;
 	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = nr_channels;
-- 
2.39.5



