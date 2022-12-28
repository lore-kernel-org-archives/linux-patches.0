Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58A31863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618EDC433D2;
	Wed, 28 Dec 2022 14:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239424;
	bh=9H5l4CQ8u8WDFpOSxw0urqW3JuRp+pRhbLSUVgXweQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jC1WaU/mqLlZ4TrNtS3pWYzCBJdoeYaDWDXj6/lhyhlYbDfkIgw9Ke3KoFeZTOTZm
	 i0lygRtvyHxw/Z54M1LmYfd97kPIDsm8/RYwJ2Sb9iQRshGLNiZN/+UtKr0Tf4pK4W
	 KSfX+L35gjEPpZzbZH8r8XFTgdeO68Fi81+YdsTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0027/1073] arm64: dts: qcom: pm660: Use unique ADC5_VCOIN address in node name
Date: Wed, 28 Dec 2022 15:26:55 +0100
Message-Id: <20221228144328.883869144@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 02549ba5de0a09a27616496c3512db5af4ad7862 ]

The register address in the node name is shadowing vph_pwr@83, whereas
the ADC5_VCOIN register resolves to 0x85.  Fix this copy-paste
discrepancy.

Fixes: 4bf097540506 ("arm64: dts: qcom: pm660: Add VADC and temp alarm nodes")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220926190148.283805-3-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pm660.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/pm660.dtsi b/arch/arm64/boot/dts/qcom/pm660.dtsi
index d0eefbb51663..d8c9ece20cd9 100644
--- a/arch/arm64/boot/dts/qcom/pm660.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm660.dtsi
@@ -163,7 +163,7 @@ vadc_vph_pwr: vph_pwr@83 {
 				qcom,pre-scaling = <1 3>;
 			};
 
-			vcoin: vcoin@83 {
+			vcoin: vcoin@85 {
 				reg = <ADC5_VCOIN>;
 				qcom,decimation = <1024>;
 				qcom,pre-scaling = <1 3>;
-- 
2.35.1



