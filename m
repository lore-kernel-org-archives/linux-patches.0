Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049638;
	b=QQLA0CzW/CDGnF5Ub9UH/Zap6J49YrK4tBgD2iHJpZR/JUc2MLnO3+WE/jmnHUF+Zs+U
	 2RX5vBIMWclrx+J1zJaNFtCTr5OLk2bknJY6V4vhYLAW1d7cPpfyGy1GV8xgStuZ+6ohQ
	 HFBD2x7gVuTkueVA8LD/ecuo5VwbgSDDxLO2dEgQpAOjIpqSeXYfn+TkXzlSHwZGtDAzz
	 ooMOvEezKoX47gE/le3j7vIAjwrTEm8ZGx16h9awzz3wyKunu0zVqY7iPwxZ3ynohbWPp
	 y0VSvyGt4a+R3izLzwyK44XP1ypcxc/OUZIw0LTCnVH0jDWIToB/gZV7B+UkE9a7gtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uLHBY3SYKpvMv4m0Gz89elAn2TFKvJyBMCExTbtQrDk=;
	b=Vw2NktazHqjhg/POk3f3fDQ9AihRDQJaNf/SoFVFN9WlrDYRvs6dDLGLLmCNR++dyrAY
	 28qHukYptxpYvQyLAumvgmwtriJ5kAT1OYdR/T5+Ae0T3VFle5LcQofiBSRHTuIvuoS8S
	 qT72604QiUh/rl49Jl8vveZ7IzgqvpQEPneispq4aivgw6HIPDyNMpGWiXaUmz35dTOwg
	 F25HeGUS/1KJHmHLks/ugc+O39c6tDJ3ZNBmBrUYonXB6NbFmpzmyh2UTQnXamvB0TRa+
	 1MZfg0dXogwFw8Vy90qTC+lEZomRB1WeQNVo+Wh0lLjV9hDLlp7aDdj0jjafRQvtd0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VAD38PB5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC49606A31C;
	Thu, 19 Nov 2026 00:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VAD38PB5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958FA1F000C4;
	Thu, 19 Nov 2026 00:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049638;
	bh=uLHBY3SYKpvMv4m0Gz89elAn2TFKvJyBMCExTbtQrDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VAD38PB5mljO7p92mWri9FVkRVrE/0N5YxJhf2Kzk+D1acUpvUvv+4k4H4E3sRpRN
	 lh5p+3Vh94bQa/lJBzeWJSBOJ3cwW9waeYEUc2fyqboiJ8SHmKxIBMeHatjLAP6s2s
	 ZhJmXqT9vDkg8l3KN3vl2TMN7GZSap3d/Z2aF2Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2423/2857] clk: qcom: mmcc-msm8996: Fix FD AHB clock register offset
Date: Wed, 18 Nov 2026 15:57:37 +0100
Message-ID: <20261118150328.795617679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 7cb2d65286b817d8d7e26f454a9c374d65e87072 ]

The FD AHB clock branch register is at offset 0x3b74, not 0x3ba74.
The incorrect offset exceeds the regmap maximum of 0xb008, so regmap
rejects accesses to it and the clock cannot be enabled.

Correct both the enable and halt register offsets so the driver can
enable the branch and check its status.

Assisted-by: LLM
Fixes: c252659770db ("clk: qcom: Add MSM8996 Multimedia Clock Controller (MMCC) driver")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916-clk-qcom-mmcc-msm8996-fix-fd-ahb-offset-v1-1-a575e1b9112c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/mmcc-msm8996.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/mmcc-msm8996.c b/drivers/clk/qcom/mmcc-msm8996.c
index 80330dab4d81a..8fb340d3ffa81 100644
--- a/drivers/clk/qcom/mmcc-msm8996.c
+++ b/drivers/clk/qcom/mmcc-msm8996.c
@@ -3137,9 +3137,9 @@ static struct clk_branch fd_core_uar_clk = {
 };
 
 static struct clk_branch fd_ahb_clk = {
-	.halt_reg = 0x3ba74,
+	.halt_reg = 0x3b74,
 	.clkr = {
-		.enable_reg = 0x3ba74,
+		.enable_reg = 0x3b74,
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "fd_ahb_clk",
-- 
2.53.0



