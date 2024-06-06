Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B859196C6F;
	Thu,  6 Jun 2024 14:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682934; cv=none; b=t9bLJH2p42XTXpKHj3aXUmFOFPGs7AgQpk34QFSBNWXd0QiLAR8JcMfBhoKVagT0q5dAJaZpzTHyATS6JPqHMR69MLwcOqexh1CRPyZhh3SJyYCTlZLq8HMDl0z6GQqTtBUfNv7VZxUKj8X6C9hIMQJcxuDoeqLV3luuyeXBDa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682934; c=relaxed/simple;
	bh=jLgPPIq1bpjsru/Qj4w9l3EWDbmympdAZ94+sfUuc9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1KFYOa2GZ4M1UqbDpyKngdL90thBauacp7YrbidaeXw6ekFgvyuYZyUZMiv2DcNihEkHNL5REWRj9OJ+NOf4qUVy16saE1IpdckYhmq1NugzpCYHvd10n6tTIn4lMZDYgMPBYEWianz6WAMPE9HjM/NtPf70j+IjtgraYa7qbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2JOD+DEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2JOD+DEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34599C2BD10;
	Thu,  6 Jun 2024 14:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682934;
	bh=jLgPPIq1bpjsru/Qj4w9l3EWDbmympdAZ94+sfUuc9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2JOD+DEE1ZuiWZapSMoq2+V5ZUT2ZhS+PpeI+cjDf7LmgJeX8+ygGnQOxtIthRpcZ
	 72XustmSEt5kusZnja+FOGLQz5ciBvh3f8KUMIQ8pHbE/4OT1TzjtWkVyJfo/6htEl
	 m1i7wS2ANy6KKjrOf6MRgdYJhEytMQOyDeXnAd2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 083/374] dt-bindings: phy: qcom,usb-snps-femto-v2: use correct fallback for sc8180x
Date: Thu,  6 Jun 2024 16:01:02 +0200
Message-ID: <20240606131654.652786747@linuxfoundation.org>
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

[ Upstream commit 960b3f023d3bda0efd6e573a0647227d1115d266 ]

The qcom,sc8180x-usb-hs-phy device uses qcom,usb-snps-hs-7nm-phy
fallback. Correct the schema for this platform.

Fixes: 9160fb7c39a1 ("dt-bindings: phy: qcom,usb-snps-femto-v2: use fallback compatibles")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-3-f1fd15c33fb3@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml       | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml b/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
index 0f200e3f97a9a..fce7f8a19e9c0 100644
--- a/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
@@ -15,9 +15,6 @@ description: |
 properties:
   compatible:
     oneOf:
-      - enum:
-          - qcom,sc8180x-usb-hs-phy
-          - qcom,usb-snps-femto-v2-phy
       - items:
           - enum:
               - qcom,sa8775p-usb-hs-phy
@@ -26,6 +23,7 @@ properties:
       - items:
           - enum:
               - qcom,sc7280-usb-hs-phy
+              - qcom,sc8180x-usb-hs-phy
               - qcom,sdx55-usb-hs-phy
               - qcom,sdx65-usb-hs-phy
               - qcom,sm6375-usb-hs-phy
-- 
2.43.0



