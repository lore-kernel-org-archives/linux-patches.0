Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0A91170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59008C433C7;
	Mon, 11 Sep 2023 14:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441331;
	bh=qoNOORJMFl0WXH/QhA/sYcbeqLiw0+o3z4YvBxzDTAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFPG3LyoNWXFOm6sNurSXPaHK06J46m39aSKW9tFVN9MZAISa8M4gmgD/hD7fbeuC
	 Lq6S/hTq2F7sxcXOcFmOs40OPlhDxisPzBzB8TLamMy8CTDeNexI0B6t83i1rJi9Wl
	 0jxoMljDC3+b4lrnRyRjHjPif55Lmhvu+BfUziaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wronek <davidwronek@gmail.com>,
	Yassine Oudjana <y.oudjana@protonmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 349/739] arm64: dts: qcom: msm8996: Fix dsi1 interrupts
Date: Mon, 11 Sep 2023 15:42:28 +0200
Message-ID: <20230911134700.867167631@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Wronek <davidwronek@gmail.com>

[ Upstream commit bd3b4ac11845b428996cfd2c7b8302ba6a07340d ]

Fix IRQ flags mismatch which was keeping dsi1 from probing by changing
interrupts = <4> to interrupts = <5>.

Fixes: 2752bb7d9b58 ("arm64: dts: qcom: msm8996: add second DSI interface")
Signed-off-by: David Wronek <davidwronek@gmail.com>
Acked-by: Yassine Oudjana <y.oudjana@protonmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230805130936.359860-2-davidwronek@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 8a0561f1820f5..2ea3117438c3a 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -1075,7 +1075,7 @@ mdss_dsi1: dsi@996000 {
 				reg-names = "dsi_ctrl";
 
 				interrupt-parent = <&mdss>;
-				interrupts = <4>;
+				interrupts = <5>;
 
 				clocks = <&mmcc MDSS_MDP_CLK>,
 					 <&mmcc MDSS_BYTE1_CLK>,
-- 
2.40.1



