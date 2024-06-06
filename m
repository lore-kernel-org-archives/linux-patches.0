Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61277198A01;
	Thu,  6 Jun 2024 14:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682933; cv=none; b=sNv1MowRyV9Bm8lO0X0DkGBbCKMyXJ8zNrosj2MhPFakCom9zWPEwmhqlyUx8BBu3a7UUQHemHGBrWlW6k2zac4krjZPAGpkgIidRCPjGJHn/FzQ9qPaRybZ8qyAC2g27NRxng2ydCmMm7SVY+9GbyAQMXreHiApP+FuNMrS3N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682933; c=relaxed/simple;
	bh=o15B2N6u5yBTlDlAc6SXGvRMIl3l2NOElP9MM32nutM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMmpN7F6ZXD9BiSOlvFKdWCyazKG1xHDuCj2W8gKYcteD+ID8VzSeXOvtmFyNFeuVF/SHJ0FnqHdPpls2iayEzxR0CtkRT4TQT5SUQOlBeLFI4wXYkAviDb5foyAmP2b6UtVv+gYaMAzVo5672DoddcR2O79SxUtZWfnFcRn5GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3x2K8Ea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3x2K8Ea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3025CC32781;
	Thu,  6 Jun 2024 14:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682933;
	bh=o15B2N6u5yBTlDlAc6SXGvRMIl3l2NOElP9MM32nutM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3x2K8Eat7gg4rxSYnXO8X6wBce6RHMmWQx8HOHxyNVr9MY1QFrosa4uKcHWf7e8K
	 bk0oi7zB9VlCjQMicQnVXsou5Xmc9n9qnMc11a0u/F2A9l9z8PVNEzU3aiL+w5oavB
	 ui0qqIqvfT69tIMi7rt5XQCPzMOB41GAoBNq0IV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 081/374] dt-bindings: phy: qcom,sc8280xp-qmp-pcie-phy: fix x1e80100-gen3x2 schema
Date: Thu,  6 Jun 2024 16:01:00 +0200
Message-ID: <20240606131654.564991710@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 484b139a4cd7e629f8fcb43d71997f400c5b8537 ]

The qcom,x1e80100-qmp-gen3x2-pcie-phy device doesn't have second reset,
drop it from the clause enforcing second reset to be used.

Fixes: e94b29f2bd73 ("dt-bindings: phy: qcom,sc8280xp-qmp-pcie-phy: Document the X1E80100 QMP PCIe PHYs")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-1-f1fd15c33fb3@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/phy/qcom,sc8280xp-qmp-pcie-phy.yaml      | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-pcie-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-pcie-phy.yaml
index ba966a78a1283..7543456862b80 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-pcie-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-pcie-phy.yaml
@@ -198,7 +198,6 @@ allOf:
             enum:
               - qcom,sm8550-qmp-gen4x2-pcie-phy
               - qcom,sm8650-qmp-gen4x2-pcie-phy
-              - qcom,x1e80100-qmp-gen3x2-pcie-phy
               - qcom,x1e80100-qmp-gen4x2-pcie-phy
     then:
       properties:
-- 
2.43.0



