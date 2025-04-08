Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7C126989E;
	Tue,  8 Apr 2025 12:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115539; cv=none; b=DLwcMpyGNfUvI41NzCU+3gHKi/UtF1awM0cPe2/8wL0toOPTS84sYjT/l9iq6U3pNlzdFBRuF90XMp5GDOKOdy8QVWttajVfEbFKQMm3ZawrviaMsYxfvLcRcGDaZ9mJ0940/Ky+phNu4x+x9T66s0okIcGBW8EB1uES21TqF8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115539; c=relaxed/simple;
	bh=Q2nOfWlS3vHpJgxjt93ZWYTosbtSClI7EOcK77PEvtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fc/EU4LfQUzAhkhh31p8Onr26gmGL1RgCT7ZYqB99vP8HJ4/6QUlCEvudBFKuzngb6R3gOyI8TKsr9eYVzjriOIxuEF3NhTJ6wV+/yidVUZnY1l1j9s5x8YJvLaJdVCHcnDAs669B9G6y0jxUZw/6cWzOEyqZhcEi+OHrcBZF7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlVFq1G7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlVFq1G7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBBBC4CEE5;
	Tue,  8 Apr 2025 12:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115538;
	bh=Q2nOfWlS3vHpJgxjt93ZWYTosbtSClI7EOcK77PEvtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlVFq1G7vwVuUE8nyLZRre7orXVHdUGnV9rcGqXF+aFaQmqUmduHb4ce6x5+CorNE
	 Y+7RrZXWBQXsnHokKi4/G0FDx+4OUbPLum/hAZZWSmoSkBagRjguug4lhEBcpFdR2m
	 YVCs6PqfQlsTg6tKocm81WkCRj1A6Prv8ghkFNIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Gary Wang <gary.c.wang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/204] EDAC/ie31200: Fix the size of EDAC_MC_LAYER_CHIP_SELECT layer
Date: Tue,  8 Apr 2025 12:49:03 +0200
Message-ID: <20250408104820.701183195@linuxfoundation.org>
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
index 9ef13570f2e54..98d74c604d726 100644
--- a/drivers/edac/ie31200_edac.c
+++ b/drivers/edac/ie31200_edac.c
@@ -91,8 +91,6 @@
 	 (((did) & PCI_DEVICE_ID_INTEL_IE31200_HB_CFL_MASK) ==                 \
 	  PCI_DEVICE_ID_INTEL_IE31200_HB_CFL_MASK))
 
-#define IE31200_DIMMS			4
-#define IE31200_RANKS			8
 #define IE31200_RANKS_PER_CHANNEL	4
 #define IE31200_DIMMS_PER_CHANNEL	2
 #define IE31200_CHANNELS		2
@@ -426,7 +424,7 @@ static int ie31200_probe1(struct pci_dev *pdev, int dev_idx)
 
 	nr_channels = how_many_channels(pdev);
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
-	layers[0].size = IE31200_DIMMS;
+	layers[0].size = IE31200_RANKS_PER_CHANNEL;
 	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = nr_channels;
-- 
2.39.5



