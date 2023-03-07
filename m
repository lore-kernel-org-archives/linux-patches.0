Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D109EBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A61C433D2;
	Tue,  7 Mar 2023 17:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209082;
	bh=VJJFthoER9C3nd7IDCYob4XVZMZsZv63VV+YI/+PZ1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0VGWk/OS6hBsKWr89lzK8QBvaHDLNpcTBLIKETOLkqm4I/KGWwocjD//mCPZR2WOp
	 BQ87fz38sdYx1hixzM40PZi1AT24mt2Qsbu/cZekp9lSjp5wKkKjX8ByOXSa3EzLs4
	 642/UlQdy4Vc3Le3keZ05svK6Iw8hp5vtQ3UkCsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0105/1001] arm64: dts: qcom: sm8450-nagara: Correct firmware paths
Date: Tue,  7 Mar 2023 17:47:57 +0100
Message-Id: <20230307170026.687802573@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit e27f38e6255306527e32af85592d805f3360ff94 ]

Nagara is definitely not SM8350, fix it!

Fixes: c53532f7825c ("arm64: dts: qcom: pdx223: correct firmware paths")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230203142309.1106349-1-konrad.dybcio@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara.dtsi b/arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara.dtsi
index 38256226d2297..e437e9a12069f 100644
--- a/arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara.dtsi
@@ -534,17 +534,17 @@ &pcie0_phy {
 };
 
 &remoteproc_adsp {
-	firmware-name = "qcom/sm8350/Sony/nagara/adsp.mbn";
+	firmware-name = "qcom/sm8450/Sony/nagara/adsp.mbn";
 	status = "okay";
 };
 
 &remoteproc_cdsp {
-	firmware-name = "qcom/sm8350/Sony/nagara/cdsp.mbn";
+	firmware-name = "qcom/sm8450/Sony/nagara/cdsp.mbn";
 	status = "okay";
 };
 
 &remoteproc_slpi {
-	firmware-name = "qcom/sm8350/Sony/nagara/slpi.mbn";
+	firmware-name = "qcom/sm8450/Sony/nagara/slpi.mbn";
 	status = "okay";
 };
 
-- 
2.39.2



