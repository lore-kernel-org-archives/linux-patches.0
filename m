Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056138;
	b=NCqmNQdlgffbnJXeJP6x2/xtZnx88pT9WpcGxT+Ll6IMyw2UFiadrZj+NEXmG00I7RO2
	 tbg8dcSVw99oFj88Btz2x+Ygi8wJXHh1o4XZV10VA9Huwted8xY6CfnIfYeIW/4TbHNcX
	 1QSTWhFnrgTEdBSJ0nutJ+S7LqoaMWYoeQnl8dJkdHI0I7AYF/5zYcdz+xwQD3EyaBFRx
	 cqnr1wmyETnznrIIG0hfvyJ2ixcOgcmljI7IVV3ODec1jS5ENN4ttBJ77ps49kP/lu/CE
	 x/i9MkxZCGM5a4PQrF7rA/k76c11+BYcDj0tlAcbGMNRYqTY01K7erhLTTdT0/r6dCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DxzB7Yev1BYWJAi6Kz/u1Oqsumunn+ORQjvNkJFX6Y4=;
	b=GGvBx8/UcfPYsY9LMq87lSjwYdPYGdbXAriMZz6lVPsGVmml+9F5KPByXM9wLrno4lun
	 bJTyiYgXh6D1WZGI9BRclVxMjsgUOFMlbv7g/F7jZvnyZ909o92ccXsem3Hen5CLH8hRB
	 aZU/qnsv1ZPE9mTt1Zdp0ZwTmpNhxQadqUr2neNsy/QAmQS1aaR9vI05Qv4uTs/Tcgwb7
	 YaJ/EUeJ8iB6iCQ+llqZqHQi5+fSu6QtQJ0fbcu9MJ193RvCWmDHKbTE3woss7N37frpI
	 8idGgsvBN5/WmjniJCvnua1zLmrN1NKoSwb4ntaWYCWh8Xf1ZyDsVMVAbXvr3UqUzbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r4Rp4GEW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D88A606A32F;
	Thu, 19 Nov 2026 02:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r4Rp4GEW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B5C1F000C5;
	Thu, 19 Nov 2026 02:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056138;
	bh=DxzB7Yev1BYWJAi6Kz/u1Oqsumunn+ORQjvNkJFX6Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r4Rp4GEWY6l9MtRSj5iDOa61OZoiNiiEhsDVls+zU6z66x6V4A8Xed6GHYWcnSvKz
	 6Mu0LxGRBehYjHnozd5rdqFHhT+OXdGb49yO1AzACxYvEvrWrWaOLA0cw2ub7twDij
	 S1OnJZ8RJ1uCQAc+GBOx/Ah4cT7aLp/XhACviwPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1881/2214] clk: qcom: mmcc-msm8996: Fix FD AHB clock register offset
Date: Wed, 18 Nov 2026 15:59:17 +0100
Message-ID: <20261118150126.500349006@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 24843e4f2599d..e78d61032a1dc 100644
--- a/drivers/clk/qcom/mmcc-msm8996.c
+++ b/drivers/clk/qcom/mmcc-msm8996.c
@@ -2883,9 +2883,9 @@ static struct clk_branch fd_core_uar_clk = {
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



