Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8FF1A76A9;
	Tue, 30 Jul 2024 17:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360168; cv=none; b=WBIcVeFFQQC79URk3vP0qm/v0TydoFrFeYH99OQPqRzoyFIZTwEZkhV3Zmr1uywUPfMrqPJHN5U1oE7I8isXwBFUeIMgh87IlmAe6owoYpBAml6R0KnwO3SdBfocYELP87xxgJ6GnhuaJT59856rikIvO9A4oC/32OGp/AbDCxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360168; c=relaxed/simple;
	bh=gPztSG5j899hDQKRvN/pSUUyk0iWTzZQGlKThEafXss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+J3GGo+Il96XHxbffUF7MRs23VNjk0L3Y4oYPbft3N3B+033am7ssV+0odfBmLE0pl9GYNoBG9efmX9jVx+Xium8bg0YIIgCDdLerE6w4TC3BJgbQ1wBDXbzNLH8nyZsJVwrPXLgYdkjOR59MANoMD622vFSrDqmy1i+/aaT9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QR4C/JCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QR4C/JCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FF9C32782;
	Tue, 30 Jul 2024 17:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360168;
	bh=gPztSG5j899hDQKRvN/pSUUyk0iWTzZQGlKThEafXss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QR4C/JCcNUL70QZDUdWvOIadUcG0S2UwM6VLa/9qPMRrFqgfSyRmBccqQyaR4e9f1
	 P2sdkvrK6sXmutr91Fil1IUo9zBpszY1RMqVfuw9W+1+fKh7LXesjHZSp3vu3MHI9f
	 2F5n36/3VKhngfhOCs1qh6Vtae3O7wXek7ujIms8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Chen <Jason-ch.Chen@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.10 617/809] remoteproc: mediatek: Increase MT8188/MT8195 SCP core0 DRAM size
Date: Tue, 30 Jul 2024 17:48:13 +0200
Message-ID: <20240730151749.210137921@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Chen <Jason-ch.Chen@mediatek.com>

commit 19cb6058620620e68f1a9aed99393be5c3629db4 upstream.

The current DRAM size is insufficient for the HEVC feature, which
requires more memory for proper functionality. This change ensures the
feature has the necessary resources.

Signed-off-by: Jason Chen <Jason-ch.Chen@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240703034409.698-1-Jason-ch.Chen@mediatek.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/mtk_scp.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -1388,7 +1388,7 @@ static const struct mtk_scp_sizes_data d
 };
 
 static const struct mtk_scp_sizes_data mt8188_scp_sizes = {
-	.max_dram_size = 0x500000,
+	.max_dram_size = 0x800000,
 	.ipi_share_buffer_size = 600,
 };
 
@@ -1397,6 +1397,11 @@ static const struct mtk_scp_sizes_data m
 	.ipi_share_buffer_size = 600,
 };
 
+static const struct mtk_scp_sizes_data mt8195_scp_sizes = {
+	.max_dram_size = 0x800000,
+	.ipi_share_buffer_size = 288,
+};
+
 static const struct mtk_scp_of_data mt8183_of_data = {
 	.scp_clk_get = mt8183_scp_clk_get,
 	.scp_before_load = mt8183_scp_before_load,
@@ -1474,7 +1479,7 @@ static const struct mtk_scp_of_data mt81
 	.scp_da_to_va = mt8192_scp_da_to_va,
 	.host_to_scp_reg = MT8192_GIPC_IN_SET,
 	.host_to_scp_int_bit = MT8192_HOST_IPC_INT_BIT,
-	.scp_sizes = &default_scp_sizes,
+	.scp_sizes = &mt8195_scp_sizes,
 };
 
 static const struct mtk_scp_of_data mt8195_of_data_c1 = {


