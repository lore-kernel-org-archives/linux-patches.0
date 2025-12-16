Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B1134D397;
	Tue, 16 Dec 2025 11:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885292; cv=none; b=MCbozd1sKY8Ui0PhZT9cFADE3hZdpOBt8FDCSe9XUSGkMbFFXVbgEJv6VRFUziCyKArXM4VmAtlvqtGMHTfVep17HH77m6+o5cjRhld6MTpZosexNoKS75IxDL82zE9zHuifW1YfELSGbl3aavYDsQj0BOkgkVL3rVnifEyIrlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885292; c=relaxed/simple;
	bh=D32q2iEddA4zwTeisLa8gQnkuttKIeQm85fsvaLxkqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8gl18ZE77YGzmeCOD9rEClA0xKvlxhI9bWBtXSQ/levGdirqQz+dJHFET5Cmyd+4c9kLTi+dP1Irm8cSFo8jF9EnMq//iZ7jXTlh+OBCROX6IL6eNJtft9rMuYu+Fl2aZFhn5UOa+z6G/HsDv8jS2VzXxHU6yqOb4/7t3rWVjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VwuVFQE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VwuVFQE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E78C4CEF1;
	Tue, 16 Dec 2025 11:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885292;
	bh=D32q2iEddA4zwTeisLa8gQnkuttKIeQm85fsvaLxkqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VwuVFQE75OorbAgBzp+k69hAQODDZCynVWbzN/yTeNAgp8FN0hX0JuXt9MhZUGqYY
	 AAIY+keoe7XXbhdDgSxxhQeqLpR4YoezpD8vWvCTQ/Y+DvklrSgwVgoFeS45FDy9Au
	 H6smTMOmcLIej50ChPb2grGV9nayWuJXhHH+2igg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 094/507] arm64: dts: qcom: sdm845-starqltechn: remove (address|size)-cells
Date: Tue, 16 Dec 2025 12:08:55 +0100
Message-ID: <20251216111348.943026943@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dzmitry Sankouski <dsankouski@gmail.com>

[ Upstream commit 4133486382364f60ea7e4f2c9070555689d9606e ]

Drop the unused address/size-cells properties to silence the DT
checker warning:

pmic@66 (maxim,max77705): '#address-cells', '#size-cells' do not
match any of the regexes: '^pinctrl-[0-9]+$'

Fixes: 7a88a931d095 ("arm64: dts: qcom: sdm845-starqltechn: add max77705 PMIC")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250926-starqltechn-correct_max77705_nodes-v5-1-c6ab35165534@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
index d686531bf4eac..016a245a97c40 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
@@ -591,8 +591,6 @@ pmic@66 {
 		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-0 = <&pmic_int_default>;
 		pinctrl-names = "default";
-		#address-cells = <1>;
-		#size-cells = <0>;
 
 		leds {
 			compatible = "maxim,max77705-rgb";
-- 
2.51.0



