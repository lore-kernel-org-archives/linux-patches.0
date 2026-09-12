Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62327313E2B;
	Sat, 12 Sep 2026 10:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210552; cv=none; b=MeMoZZCyCzArJAY89eaVwbAWy5rSm1wNKZcn6kMN+Cwas5tNopkLe+xH5/8znQEpwJ335KVnEnpaELTVo8wgHncuMSGvbfOgdZShanL3dhQkIPs8Tm6Rsaq/192vanOuS1rvv2cC1kkQy9cxzF+7xV/cWFBOfgKKBMWJdy3NC7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210552; c=relaxed/simple;
	bh=3x151O7sLLvqsRw0SeX2QRjnahOoBaQmB++namAkRPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1xSKxnJIirw0l6IXzjRxoL1KOTK+ZWPIFo6CDpY+h3wD7qXY7XYhBWo1GD31b0zlP6bddfW0cjZTlCm23k+ZiLkJnBscUiumprg3ldYRKWEcGQDk9IY9k1GIA5jJfOn2RxwIJovQZZEwHe7UGimAgMStxHoBhCMMM3v0xgrIUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adfne5Wc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adfne5Wc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C8B1F000FF;
	Sat, 12 Sep 2026 10:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210551;
	bh=pLusDkwRydnGwGYx0bQzWEgpttjS1hgCZVVlwV4r6eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adfne5WcfX9VjIdvKvUgGKyXGx7wADO+sLD1qQcATJeF7vEPoO13OYU4OhabTbtg+
	 jM/Jfb8L/CCoPfVU18KWc9dpdLDY0Q40qBqzWDOJk/En9bCA7Jk9aB24VEboFPdeGc
	 okFPFixs6Mf6zYvdj5l2QMtBo8bz3OupbefamghQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1048/1518] ARM: dts: helios4: add vcc-supply to GPIO expander
Date: Sat, 12 Sep 2026 08:53:37 +0200
Message-ID: <20260912065647.158636983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit c23988f84496e937dd255564cb30bec67608dcc6 ]

The pca953x driver requests a 'vcc' supply, producing:
  pca953x 0-0020: supply vcc not found, using dummy regulator

The PCA9655 (PCA9555-compatible) expander is powered by the same
always-on 3.3V rail as the other I2C devices on the bus.  Add
vcc-supply = <&reg_3p3v> to silence the warning.

Fixes: ced8025b569e ("ARM: dts: armada388-helios4")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/marvell/armada-388-helios4.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/marvell/armada-388-helios4.dts b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
index 61fc3adab54bb..21df1b9e3900f 100644
--- a/arch/arm/boot/dts/marvell/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
@@ -169,6 +169,7 @@ expander0: gpio-expander@20 {
 					gpio-controller;
 					#gpio-cells = <2>;
 					reg = <0x20>;
+					vcc-supply = <&reg_3p3v>;
 					pinctrl-names = "default";
 					pinctrl-0 = <&pca0_pins>;
 					interrupt-parent = <&gpio0>;
-- 
2.53.0



