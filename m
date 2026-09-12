Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0957F478E36;
	Sat, 12 Sep 2026 12:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217761; cv=none; b=T/L+OC+VjQZJtOBdir5drXzi5YyDSyxRchiG+6DPWYY27+iCFYhRfAD7woew/WbMUy2AuH1nkfyLzQgKbt3cUNnhwTrx6n6y2v0qaKCc5+nu8A16XZOjZGLNJzewbRXG7DNXNZ6d0AicsL7vS1gGCckxlz3RvUioMmIo0AYBWck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217761; c=relaxed/simple;
	bh=yf8kH7iH2zWa0O5WYP115qk32ECxZt6BsgADnns632g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIrIQ4GpTwQWgP8kICBpMIdlfGHFnfxrbrDRAaJj8LwX0kIT0Yox8uZns22wXs12SOrsOtLVB8pktF/wl5kxI963Grj2kGfjOBzXDz41TE0Ae//r70j6r8EboUReRZBNCY14Fa/6l9bQofaqjemXPf8/wng3l8+Xed8fzErWg+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJxg0zIc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJxg0zIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934531F000FF;
	Sat, 12 Sep 2026 12:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217759;
	bh=AiHTZzc8G7mT9SsRxlaaT4fhMlSr4QUQxZ/uyJWjxhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJxg0zIcmAPMNZOlecasE2MuCpqCTooSVmB8QuLaSN1oUI5/qB/FEXzy6SG8lsI2S
	 DkDHqhQ3XwlUw+VIfbhiV8PjAmVIleW6IrGVrjEe6GqSuAG8cnh6ZrQZllPaCTHNjs
	 hrh49BrHHq0OT/XbnU+m66o9i2ZOtPCDJwWkaM5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1004/1376] ARM: dts: helios4: add vcc-supply to GPIO expander
Date: Sat, 12 Sep 2026 08:57:10 +0200
Message-ID: <20260912065629.940454246@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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



