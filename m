Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A71B2E11B9;
	Mon, 13 Apr 2026 16:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097654; cv=none; b=moDswYfMzbTYG4Mj2S05MwHMdTY7+FiIdZP0YJr1VO5wobRoLdDP4GGxEBQTx9do6VXo/+Njk6aAOUS/oPV5CZbIcgXC1P03zD9YQ4FdGm6Wv+J1voUwRZLlGX6TJxg8BdY0FotiI8S1ugLxXVH3Ras62nhUo2P3yZvcRWtaCyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097654; c=relaxed/simple;
	bh=pVx5VU7ywhr7MgDXuq7yASemaNLmO3YCq03GdbNmg7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DC1QhjlWfdU/UELYki5fmsg/ewbCAaj4P9VvPekIvEWCqC3N+nqbaOb/VBA/fuU3oB8AMyRqBU+UvNu4tkpbttxMDoCyXJ/Ig7qZs3ulCP5kYGrA6cPt0tPHMdkSBjggnxpdlucdoOWQ8psXOwNSM/PFXGGq8J4k0c8HmUtwmto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABOqtQU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABOqtQU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75004C2BCAF;
	Mon, 13 Apr 2026 16:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097653;
	bh=pVx5VU7ywhr7MgDXuq7yASemaNLmO3YCq03GdbNmg7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABOqtQU3zuMWGyPhD4pCQknOc3+Nda8MmL4nFuy0ucjNks6mszucqGoNJYVnrV2bz
	 ZMUyKVkIukmz8YkNzAQPShGBg6yn7v31zfysMeaY7Cnxkin9OX5ame/IEeQbgGoepN
	 Vm/Vho1G8R8UA2Frh750z/DD5Lgu8QwXmNF3GBGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongliang Wang <wanghongliang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 220/570] net: stmmac: dwmac-loongson: Set clk_csr_i to 100-150MHz
Date: Mon, 13 Apr 2026 17:55:51 +0200
Message-ID: <20260413155838.699143989@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit e1aa5ef892fb4fa9014a25e87b64b97347919d37 upstream.

Current clk_csr_i setting of Loongson STMMAC (including LS7A1000/2000
and LS2K1000/2000/3000) are copy & paste from other drivers. In fact,
Loongson STMMAC use 125MHz clocks and need 62 freq division to within
2.5MHz, meeting most PHY MDC requirement. So fix by setting clk_csr_i
to 100-150MHz, otherwise some PHYs may link fail.

Cc: stable@vger.kernel.org
Fixes: 30bba69d7db40e7 ("stmmac: pci: Add dwmac support for Loongson")
Signed-off-by: Hongliang Wang <wanghongliang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Link: https://patch.msgid.link/20260203062901.2158236-1-chenhuacai@loongson.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -11,7 +11,7 @@
 
 static int loongson_default_data(struct plat_stmmacenet_data *plat)
 {
-	plat->clk_csr = 2;	/* clk_csr_i = 20-35MHz & MDC = clk_csr_i/16 */
+	plat->clk_csr = 1;	/* clk_csr_i = 100-150MHz & MDC = clk_csr_i/62 */
 	plat->has_gmac = 1;
 	plat->force_sf_dma_mode = 1;
 


