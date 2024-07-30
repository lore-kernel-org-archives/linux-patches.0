Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8B4189535;
	Tue, 30 Jul 2024 16:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356191; cv=none; b=feDMd9DLmhW00YC8Ch8U2vyO2rYWY2J3WHdfeBG865pYfDTTyKgoi0CwYWXoho8hCPvQxYmW+LUwukrUbMan+mVGgfe7UXoZ/IJdOx+x+vTtMuSOW0aUwBhOZ8ROekrkgmOAobFYqdw2zWCdtQStQC9DpBkTnsXyhmluwqEYJ2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356191; c=relaxed/simple;
	bh=8hqWjhsOkTjWxxkyEqf54O40ZUpZO0ige6xdNpvlk+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxT9YUP1TZaY+GqnIzmBaykYm8h9cPCVX3q9HFxDgpfYBw79iB5kcagWvinpJMPnVFdMhhmAF05ACwDVO6V5sNIU1JblzFOngv7u1HsC7Sw/PeY9Zg/ksPkwyk2Hx8hgJmSaTASLp/sYV6M/8CLxTCsA/VA0bSUrL9uf/P35B5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIMO+u/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIMO+u/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FC3C32782;
	Tue, 30 Jul 2024 16:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356191;
	bh=8hqWjhsOkTjWxxkyEqf54O40ZUpZO0ige6xdNpvlk+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIMO+u/gwrH6p8Piz5azkcAYRAsL8vxNiiUTKHeFGioLC4su7waSAn2ZqVprj724t
	 ZVDZXgDxgDa66pURx//goPxE6kjA3uIG/tLzs8DvMSbD48NY+GyCpusJNRd6o8piQN
	 TOzSgopB6oufOHC0GuIjaIQY/sn2tD7TR11pWHMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 118/809] arm64: dts: renesas: r8a779f0: Add missing hypervisor virtual timer IRQ
Date: Tue, 30 Jul 2024 17:39:54 +0200
Message-ID: <20240730151729.280101120@linuxfoundation.org>
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

[ Upstream commit b1c34567aebe300f9a0f70320eaeef0b3d56ffc7 ]

Add the missing fifth interrupt to the device node that represents the
ARM architected timer.  While at it, add an interrupt-names property for
clarity,

Fixes: c62331e8222f8f21 ("arm64: dts: renesas: Add Renesas R8A779F0 SoC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/46deba1008f73e4b6864f937642d17f9d4ae7205.1718890849.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779f0.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a779f0.dtsi b/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
index 72cf30341fc4d..9629adb47d99f 100644
--- a/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
@@ -1324,7 +1324,10 @@ timer {
 		interrupts-extended = <&gic GIC_PPI 13 IRQ_TYPE_LEVEL_LOW>,
 				      <&gic GIC_PPI 14 IRQ_TYPE_LEVEL_LOW>,
 				      <&gic GIC_PPI 11 IRQ_TYPE_LEVEL_LOW>,
-				      <&gic GIC_PPI 10 IRQ_TYPE_LEVEL_LOW>;
+				      <&gic GIC_PPI 10 IRQ_TYPE_LEVEL_LOW>,
+				      <&gic GIC_PPI 12 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-names = "sec-phys", "phys", "virt", "hyp-phys",
+				  "hyp-virt";
 	};
 
 	ufs30_clk: ufs30-clk {
-- 
2.43.0



