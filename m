Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF8232E757;
	Sat, 12 Sep 2026 15:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225221; cv=none; b=bBo+s1XwnAK/o5TUBfefhMeMe38Sw7DG11cjIYrq0stdMp+W7tAVk2ACqPCoemSTK7YHbFejBXTzGtTo0Q5w+jhIKUTrrjv9o6g2GzLVyzVqDX2Au+6iIH9ET+5NXAf+NEWXG61dnW+rJl2f1TXA3zsCSoCnUfM3XY0nDKn54Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225221; c=relaxed/simple;
	bh=wzSepe/K4Gnm+UW0ShyaakbBBq1efyGtcHSZAqyaXBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RbO0Eorm3thjjeyDQx8jK6f5utoErr/quoO9almStpvwagzCu2rbFY8YjBbu2eUvzxl4fjB/ybx/rCeoVWvClRnCis9adJaTonFFzmHl9qLFHaxw/fmshLM9PT+9KrLjoligLAU4m0TCEs+ZQ1JdoE0BSXAYsX537jzxZfS2H78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sv9O7Lu/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sv9O7Lu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A871C1F000FF;
	Sat, 12 Sep 2026 15:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225219;
	bh=rL2XDEM+HYKeFlaB388H2xSv+0S3qXWWBtUGFS4USvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sv9O7Lu/Gd9pazfRyXVNu0/aVYw8kdTD3c7umVA7sFGzIUAEq4ulhdW/oALuBh9Ih
	 o6eRC8mxjJ5O6Zu3pWspG5V8DKTQ+n7428Y2yyyzytDflVHHJw4txr+cM1HgSC47ne
	 hKn50WDET5e84Ib3o2b5GIlV2PTKEubxoA2LEGbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tom=C3=A1=C5=A1=20Macholda?= <tomas.macholda@nic.cz>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1136/1424] arm64: dts: turris-mox: fix usb3 phys
Date: Sat, 12 Sep 2026 08:59:28 +0200
Message-ID: <20260912065632.739875884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 805ef2d79b401..1cbaae0310d6d 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -292,7 +292,8 @@ connector {
 
 &usb3 {
 	status = "okay";
-	phys = <&comphy2 0>;
+	phys = <&usb2_utmi_otg_phy>, <&comphy2 0>;
+	phy-names = "usb2-phy", "usb3-phy";
 };
 
 &mdio {
-- 
2.53.0



