Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026426;
	b=dy45syubhNdJQSaP4ZM/M31FqqQrlQVrW5obAVl9OI+KgcDEiV+hQgo2Cfiy5ooIdgCe
	 nuKvtYgQ5Xk8cf4uyakEOTLb8rYM489ap0ElEG1DYPxeI/I7smtYzPkl+Kjc6LeUpHE8I
	 zIVPy85196XlWIRMlZPSIL8+mNCg8Hkv46h3ytO+k6j3D/i2s4ncMhZIbhLHPdXi9mwhM
	 V+42uMHDeioTc8qOBcazke81GIN5JRIdfuymlM6hs/msY9rfyR5dZ/YNcQ8yotaiN0xu2
	 7ucyzMaSe8umIsLCw3B+mrqyDvY8q7w72V4uvRytujY852cXj2quGmKv05hqS6HtvVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MyF3vdZ89Seq40QuJUnY5NyP+ytEkPofcy4gALz24s4=;
	b=CcARyCPwRvxM1stuPtdbHbiccGNY9W5aG4TgqN+axnA+QfYJr5Ob98jzvG4ZcRn25RA6
	 J53tvn2h97g/fP3cG7hclRE/0APlItmdexN/6KnW+nxiimUAyWuNwFDseI2vFljJdotcx
	 Vt2jdz2hJGUynbUaqpX5nu69s1yfst9la6oev2eY417Ucpdk6B3nOZ5xbPYKKZw0zMwbg
	 FtIUK93UsZkj8oC9sZRCPIkZYWK6R0FfXn+bIw37i3eq+znuBe3leaXjrz6cGYz7ptBbG
	 dt21V0xG+1bDOM0N84vcyyevmkxgrQY6tZHiA3Qtv10PVAR2VcN162okKBJqMKOJs1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x+Pv+udf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F55A606A32A;
	Wed, 18 Nov 2026 18:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x+Pv+udf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F121F000C4;
	Wed, 18 Nov 2026 18:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026426;
	bh=MyF3vdZ89Seq40QuJUnY5NyP+ytEkPofcy4gALz24s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+Pv+udf7pmYd+l9dMGxKX4MWKJt2xdKSFaFJdehAPN27c3Q0pwv4jKwsXV3v0gmW
	 5aUaKoFZSPlYcp440Rl6/F5IY0TcZxhd7SOGC0MR6xLwmR9tMa76fwkCILBHjTZnuh
	 1ypaV04gnW6H1XTr9/L7UcadUOJRjR/5oiHxpD9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1432/2151] clk: qcom: mmcc-msm8996: Fix FD AHB clock register offset
Date: Wed, 18 Nov 2026 15:52:47 +0100
Message-ID: <20261118150214.100159044@linuxfoundation.org>
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
index 7d67c6f73fe13..deb90fe5aa9f8 100644
--- a/drivers/clk/qcom/mmcc-msm8996.c
+++ b/drivers/clk/qcom/mmcc-msm8996.c
@@ -3134,9 +3134,9 @@ static struct clk_branch fd_core_uar_clk = {
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



