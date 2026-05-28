Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352B225F7B9;
	Thu, 28 May 2026 20:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000713; cv=none; b=VkLobF/Vo9glN9SgItSZo4e5QbY8c6nb6FE/9ck6o2lYajvMGnKx1G50zlnS6aGdg8OOlksNtryAW0s5ppuJAb19YYShuqrrcFYG6C3Ch/5fE3grADFEc1VFEzzQVrRQWBd3Xs/+g9dbUIHhZ/PgH5o1rj9tWUDhFutLxxsI9KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000713; c=relaxed/simple;
	bh=ygwnuTFAwK86YZ0soBxER8akbGHxK2c9i7v9ZWPnt2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBrTpRHSNDSRk+lmAV9cdRJaFVgNBlBKmnCXw2XENueh89wEyF3VlY00p8nDJEFd4QieY1+t90+tYxU9UNTG0IG1yJBlzHxgDGXfGnEall56831utbWu7zrK/s/Xpl5KoUpwg8NdqDdMg6yPI1ZXEuDDdw+BeF8vlm5gvK52Q78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KelXILnj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KelXILnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404421F000E9;
	Thu, 28 May 2026 20:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000711;
	bh=fLP54U2p2YJYSt69k0+PIzEkNEVWG1vczANAieSEObQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KelXILnjF30XIhLc0ajU/bDOHkT68ZhMDpXOvdFQEIOMQPxn+W4Up6BP5mY/s5V2M
	 NGQnhEgscMPLgXe/d+ZFnEdutCCopmmv4Xkwornc2wzrxpB+Riz0oAmtRSkGL+hNfh
	 DeHUDC00UPBuh1Ruo+3zz1zPnzbytzDFUBCzO8H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/272] ARM: dts: renesas: rskrza1: Drop superfluous cells
Date: Thu, 28 May 2026 21:48:37 +0200
Message-ID: <20260528194633.375362812@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit ab83176d3cf1cf1c1f6e604432905bda4515d17f ]

Drop superfluous address-cells and size-cells to fix DTC W=1 warning:

    arch/arm/boot/dts/renesas/r7s72100-rskrza1.dts:32.17-72.4: Warning (avoid_unnecessary_addr_size): /flash@18000000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property

Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Fixes: 98537eb77d3ef185 ("ARM: dts: renesas: rskrza1: Add FLASH nodes")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260327234244.91707-7-marek.vasut+renesas@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/renesas/r7s72100-rskrza1.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/renesas/r7s72100-rskrza1.dts b/arch/arm/boot/dts/renesas/r7s72100-rskrza1.dts
index b547216d48014..416c741034482 100644
--- a/arch/arm/boot/dts/renesas/r7s72100-rskrza1.dts
+++ b/arch/arm/boot/dts/renesas/r7s72100-rskrza1.dts
@@ -36,8 +36,6 @@ flash@18000000 {
 		power-domains = <&cpg_clocks>;
 		bank-width = <4>;
 		device-width = <1>;
-		#address-cells = <1>;
-		#size-cells = <1>;
 
 		partitions {
 			compatible = "fixed-partitions";
-- 
2.53.0



