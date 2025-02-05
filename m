Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12A91494DF;
	Wed,  5 Feb 2025 14:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764683; cv=none; b=sOFt5j3zTGCW4pyEwOQ7gEHWxCJjolnVeRcEV0OV5mocgDei9kLSFoM9MNZmpevSzJPkf7dv0uES6dI8HI5habomNXH++2qHbZLdfQ2qH7+LrsHYJvOBP8NRcARkp+Uz24RbXeHTPUUVc5iDLKgS/zTmmxJBj8LKp5be5Dwcc4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764683; c=relaxed/simple;
	bh=N41/YRpQa6EWxMi2Fm1XpvTUagRn2WhWTSF8lv49Fqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7qzLsggCJmXXtW+MFD1xFeycWAsM/k7G2vT6X/+JoMVzCsISQrDI3l/gV3b383nEJmwsi1SaCEbsClxE4u2PnJ7PFct2r/vzi3YbPlxatET5eB1CQIscIRst9prYUSFGFHTckPAKmx629UBhe33aW5JvMj41ts2k1+KHl5ds+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJjmYpiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJjmYpiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D724C4CED1;
	Wed,  5 Feb 2025 14:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764683;
	bh=N41/YRpQa6EWxMi2Fm1XpvTUagRn2WhWTSF8lv49Fqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJjmYpiHREpRP9mejF+7blAmItSCqlQQQe8JiLvTVOo0s2sGNSOSDpYFtfEaqfJnb
	 vj8rxKYx2jAcBsLxS3ZeFMaqEl1DEgdTUHLNySVgqt2jDYaX32d28BnT2OO6iFpzU6
	 mBNFQ32WDe1m8FkA1zBFG1kVrWQghGt18eksraEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 101/623] dt-bindings: mmc: controller: clarify the address-cells description
Date: Wed,  5 Feb 2025 14:37:23 +0100
Message-ID: <20250205134500.081152541@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit b2b8e93ec00b8110cb37cbde5400d5abfdaed6a7 ]

The term "slot ID" has nothing to do with the SDIO function number
which is specified in the reg property of the subnodes, rephrase
the description to be more accurate.

Fixes: f9b7989859dd ("dt-bindings: mmc: Add YAML schemas for the generic MMC options")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Message-ID: <20241128-topic-amlogic-arm32-upstream-bindings-fixes-convert-meson-mx-sdio-v4-1-11d9f9200a59@linaro.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/mmc/mmc-controller.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mmc/mmc-controller.yaml b/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
index 58ae298cd2fcf..23884b8184a9d 100644
--- a/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
+++ b/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
@@ -25,7 +25,7 @@ properties:
   "#address-cells":
     const: 1
     description: |
-      The cell is the slot ID if a function subnode is used.
+      The cell is the SDIO function number if a function subnode is used.
 
   "#size-cells":
     const: 0
-- 
2.39.5



