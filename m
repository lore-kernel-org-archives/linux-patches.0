Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D80440A3E;
	Sat, 12 Sep 2026 08:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202759; cv=none; b=aN1d+Do8nOeB11lNSqB/FI6ilfjta+vsSymJ0wwasWdTgLTn4bpmF6Qc1q9v2YoQmhHWr0F4rv7s+iqLVWszR0Re436EyD2Tms6UqMyShZhVp6UjGOBZL4vu55MBaM75r1gaKK6nKf8QrZERXRlHhm//qib4MbQbb7I1EvHHq+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202759; c=relaxed/simple;
	bh=aigDAr+84xAj0mDvWLQeoZ0y+TqsAgBOjb82deTAgm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zwri8HY5XmNV8l2dMsuPVYnLlq6kixknEjT8EuKwKpi61ZFI8eFACAFSIHhzVAPGIosRNgM3snIIkQXM55Zs4XB3eOsJZeWLxtRFC1vcI8262medXANDqnjoS2uv5XdhiOOWdL77UbGmyJzR6iV1I5+Nz+GXjd5p3ij2WKL1xIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbH4uck9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbH4uck9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FA71F000FF;
	Sat, 12 Sep 2026 08:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202757;
	bh=E+/IbhfYUBC3QVmixuGyW3X6IRFLxDHVVnS9uIgJ7+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DbH4uck9hpO+dCA9VhhZvcEQdcMVGmbTopz0bQDSgeBrlP8NqM4X5rpTBcANNBhEy
	 9Ydz4Bg+HDUZEWAkSaQhkavlsyqQn8CTdXIzANxMiLTsnqwVRZYgkegSdwu0+2pi7N
	 VERURd67dcFhDDmmHv0KiVW64C/XIF0GgPGUOw/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tom=C3=A1=C5=A1=20Macholda?= <tomas.macholda@nic.cz>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1268/1815] arm64: dts: turris-mox: fix usb3 phys
Date: Sat, 12 Sep 2026 08:50:18 +0200
Message-ID: <20260912065718.785788887@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index f4d73c8b1a6d3..bd00e7df87c67 100644
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



