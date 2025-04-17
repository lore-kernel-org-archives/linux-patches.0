Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AB62571A1;
	Thu, 17 Apr 2025 18:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916081; cv=none; b=DdVV5PU9H2t2FmpDtcfob2XtNbhZgr3lmvyqmrgWTpzAjNJN5gfmnY2Mn9jnaCw1Xe6KMA2T807y61SSvPIi0oohVoF+3L0dijWUpdlwYQ/k9YlAT3s/6MC9MEs/5qnLIb5Qi5mMjMMmpHN3r2KgmCpj0iN7SNHKhRsH+I9W+cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916081; c=relaxed/simple;
	bh=bq3G0NEY5M9Q10gviG2V9czPkmVTVdakwmLBsnn0YqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzvB6mny9mXKbebH7CD9OqsIsIBxQ4R/nUnL6wM9KZEyVtzJmsiE7T4/JxWWQ8IteV21DpA5nNmL5G078dWw7komgqPzREfwqdfCncEYkFp7zeK854AWaO1LugL+JxpdU6wqFvmjWTHgucMCpawh0FGhOF/0iq6kxH4yCEeOfvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQsGR2Yz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQsGR2Yz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E6BC4CEE7;
	Thu, 17 Apr 2025 18:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916080;
	bh=bq3G0NEY5M9Q10gviG2V9czPkmVTVdakwmLBsnn0YqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQsGR2Yzws4hgVvQ4aU1M+ADt/RFP2h6hJiQ7H5IxadwjWnwQNU/K7/IPnIoN2SXr
	 pA+Ywssu0vY+9WVOPyqblGERvmDxtPk1I8Qc6z+NrUZzlOTyfVoJ+kdngz9xsplHLY
	 0WhyOnGb3VI49TNOGVwsS5jikEpNZ6MFvQBT+YpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 6.12 336/393] dt-bindings: coresight: qcom,coresight-tpdm: Fix too many reg
Date: Thu, 17 Apr 2025 19:52:25 +0200
Message-ID: <20250417175121.115598455@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


