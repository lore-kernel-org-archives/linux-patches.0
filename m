Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D801A168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA55C433D2;
	Mon,  8 May 2023 10:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541543;
	bh=vw7pUMcuOnjNzUsyswCVxy1RctXSPIksujjPlIxQ/NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/lb228SpwbNo0grB5l2NZwHajloZIfm6vc9odsRUnRWMczSZR9An7SERPKBxIbHb
	 uuYC12dKX+9LT+Kdi1yeKK3PpbVXse+IVmyVPnOaUD9e/iMEMqKbjr0tDNjRWCXMrN
	 ZUzojzRmAJzaechMZZfM+15151PQX0G89fPi1fDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 149/663] ARM: dts: qcom-apq8064: Fix opp table child name
Date: Mon,  8 May 2023 11:39:35 +0200
Message-Id: <20230508094433.331099844@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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

[ Upstream commit b9745c275246a7e43c34d1b3be5ff9a9f3cf9305 ]

The opp-320000000 name is rather misleading with the opp-hz value
of 450 MHz. Fix it!

Fixes: 8db0b6c7b636 ("ARM: dts: qcom: apq8064: Convert adreno from legacy gpu-pwrlevels to opp-v2")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230220120831.1591820-1-konrad.dybcio@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-apq8064.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 0da9623ea0849..4133321edad88 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -1261,7 +1261,7 @@
 			gpu_opp_table: opp-table {
 				compatible = "operating-points-v2";
 
-				opp-320000000 {
+				opp-450000000 {
 					opp-hz = /bits/ 64 <450000000>;
 				};
 
-- 
2.39.2



