Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9674149C53;
	Wed,  5 Feb 2025 14:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764734; cv=none; b=WyBIb5LYi1bG4EV6J3OOiPmiszIMbA+MYFYjnytKKZmQQhy/m1kOIZQ7cc5dfhA2jsTASF3Jt13w1Pb8AH6Rrkm1R1WT4oWnj6thEJkioVB/WfyO2aWJs95mJjeOlizy1RO/9qZZXvdYyOZQDt2oNHL1XLUHoSxKeU/UsNNNKkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764734; c=relaxed/simple;
	bh=VH39SUO52Oq6eb7BB0qxw65Finmxw3Oq23YUk6Yr+7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItKkr0BUFk2CbHu7ryrBkpAiB1RcJv1P5SEt7MuEXdEjHNyb3+Ddu9Ht0rsjO0oTPfiCxhXoy5q2A8xkHHLVd8WF59tWsM/Lz6k+rT+MSA/Nhw4Ud700JaRtuKS1zA8EnT4A66za5nBoX525xIGQN9HZS4ecyxSt7BxUVc/+WZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pViTCLCL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pViTCLCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB0AC4CED1;
	Wed,  5 Feb 2025 14:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764734;
	bh=VH39SUO52Oq6eb7BB0qxw65Finmxw3Oq23YUk6Yr+7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pViTCLCLjZFyOHhXWQwvlig+u80JtqDUUslcTd0FLT58D9zAVD+TGd95pvgff/X1h
	 YRTLrHllcABaBnze2ugTQ9uLxS5jGrFMiHldviIvUpxi/RZHdSjgGZewkLVd6nZINS
	 jlXQ7juCPxgdA62RCrTysIXVMuvIWxtoJsQDcYYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 109/623] regulator: dt-bindings: mt6315: Drop regulator-compatible property
Date: Wed,  5 Feb 2025 14:37:31 +0100
Message-ID: <20250205134500.385749064@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 08242719a8af603db54a2a79234a8fe600680105 ]

The "regulator-compatible" property has been deprecated since 2012 in
commit 13511def87b9 ("regulator: deprecate regulator-compatible DT
property"), which is so old it's not even mentioned in the converted
regulator bindings YAML file. It should not have been used for new
submissions such as the MT6315.

Drop the property from the MT6315 regulator binding and its examples.

Fixes: 977fb5b58469 ("regulator: document binding for MT6315 regulator")
Fixes: 6d435a94ba5b ("regulator: mt6315: Enforce regulator-compatible, not name")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20241211052427.4178367-2-wenst@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/regulator/mt6315-regulator.yaml     | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml b/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
index cd4aa27218a1b..fa6743bb269d4 100644
--- a/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
@@ -35,10 +35,6 @@ properties:
         $ref: regulator.yaml#
         unevaluatedProperties: false
 
-        properties:
-          regulator-compatible:
-            pattern: "^vbuck[1-4]$"
-
     additionalProperties: false
 
 required:
@@ -56,7 +52,6 @@ examples:
 
       regulators {
         vbuck1 {
-          regulator-compatible = "vbuck1";
           regulator-min-microvolt = <300000>;
           regulator-max-microvolt = <1193750>;
           regulator-enable-ramp-delay = <256>;
@@ -64,7 +59,6 @@ examples:
         };
 
         vbuck3 {
-          regulator-compatible = "vbuck3";
           regulator-min-microvolt = <300000>;
           regulator-max-microvolt = <1193750>;
           regulator-enable-ramp-delay = <256>;
-- 
2.39.5



