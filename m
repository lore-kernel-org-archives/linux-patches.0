Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D4128504C;
	Tue, 17 Jun 2025 16:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177695; cv=none; b=mFxmPN0ibFLjR3YwenkCS+FHNj8szmMfq29EmigDwamIopxzKmn/S/eioEFH4G0mADhT1JQTGv6w1fBdddiJfNT7MKzf9Hs4FyXW0wvRU3CB8tVzP+ZQmUlgoUiqczDWNh5XUf6cSaNXVqkFIQ8rdzkGAKdN7KtlseFIo0Kx534=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177695; c=relaxed/simple;
	bh=tZKyiPmezdWV510rDnH0v+ovTJqA5A1PBFeLI+5ErAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYsomfoe7Xq1c5urIWIqa//m0vqvNFVjW6BnJDXTlZRdGrhiiX5oql8zpFefh3JEPqNz0v/qJe6byvynGRcaD8Q23xZA/jS8+0pYUlDQhuXheYpPqXuslk7n+mSn4EnfPU6/ZBTQGdHzLkBY2umCLdSa3/yiqjLRcGCSQIEtT2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDmxFnwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDmxFnwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8DCC4CEE7;
	Tue, 17 Jun 2025 16:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177694;
	bh=tZKyiPmezdWV510rDnH0v+ovTJqA5A1PBFeLI+5ErAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDmxFnwHp0iaBUUimUeuvZ0RgkJLPXStX5gPEdfORAXtMH67bxWxbLeRn6/EWsZ9+
	 62Vv+89eQDSMlrAihMJPYIyDrYLGVAsBEDI8f4UStqAY9uJfsNOZbp6nFEpdwodUMf
	 +qRovhYwja90ifxfNRUa+ke+g3A4qWq+UL+HOJ/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 347/780] arm64: dts: qcom: sm8650: add missing cpu-cfg interconnect path in the mdss node
Date: Tue, 17 Jun 2025 17:20:55 +0200
Message-ID: <20250617152505.582512033@linuxfoundation.org>
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

[ Upstream commit f22be5c1dd3e12519e3f3b80c14d10b90be2c2fc ]

The bindings requires the mdp0-mem and the cpu-cfg interconnect path,
add the missing cpu-cfg path to fix the dtbs check error and also to ensure
that MDSS has enough bandwidth to let HLOS write config registers.

Fixes: 9fa33cbca3d2 ("arm64: dts: qcom: sm8650: correct MDSS interconnects")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250227-topic-sm8x50-mdss-interconnect-bindings-fix-v5-2-bf6233c6ebe5@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 9591c13edbb9d..36919efc888c2 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -3658,8 +3658,11 @@
 			resets = <&dispcc DISP_CC_MDSS_CORE_BCR>;
 
 			interconnects = <&mmss_noc MASTER_MDP QCOM_ICC_TAG_ALWAYS
-					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>;
-			interconnect-names = "mdp0-mem";
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
+					<&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &config_noc SLAVE_DISPLAY_CFG QCOM_ICC_TAG_ACTIVE_ONLY>;
+			interconnect-names = "mdp0-mem",
+					     "cpu-cfg";
 
 			power-domains = <&dispcc MDSS_GDSC>;
 
-- 
2.39.5



