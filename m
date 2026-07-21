Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0654546AA6C;
	Tue, 21 Jul 2026 15:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648128; cv=none; b=hmiqD3IvDbt5HXE5xdtv0kWoLChZvnJGZKxZigj0z1pP+s0TlPqIBqq8JWxpYiLMNemzpBwN0PZilru3jKdWs+ocPENKN8NwT0F5ekQhkI+rEo6LiRzYnBKYJS4J/VKbxF6aR5HdfguWWrHeSLEtGAcxnYvKixLEF/kp3SK6n6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648128; c=relaxed/simple;
	bh=xqNtkl6Jwk/GHpUumaIkMP4NhEF11ADx2TVB8Bg9Rs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urpGtmgKWRsotA0lM8xjfvPItrg4tyolaTYEmH19ODXHW2zTNcm6l6E24R+0cvYdYjbEO7xTFeP8/0ebJwu7yjDWZTRsilnqKpAJAhRi92vw7+6xOzvg2S9yVBco82Yv6EDH7vh6QJJXIdZ3w1k8vs8wwS6ZdJZMDPTagdT/TIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k2EdRdvM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k2EdRdvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539271F000E9;
	Tue, 21 Jul 2026 15:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648126;
	bh=pVT9llZye8w+c9pNrBivKFbQGcC1OfHWSizbxrjv9e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k2EdRdvMM1tqu5issK1UCmhfaFVDSA4tLjTJ5+86kXXBaRhy5zsjbIARfoy4/58s9
	 ZT1BwomSyiUaQId/DmtfDXxjI95+eyAwSUnqx2+Bs/Xg1yZLpvbeACSZRFmQl35ovX
	 LAW4ceLwQP3UxHrnVHaP2UG64x+0tsi77yHJm65E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0080/2077] dt-bindings: net: bluetooth: qualcomm: Fix WCN6855 regulator names
Date: Tue, 21 Jul 2026 16:55:53 +0200
Message-ID: <20260721152554.581753176@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 63b35a29d7ad2cafb0076f8b002b30fb74df053a ]

Commit 5f4f954bba12 ("dt-bindings: bluetooth: bring the HW description
closer to reality for wcn6855") changed the vddrfa1p7-supply to 1p8
for whatever reason.

The schematics footprint for this chip definitely says 7 on the input
leg and the driver still expects 1p7. Bring it back.

Fixes: 5f4f954bba12 ("dt-bindings: bluetooth: bring the HW description closer to reality for wcn6855")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Acked-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260225-topic-wcn6855_pmu_dtbdings-v3-1-576ec5c4e631@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/net/bluetooth/qcom,wcn6855-bt.yaml | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/bluetooth/qcom,wcn6855-bt.yaml b/Documentation/devicetree/bindings/net/bluetooth/qcom,wcn6855-bt.yaml
index 45630067d3c8ed..0beda26ae8bb45 100644
--- a/Documentation/devicetree/bindings/net/bluetooth/qcom,wcn6855-bt.yaml
+++ b/Documentation/devicetree/bindings/net/bluetooth/qcom,wcn6855-bt.yaml
@@ -50,9 +50,6 @@ properties:
     description: VDD_RFA_1P7 supply regulator handle
     deprecated: true
 
-  vddrfa1p8-supply:
-    description: VDD_RFA_1P8 supply regulator handle
-
   vddrfacmn-supply:
     description: VDD_RFA_CMN supply regulator handle
 
@@ -68,7 +65,7 @@ required:
   - vddbtcmx-supply
   - vddrfa0p8-supply
   - vddrfa1p2-supply
-  - vddrfa1p8-supply
+  - vddrfa1p7-supply
   - vddrfacmn-supply
   - vddwlcx-supply
   - vddwlmx-supply
@@ -91,7 +88,7 @@ examples:
             vddbtcmx-supply = <&vreg_pmu_btcmx_0p8>;
             vddrfa0p8-supply = <&vreg_pmu_rfa_0p8>;
             vddrfa1p2-supply = <&vreg_pmu_rfa_1p2>;
-            vddrfa1p8-supply = <&vreg_pmu_rfa_1p7>;
+            vddrfa1p7-supply = <&vreg_pmu_rfa_1p7>;
             vddrfacmn-supply = <&vreg_pmu_rfa_cmn_0p8>;
             vddwlcx-supply = <&vreg_pmu_wlcx_0p8>;
             vddwlmx-supply = <&vreg_pmu_wlmx_0p8>;
-- 
2.53.0



