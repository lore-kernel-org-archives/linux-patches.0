Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724A93955F4;
	Tue, 21 Jul 2026 15:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649409; cv=none; b=abY6EZujAXITt+dqifGu17KBWIP2e5IffMkLTbnnOE2mMlkvCSk1DKanEBWi+Bw9NogigROzuB0WMOM+pwbtVTWp62mXMgwixPCcUvwLRY7ZfC3R948CJrTKzh8TXEag8yLJHd3LDGAIKWfPkE6y+fbPNdviGkTUTPrXkmwU+B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649409; c=relaxed/simple;
	bh=FpYL0PHuNmyxcwgXJy7MUsldKAReNdz8HDlBLjx0voE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O94d4y513KazkAlmY0tTefmH28h/R/8gE2fyfsL+YSYDGNbn54eZRCv0jAKY87RmtJalu4QxrXWFmWTEtRIz+t+sfRlquQU7z52MmWltYus/Or51q3FuHIUp37AhsQUnRG236zI4LUzc18H8UWdXw91Xo3ieJWXYpl7ggTGyIoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvxUWqYA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvxUWqYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB7F1F00A3A;
	Tue, 21 Jul 2026 15:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649408;
	bh=3nawCL+WBRBI4xnfVRNMlaRwBQDEKq0ejQF+GydiUYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GvxUWqYAzaoBkZxPhCvI2eCHyW6pR8yMjfdk8GQt4X3PVBfgbFdvXkFhuormEme2X
	 V9cxzZ4vL+YQvgOA8IievDDhjZdykS2JmWMjSMz0M7YrCg1+TSIJwLiDt645rU37MA
	 ZKl5qasO0T72Fst06+WIFK74gGB4gphcDvtmkpQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Chun Lin <eleanor.lin@realtek.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0567/2077] dt-bindings: pinctrl: realtek,rtd1625: Fix input voltage property name
Date: Tue, 21 Jul 2026 17:04:00 +0200
Message-ID: <20260721152606.184119159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu-Chun Lin <eleanor.lin@realtek.com>

[ Upstream commit 388d2fe16283d68e4be8c5317809a4a218ebeace ]

The property 'input-voltage-microvolt' is a typo. Rename it to
'input-threshold-voltage-microvolt' to align with the standard pin
configuration defined in pincfg-node.yaml and parsed by pinconf-generic.c.

Fixes: f6ea7004e926 ("dt-bindings: pinctrl: realtek: Add RTD1625 pinctrl binding")
Signed-off-by: Yu-Chun Lin <eleanor.lin@realtek.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/pinctrl/realtek,rtd1625-pinctrl.yaml    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/realtek,rtd1625-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/realtek,rtd1625-pinctrl.yaml
index 9562a043707ee2..adc5955a2047c2 100644
--- a/Documentation/devicetree/bindings/pinctrl/realtek,rtd1625-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/realtek,rtd1625-pinctrl.yaml
@@ -110,7 +110,7 @@ patternProperties:
 
       input-schmitt-disable: true
 
-      input-voltage-microvolt:
+      input-threshold-voltage-microvolt:
         description: |
           Select the input receiver voltage domain for the pin.
           Valid arguments are:
-- 
2.53.0



