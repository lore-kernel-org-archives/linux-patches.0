Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF93434752E;
	Sat, 12 Sep 2026 07:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199826; cv=none; b=QytCaT9wRrC3VrGpeX1Ehgc9Z8SqUDRe8BjiMlvgnboCLOS0Bf983VZ9u28ZioyszWngXErLeyIoA2lHjepc3/WggHKd/njFY1rs6xZ7ALT13zbJgGkF8+a7jxv+PddJEuljl35/SOjHNYgKi/vBjQOgrhOZ1gX+JyfpO2LukiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199826; c=relaxed/simple;
	bh=W4SsM8SRGPxFET9Y3ADDUCCCixZ7UmAlbT379XiWNoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Psiaam8YxidoYeDaTRuvwpnlZ4p60vcjV8oFqXeLXUgtnCNto05s5686vdmuY3x/LFzvcHrsNCPS0f0UZvHDq3IFZ3BPrPvJiOL5Cs3zoskwJa138c/om/kHxOsxIzlCuPGO1iSd0X/FKOnzXxvYHibKPdtMU1+dxvwPZb88Amg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRGVRVje; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRGVRVje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7EC1F000FF;
	Sat, 12 Sep 2026 07:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199824;
	bh=woH1bsjiZQU7wFLC8VBfhDwPRkisaFWjtAkshR3z1zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vRGVRVje2O8PvXOlNfK5IHV7zMxrScSMHF0syrRsQCm04+krt90O15PENGLgVGlKK
	 PCxu1zlrf3vX+DLu4fIPl/pOXA84cH1JvV6dtFhJ7U2GsTUy9vp6Y8pRiyszS/hU4O
	 SOQam/rfv3bEAMxjRyC4iLu1BxWgQdRXCMDtz8w4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	E Shattow <e@freeshell.de>,
	Inochi Amaoto <inochiama@gmail.com>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0664/1815] riscv: dts: spacemit: Fix phy id check for the phy on pico-itx board
Date: Sat, 12 Sep 2026 08:40:14 +0200
Message-ID: <20260912065704.472845962@linuxfoundation.org>
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

[ Upstream commit 6d6536c880febe2340d8d388f42660eccff5aa81 ]

Current phy framework can not re-initialize the phy correctly, as it will
assert the phy reset GPIO so the phy id can not be read. Setting the
phy id of board pico-itx manually so the phy id detection can be skipped.

Fixes: 74657a376960 ("riscv: dts: spacemit: Add ethernet device for K3")
Reported-by: E Shattow <e@freeshell.de>
Reported-by: Inochi Amaoto <inochiama@gmail.com>
Closes: https://lore.kernel.org/netdev/20260712045233.800748-1-inochiama@gmail.com
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Tested-by: E Shattow <e@freeshell.de>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260725233351.55004-2-inochiama@gmail.com
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k3-pico-itx.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
index 650a0fe5b1ba8..3ed2bbcd8f836 100644
--- a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
+++ b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
@@ -191,7 +191,7 @@ &eth0 {
 
 	mdio {
 		phy0: phy@1 {
-			compatible = "ethernet-phy-ieee802.3-c22";
+			compatible = "ethernet-phy-id001c.c916";
 			reg = <1>;
 			reset-gpios = <&gpio 0 15 GPIO_ACTIVE_LOW>;
 			reset-assert-us = <10000>;
-- 
2.53.0



