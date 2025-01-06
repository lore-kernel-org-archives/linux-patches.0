Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE4A39FCE;
	Mon,  6 Jan 2025 15:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179019; cv=none; b=CQ3IlXzsmUM+9Kzw4Ojye+vk7idnK6pa/6T3HuDin6FM4t1VWxXf+uUcWeStaFBmjOsPdD6PnigUdlRr/uSUjhiHYyfsk3xQV4J/5k2SZuxu2F1VlCdq0oiB6oU7Gqc+PniIfniJSBXdKazzjOu2b3A4LxCmXwWDgtG/mfU/GLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179019; c=relaxed/simple;
	bh=JYxCZ7wp5nGIOQall1dGNlZbvXeESXEvyDlnXBPp5Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0kPiQaybrCXRUEMTfx/gpYtkJ6NcgDNl270LLcVRvgnOGFFnbaVvj0qkpAWcLlTiwGLsHjZlmr23xZ30FJMLwmfcZqydc6W497GHuM3bfQYw7P0eKkFe4323izqArzanUk7+Ob3fBwT3jcZZqFpxy2zQn5qdC1E7CASVKYatD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPfx3H2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPfx3H2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F92EC4CED2;
	Mon,  6 Jan 2025 15:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179018;
	bh=JYxCZ7wp5nGIOQall1dGNlZbvXeESXEvyDlnXBPp5Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tPfx3H2aI8UCkxP76aqOfPzRQjTrctjl21J+y1dlbtYFdhjoV7EAyN9jw/q3i8x9u
	 RU3U1+Cj0FU8kHkufvevuozg9GjoZspupKJnP2jy1kCqP+YnvbYIlizANkMwendSkH
	 qObXBm8Lc75WD2txpob6vI/YE1dUEg808Dx7hluQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 5.15 167/168] dt-bindings: display: adi,adv7533: Drop single lane support
Date: Mon,  6 Jan 2025 16:17:55 +0100
Message-ID: <20250106151144.733835189@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

commit ee8f9ed57a397605434caeef351bafa3ec4dfdd4 upstream.

As per [1] and [2], ADV7535/7533 supports only 2-, 3-, or 4-lane. Drop
unsupported 1-lane from bindings.

[1] https://www.analog.com/media/en/technical-documentation/data-sheets/ADV7535.pdf
[2] https://www.analog.com/media/en/technical-documentation/data-sheets/ADV7533.pdf

Fixes: 1e4d58cd7f88 ("drm/bridge: adv7533: Create a MIPI DSI device")
Cc: stable@vger.kernel.org
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241119192040.152657-3-biju.das.jz@bp.renesas.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/display/bridge/adi,adv7533.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/display/bridge/adi,adv7533.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/adi,adv7533.yaml
@@ -87,7 +87,7 @@ properties:
   adi,dsi-lanes:
     description: Number of DSI data lanes connected to the DSI host.
     $ref: /schemas/types.yaml#/definitions/uint32
-    enum: [ 1, 2, 3, 4 ]
+    enum: [ 2, 3, 4 ]
 
   ports:
     description:


