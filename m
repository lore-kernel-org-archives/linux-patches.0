Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D82BE46;
	Tue,  8 Jul 2025 16:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993691; cv=none; b=l3TbLMTJSKLjrnBuV55KTpStJq6/C2r1c/VaqICUepj3EDOfanACn4Fh5eIbM30+cPXkod3rS6lGh1NImXiAQP62dK5K4sFm43G3QJ62m8s8yECZY+e9NhSDNu42XzBH/wzFaiC4BPN9r+c66XiX138uqovlWNI3tF+VMgM2yCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993691; c=relaxed/simple;
	bh=T9EX4YHnjY+buTC5Bg+JpfC3AfTTQQApCm5ubhMwXLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWGgHhhsZcLaNBsvsRpApRvhba28Bj2C7Pn3ub9FvcU7lVFy0ya31JArLZ7s7X/Z/ibzoBAlcM0eFQ3UapdSGujtXHhnN1o0wmCCMo7XRZkwc3BKhfGs6ov3m8y+sKrOn1KGL6QR2RyzOVjuje2vqVA2/mdIykc6/XpGXt1uNJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWYeYfRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWYeYfRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7303AC4CEED;
	Tue,  8 Jul 2025 16:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993690;
	bh=T9EX4YHnjY+buTC5Bg+JpfC3AfTTQQApCm5ubhMwXLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWYeYfRcD1TD60yVDqcjPoeWPI8kbYlA14ODo0mFsTSY013RJNZjUX8bO8IroVe5Z
	 eCbnurIUbeT3dM68rokpMYduUaDM8Gtq4qeCLnNRtNbgbYLf1uirgb51DGkp4db5OI
	 IrWvsmPd9W8TGo4c8m1+d29jLQd7yswy7UAxCkUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.15 160/178] dt-bindings: i2c: realtek,rtl9301: Fix missing reg constraint
Date: Tue,  8 Jul 2025 18:23:17 +0200
Message-ID: <20250708162240.666164788@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 5f05fc6e2218db7ecc52c60eb34b707fe69262c2 upstream.

Lists should have fixed amount if items, so add missing constraint to
the 'reg' property (only one address space entry).

Fixes: c5eda0333076 ("dt-bindings: i2c: Add Realtek RTL I2C Controller")
Cc: <stable@vger.kernel.org> # v6.13+
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250702061530.6940-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/i2c/realtek,rtl9301-i2c.yaml |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/i2c/realtek,rtl9301-i2c.yaml
+++ b/Documentation/devicetree/bindings/i2c/realtek,rtl9301-i2c.yaml
@@ -26,7 +26,8 @@ properties:
       - const: realtek,rtl9301-i2c
 
   reg:
-    description: Register offset and size this I2C controller.
+    items:
+      - description: Register offset and size this I2C controller.
 
   "#address-cells":
     const: 1


