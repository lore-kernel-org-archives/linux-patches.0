Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D3B25E821;
	Tue, 11 Mar 2025 15:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705437; cv=none; b=twQs3AIjMzY3+V59j+TNXb2+K9Ogx4eBHz938QM7/ykV7OmjXUVx41mnMxSL/AChjVjbsGIHcAjhdphTjju7bN8yE4h7BCjD+/yVKc6b2Aph4hCJj/69KZ1EjpvSFMqonUl076zUaz3NP/vJ461OmtzjEdpoMMecOKj1ZuTw3pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705437; c=relaxed/simple;
	bh=qgw7vCRv+piknX4JyBFwYICVKi08FQjmkd+rEwFiR1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAZH5/Gjosgld1fAaJWC1E7WFUMuytf46ib9qwIlk+cHpGbAv0l4uip1FpCXEFiGyI7aHtDqTKQmsT4LVtvaTXyHrmLkO8PdKFFLbkMyJqG8iJ9fct/RGxjp6i25L+YFEKzdppaMP2UsD3Pa6FG9oc4ZSeBrLeQiubs4G4CS5i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1inYXJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1inYXJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81B6C4CEE9;
	Tue, 11 Mar 2025 15:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705437;
	bh=qgw7vCRv+piknX4JyBFwYICVKi08FQjmkd+rEwFiR1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k1inYXJcJxsZTGQlChuVY1DnczU8OQSlxrEvk8sdPWk/mNXraidtK3iF8X+HPP7EW
	 F/HX0O/xxjWpH/M+fm9fGxx2E30YzlERG/Xbv12xovNLkTCq0lE7bwq0kbWk36Lwe3
	 +spEmSI3DL87VHx07uVNBzJn8iyI4neBtZh0d9Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 016/328] dt-bindings: mmc: controller: clarify the address-cells description
Date: Tue, 11 Mar 2025 15:56:26 +0100
Message-ID: <20250311145715.526626164@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 080754e0ef352..ccb9df705fb1c 100644
--- a/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
+++ b/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
@@ -21,7 +21,7 @@ properties:
   "#address-cells":
     const: 1
     description: |
-      The cell is the slot ID if a function subnode is used.
+      The cell is the SDIO function number if a function subnode is used.
 
   "#size-cells":
     const: 0
-- 
2.39.5



