Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD6126B0BE;
	Tue,  8 Apr 2025 12:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116114; cv=none; b=fE4RLD9y4CeYJAhOVQiWb2lvrfnngkCY/OivNHe5Mlx+6A24elPEzRFo5h5T3tAZ3k/48P5yweDv4YT3ikiHPU/TqsPe36JC5Ov1fRh4G13xauLfLCG3JCF8HOzuP4wM1OoAjRlsgugR7+p46qz6r3lsAWRIpxnK9OWFqdUK88g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116114; c=relaxed/simple;
	bh=92fl+h5ZwjM65tT+QHG5razljnoMSvAlhUyTV/qqRGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nseO3VjTppUuHkFfcmznuM0kYV4Y3PoarbOARvLfGZi/kBUyCE7GzcRje2yWmVxWzadGE9fXTvpSQO8VEpjOAjOh08juaJTTNicYtANvTFSwviSQxIFjdspK17Zgu96ikszjKGx8TO3eoBiytRA45Qk0cvlxmzI/MYeBifGtXSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KkOOK8m9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KkOOK8m9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F30CC4CEE5;
	Tue,  8 Apr 2025 12:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116113;
	bh=92fl+h5ZwjM65tT+QHG5razljnoMSvAlhUyTV/qqRGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KkOOK8m95i5hJJneWvmtqVlEWdtWnS5+nnhxsGpFURYe9x3HHyljQngh2YMTsMSUc
	 KowYl0uvxE5BEFcEf/+3OiegyBUT1J6wjl/ccAsmf15471rxWWAs79g2EyymKZRN75
	 hDFrkOTBOTzfp7Jqjkc8ryiX5J0w1kI6vZsXSbM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Gary Wang <gary.c.wang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/423] EDAC/ie31200: Fix the size of EDAC_MC_LAYER_CHIP_SELECT layer
Date: Tue,  8 Apr 2025 12:45:47 +0200
Message-ID: <20250408104846.237564065@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



