Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A93B136658;
	Tue, 23 Jan 2024 00:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969693; cv=none; b=fjJ/jYKqnHU8a1W+W+9j8D20kAVjJMtV0Dc6L1OMfT0bn+jLTT/mNWJvT7HqYdCv3CHV2R1ETZ8mt8Lx6cnucmfCNqiR+FETLOqGAk5OYhcD2m1tePVin0fnKpfiB6xGCE4chMPUF3W89PnImfHoLRXiiey6PX3DnrdpDYngz3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969693; c=relaxed/simple;
	bh=4eyQ/VhY88+8vh4edaqHT8z6sXTz9ob+e87YAls1RWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENTz5g8sc5w6ZnPWqttxUnE7h8NTldNNe72m1YOf7ESiGy1+zeUyiZzijN5X3IuEqnDTqvqY6v6RWpcYyHK/5r/l6EOEC0F/zcYEV3cki1u/nhVNnqCkSbSCyMMArjyCGn5Dq6pp112rg3mUeC7wqVry/ayapMODxqzk2YfCK6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLtBEFDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLtBEFDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B666AC433C7;
	Tue, 23 Jan 2024 00:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969693;
	bh=4eyQ/VhY88+8vh4edaqHT8z6sXTz9ob+e87YAls1RWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLtBEFDhbJ0mqyvYUIIcau/hiJdl1rW2DgLH2nEWrhS9oLeRIL7A9HkZGXVlyHtKK
	 bJmmkrbxeITC1ReN2U+nXvSxuTYmypapO2w8r020RprwvF+SJP/zRpG+GL1552Es/b
	 bt5QkEqxuidG5W8hi8yvp99X3ZyKwSMWvhk7eXtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.7 408/641] dt-bindings: phy: qcom,sc8280xp-qmp-usb43dp-phy: fix path to header
Date: Mon, 22 Jan 2024 15:55:12 -0800
Message-ID: <20240122235830.747493723@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 21a1d02579ae75fd45555b84d20ba55632a14a19 upstream.

Fix the path to bindings header in description.

Fixes: e1c4c5436b4a ("dt-bindings: phy: qcom,qmp-usb3-dp: fix sc8280xp binding")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231218130553.45893-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-usb43dp-phy.yaml |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-usb43dp-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-usb43dp-phy.yaml
@@ -62,12 +62,12 @@ properties:
   "#clock-cells":
     const: 1
     description:
-      See include/dt-bindings/dt-bindings/phy/phy-qcom-qmp.h
+      See include/dt-bindings/phy/phy-qcom-qmp.h
 
   "#phy-cells":
     const: 1
     description:
-      See include/dt-bindings/dt-bindings/phy/phy-qcom-qmp.h
+      See include/dt-bindings/phy/phy-qcom-qmp.h
 
   orientation-switch:
     description:


