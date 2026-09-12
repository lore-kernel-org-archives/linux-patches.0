Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B431399365;
	Sat, 12 Sep 2026 20:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243272; cv=none; b=uImbIkB1SWjOyFRTYZdo48A3bbtl6X8xztq0+no9bft2EP8tObjg05y0YlErPQ5whUfK+NDRcG6e8mPeqoM9RiZlT/nuykzb0Esjvkn5frfZQcgnr0IzaZLE4bZFl4RuoeOb3tBiEWSiRhLj3ka4Wt4Llrdrw3DZV+kre+Jfoqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243272; c=relaxed/simple;
	bh=Plb+QMHB4F1exdXbRhZDoEwx0zbSN/YhRWcpOUqyXWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Js6G7mLDZNREqbSlgFnEYN1KDtVlqb/EVyi5LxodWgXvzw02hTzXY7ZLJ2bC73CfwNO8cKpOKlS3rHMhgdSnf1ziyszp1YjW2oL3Lnkd0WiRbFOtqMuiXbxcmi2d2Izinqkn7e8TtY0WhGnQezl15Q9b0JNBD9g+iR7fBuQTPoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x24NUnkA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x24NUnkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6622E1F000FF;
	Sat, 12 Sep 2026 20:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243270;
	bh=GJ0h7U/DfnspBRfm8sVCsQhsKS8D7ebcGbW1AzbP+W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x24NUnkAIrxESrSdDJ14OTcTtNiWspkxYE+GhFm0ay7lqHuZ8aGMTj7rxFilbndcp
	 0KWVk6RcSIbZ1ZX/egZcqIQwpz/BgOXiRt2InlIofdcU3Xt+sPLbesUL/1da/nMy53
	 mBD+s+DEhTW249FTqHqro8A51JdIbP5z2zcrwbWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tom=C3=A1=C5=A1=20Macholda?= <tomas.macholda@nic.cz>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 654/798] arm64: dts: turris-mox: fix usb3 phys
Date: Sat, 12 Sep 2026 09:04:42 +0200
Message-ID: <20260912065532.103410741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 39e9b38757616..02f59d91295ef 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -290,7 +290,8 @@ connector {
 
 &usb3 {
 	status = "okay";
-	phys = <&comphy2 0>;
+	phys = <&usb2_utmi_otg_phy>, <&comphy2 0>;
+	phy-names = "usb2-phy", "usb3-phy";
 };
 
 &mdio {
-- 
2.53.0



