Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE801F76A8;
	Tue,  3 Dec 2024 15:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241565; cv=none; b=jZw8ELT+hOZESImaLmAMNca5hE06IOgM6HobfyaGt2KOKn36nesvr6pe07wcNCnVgfGqtyWwAcYeZXo0da8rl5ac/n0RXFS55vf8IJl1QLiBHni5dy/WDlMyMnCBTDZh5qD3l4q21pjLvY6h1437xEXI2z418uJO72atnUqkKmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241565; c=relaxed/simple;
	bh=QRIN496kipxpB39ZIMlE1uv46QGiAy+MsU4gYnUOG9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdvy8lt7eizHoknHCvXUMhO6MEj6+4xCymfvwfjYZe8WL9nIJMBUWZA25X09RJFeiLiCgGDhshiiyFdlH5ltZ6jxgLvPQWGbbi2VC5y6ESpGWD3/OWJWQ6lvZidic8a7WCdbQSmMMUr8JBUertb5sOYGmKnsMxiQeyjdFvdfpo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xl3BY7vd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xl3BY7vd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C834C4CECF;
	Tue,  3 Dec 2024 15:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241564;
	bh=QRIN496kipxpB39ZIMlE1uv46QGiAy+MsU4gYnUOG9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xl3BY7vdXhw3rniYCoj5q81q3fzz/H9jGaLYwFS+rfrV/219scZ1sy6aSYqVLMfu5
	 eppaMEATOs4BGJgze/YRCDf8CZqe6Tln0jzgC7lTUrZWOTRTaB4vviPJcfjtp5bof0
	 rWIaNz3mw5OIN4OFEAzIvhRADJyMLuz2gNPYnrfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 454/826] dt-bindings: clock: axi-clkgen: include AXI clk
Date: Tue,  3 Dec 2024 15:43:01 +0100
Message-ID: <20241203144801.468185966@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit 47f3f5a82a31527e027929c5cec3dd1ef5ef30f5 ]

In order to access the registers of the HW, we need to make sure that
the AXI bus clock is enabled. Hence let's increase the number of clocks
by one and add clock-names to differentiate between parent clocks and
the bus clock.

Fixes: 0e646c52cf0e ("clk: Add axi-clkgen driver")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20241029-axi-clkgen-fix-axiclk-v2-1-bc5e0733ad76@analog.com
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/clock/adi,axi-clkgen.yaml        | 22 +++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml b/Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml
index 5e942bccf2778..2b2041818a0a4 100644
--- a/Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml
+++ b/Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml
@@ -26,9 +26,21 @@ properties:
     description:
       Specifies the reference clock(s) from which the output frequency is
       derived. This must either reference one clock if only the first clock
-      input is connected or two if both clock inputs are connected.
-    minItems: 1
-    maxItems: 2
+      input is connected or two if both clock inputs are connected. The last
+      clock is the AXI bus clock that needs to be enabled so we can access the
+      core registers.
+    minItems: 2
+    maxItems: 3
+
+  clock-names:
+    oneOf:
+      - items:
+          - const: clkin1
+          - const: s_axi_aclk
+      - items:
+          - const: clkin1
+          - const: clkin2
+          - const: s_axi_aclk
 
   '#clock-cells':
     const: 0
@@ -40,6 +52,7 @@ required:
   - compatible
   - reg
   - clocks
+  - clock-names
   - '#clock-cells'
 
 additionalProperties: false
@@ -50,5 +63,6 @@ examples:
       compatible = "adi,axi-clkgen-2.00.a";
       #clock-cells = <0>;
       reg = <0xff000000 0x1000>;
-      clocks = <&osc 1>;
+      clocks = <&osc 1>, <&clkc 15>;
+      clock-names = "clkin1", "s_axi_aclk";
     };
-- 
2.43.0



