Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCE125525A;
	Thu, 17 Apr 2025 18:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913685; cv=none; b=Ij+Bib071yxRGVIQNJJsaqtUyHDyVj26pb2/q1kztcVmyIbSlXLLjI9ZI1axMr8cwIj1/7n4My8wbMZQnZcKcrv776KLH6maQ1gGfyqo3bHq7F/NagsBtNm/HGcbpZigvmGmfeil8wryXrW7i8WuebmMhowXgFLO4Gsgx/BGZGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913685; c=relaxed/simple;
	bh=7GgzCzJ9P+CBxwHpExZGKiFLEaCFyCLsrGsKO7XZv3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dj+O9ql/e88ltnjOhRXbk/CpJDycBnlxWPo2n55aE60TUnuEepMzAEKESq8NwzE2mJqfK8FkafIV6ZsP9tt3Mdygde4g3HqpdtoEn9RzljoUI4Gw2lArctSER+sAvaEwMgwPjZgC/9UFt9V5EYPwKJyG/6EQ+ye4ypYtNcuyhjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peghB0Gh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peghB0Gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4110C4CEE4;
	Thu, 17 Apr 2025 18:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913685;
	bh=7GgzCzJ9P+CBxwHpExZGKiFLEaCFyCLsrGsKO7XZv3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peghB0GhWU2tYioFUDj5Cn7WL37u+zhM8UjaCoXw5ra0swIZMlkLn6UbDL58B6p49
	 EEhbOX3ffT6MOokbbbxBfmZtL+Vb4H3sf4OViXdLVMekFcvX7kEpDW12ELCFteOhAX
	 S089+WliKZL8JP8XXedyZpjjqCRUoP6qK1f5HQDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 6.14 392/449] dt-bindings: coresight: qcom,coresight-tpdm: Fix too many reg
Date: Thu, 17 Apr 2025 19:51:20 +0200
Message-ID: <20250417175134.046487719@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


