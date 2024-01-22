Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DA8524BD;
	Tue, 23 Jan 2024 00:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970199; cv=none; b=QVPEpcjt42Mpc4DtgFKir0Ew+lGaXi4yfnevGRsW3N2N77I+VyfUgyUdM+1LzLM26XAoQD1FxJkN5CJm06WeOav9b2tsK/pWilyhBDfPN1yeXtOAGM0n0yIwlPfCwXlsdjezNZee2pj7uzm777x9TIV5ZB+qkXJb29i+AozMU9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970199; c=relaxed/simple;
	bh=2B1NXSw0dyx4bw7xGCslB3o5UDEqgaythDV/d2I0Cdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QD5hV0Cw3cW/c6s0aLsrSZ0+NUYcMECNH4nErVCUT/wpJuELh/3P4LMBiBdmaTSBSypMl+qd4CdLSBL3QpIR57TK/M6EGJgsbGt7Y7pmJw1wknuxPPhrD5xzlp/jbyiOsK23SuVlIiYvKYfea1c2bQRQUlPYLkXOE5RYW4+NPto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUj46WmI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUj46WmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E519C43399;
	Tue, 23 Jan 2024 00:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970199;
	bh=2B1NXSw0dyx4bw7xGCslB3o5UDEqgaythDV/d2I0Cdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUj46WmInS/PCJREqaCJwgcexYTzIORDVLOtYRMIQyPPNxWy1fle/PuO25YPL0yRj
	 AFEJI1bSqzDZ0obE8BH3iXnGaqzpphvnXzpcME3S925D4XKRY0ng7/dGHSXGxgiccF
	 IaBH6JiD/tjzUEhS1vdGPr/RaikDZPeHmdH1aRaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 606/641] dt-bindings: gpio: xilinx: Fix node address in gpio
Date: Mon, 22 Jan 2024 15:58:30 -0800
Message-ID: <20240122235837.210134620@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Simek <michal.simek@amd.com>

[ Upstream commit 314c020c4ed3de72b15603eb6892250bc4b51702 ]

Node address doesn't match reg property which is not correct.

Fixes: ba96b2e7974b ("dt-bindings: gpio: gpio-xilinx: Convert Xilinx axi gpio binding to YAML")
Signed-off-by: Michal Simek <michal.simek@amd.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/gpio/xlnx,gpio-xilinx.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/gpio/xlnx,gpio-xilinx.yaml b/Documentation/devicetree/bindings/gpio/xlnx,gpio-xilinx.yaml
index c1060e5fcef3..d3d8a2e143ed 100644
--- a/Documentation/devicetree/bindings/gpio/xlnx,gpio-xilinx.yaml
+++ b/Documentation/devicetree/bindings/gpio/xlnx,gpio-xilinx.yaml
@@ -126,7 +126,7 @@ examples:
   - |
     #include <dt-bindings/interrupt-controller/arm-gic.h>
 
-        gpio@e000a000 {
+        gpio@a0020000 {
             compatible = "xlnx,xps-gpio-1.00.a";
             reg = <0xa0020000 0x10000>;
             #gpio-cells = <2>;
-- 
2.43.0



