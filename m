Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347A01A618F;
	Tue, 30 Jul 2024 16:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356142; cv=none; b=sdFfY8SYSj5ilrYOHmn5TqMKPgiZrmp87R5fG3GAaz6F2PKQZ0vF7wo1eBFrkF77nnGJ4GGhduywg+q514YHWfB+cwRFz3zpZbnF3vGgXuHtfXwta3+OR72mTppZkCKlLcJxS7L9ImWjTaglMLaiQbv0C+TarbotBFQ+y+gVsEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356142; c=relaxed/simple;
	bh=Fa5tb5zgqcee6av3BwehimY4qh0ylHrTtyUMdAAn3jQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxiDpd3jjtRHmL9vk13GFI2FAwbP2/1oqL9zBXR7LQiOErLuy0ziCEDb51/bv5VUdSkAE1OO5MGGTDA3PohhSuNifckg72ULDmZQpFwVzh6PhQbF9OEjaLb9UIBXB1UXR6HjZI3FTN3PUmgFDtprp18xrz5VnBJVMXBQQvPWU5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=db9NEN/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="db9NEN/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1335C32782;
	Tue, 30 Jul 2024 16:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356141;
	bh=Fa5tb5zgqcee6av3BwehimY4qh0ylHrTtyUMdAAn3jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=db9NEN/ggdXWmRecHowxfuL7LeLDF2DqXT9Vzb+TeJot64Qh7xKgZ3MlOnDyDkBTm
	 GTDtUsG9g4NunLyjdu49yYONi9/ikGSCqQyDS0zdeEUCCgQCU/5y1NGhkNqzcOUzg2
	 RzEBt4LKhVyoApv46Ti0In93TJoQOB1KzLopwp9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 123/809] arm64: dts: renesas: r9a08g045: Add missing hypervisor virtual timer IRQ
Date: Tue, 30 Jul 2024 17:39:59 +0200
Message-ID: <20240730151729.475587169@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 10f9badc473d43ebfddd1ddedbcb8eb3f8f3fdd9 ]

Add the missing fifth interrupt to the device node that represents the
ARM architected timer.  While at it, add an interrupt-names property for
clarity,

Fixes: e20396d65b959a65 ("arm64: dts: renesas: Add initial DTSI for RZ/G3S SoC")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Tested-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/884c683fb6c1d1bf7d0d383a8df8f65a0a424dc7.1718890849.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a08g045.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a08g045.dtsi b/arch/arm64/boot/dts/renesas/r9a08g045.dtsi
index f5f3f4f4c8d67..a2adc4e27ce97 100644
--- a/arch/arm64/boot/dts/renesas/r9a08g045.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a08g045.dtsi
@@ -294,6 +294,9 @@ timer {
 		interrupts-extended = <&gic GIC_PPI 13 IRQ_TYPE_LEVEL_LOW>,
 				      <&gic GIC_PPI 14 IRQ_TYPE_LEVEL_LOW>,
 				      <&gic GIC_PPI 11 IRQ_TYPE_LEVEL_LOW>,
-				      <&gic GIC_PPI 10 IRQ_TYPE_LEVEL_LOW>;
+				      <&gic GIC_PPI 10 IRQ_TYPE_LEVEL_LOW>,
+				      <&gic GIC_PPI 12 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-names = "sec-phys", "phys", "virt", "hyp-phys",
+				  "hyp-virt";
 	};
 };
-- 
2.43.0



