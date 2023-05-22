Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCDD171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D482C433EF;
	Mon, 22 May 2023 19:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783769;
	bh=3+3vuzsdPUtdThHxyY8H5ECFDHyhppzUFCvPl1cIETU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivl8EKX7Gz77VKcVKRnTMKw+1ECcF0SiuEQ57JoIlkun6jvUElTL651DsQ0lu9lNl
	 YMCj7n9k1i2fztC9fkAa32SV3D/eYRnBWE+etkdv09cQJ9phCWS5+hqgGAnhIKW08U
	 gXgJZJXcTr5Gd6IUkEQWTO/v/qVQIrHCeDAhUNco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Jianhua Lu <lujianhua000@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/292] dt-bindings: display/msm: dsi-controller-main: Document qcom, master-dsi and qcom, sync-dual-dsi
Date: Mon, 22 May 2023 20:08:34 +0100
Message-Id: <20230522190409.887654199@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jianhua Lu <lujianhua000@gmail.com>

[ Upstream commit ca29699a57ecee6084a4056f5bfd6f11dd359a71 ]

This fixes warning:
  sm8250-xiaomi-elish-csot.dtb: dsi@ae94000: Unevaluated properties are not allowed ('qcom,master-dsi', 'qcom,sync-dual-dsi' were unexpected)

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Jianhua Lu <lujianhua000@gmail.com>
Fixes: 4dbe55c97741 ("dt-bindings: msm: dsi: add yaml schemas for DSI bindings")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/534306/
Link: https://lore.kernel.org/r/20230427122132.24840-1-lujianhua000@gmail.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/display/msm/dsi-controller-main.yaml    | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/display/msm/dsi-controller-main.yaml b/Documentation/devicetree/bindings/display/msm/dsi-controller-main.yaml
index 6c5b4783812ae..2fa1759e74d95 100644
--- a/Documentation/devicetree/bindings/display/msm/dsi-controller-main.yaml
+++ b/Documentation/devicetree/bindings/display/msm/dsi-controller-main.yaml
@@ -65,6 +65,18 @@ properties:
       Indicates if the DSI controller is driving a panel which needs
       2 DSI links.
 
+  qcom,master-dsi:
+    type: boolean
+    description: |
+      Indicates if the DSI controller is the master DSI controller when
+      qcom,dual-dsi-mode enabled.
+
+  qcom,sync-dual-dsi:
+    type: boolean
+    description: |
+      Indicates if the DSI controller needs to sync the other DSI controller
+      with MIPI DCS commands when qcom,dual-dsi-mode enabled.
+
   assigned-clocks:
     maxItems: 2
     description: |
-- 
2.39.2



