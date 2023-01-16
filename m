Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2830833EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A108DC433D2;
	Mon, 16 Jan 2023 15:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884587;
	bh=zgWuZHm0L3Rn5ONZWLTU9T5wxD4w9q34r89Agk7OXlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09cVDPLwM1O8/eeCVM4S6jklGFfUDRKrNdTHLhaovRe3Uave3gRYiprYJGmYyynv6
	 E7RwDltU8KvYDogLUOZa/UTBQ9WBrH07Xxfx5/wIPmGrlEQezXJgzsBRNngGOg/gyE
	 vGQd+W1GwK8b2JdoqEeKxlaNaVeVDu4vj/1bdwNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 6.1 062/183] dt-bindings: msm: dsi-phy-28nm: Add missing qcom, dsi-phy-regulator-ldo-mode
Date: Mon, 16 Jan 2023 16:49:45 +0100
Message-Id: <20230116154805.976039460@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit be79f805a1e1b95605c825f1c513bdd2c8b167ed upstream.

Add in missing qcom,dsi-phy-regulator-ldo-mode to the 28nm DSI PHY.
When converting from .txt to .yaml we missed this one.

Fixes: 4dbe55c97741 ("dt-bindings: msm: dsi: add yaml schemas for DSI bindings")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/516205/
Link: https://lore.kernel.org/r/20221229124438.504770-2-bryan.odonoghue@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/display/msm/dsi-phy-28nm.yaml |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/devicetree/bindings/display/msm/dsi-phy-28nm.yaml
+++ b/Documentation/devicetree/bindings/display/msm/dsi-phy-28nm.yaml
@@ -34,6 +34,10 @@ properties:
   vddio-supply:
     description: Phandle to vdd-io regulator device node.
 
+  qcom,dsi-phy-regulator-ldo-mode:
+    type: boolean
+    description: Indicates if the LDO mode PHY regulator is wanted.
+
 required:
   - compatible
   - reg


