Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C5118C2C;
	Mon, 22 Sep 2025 19:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570450; cv=none; b=m9Gth/Wb25a+13m+kOl1krOf7Ab991jVPe5Y1E1cx0G9drcDeLjN0P/xcrfFtMuHpPRb/PwHzGaYsOkXE/M4Om2KpKXRO0j7Jo5OcYp5haxepKBwaV2kH7rd/pZ2SNjyf/rS5iuxcGz0XaIbO4z/R79Yhp1rROP5NXfhSgU7UPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570450; c=relaxed/simple;
	bh=yJ09nhmvXDNh5vk3MCGdICTonHIt6zs6QhTY5UILUy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kti+E0A+YGHqGEos9YJbiPWM3OfpTzgk4gSFtx5gHjsd0ZIccMigsabWjM/afQ5DQHeqRq6/ThA9UsUhcfMk1fOYC7RNIO6EP80tB65FLb3hZ7YHpaCAYLHzY/66C1FUsFwWOOqdXH+F+z6SOeGdC0VaHy2qb4pu/qpza6cSIf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ciHzUcx5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciHzUcx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9817BC4CEF0;
	Mon, 22 Sep 2025 19:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570449;
	bh=yJ09nhmvXDNh5vk3MCGdICTonHIt6zs6QhTY5UILUy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ciHzUcx5zhNRIiQuPj7/L1EJss/CLos4C2UkDsVlLt89wm07o7NL4ApHcZgxm+Hov
	 0zLUWNrroJ+Xig56YtUMxItiyVFOD/OjLewo28FLz6ewPmuAHcVNKS0WchzFAgtM+R
	 Cer8G/VdACzYpyO5y7t5aiqKmdHnb1+hqxU7GhK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Conor Dooley <conor@kernel.org>,
	Alex Elder <elder@riscstar.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 144/149] dt-bindings: serial: 8250: move a constraint
Date: Mon, 22 Sep 2025 21:30:44 +0200
Message-ID: <20250922192416.499027415@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@riscstar.com>

[ Upstream commit 387d00028cccee7575f6416953bef62f849d83e3 ]

A block that required a "spacemit,k1-uart" compatible node to
specify two clocks was placed in the wrong spot in the binding.
Conor Dooley pointed out it belongs earlier in the file, as part
of the initial "allOf".

Fixes: 2c0594f9f0629 ("dt-bindings: serial: 8250: support an optional second clock")
Cc: stable <stable@kernel.org>
Reported-by: Conor Dooley <conor@kernel.org>
Closes: https://lore.kernel.org/lkml/20250729-reshuffle-contented-e6def76b540b@spud/
Signed-off-by: Alex Elder <elder@riscstar.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20250813032151.2330616-1-elder@riscstar.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/serial/8250.yaml |   46 ++++++++++-----------
 1 file changed, 22 insertions(+), 24 deletions(-)

--- a/Documentation/devicetree/bindings/serial/8250.yaml
+++ b/Documentation/devicetree/bindings/serial/8250.yaml
@@ -48,7 +48,6 @@ allOf:
       oneOf:
         - required: [ clock-frequency ]
         - required: [ clocks ]
-
   - if:
       properties:
         compatible:
@@ -66,6 +65,28 @@ allOf:
           items:
             - const: core
             - const: bus
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - spacemit,k1-uart
+              - nxp,lpc1850-uart
+    then:
+      required:
+        - clocks
+        - clock-names
+      properties:
+        clocks:
+          minItems: 2
+        clock-names:
+          minItems: 2
+    else:
+      properties:
+        clocks:
+          maxItems: 1
+        clock-names:
+          maxItems: 1
 
 properties:
   compatible:
@@ -264,29 +285,6 @@ required:
   - reg
   - interrupts
 
-if:
-  properties:
-    compatible:
-      contains:
-        enum:
-          - spacemit,k1-uart
-          - nxp,lpc1850-uart
-then:
-  required:
-    - clocks
-    - clock-names
-  properties:
-    clocks:
-      minItems: 2
-    clock-names:
-      minItems: 2
-else:
-  properties:
-    clocks:
-      maxItems: 1
-    clock-names:
-      maxItems: 1
-
 unevaluatedProperties: false
 
 examples:


