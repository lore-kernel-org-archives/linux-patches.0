Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A19E1C5799;
	Sat, 12 Sep 2026 15:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225327; cv=none; b=fnXuOwQy0xEV6ZTt0uUx9+4DNp8BOcVBEtabaJ+E5NLBWHbXqWwoep8aqOCDlYyDqgzLwvTFBWdQf44DpF/6mUSUySnHSuUPsO3FUlEiQkmnt7uY6o0t7o1ijH5hre7BAzNssoP1PM7HJgzZJ95cwPQnucwJjj6lD/6rEqC+zZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225327; c=relaxed/simple;
	bh=gblx8dguYciVS4VDGZOScFB6VxxaDBg3XoDDOWeoVms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pr6AbLLjE0JDjo3/+eh1NDKtipfPsK0SEMzWGxSAee0rkY3DX0ybHHqYoX/HGACmar/ReXYXEGl5rXdaUzOsIZb40AsVVQTIdCGennJW7MpYxBWj/XvO78Ct9RzBg4EP6XHbMg0wMRPrg1y5Z2o0Xk1eR/KSDmyn85RjBwYtvL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbAx9P4l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbAx9P4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF71B1F000FF;
	Sat, 12 Sep 2026 15:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225326;
	bh=t+FwO+SCOk0dZwG7iiSZwrIRWBQs22dDw0wPK1Yuyxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wbAx9P4l53z/QxCfQlvNe4//2Y18LBQPWf879J9ecORa88sa84pyHA5rgyUNE/NKI
	 NSd8gNf7DtrkLN+UMPpnnco90sxBPGB/DIEz7I5mcEnEPxssnPo/4kmM1K6P3ItfOS
	 XXRvabAiUu4OHKr9wW2wV4qLtYZid6TQFErdBjIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1138/1424] ARM: dts: helios4: add vcc-supply to GPIO expander
Date: Sat, 12 Sep 2026 08:59:30 +0200
Message-ID: <20260912065632.783941777@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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



