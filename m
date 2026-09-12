Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44843542F8;
	Sat, 12 Sep 2026 08:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200278; cv=none; b=Hl0IyFVtieihVb2wq2bAre+LCiDgpgQbkOyWcVV7P4YNiboz/yw7fw17X6NfitP2ekPXEiTnECC+r8EH6FzkWZ99ZhrIgnq9uhUttgEo4xFGXoZz2KsIBrkKPylKro1g18g53UOGjN3dFIweRY7onWaSEFKMgEid7wwj6Z9iNTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200278; c=relaxed/simple;
	bh=H5IsBTOQZPYor3QZlkZS9zLgGPeGWHBFch+PLIOp5ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDb/hnnlwpWW++n9A7cSeKBPOMnKdrNaj5MUid1N38cTwvR//b4jbw11xbEMLeaQpxzTlazFKSJ8xcgaufoe4oJXqMw8ryMYKZkzmU2/h+DVgBqUK7aYVEdWwk4XjiAb1VCxwyqOMMKvTm3O//YRt0PUSAHv5TtayJFzVMQKTjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdSnhYrq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdSnhYrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF511F000FF;
	Sat, 12 Sep 2026 08:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200276;
	bh=/hbQSNmR9LvzUGbjCxRRRc/QKnbkDY4ZmHvTpuEFnBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qdSnhYrq5m7u4/vS+qQbSWPn0m9oIxlD2iMGz4qNcewEm4nPg0TLyMax55KCj9HFG
	 a8pNZlfYehHZz+2RBCttZ50TyXpH4C6n8cF0LmKHoXPhWdUSMh1aZKU2aPq8BAo04L
	 bEldivcC+sDlMT9by4YO+/VmjpRPA7lKzhCESFmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0730/1815] riscv: dts: spacemit: Make dtschema recognize the etherent PHY correctly on K3 pico-itx board
Date: Sat, 12 Sep 2026 08:41:20 +0200
Message-ID: <20260912065706.037212465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Inochi Amaoto <inochiama@gmail.com>

[ Upstream commit 9b371a8b13fd0e8e6f3b12f4ef7e58927d6f62ee ]

Since the previous commit does not change the phy node name,
the dtschema can not recognize the type of the ethernet phy,
so the following error is produced:

/arch/riscv/boot/dts/spacemit/k3-pico-itx.dtb: phy@1 (ethernet-phy-id001c.c916): $nodename:0: 'phy@1' does not match '^ethernet-phy(@[a-f0-9]+)?$'
        from schema $id: http://devicetree.org/schemas/net/realtek,rtl82xx.yaml
/arch/riscv/boot/dts/spacemit/k3-pico-itx.dtb: phy@1 (ethernet-phy-id001c.c916): Unevaluated properties are not allowed ('reg', 'reset-assert-us', 're
set-deassert-us', 'reset-gpios' were unexpected)
        from schema $id: http://devicetree.org/schemas/net/realtek,rtl82xx.yaml

Change the nodename to make the dtschema can recognize the right
PHY type.

Fixes: 6d6536c880fe ("riscv: dts: spacemit: Fix phy id check for the phy on pico-itx board")
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260729012418.154652-1-inochiama@gmail.com
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k3-pico-itx.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
index 3ed2bbcd8f836..86210cc6f7733 100644
--- a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
+++ b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
@@ -190,7 +190,7 @@ &eth0 {
 	status = "okay";
 
 	mdio {
-		phy0: phy@1 {
+		phy0: ethernet-phy@1 {
 			compatible = "ethernet-phy-id001c.c916";
 			reg = <1>;
 			reset-gpios = <&gpio 0 15 GPIO_ACTIVE_LOW>;
-- 
2.53.0



