Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39ED547ACE6;
	Sat, 12 Sep 2026 12:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217751; cv=none; b=HplRyigPoHDYBLFHaAfNvcSPVpWn0c7evfBPCgxlSpudgXsGN6IGEm4/FTeHtj5+hek05TFA2ZABmEFlkKdgtWgJizJfXOQPEk/8ZuKkT9Eg4ObC5o4dktHu6oD7bYhOQOuv1FUuh3jgBNtNgMam7CIh89+AQkI5K60elxfHUpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217751; c=relaxed/simple;
	bh=IUUkt7eo2o8JuzDD6jNiwzj86gvF0vQdCafuw6f12GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fuSGyPA7ZEqxd4XBpxB7/VaINhkEquRFkOySa/csw4YEy0dXx0Anrfv7MQEtaX+knh4JMXtmB8gwf71IGCZB4UfB+p8gNMSDWwOyYMQ26eBvmgktuDOPG0YTjGvKHINJ+rI0Ng3kE21Xf/Rk8FA9zOcRkbdhy0hRT0xU1Zx4CBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IWAxsWr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IWAxsWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B581F00893;
	Sat, 12 Sep 2026 12:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217749;
	bh=rWTbpiROBpmW+utDij03in3c5cCNZ93AWdKqqFBZUxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1IWAxsWr2gKZfoh9eg79KtVlHaQGyxdb9titt90YLjeX425jBLVWtapKqOkn6konE
	 fCr8l+jIVBJ7bxbmBd3Lla9kr80elDEknBK7yIAzy6gi2pXJovS980/9feT0TW3PJO
	 448YPvd/DyfBC7+zyMe0itcBgGymgtsuVhA2kf4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tom=C3=A1=C5=A1=20Macholda?= <tomas.macholda@nic.cz>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1002/1376] arm64: dts: turris-mox: fix usb3 phys
Date: Sat, 12 Sep 2026 08:57:08 +0200
Message-ID: <20260912065629.896812099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 54453b0a91f96..2c4b8f3f43e03 100644
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



