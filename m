Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6929331EAE;
	Sat, 12 Sep 2026 16:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231132; cv=none; b=c3KE7rorRbJ7/Gzy41CoM9N1gjVO1hKd4cWbBFE3i95Oe+pUTf8i8twEGs+N3pYs6XdhsFc6AMpygGl5j5VG+e+Vy9pY4pURgU7HOYvFS/5mG/sw6tprdRpWp0iOFH7wKdlvxuvhQG0IeXaJ5HfH+LgnQ41NUzxkCkXIusgqD6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231132; c=relaxed/simple;
	bh=zIflapjNPFctEgel1wCoDheocjQh6Yx1057XYWFXbeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hppoetu1TFk02i0gsZVkCH9VWlpi2MsCMbnIfRqu8+cus6w0eJxwSraBxg/4oqvV8F4uBN3wWfjhqT3dgxcvNFpSRnaQ0ip0+/Bc7t9QULmb6uFH2wm7aTiVc1EBCG4JzBku5H0Bzo+iaQysLlh12StzsNnaSODeeBp0uGnG4DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5WLwr7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5WLwr7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB881F000FF;
	Sat, 12 Sep 2026 16:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231131;
	bh=8P3xr14jGHBH0iHHIhAUkXOGf74nMd7KRhMTuw/iBLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5WLwr7ixmOgEpKvGJEJwNmJA7KcCIOs0ZCKqMvdEnehI1dWQm6xBVpwv2ZFy1jos
	 FQZAjzdCJlFzEofK7NVkRjn+64Iuuh3gXzZ2djSC4MtB4nxjpB78dM6xVdw3hDq5SJ
	 SA9UrwaMtgBA8iTFz1QmV8e8fIbi3aZW5OxZBV4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tom=C3=A1=C5=A1=20Macholda?= <tomas.macholda@nic.cz>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0937/1191] arm64: dts: turris-mox: fix usb3 phys
Date: Sat, 12 Sep 2026 09:01:05 +0200
Message-ID: <20260912065609.271742334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomáš Macholda <tomas.macholda@nic.cz>

[ Upstream commit 0c2a8eed95160e41b367a1fa605a2c1b24a9639a ]

After commit 00e6d608fe80b0f6 ("arm64: dts: marvell: armada-37xx: swap
PHYs' order in USB3 controller node") swapped USB3 PHY order, USB
initialization breaks on Turris MOX.

This regression was exposed by commit 91ddf6f722084383 ("phy: marvell:
mvebu-a3700-utmi: fix incorrect USB2_PHY_CTRL register access") which
made USB2 devices not work at all.

Fix the issue by explicitly adding all USB3 PHYs and PHY names to
Turris MOX device-tree.

Fixes: 7109d817db2e ("arm64: dts: marvell: add DTS for Turris Mox")
Signed-off-by: Tomáš Macholda <tomas.macholda@nic.cz>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
index 37350e5fa253a..4b8cc6bca2f58 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -291,7 +291,8 @@ connector {
 
 &usb3 {
 	status = "okay";
-	phys = <&comphy2 0>;
+	phys = <&usb2_utmi_otg_phy>, <&comphy2 0>;
+	phy-names = "usb2-phy", "usb3-phy";
 };
 
 &mdio {
-- 
2.53.0



