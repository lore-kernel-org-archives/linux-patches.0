Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A096274B39;
	Sat, 12 Sep 2026 16:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232290; cv=none; b=RC+EBeq//b5XzQM+z8Xyx8hms2/bveBmQ/Oxbzx9V7WGbXUfeuAQbv0WRGd4klxxVoef1lbeAX3+ufleBoBD33stReNPyxlY5C1xbCkfpsSQ+MXPoXOgybFQbd5gjH++sffXdxr8LyCERxm9xJxcxj1C+ZpPHJEBe1AwZwIOrnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232290; c=relaxed/simple;
	bh=3twyqLjJ5WaNkojBHptlUM7SbHlnLXaO1ODKFl5DjxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnCv+5mWsgnc3ywXUZYAmpz1Qz8xx3iRrTH+P9zkOkGKRb4bc2gdrIyi7kbpnBxAPm1y4XrISijIgvtGOozo1xBfU6VcIbT5h+qsiOAJvDn9m1Yyw88dU4ZE9GQ5wBY7CpHHE+VFVInX9lrcVEVuU2syRUBNG9MOx2y5GIpAGVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04AGsvH+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04AGsvH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0977F1F000FF;
	Sat, 12 Sep 2026 16:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232289;
	bh=aInhh3aIEdMjLkfzTRNmG2jpALU4fpYpKJZvEzlui5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=04AGsvH+K3bgGB12+ivWgFQXMc4/yHILbnoRUqVOhnTGaM6cd+sUfwgvzbqlPesyz
	 0gZlccIjEbjfTittGJC8pRdGbZntCVnv5QQtMVb7J4QGfjJ9ciDvjbs7vCIlS2o5ib
	 pbVkQfaBBqaQRqMCd1cBIjhz0LQXVtogHQ0EbQIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1172/1191] arm64: dts: qcom: sm8550: fix qup_spi0_cs node
Date: Sat, 12 Sep 2026 09:05:00 +0200
Message-ID: <20260912065614.463230185@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 7629c7a525d163f2a3a08e260a69ff25163ab357 ]

The node is incomplete and doesn't need a subnode, add the missing
properties and move everything to the root of qup-spi0-cs-state node.

Fixes: ffc50b2d3828 ("arm64: dts: qcom: Add base SM8550 dtsi")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230308-topic-sm8550-upstream-dt-fixups-v1-2-595b02067672@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index cb4927e0a24ad..218ebb6d41c0f 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -2107,10 +2107,10 @@ qup_i2c15_data_clk: qup-i2c15-data-clk-state {
 			};
 
 			qup_spi0_cs: qup-spi0-cs-state {
-				cs-pins {
-					pins = "gpio31";
-					function = "qup1_se0";
-				};
+				pins = "gpio31";
+				function = "qup1_se0";
+				drive-strength = <6>;
+				bias-disable;
 			};
 
 			qup_spi0_data_clk: qup-spi0-data-clk-state {
-- 
2.53.0



