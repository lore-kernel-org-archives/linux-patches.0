Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B79874C0C;
	Mon, 15 Apr 2024 14:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191109; cv=none; b=ZDPA/oycEbQuC0J6MAANj/1picm65v1ixqBSgXLDA2uQjo6c/Hnbu9GA8V+Je7AsVxHmsf92VJxT9nDBcmqiNJL9aZ/37bjpmrvxFF/GN6Cse7zSBY34gNAfl2kZuADjFzVY69dfr6P2RqHiDAIgJzvJQrz2cxHgVuDCitLnlqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191109; c=relaxed/simple;
	bh=uvbPiPWuxJZPNDMSJkQuu0aJ4gJLz+Mz31e8XyTZvPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1G3jiGZCo4t132jPyRBMdtcDXR5yZvCJFufRiZQMTIR/P/QLGV83cQbJkgvR6nhvA6ts0TegEseafPd2gjXe84Xgm54SOY4yjx5iaulDNMZH9PuP6G6NCz/xQ7Vc6vVe9agDr85TK8knQFZjt3rN2AYHwMpXWKCPtQ3nsA/Fb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETBT6WxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETBT6WxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1468AC113CC;
	Mon, 15 Apr 2024 14:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191109;
	bh=uvbPiPWuxJZPNDMSJkQuu0aJ4gJLz+Mz31e8XyTZvPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETBT6WxTBPAjJyJEvbOnO08XlSnLqFWcavQD9KNOv2l/r7qwLusGICk2H1bxHg51C
	 j4/nSy38je+WS68CeDMFFJAvLsjJVptGbP8amGYekwbEIz2LgqVWBx22tin3942jcA
	 mdH2x5j9toRsISE2dD+erh/IfH+zqcfzVNUOFMUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 035/172] dt-bindings: display/msm: sm8150-mdss: add DP node
Date: Mon, 15 Apr 2024 16:18:54 +0200
Message-ID: <20240415142001.495977235@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit be1b7acb929137e3943fe380671242beb485190c ]

As Qualcomm SM8150 got support for the DisplayPort, add displayport@
node as a valid child to the MDSS node.

Fixes: 88806318e2c2 ("dt-bindings: display: msm: dp: declare compatible string for sm8150")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/586156/
Link: https://lore.kernel.org/r/20240402-fd-fix-schema-v3-1-817ea6ddf775@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/display/msm/qcom,sm8150-mdss.yaml           | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/display/msm/qcom,sm8150-mdss.yaml b/Documentation/devicetree/bindings/display/msm/qcom,sm8150-mdss.yaml
index c0d6a4fdff97e..e6dc5494baee2 100644
--- a/Documentation/devicetree/bindings/display/msm/qcom,sm8150-mdss.yaml
+++ b/Documentation/devicetree/bindings/display/msm/qcom,sm8150-mdss.yaml
@@ -53,6 +53,15 @@ patternProperties:
       compatible:
         const: qcom,sm8150-dpu
 
+  "^displayport-controller@[0-9a-f]+$":
+    type: object
+    additionalProperties: true
+
+    properties:
+      compatible:
+        contains:
+          const: qcom,sm8150-dp
+
   "^dsi@[0-9a-f]+$":
     type: object
     additionalProperties: true
-- 
2.43.0



