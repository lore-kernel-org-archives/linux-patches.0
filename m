Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6914283C82;
	Mon, 23 Mar 2026 16:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283049; cv=none; b=LZP01MxRrhSOsBQFkRlQ7uZzXI7IIZU7YTDM/LSjpf5vwAyzGx8MpFV4BCbAWGhScVq+ctx2wfeuWe5DAEi005P6gkxlxHJTQquR02FNWyihHewRZlpCavZL+QPJKlO7hrbLLoDqWJFZTGd6HXxd7ouMVY1EsewsU+C9ifTGzOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283049; c=relaxed/simple;
	bh=CXqKIwux/fyZ/yhVuLCiafygjM/kBd3jJ5zteBCqwVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3tB4ijFIuHjTaKXj4F8uwFZrgn9pk7wF6E0zMzuZDZb8TFNZBPdKAMiz4ul1XeGW1wAJOsCSpzFyksHHFoazdIIpNZre2cIGOjiiG9FVVZbGwGtgXoOC5ksqwQS59KHvcCF2Rh29FSquGC/4fZaNn7oOtHZeV5A9fXXwnvsRus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDK5HIPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDK5HIPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E52DC4CEF7;
	Mon, 23 Mar 2026 16:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283049;
	bh=CXqKIwux/fyZ/yhVuLCiafygjM/kBd3jJ5zteBCqwVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDK5HIPvH9ojJHOLlnWdIOIJOirhe5y/dPw2KtbFzIt8L66p/t37dqyk1Fd0svU48
	 F/rfbVHrcSGlf31W0XjqF4vJ/9tP+63KhYpqSDaVtjwId7W/1SzXiNhz1exrOf+qEO
	 MLrp3OxXqtzafZ+rRbTpqtOkvOC7ra0PlZ3zyjwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongliang Wang <wanghongliang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 384/481] net: stmmac: dwmac-loongson: Set clk_csr_i to 100-150MHz
Date: Mon, 23 Mar 2026 14:46:06 +0100
Message-ID: <20260323134534.499799115@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


