Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E7517993;
	Sat,  9 Nov 2024 00:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731112112; cv=none; b=phQ+MZHzfF5NK/lCdPoxPaCic8PP0p1JHbDDix/99x/nVER/O4+apT2SISq2g0Tp+JwKZ0NdAWzwj0/yNrZNSPQw25t3yyaArqySfdlZ5AWeWbWHA9vqxWyJa2ZPAp6JXSBpS5HdqKZEgI4uEzmRyoOxQYfc2oBBd5LN8CXB+Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731112112; c=relaxed/simple;
	bh=XBnS+T3tfTWUgGdodsXOJJqALpDykojZytRpKocJqXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnmFKrJHzVq6O9+9tCMb9e0ctLP6X3wpQvYWlLDUKKwx18h3Kc60M/3D7HQciCXIb3IArHDIrHhLnaOpyM7tYYULk45JWhCKskQsz0hHfMBR9h99bDhlbSvqz0DdFre1EQjzAjNlgWu3rc4UNC0Nz0c/mGvqcGa8Bal+puYpUFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LsVxsN6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LsVxsN6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B7FC4CED4;
	Sat,  9 Nov 2024 00:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731112112;
	bh=XBnS+T3tfTWUgGdodsXOJJqALpDykojZytRpKocJqXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LsVxsN6uw53xH+9j/c59fmMNGja5oZJYK6L0gd7kUv4D4Vt993+oouzVvtGTauW75
	 /bd5F662FfuBMg3t9ahj0/Lqfwr6CSlMyetPZqhgq39xUCRpHVldPSryiZDTZjckeo
	 LJ8pyHTy7PUhSPRyrZUHQGicjGkW6ABgw8Oc3sr5n7rLDLSKjGnpTl6apYc939zqs7
	 nxUUUZu5KXOGuyilmZIeeL240UxgSV0mocNc3foV9Z6bfNIOc0h7OjQbGEpJ5TXwa2
	 dELaPbz/23AvA16kDzNYjgauuLxvmMukCpSGU+II7JpCdmFWlAhTpRDJh2Uj3P4X+K
	 /ByOw7kh8hKGA==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 3/3] dt-bindings: spmi: qcom,x1e80100-spmi-pmic-arb: Add SAR2130P compatible
Date: Fri,  8 Nov 2024 16:28:28 -0800
Message-ID: <20241109002829.160973-4-sboyd@kernel.org>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
In-Reply-To: <20241109002829.160973-1-sboyd@kernel.org>
References: <20241109002829.160973-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

SAR2130P has SPMI v7 arbiter. Although it has only a single bus
configuration, use the new bindings for v7 platforms.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241017-sar2130p-spmi-v1-1-43ac741ee071@linaro.org
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 .../bindings/spmi/qcom,x1e80100-spmi-pmic-arb.yaml          | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/spmi/qcom,x1e80100-spmi-pmic-arb.yaml b/Documentation/devicetree/bindings/spmi/qcom,x1e80100-spmi-pmic-arb.yaml
index a28b70fb330a..7c3cc20a80d6 100644
--- a/Documentation/devicetree/bindings/spmi/qcom,x1e80100-spmi-pmic-arb.yaml
+++ b/Documentation/devicetree/bindings/spmi/qcom,x1e80100-spmi-pmic-arb.yaml
@@ -19,7 +19,11 @@ description: |
 
 properties:
   compatible:
-    const: qcom,x1e80100-spmi-pmic-arb
+    oneOf:
+      - items:
+          - const: qcom,sar2130p-spmi-pmic-arb
+          - const: qcom,x1e80100-spmi-pmic-arb
+      - const: qcom,x1e80100-spmi-pmic-arb
 
   reg:
     items:
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

