Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CA18F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E589BC433C8;
	Sun, 16 Jul 2023 20:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538803;
	bh=aPCdBMrlgF+gklBIlDerPQRDP5Yqkv8wEVLWVDG4rPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlGyS02k4fl1+vQPLd9Q6O+ik3OygaOOG5Q4lmjsCHYpZ7mQRQqnDxerFwI891s75
	 bY+Nc9VIv2TEA0mGEGGO3wktDk6hwiR5xw3pmm2aR+CWXMMl4w6Svy5o/FnKDqX+9O
	 R8osnlApLXBsdPoIGU0tfHz3KQc1Ye2qQFFlzLdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Mylavarapu <quic_mmanikan@quicinc.com>,
	Kathiravan T <quic_kathirav@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 581/800] clk: qcom: ipq5332: fix the src parameter in ftbl_gcc_apss_axi_clk_src
Date: Sun, 16 Jul 2023 21:47:14 +0200
Message-ID: <20230716195002.579765473@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kathiravan T <quic_kathirav@quicinc.com>

[ Upstream commit 81c1ef89a45eccd5603f1e27e281d14fefcb81f9 ]

480MHz is derived from P_GPLL4_OUT_AUX not from P_GPLL4_OUT_MAIN. Update
the freq_tbl with the correct src.

Fixes: 3d89d52970fd ("clk: qcom: add Global Clock controller (GCC) driver for IPQ5332 SoC")
Reported-by: Manikanta Mylavarapu <quic_mmanikan@quicinc.com>
Signed-off-by: Kathiravan T <quic_kathirav@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230417044342.9406-1-quic_kathirav@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5332.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-ipq5332.c b/drivers/clk/qcom/gcc-ipq5332.c
index 1ad23aa8aa5a9..b9ab67649130a 100644
--- a/drivers/clk/qcom/gcc-ipq5332.c
+++ b/drivers/clk/qcom/gcc-ipq5332.c
@@ -366,7 +366,7 @@ static struct clk_rcg2 gcc_adss_pwm_clk_src = {
 };
 
 static const struct freq_tbl ftbl_gcc_apss_axi_clk_src[] = {
-	F(480000000, P_GPLL4_OUT_MAIN, 2.5, 0, 0),
+	F(480000000, P_GPLL4_OUT_AUX, 2.5, 0, 0),
 	F(533333333, P_GPLL0_OUT_MAIN, 1.5, 0, 0),
 	{ }
 };
-- 
2.39.2



