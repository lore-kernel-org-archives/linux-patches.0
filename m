Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5548725EF8E;
	Wed, 23 Apr 2025 15:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421802; cv=none; b=hQXkCEdgZ46TTBqIEb8PjsmmATO7eFsrvjLQrE/ALdHwqTt9tD8Bvf1B8z+ZuZ3DJE10haJsj+QnVnL6N3qoej9rI8rjUsed9bXESuQYqoPPH7lwunsxhDZ/96teqtbaXk6u4H8suUcquE3ypsNmpCyCRNAjBWXJmJeSSWyHjqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421802; c=relaxed/simple;
	bh=/jo1/nFCp2a2Xos8IpevB/JdbAzJKd1VrW+F/Ue9Eq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swXjqNKiR7LHozWkikJlKaWRK6n1t7tXI8RWR0mzmm++RY9VS8jpeU4e8XuuZqxqTgUOYutqEdAIf19LanXDso1H3WAjlZpOOUy5O1+FTLL7wMXHNk0evpvtIwYIvNYafupjhdWGswdDaWf/pxNBlDVPhGeztDyRaHqzevlfG2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQNBZGYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQNBZGYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA85EC4CEE2;
	Wed, 23 Apr 2025 15:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421802;
	bh=/jo1/nFCp2a2Xos8IpevB/JdbAzJKd1VrW+F/Ue9Eq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQNBZGYz7WeGFr660QvcywrDNhAIjS5LzZWitUid5ukLVPWt/LBHriyGxkAuBQced
	 fJhaUmntQ7DGATBroNCvE2dn9E3qYxOaE/A4zU8Ud6wlXR0CExDfaWnamyeb6GVSFn
	 pLreiNi1D0m1w2pZUoxD4ijeqf7FPyK+zVGtJdS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 6.6 213/393] dt-bindings: coresight: qcom,coresight-tpdm: Fix too many reg
Date: Wed, 23 Apr 2025 16:41:49 +0200
Message-ID: <20250423142652.180490784@linuxfoundation.org>
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
 
   clocks:
     maxItems: 1


