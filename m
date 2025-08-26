Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56A833439F;
	Tue, 26 Aug 2025 11:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207129; cv=none; b=bQDKsTHY+uuqU+r5+5xrLYY9e3fJ8AO2FJx5QqbWxpE7o1iOxTKLBp6ECrw+1zMQVA2SuZPEuYZ5i3ceA+8GDyN7FcX+f++D+iyvyT2T2giKuuwoHy1JOB7/cWNjvagorw3kPwmiigvCdgLFY9oxmihkpNpu/+rEnWD0e4FM0ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207129; c=relaxed/simple;
	bh=1Zamj6Q5ZJcgoYIGCyPiyDtD3z/Q3xecQB6ASq9+mYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWCdfwRpEdjZOvhgfq/XN5H70VVawgf7nr1es+gx+cxpWiYDgoCpMiRUFpV9No7/JzqV3NzGVf/BPZKJUttA/QHTNazkN7f6SpVA0cXUwt0aOIbiFx52cqlUvOn75ZX89EIP9ObKx6B74Wiv1J8wRhNTWQ8iUWIQvnRIFQ1tIB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqLk1cM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqLk1cM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D5EC4CEF1;
	Tue, 26 Aug 2025 11:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207128;
	bh=1Zamj6Q5ZJcgoYIGCyPiyDtD3z/Q3xecQB6ASq9+mYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kqLk1cM6OCsA/5YR38znA4cNJNKwWpgFJMzN+jDExR38HsG54JOl+pT/zDQtC5gcx
	 NDTucujmDtnU/cmYhqbyMR7+Y2QE0k0DANsBWsh5PXScojOCYnHD6P5EhS2XDdqrO+
	 4g2ZHzLJNK1L+vmVNUjes5V9DrG8ESDokAAbRmEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.16 062/457] dt-bindings: display: sprd,sharkl3-dpu: Fix missing clocks constraints
Date: Tue, 26 Aug 2025 13:05:46 +0200
Message-ID: <20250826110938.890904470@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 934da599e694d476f493d3927a30414e98a81561 upstream.

'minItems' alone does not impose upper bound, unlike 'maxItems' which
implies lower bound.  Add missing clock constraint so the list will have
exact number of items (clocks).

Fixes: 8cae15c60cf0 ("dt-bindings: display: add Unisoc's dpu bindings")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250720123003.37662-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/display/sprd/sprd,sharkl3-dpu.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/display/sprd/sprd,sharkl3-dpu.yaml
+++ b/Documentation/devicetree/bindings/display/sprd/sprd,sharkl3-dpu.yaml
@@ -25,7 +25,7 @@ properties:
     maxItems: 1
 
   clocks:
-    minItems: 2
+    maxItems: 2
 
   clock-names:
     items:


