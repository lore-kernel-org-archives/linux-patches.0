Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02D933EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55986C433EF;
	Mon, 16 Jan 2023 15:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884602;
	bh=HW9Yx9CkZu9N3Nw1ZH09NZ7/pewdTSPQX5GGC3qp6eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FjdvHvZvZbIu0vOy/x2AGhlZFhnOLV0a5UkVIMm4S3bnpO6Zc6ywVkNk89dRezpBb
	 ZioV0pQF2gBhixphI+NXrvonCw/zj0TMbtdsw8AkCFsEChHNsx3ImtmyPGkh0LTKei
	 ZK54TVCsUeso5qO7He6WaIxJqSAMJ1HuCbVetGAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 6.1 067/183] dt-bindings: msm/dsi: Dont require vdds-supply on 10nm PHY
Date: Mon, 16 Jan 2023 16:49:50 +0100
Message-Id: <20230116154806.184564887@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

commit ef11cb7a29c0e13031c968190ea8f86104e7fb6a upstream.

On some SoCs (hello SM6350) vdds-supply is not wired to any smd-rpm
or rpmh regulator, but instead powered by the VDD_MX/mx.lvl line,
which is voted for in the DSI ctrl node.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Acked-by: Rob Herring <robh@kernel.org>
Fixes: 8fc939e72ff8 ("dt-bindings: msm: dsi: add yaml schemas for DSI PHY bindings")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/511889/
Link: https://lore.kernel.org/r/20221116163218.42449-1-konrad.dybcio@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/display/msm/dsi-phy-10nm.yaml |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/devicetree/bindings/display/msm/dsi-phy-10nm.yaml
+++ b/Documentation/devicetree/bindings/display/msm/dsi-phy-10nm.yaml
@@ -69,7 +69,6 @@ required:
   - compatible
   - reg
   - reg-names
-  - vdds-supply
 
 unevaluatedProperties: false
 


