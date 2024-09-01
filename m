Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAC91C68C;
	Sun,  1 Sep 2024 16:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208682; cv=none; b=PMudBRf+MAgZLY3KLRk/B6BHRaWDMaWDkPydp3D55AZem+r8C3MD+TfX00P0KPeTFyvpM9nETtPWsnGrUIxi+0Pz/VowjR/yseQjgKpxc1nHJsjI9ZlhsANWp/TpM60XvCjSYZna+8EuqiyKijCVmHbs5wSHwftKG9IQ3WFn6zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208682; c=relaxed/simple;
	bh=KKWzR28Y0LZzHLeb1x3qwxvtXK8cuJOg7IMed/9G6cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYHy0dawk7mvheetOL5AhqcEQ1ABgCHoz/z+H6QwWX46iNd1tfyaiAHMBU+eh/830u+M0HWugcSzEeqlHkp+FpAiAh4tDOpeY/6eA1qvcuMFsEq/cj/6wgMouFYMrT/6AOn2FOWOHMVkr2x8yOGqTEf3WSO8fLpyYXeBiJSTtvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWQub7KI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWQub7KI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB973C4CEC3;
	Sun,  1 Sep 2024 16:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208682;
	bh=KKWzR28Y0LZzHLeb1x3qwxvtXK8cuJOg7IMed/9G6cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWQub7KIrvhwgQJ65ioymivtJ4dbxkjdYk9QgTlrYqKy7ItFXfr+noh7dn0yw6peh
	 NzahZxXJQtL4YLe6/dt9ucg+jK/6jN/TyBirL2ivU64xwEjTUKdcUSNWPYPOjNjcTK
	 QlhxS7t+e6mcOCeYruErJiJZ6xgKez+sfnOxH6NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>
Subject: [PATCH 6.10 122/149] dt-bindings: usb: microchip,usb2514: Fix reference USB device schema
Date: Sun,  1 Sep 2024 18:17:13 +0200
Message-ID: <20240901160822.041311224@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit 5b235693ed2a1e4963625717a1598becf97759cc upstream.

An USB hub is not a HCD, but an USB device. Fix the referenced schema
accordingly.

Fixes: bfbf2e4b77e2 ("dt-bindings: usb: Document the Microchip USB2514 hub")
Cc: stable@vger.kernel.org
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20240815113132.372542-1-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/usb/microchip,usb2514.yaml |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/usb/microchip,usb2514.yaml
+++ b/Documentation/devicetree/bindings/usb/microchip,usb2514.yaml
@@ -10,7 +10,7 @@ maintainers:
   - Fabio Estevam <festevam@gmail.com>
 
 allOf:
-  - $ref: usb-hcd.yaml#
+  - $ref: usb-device.yaml#
 
 properties:
   compatible:
@@ -35,6 +35,13 @@ required:
   - compatible
   - reg
 
+patternProperties:
+  "^.*@[0-9a-f]{1,2}$":
+    description: The hard wired USB devices
+    type: object
+    $ref: /schemas/usb/usb-device.yaml
+    additionalProperties: true
+
 unevaluatedProperties: false
 
 examples:


