Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9C3346E7B;
	Tue, 16 Dec 2025 12:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887622; cv=none; b=HLHe1vKRh8kDK68L7hs8AhJU9WRsiUbQt71bGAkd57WHlTo1jN+zc+zeKrxlmuHQsj8Mhd7JJFJh06BKcsDF6aab+Q7yCGi87IJ2qWmDNBJh/p/Mon+Iyg+p+0zMXyEyOJrakWnsskGJ0lb4vHEdK7F5ftOcQo67LkVVFSBcVHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887622; c=relaxed/simple;
	bh=xno/SCRKm25WvnYPB8P7lLm3ZDqKHezviUzmYXSPojs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzd6KrQnpeHu2cQNwXunnASAS+1fjiMwCVnFeVoVByZ2TfScoTfpg6QYvd70Zb5ZNOFWgUGvHv38wFSKjE/W6n2NF28IkQddWQch6pT9nq9XgiI32L61p1p5Cl63aXBDrjR3bOQNOKWMy8n0b/4uCJh2+JTcXBrZsqDjVmIgjik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QAxUgtgf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QAxUgtgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E7BC4CEF5;
	Tue, 16 Dec 2025 12:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887622;
	bh=xno/SCRKm25WvnYPB8P7lLm3ZDqKHezviUzmYXSPojs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QAxUgtgfZKNAor6Y78KqOQUiyCPQ1NBloePfJINAMjU7tm68Q2dD0gErH1aF1/pj5
	 do6bBjZqBM9vZRAw87o/3kawLd46O3T2UFHnGQDuyO7ReZgclAMMR8KOa3V0raUQFf
	 /I7ggyktJfiUMjHn0OS/+dAzDnVKRrJSMD+V1TK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 288/614] soc/tegra: fuse: speedo-tegra210: Update speedo IDs
Date: Tue, 16 Dec 2025 12:10:55 +0100
Message-ID: <20251216111411.805389798@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit ce27c9c2129679551c4e5fe71c1c5d42fff399c2 ]

Existing code only sets CPU and GPU speedo IDs 0 and 1. The CPU DVFS
code supports 11 IDs and nouveau supports 5. This aligns with what the
downstream vendor kernel supports. Align SKUs with the downstream list.

The Tegra210 CVB tables were added in the first referenced fixes commit.
Since then, all Tegra210 SoCs have tried to scale to 1.9 GHz, when the
supported devkits are only supposed to scale to 1.5 or 1.7 GHZ.
Overclocking should not be the default state.

Fixes: 2b2dbc2f94e5 ("clk: tegra: dfll: add CVB tables for Tegra210")
Fixes: 579db6e5d9b8 ("arm64: tegra: Enable DFLL support on Jetson Nano")
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/fuse/speedo-tegra210.c | 62 ++++++++++++++++--------
 1 file changed, 43 insertions(+), 19 deletions(-)

diff --git a/drivers/soc/tegra/fuse/speedo-tegra210.c b/drivers/soc/tegra/fuse/speedo-tegra210.c
index 695d0b7f9a8ab..a8cc363297723 100644
--- a/drivers/soc/tegra/fuse/speedo-tegra210.c
+++ b/drivers/soc/tegra/fuse/speedo-tegra210.c
@@ -65,27 +65,51 @@ static void __init rev_sku_to_speedo_ids(struct tegra_sku_info *sku_info,
 	sku_info->gpu_speedo_id = 0;
 	*threshold = THRESHOLD_INDEX_0;
 
-	switch (sku) {
-	case 0x00: /* Engineering SKU */
-	case 0x01: /* Engineering SKU */
-	case 0x07:
-	case 0x17:
-	case 0x27:
-		if (speedo_rev >= 2)
+	if (sku_info->revision >= TEGRA_REVISION_A02) {
+		switch (sku) {
+		case 0x00: /* Engineering SKU */
+		case 0x01: /* Engineering SKU */
+		case 0x13:
+			sku_info->cpu_speedo_id = 5;
+			sku_info->gpu_speedo_id = 2;
+			break;
+
+		case 0x07:
+		case 0x17:
+		case 0x1F:
+			sku_info->cpu_speedo_id = 7;
+			sku_info->gpu_speedo_id = 2;
+			break;
+
+		case 0x27:
+			sku_info->cpu_speedo_id = 1;
+			sku_info->gpu_speedo_id = 2;
+			break;
+
+		case 0x83:
+			sku_info->cpu_speedo_id = 3;
+			sku_info->gpu_speedo_id = 3;
+			break;
+
+		case 0x87:
+			sku_info->cpu_speedo_id = 2;
 			sku_info->gpu_speedo_id = 1;
-		break;
-
-	case 0x13:
-		if (speedo_rev >= 2)
-			sku_info->gpu_speedo_id = 1;
-
-		sku_info->cpu_speedo_id = 1;
-		break;
-
-	default:
+			break;
+
+		case 0x8F:
+			sku_info->cpu_speedo_id = 9;
+			sku_info->gpu_speedo_id = 2;
+			break;
+
+		default:
+			pr_err("Tegra210: unknown revision 2 or newer SKU %#04x\n", sku);
+			/* Using the default for the error case */
+			break;
+		}
+	} else if (sku == 0x00 || sku == 0x01 || sku == 0x07 || sku == 0x13 || sku == 0x17) {
+		sku_info->gpu_speedo_id = 1;
+	} else {
 		pr_err("Tegra210: unknown SKU %#04x\n", sku);
-		/* Using the default for the error case */
-		break;
 	}
 }
 
-- 
2.51.0



