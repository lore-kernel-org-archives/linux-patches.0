Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4A711705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C41C433C8;
	Mon, 11 Sep 2023 14:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443189;
	bh=RE9Kb3IB4Q3B4kYxWAwLWN4QEL6iVmnDq/N48Ftmq94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpqFAtOT0jrJ8tgpvPSiBev3w7485gmTstU27pRxKlswUOoxGp3+CyBimJKiN0JPb
	 qLBYFc+M65Uq1X0xjD1xtI2pivU7sHqryHSFYVRK4HD4pujgKyV7EaKNELusES2Wz8
	 a2Sqhq1kcfPLK3gFlNEWHiPiiY07hrKLTkvRgyR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 289/737] arm64: dts: qcom: sc8280xp: Add missing SCM interconnect
Date: Mon, 11 Sep 2023 15:42:28 +0200
Message-ID: <20230911134658.636225636@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 0a69ccf20b0837db857abfc94d7e3bacf1cb771b ]

The SCM interconnect path was missing. Add it.

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230622-topic-8280scmicc-v1-2-6ef318919ea5@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index cc4aef21e6172..9c3fb75e06005 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -296,6 +296,7 @@ CLUSTER_SLEEP_0: cluster-sleep-0 {
 	firmware {
 		scm: scm {
 			compatible = "qcom,scm-sc8280xp", "qcom,scm";
+			interconnects = <&aggre2_noc MASTER_CRYPTO 0 &mc_virt SLAVE_EBI1 0>;
 		};
 	};
 
-- 
2.40.1



