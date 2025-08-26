Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD103230BF8;
	Tue, 26 Aug 2025 13:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213467; cv=none; b=iN6x6jHMNQTRf5ll41DdjmPZl+YdPKyg2cyPLtb0IaNV1DKnJCbUFiOUV+nGliSB96TiUKIhFRJnFkWCa3Uvm6+ZYJ9eV6d+P0iYQbby8DDkz8YYo+zrhkI5qQCv0fHscSQ0YtGbx5WRSBnobqhUBN3eWH9GYvLhCkhW2WIflE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213467; c=relaxed/simple;
	bh=nd2aElGv7ByQ/6aQ1EbYJKJa1dKMpVsIpA0tYEiAZsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMtNUlll3O6KRGg/kXFjiTGHBqUjukj55HBkt1lVQjXwTejBASxtkjruNYDrnnmQuguA2hbSVIJa6DXQmogvwutmxWOSg/aMkViJMyc2uemAx6HGFeUUW8ezilFsJ8t8YKD4cUV/asUDC0oY7AtYkR2tkPvehTkj/1pb72PmhKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffEM5Cu6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffEM5Cu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAA6C4CEF1;
	Tue, 26 Aug 2025 13:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213466;
	bh=nd2aElGv7ByQ/6aQ1EbYJKJa1dKMpVsIpA0tYEiAZsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffEM5Cu6R42eyS9AGb6XYXK1tHpmNx8cqlDWqYbPY+mHq0oJUfUsL3aaVad0gDzMk
	 P1FMAzbGFn1/j8qLg6DSUbJfk1EHpFhhceJgQv6kLtnOJw25/kh6jtuRcgXG1MSUd1
	 eu6qjm+8nDWHuKnHRZQliXyitaXJWd7/uX51Kvyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.6 358/587] dt-bindings: display: sprd,sharkl3-dpu: Fix missing clocks constraints
Date: Tue, 26 Aug 2025 13:08:27 +0200
Message-ID: <20250826111002.019569285@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


