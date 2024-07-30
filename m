Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05B61A76BF;
	Tue, 30 Jul 2024 17:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360356; cv=none; b=qb+SrjJO2vWZy5vY2rgRWt4yTu5WvUXYbaVFuyI/pXqPSvIHWJudN6+B25g9VsihkLzDOgXx3cKBq10bYLVsSxDcdRpx/ZQvxClwLbtJxv4RBREGTpsJqWuAdt8uffuTwQTTlo0bsIrPd0aTWREIjbC4no9dDwM022ht1FDHtOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360356; c=relaxed/simple;
	bh=5wfViMb8BAPyTp1XgdzjfsTMCi4GXA3ZkNtgjTId1p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d61+cn44lZlUp+LTAuyl+o2m66TuvUEKVaZnjyJ3GOvVYonhO8darvUs5V5iasIL6CeRcTMJPn8gCs/6tXBBwD9L5NleexYEfasbHbI1VVytaHQVcpHpqlzXCEu6FhoL8uBXgCAUzubo45UoYlLxZHei6Sx0z4il98Cfr1mbB84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EMxtsenL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EMxtsenL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB316C4AF0F;
	Tue, 30 Jul 2024 17:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360356;
	bh=5wfViMb8BAPyTp1XgdzjfsTMCi4GXA3ZkNtgjTId1p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMxtsenLj62Vs1nxi0unVYGtU3kB6yCNJGA4rInv8kGz0GrrjMaX/NEih4ITvSsje
	 8srj0/3SMebUCBJzNBuwcJChX58AM7USiOZGhY0hVc+lhmc0hpLBeHvRGdPBQWK8/3
	 pWcH2exXjZHs/DdvtuBKBEPfA2rlFsyxoEOLLRek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yijie Yang <quic_yijiyang@quicinc.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.10 674/809] dt-bindings: phy: qcom,qmp-usb: fix spelling error
Date: Tue, 30 Jul 2024 17:49:10 +0200
Message-ID: <20240730151751.523843517@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yijie Yang <quic_yijiyang@quicinc.com>

commit 3d83abcae6e8fa6698f6b0a026ca650302bdbfd8 upstream.

Correct the spelling error, changing 'com' to 'qcom'.

Cc: stable@vger.kernel.org
Fixes: f75a4b3a6efc ("dt-bindings: phy: qcom,qmp-usb: Add QDU1000 USB3 PHY")
Signed-off-by: Yijie Yang <quic_yijiyang@quicinc.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240624021916.2033062-1-quic_yijiyang@quicinc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-usb3-uni-phy.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-usb3-uni-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-usb3-uni-phy.yaml
@@ -20,7 +20,7 @@ properties:
       - qcom,ipq8074-qmp-usb3-phy
       - qcom,ipq9574-qmp-usb3-phy
       - qcom,msm8996-qmp-usb3-phy
-      - com,qdu1000-qmp-usb3-uni-phy
+      - qcom,qdu1000-qmp-usb3-uni-phy
       - qcom,sa8775p-qmp-usb3-uni-phy
       - qcom,sc8280xp-qmp-usb3-uni-phy
       - qcom,sdm845-qmp-usb3-uni-phy


