Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305582F94A0;
	Tue, 17 Jun 2025 16:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177688; cv=none; b=Jp8M4tWb/wGbVdekemyILjvK27QpqCNdQEqyDdXe+luGInM2Y3IEEw8OhGdU0oU5ieujk/GI0FiABkWzOIWTZLNyU11py2nftAWcmrSUrBnmJYa7JswBf+NorobtnhCIa1wiioPStHII52r0lkXKjyG/Pac9PfywHNNBvHCDtWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177688; c=relaxed/simple;
	bh=H3PRooGKww/3EEKJgDMdSHsKMlU0wz/4ouGShIAnJOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGi4WO0ckbHTCtBFFAX9pA9MCacmq64qsj5Ugf9m/SfcyTU/ONj9hs5NB9WIAUcl7bC/OGnGdd0tgwGFu9mGCg6AlohUbMrY/7dxnFQMZ3IyxjIXpP1zfjR430DY3Gman+wCYVeGswyacGf8ZagpJyOmVW28rtYEZbK1VXLeNsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+inKFl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+inKFl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58EAC4CEE3;
	Tue, 17 Jun 2025 16:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177688;
	bh=H3PRooGKww/3EEKJgDMdSHsKMlU0wz/4ouGShIAnJOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C+inKFl8mgmL0bUna5YM2YdOLOEfsII7yTL1AsxrGosXO9KlHV+gIvovBi1CaO9fo
	 kfbbwxWOa0u4ea3woSyDouHcm+j2IKWAcOPUwgCafQOQijayNirvXNJa01z2r6WlMl
	 sfoTzO9ClGs964uNTV8xmZZSiWdcTV8AfnlX2f/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 346/780] arm64: dts: qcom: sm8550: add missing cpu-cfg interconnect path in the mdss node
Date: Tue, 17 Jun 2025 17:20:54 +0200
Message-ID: <20250617152505.540153268@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 327d489d1ecaf16182952f079cc21f04cf83f967 ]

The bindings requires the mdp0-mem and the cpu-cfg interconnect path,
add the missing cpu-cfg path to fix the dtbs check error and also to ensure
that MDSS has enough bandwidth to let HLOS write config registers.

Fixes: b8591df49cde ("arm64: dts: qcom: sm8550: correct MDSS interconnects")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250227-topic-sm8x50-mdss-interconnect-bindings-fix-v5-1-bf6233c6ebe5@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 9465b00f1e74c..65ebddd124e2a 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -3146,8 +3146,10 @@
 			power-domains = <&dispcc MDSS_GDSC>;
 
 			interconnects = <&mmss_noc MASTER_MDP QCOM_ICC_TAG_ALWAYS
-					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>;
-			interconnect-names = "mdp0-mem";
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
+					<&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &config_noc SLAVE_DISPLAY_CFG QCOM_ICC_TAG_ACTIVE_ONLY>;
+			interconnect-names = "mdp0-mem", "cpu-cfg";
 
 			iommus = <&apps_smmu 0x1c00 0x2>;
 
-- 
2.39.5



