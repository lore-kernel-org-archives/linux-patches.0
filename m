Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC56E359A6F;
	Wed, 20 May 2026 17:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298345; cv=none; b=qJ7p+6BDsGh0d5uEUhUw8n3Sr7BhIScZ9Enz5Tv8ymX3r594IDAct4iaB6ZePlWg78rkrxmuf7XcZ4VBi5unzM7hg6sf719dXLtmhRv3GTxwXlcQXxxZmN2N5VzrejZ/X4DP3J8jPQQ8njYP4Zeb364o1RuZ7WCUydriuxXImCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298345; c=relaxed/simple;
	bh=0GHCpL6p5xiJxU9CkSt3HCbPB5IiOb6lcOApXWixfvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/Nx0wq7LGRWth/O2q6jseLwFWn5vVS33mj1UsEItOEMyGtbn8ZQSHUYkRXQQbbvYhPOswNN27nPJPSzztv3Qk8XO219d91Xp9KBzUrPWgSLYB8XkHPNRVhAr8VdpcPrkhbydygxd0sb/TWPSHfMBdx5UedFbIwp6g41MKn2kWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qlTWqhOm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qlTWqhOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D302D1F000E9;
	Wed, 20 May 2026 17:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298344;
	bh=bj3vMEtMF2JxSMpaf6SedLzkCbcETsN584gyHAXfOPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qlTWqhOmg/vuXoE5zivJEqlBuzJgdohFNZWK8BfcYz1gyqa6bATfw8t5ZSFrRM1wR
	 LYSQhxx1oogifPnYuPCb7EnV5/p009Z6tuvOIitfh/SQcxWK7b5+SV2oAhuEDQTn5/
	 nAi/c8F0jmS0odiwen5Oe0ETXfSrBJNByjc2uxHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 375/957] arm64: dts: qcom: talos: Add missing clock-names to GCC
Date: Wed, 20 May 2026 18:14:18 +0200
Message-ID: <20260520162142.660956879@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit c653607929bb4e0d8b80573bdb523adab5b975c2 ]

The binding for this clock controller requires that clock-names are
present. They're not really used by the kernel driver, but they're
marked as required, so someone might have assumed it's done on purpose
(where in reality we try to stay away from that since index-based
references are faster, take up less space and are already widely used)
and referenced it in drivers for another OS.

Hence, do the least painful thing and add the missing entries.

Fixes: 8e266654a2fe ("arm64: dts: qcom: add QCS615 platform")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260126-topic-talos_dt_warn-v1-1-c452afc647ad@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6150.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm6150.dtsi b/arch/arm64/boot/dts/qcom/sm6150.dtsi
index 363b9f436cd0a..a066ad5ffde57 100644
--- a/arch/arm64/boot/dts/qcom/sm6150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6150.dtsi
@@ -522,6 +522,9 @@ gcc: clock-controller@100000 {
 			clocks = <&rpmhcc RPMH_CXO_CLK>,
 				 <&rpmhcc RPMH_CXO_CLK_A>,
 				 <&sleep_clk>;
+			clock-names = "bi_tcxo",
+				      "bi_tcxo_ao",
+				      "sleep_clk";
 
 			#clock-cells = <1>;
 			#reset-cells = <1>;
-- 
2.53.0



