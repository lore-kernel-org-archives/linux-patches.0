Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2F03DB95
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGh0iRgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBE2C433C9;
	Wed, 15 Nov 2023 19:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078180;
	bh=z7YemTzDMc4buqWbl/msP0VagCSUIkdi360AiGJO75w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGh0iRgxxzDnGGXrTT1dhLb4nVjFqNIs6GqBWSZV1PP0lFa5k+CS2ZVSdD+wEFHB3
	 eqWJEPuLRaqsvq0kr4n9TByRCpnBvozx2qCbgnqsIywfLINRNttyQFoC5/EMhPibl7
	 batgFkUDQ1n2v4cq6M937iNExsROL8M7Kzeu4Z3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Douglas Anderson <dianders@chromium.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/379] arm64: dts: qcom: sdm845: cheza doesnt support LMh node
Date: Wed, 15 Nov 2023 14:23:55 -0500
Message-ID: <20231115192654.574985341@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 197ae69d1caedb3203e0b189a39efb820675fd5c ]

Cheza firmware doesn't allow controlling LMh from the operating system.

Fixes: 36c6581214c4 ("arm64: dts: qcom: sdm845: Add support for LMh node")
Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20230912071205.11502-2-david@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi b/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
index b5f11fbcc3004..a5c0c788969fb 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
@@ -145,6 +145,10 @@ panel_in_edp: endpoint {
 	};
 };
 
+&cpufreq_hw {
+	/delete-property/ interrupts-extended; /* reference to lmh_cluster[01] */
+};
+
 &psci {
 	/delete-node/ cpu0;
 	/delete-node/ cpu1;
@@ -277,6 +281,14 @@ &BIG_CPU_SLEEP_1
 			   &CLUSTER_SLEEP_0>;
 };
 
+&lmh_cluster0 {
+	status = "disabled";
+};
+
+&lmh_cluster1 {
+	status = "disabled";
+};
+
 /*
  * Reserved memory changes
  *
-- 
2.42.0



