Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D7A26463B;
	Thu, 17 Apr 2025 18:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914873; cv=none; b=W7XfpeLsfRb5bPhYqhQgyv0fz6XLXLE9vCa5gMRw6MyHzUMGfO3+EQUYs8u4VwKEoHxgGFzvaqK887Im2JRXMuWvIrjSKhlKftziDlQZkaakI45R9l8L3ox1NjSy3BlmOMVKoEF3M3kp9vpLmBA0i324+aggUmrc3IbrllPqCOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914873; c=relaxed/simple;
	bh=ppApMB80e2X8Xw8UDGqOp6p7Gx/1Bbmaik0niiUi1/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9aqyPTW1Y47bKr/yebGEnK1jRTjrGPQSHMXvls8GHDSql+f1URNOe2kWQUi1D5HzO73TDd+PN+cFUcD2OKeQFomKER3mYGylsB8z/OK2yjCncyPzS7vsOk1PO4rUHSSAz02u8Sxg/XISsj6KQI1Kp6GVxYj4QuqgP2uQl0kVXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WtHxMX5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WtHxMX5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99E0C4CEE4;
	Thu, 17 Apr 2025 18:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914873;
	bh=ppApMB80e2X8Xw8UDGqOp6p7Gx/1Bbmaik0niiUi1/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtHxMX5XyubIfFsDWph7TmAELhz2Kj5yKUHEp3V+kFgPAMeuBwEhgGZ+C9VmZKFow
	 z75aAy40PySFNF1+IJMdxTMDbhfIeJXU9aHyb0T9ZxHPak+xM7XeiDR8/CWIne+sEV
	 MFyTq1q5TzQbObNVkSdPRHXhbAKvTQ8x9jQk2Kb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 6.13 358/414] dt-bindings: coresight: qcom,coresight-tpdm: Fix too many reg
Date: Thu, 17 Apr 2025 19:51:56 +0200
Message-ID: <20250417175125.862418771@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 1e4e454223f770748775f211455513c79cb3121e upstream.

Binding listed variable number of IO addresses without defining them,
however example DTS code, all in-tree DTS and Linux kernel driver
mention only one address space, so drop the second to make binding
precise and correctly describe the hardware.

Fixes: 6c781a35133d ("dt-bindings: arm: Add CoreSight TPDM hardware")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250226112914.94361-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/arm/qcom,coresight-tpdm.yaml |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/arm/qcom,coresight-tpdm.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom,coresight-tpdm.yaml
@@ -41,8 +41,7 @@ properties:
       - const: arm,primecell
 
   reg:
-    minItems: 1
-    maxItems: 2
+    maxItems: 1
 
   qcom,dsb-element-bits:
     description:


