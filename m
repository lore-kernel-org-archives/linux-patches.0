Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CBA267393;
	Tue,  8 Apr 2025 12:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114520; cv=none; b=sfs2JEMDM3EnTYMxFcXZA3LuEEpNxhO3y+fgtAOKfOZqZCB5UcaFAagyPVt5SqPxJvmcCe6Ia0eIBn21zcIQQ8JGC0IIdYxCbUDh9RhTHmkkNEjKFPrQdLSi0f7LZPrUTKfEGUrZp+6nUaqw3E9Bh5aikZEZYgpN2KwNIS6S2JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114520; c=relaxed/simple;
	bh=enCz4/hI42pD+o4IWOB7ikGnBf/A37BMpGGGsMhPFF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgthALQMb5ZO/U48NSlJQPD06EQevvVCaO/JgELugqG/s8zqB1MAs1ukDLjLMkyVcbmXQwzPEfHBShPFUc4ayLacmV32Pfu3zLaUdLOGanRT7O5R55APKHjOkD9O2RzZ7NgbOy+6FChgqD0RYVR6V04xLQYzKMptX67Vohx2P08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FouniDpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FouniDpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999B8C4CEE5;
	Tue,  8 Apr 2025 12:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114520;
	bh=enCz4/hI42pD+o4IWOB7ikGnBf/A37BMpGGGsMhPFF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FouniDpy16DZh7D42iEK21jNmWb+oKdU6DIakHfmR1etPruA4wg6kK0DPPSAYfpLc
	 ZWdH/8/7t8nuE+WqUgrJRE4AjKYuR2Nf9ULnbd3f1gdDBi0bDdW8Mgqa93CuZ80GQJ
	 JU7LGWEyNj4uXn2zvStQilg+qO3+7RO5K3Mci8+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Mylavarapu <quic_mmanikan@quicinc.com>,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 138/499] drivers: clk: qcom: ipq5424: fix the freq table of sdcc1_apps clock
Date: Tue,  8 Apr 2025 12:45:50 +0200
Message-ID: <20250408104854.630005467@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manikanta Mylavarapu <quic_mmanikan@quicinc.com>

[ Upstream commit e9ed0ac3ccba65c17ed0d59c77a340a75abc317b ]

The divider values in the sdcc1_apps frequency table were incorrectly
updated, assuming the frequency of gpll2_out_main to be 1152MHz.
However, the frequency of the gpll2_out_main clock is actually 576MHz
(gpll2/2).

Due to these incorrect divider values, the sdcc1_apps clock is running
at half of the expected frequency.

Fixing the frequency table of sdcc1_apps allows the sdcc1_apps clock to
run according to the frequency plan.

Fixes: 21b5d5a4a311 ("clk: qcom: add Global Clock controller (GCC) driver for IPQ5424 SoC")
Signed-off-by: Manikanta Mylavarapu <quic_mmanikan@quicinc.com>
Reviewed-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250306112900.3319330-1-quic_mmanikan@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5424.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/qcom/gcc-ipq5424.c b/drivers/clk/qcom/gcc-ipq5424.c
index 88a7d5b2e751a..6b76d909597ec 100644
--- a/drivers/clk/qcom/gcc-ipq5424.c
+++ b/drivers/clk/qcom/gcc-ipq5424.c
@@ -614,11 +614,11 @@ static struct clk_rcg2 gcc_qupv3_uart1_clk_src = {
 static const struct freq_tbl ftbl_gcc_sdcc1_apps_clk_src[] = {
 	F(144000, P_XO, 16, 12, 125),
 	F(400000, P_XO, 12, 1, 5),
-	F(24000000, P_XO, 1, 0, 0),
-	F(48000000, P_GPLL2_OUT_MAIN, 12, 1, 2),
-	F(96000000, P_GPLL2_OUT_MAIN, 6, 1, 2),
+	F(24000000, P_GPLL2_OUT_MAIN, 12, 1, 2),
+	F(48000000, P_GPLL2_OUT_MAIN, 12, 0, 0),
+	F(96000000, P_GPLL2_OUT_MAIN, 6, 0, 0),
 	F(177777778, P_GPLL0_OUT_MAIN, 4.5, 0, 0),
-	F(192000000, P_GPLL2_OUT_MAIN, 6, 0, 0),
+	F(192000000, P_GPLL2_OUT_MAIN, 3, 0, 0),
 	F(200000000, P_GPLL0_OUT_MAIN, 4, 0, 0),
 	{ }
 };
-- 
2.39.5



