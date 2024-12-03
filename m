Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC171F4711;
	Tue,  3 Dec 2024 14:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236619; cv=none; b=Ygho0oDbVhL9Y7+hk5VXQ/Aeg7/UCbHi7u73jWzRm/2mIdGApELMmCes8IcVSSX6dhq7lVWDM2teXG60gZd4Pm+qlBVI98uJ9+70PRoL91jj+7N4+WTvGNRRZSIeortfCthXfFi4KeGdMd1q6IqP51LyZva0UNySVjCjS0sjGLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236619; c=relaxed/simple;
	bh=lXaq1hXgCnZWSjE5KOCgRodLzX0d3IqEgGP+OkS06V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWsZf8KqR/R50zFrppX+e6lHf2nW3EbJC+KUUfW/X8fz0BA3YbALbgOQRnijYXEMPpj6IxOQBiQxeuOgTmMzmcwYF87Nop823zaHUw7Nmd8ENjhaN/Sl8xre+yeADreO215VUYLG54AUq5UU39TwgQVg5dsnhiEsfVouwZ5wTzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ys3EokL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ys3EokL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AEFC4CECF;
	Tue,  3 Dec 2024 14:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236618;
	bh=lXaq1hXgCnZWSjE5KOCgRodLzX0d3IqEgGP+OkS06V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ys3EokL2R4u6ZbxDVn7tFwMCJpRkONLb80yNrn8HtPmP1HYUOKogfqUHmwyBYu6Sd
	 tZEM7hWUr5tGVjBUy7O5BJysbp5ir5Jl3ePvfM0MhHh/P++DcTCH9SnqIC9Mr3sey6
	 Ta2dzVD2ZAJw8/nF8oFoRB6i6QfxoyXRfi2o2xtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 073/138] dt-bindings: clock: axi-clkgen: include AXI clk
Date: Tue,  3 Dec 2024 15:31:42 +0100
Message-ID: <20241203141926.358020363@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 0d06387184d68..bb2eec3021a09 100644
--- a/Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml
+++ b/Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml
@@ -25,9 +25,21 @@ properties:
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
@@ -39,6 +51,7 @@ required:
   - compatible
   - reg
   - clocks
+  - clock-names
   - '#clock-cells'
 
 additionalProperties: false
@@ -49,5 +62,6 @@ examples:
       compatible = "adi,axi-clkgen-2.00.a";
       #clock-cells = <0>;
       reg = <0xff000000 0x1000>;
-      clocks = <&osc 1>;
+      clocks = <&osc 1>, <&clkc 15>;
+      clock-names = "clkin1", "s_axi_aclk";
     };
-- 
2.43.0



