Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38C0399351;
	Sat, 12 Sep 2026 20:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243277; cv=none; b=fUpsw2EV/kcD3H8c82aUHo8lrF2kUro0vaDxZ+I2TJSNWaETtxoPvAnY1ILEDIt53iHKD7avsz8T+9pu5R8040O9/JcX6/qH2EBrkzG8uPputFEatOKtAbW1ps+yMBQNRfrpKR6B3rwND6m4eZnn+UpZNSdUVM8xdaPdeNqVM8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243277; c=relaxed/simple;
	bh=iV9vDhQRdwoNwWtz3uXWR+I2u+SWxdm+MmoBqUdwp18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWyv6oIbTX6NJTq5qaPNkcnuI4ogTFvtFjG6JHRIb1mpUmkRl/vE+5/KptbU/a/hrJyV18CBH4MQKZKB02HrVkmX5BNLN4whPmLn8AkkN40IgXz2RDcchTxRmKQ2by5wquum9OueCeuNUIDp3vGTRN2opWAC01NKIbZIrD7X71A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbZAeTtI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbZAeTtI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A201F000FF;
	Sat, 12 Sep 2026 20:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243276;
	bh=GyYCAnncem+K/spxNiqEhbIekI0jNovRk99qyfZGEyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kbZAeTtIP7JgprRTtxJr5hChcV6qTpysqMr8+FYpFHAiCPGkwl2WcFL7N6vBG+pry
	 fiJZ0MKh1JTinyxE519pz37mi+cXhJN95utQ679RTWd3JjqyXY7YH/UQN7H2r9C2nS
	 DZnu9roDrZ7DGQN51HQx/QFKeFSkln1UUymcXATc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 656/798] ARM: dts: helios4: add vcc-supply to GPIO expander
Date: Sat, 12 Sep 2026 09:04:44 +0200
Message-ID: <20260912065532.148720621@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/armada-388-helios4.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/armada-388-helios4.dts b/arch/arm/boot/dts/armada-388-helios4.dts
index c335a44d24824..a018de69da83a 100644
--- a/arch/arm/boot/dts/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/armada-388-helios4.dts
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



