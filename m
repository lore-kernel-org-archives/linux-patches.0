Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C9F28F53B;
	Wed, 23 Apr 2025 15:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421745; cv=none; b=mlEuno18HXE8NzbBG6J7Ww8neYZRAsUv4F/gciNpGPE61z17sPdebN/BqT+yqu1034ywLyAjsDlwsP35NKKao0OH3f0IAP7ruJwTJKwDr1CuUhlMXhC2NYe2cxUZkrKPhcRKxOk07OFBM8QnoX4TCPmV7t/I3WCHP4Ypz8Mt0Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421745; c=relaxed/simple;
	bh=CuhRrMYb5xJElbxvDRDjpIDqF7fhKMV3PE/+Bbat700=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNoQOOJyYVPncCa10nvGkuONr1ilC0Eo0QvKk4xSOZgRv0v6u1DvYTqhC9d4tBjgyJpeuR6JbKJfSV+CRLafrXpKd9ROKzTim/wVBFFLTe00ZFA9AEsfCOSt3RmW4ycCWiCYBPBcUC0sgPUbyojUNnA4f7M7aJXXCJoWxeDEm/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=byqssiUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="byqssiUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC24C4CEE2;
	Wed, 23 Apr 2025 15:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421744;
	bh=CuhRrMYb5xJElbxvDRDjpIDqF7fhKMV3PE/+Bbat700=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=byqssiUP3xxDvZTDy6Utjvm/1wCAxOhElM0+sLDHh+nYq239w9idGFDDziJDD9KFJ
	 XhWHaLLCAYkRWAMSWfTGeKZ+KbHAYBzyGTgDaObFa5tzs19hnrePiG/MuMYj4CIJbj
	 gOVETXuh5wQhMg8P2PC/67Im/YGzGrCjif0HPdSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 6.6 212/393] dt-bindings: coresight: qcom,coresight-tpda: Fix too many reg
Date: Wed, 23 Apr 2025 16:41:48 +0200
Message-ID: <20250423142652.138539680@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

commit d72deaf05ac18e421d7e52a6be8966fd6ee185f4 upstream.

Binding listed variable number of IO addresses without defining them,
however example DTS code, all in-tree DTS and Linux kernel driver
mention only one address space, so drop the second to make binding
precise and correctly describe the hardware.

Fixes: a8fbe1442c2b ("dt-bindings: arm: Adds CoreSight TPDA hardware definitions")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250226112914.94361-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/arm/qcom,coresight-tpda.yaml |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/arm/qcom,coresight-tpda.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom,coresight-tpda.yaml
@@ -55,8 +55,7 @@ properties:
       - const: arm,primecell
 
   reg:
-    minItems: 1
-    maxItems: 2
+    maxItems: 1
 
   clocks:
     maxItems: 1


