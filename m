Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024592;
	b=DmiIr4bab50F8B08+nxAiU04EIxlpeC1G3hDMcZkB0y/kTAmBXQ1g5DfMp8hpytJvPb/
	 mX0H/3lHXgD5mCjx4lTpw09wpqlfR0THedwavvOcLNd9UkunWoCSpcbw3hDUib1LQWLpS
	 xDa+d2vpdnNXLoo2/7062F3Y8Y8P84nk8hEt1wKjueuq+ylxI+HPcyC85Vz8tb7ZD3twr
	 7wZrldv9Y/R2NIOZiojRNKRa7g+DxxWdepX159OjuhVx69j4UG6dMLMqE2dfMY+2x1uL8
	 69Tq1nNf3/LSjpri0kLtppwL4zqts9KiuLriV0LDhQTeJrl+hn3eWcpaMFTatQPER0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6Tb3WWqS5M5GRuZYMAeP+qCFpxUXlPJbf69ENR+SmvA=;
	b=xQTMrJaGXzYoE+qNdiOe2mHcb6uS52TzdiD/z3gKKWMq2omOJxrQFF5kfsskBd0TuIhD
	 f1cvXDd07FckU+xpkXTBmaxoayKUqAzJOqhgykRFZIsO5c09VL9sm5EUF/8f2yQIqdk2c
	 NrI72hd5aeoEF7io/Xj7tCUUqJwtU8+c6cP9s17EDXMfDg5OsxjaNfas6VGat85Sbfmry
	 cQB7WYjOnnTKMMX2frHLge5Gw3Gm9Wrfyp3Wqa8sCNuPvK1hNZFqam+ADFFyoapgJ0OO+
	 7T2bUM6nnXR/gXZuHZU8JSvyS5E+6JF/056KV9YmE7Izc7BQn+rbvLcYzGGRf/Hu+wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mow7Vcte;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5DB606A31C;
	Wed, 18 Nov 2026 17:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mow7Vcte
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FB51F000C4;
	Wed, 18 Nov 2026 17:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024592;
	bh=6Tb3WWqS5M5GRuZYMAeP+qCFpxUXlPJbf69ENR+SmvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mow7VcteuN7rj8ZNfr1a+Ku5mLHRS1/QpJKxskz0hyVUyH9xdVS//XoOejf2wC11h
	 AQ6a/pE1TYoRp9Y4yruS92TSCugYc2s0MrR3sre/ySIb9j1DvRs546hpxthq1Lfp4i
	 +BKGfnClyqo87WrfNr7UbqJuq9cU0idFxOgpEtiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0739/2151] clk: qcom: gcc-qcs615: Fix GCC_CPUSS_GNOC_CBCR offset
Date: Wed, 18 Nov 2026 15:41:14 +0100
Message-ID: <20261118150148.952825277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 51ff9ffa18758c465a1a67ca36a78c2a8a5f3b2e ]

According to the documentation, the offset GCC_CPUSS_GNOC_CBCR is 0x48004.
Drop the extra zero, otherwise we land outside of regmap range.

Fixes: 39d6dcf67fe9 ("clk: qcom: gcc: Add support for QCS615 GCC clocks")
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260924-clk-qcom-gcc-qcs615-fix-cpuss-gnoc-offset-v2-1-67275f94aaec@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-qcs615.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-qcs615.c b/drivers/clk/qcom/gcc-qcs615.c
index 5b3b8dd4f114b..0f3c326e4769c 100644
--- a/drivers/clk/qcom/gcc-qcs615.c
+++ b/drivers/clk/qcom/gcc-qcs615.c
@@ -3000,7 +3000,7 @@ static int gcc_qcs615_probe(struct platform_device *pdev)
 	qcom_branch_set_clk_en(regmap, 0x71004); /* GCC_GPU_CFG_AHB_CLK */
 	qcom_branch_set_clk_en(regmap, 0xb004); /* GCC_VIDEO_AHB_CLK */
 	qcom_branch_set_clk_en(regmap, 0xb040); /* GCC_VIDEO_XO_CLK */
-	qcom_branch_set_clk_en(regmap, 0x480040); /* GCC_CPUSS_GNOC_CLK */
+	qcom_branch_set_clk_en(regmap, 0x48004); /* GCC_CPUSS_GNOC_CLK */
 
 	ret = qcom_cc_register_rcg_dfs(regmap, gcc_dfs_clocks,
 				       ARRAY_SIZE(gcc_dfs_clocks));
-- 
2.53.0



