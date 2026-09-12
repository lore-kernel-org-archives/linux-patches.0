Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D2744606E;
	Sat, 12 Sep 2026 08:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202768; cv=none; b=KGZ5cy0mM7MyzqJwX/ANDNxYQLVaXQBKoP6QfmXv3PPdt/n+LYKa9Z7IZh26lS68FxsYuO/PzYid0AN69SuRX5IiGrCMo/nN6/K7Ify5EjQtHXyIkUSZELljTze86pZFpc9zrnrFPa/0XODl+XbIAmB5HLOraTkq02e+SsAejC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202768; c=relaxed/simple;
	bh=DSSqkGuj0pkM/2zYIqGXO1hVngn3+fPeuh/PyAmFwYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyHPkPpVot3KUzZVTEJsJ4MJshd61e0Ome5GQFNTFbFq0yOR3ga3cUFD69EcCo07v13/oD1+Nb4D4VSy3YWJh/IFvhr4WZ4DmknfxoaosfeCaQgPwP5MOWSDakqOrQUirbBHPjikjfQrxWRzjtBEc7ppzJ5feQiLDzq6re3eKvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kohCvaKZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kohCvaKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843521F000FF;
	Sat, 12 Sep 2026 08:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202767;
	bh=X1Tfn4BJRrdV/Zzk7n3XXQCNEjSR0ZvWmKwBv9ZuqWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kohCvaKZRdgHJVul6UhUa1Z8IsmLUS2qLfqV9CBOueAARAqFC9+QwNkX32LtrebQa
	 JBLWZBugRwVOlvQLgXf1EXtfR6PB1X5nfqOxmnMJ+5oE3cOzYm3VaZFNazHHuuqBLT
	 jpquEC7lQhIQOYoJLROrxVoHBI7bXZxjHSbVYokI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1270/1815] ARM: dts: helios4: add vcc-supply to GPIO expander
Date: Sat, 12 Sep 2026 08:50:20 +0200
Message-ID: <20260912065718.831858476@linuxfoundation.org>
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



