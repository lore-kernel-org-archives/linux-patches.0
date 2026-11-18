Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026420;
	b=vWhBzNq5hc6uL6TrLy1DskK1f8bM/EoD7+qLldUov0DRf6M5Hosu/ur9I9x/zyfd8TQP
	 9gObAlT4ot3Q4kdbrvzCRd4n/hdXbczkAwZDziomVqjuzkrXkJ+jmP0Ez1QixED8TCVh6
	 YnxY2qmu/tf6sojjmtceUVYIZfChvM/JT0JQU8Lu41o5vGlDKM6SxRHQ+HcJlLGKGyVR2
	 MIMnxes2vWq530viofkkoRDeO+1fg8XQseRv8AQ+GTywekrQxOPAkScesom0Wrsk7Z3r2
	 c68iTbYFTFq6nGLvmxM+FTlqSubD/lXu0WSn2iEtFoWlundBLocH6sGZnuV5eP5+gDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zh500anFMlV6TOi+KvPOmQMfHRKyFW3fGN/910YM0gU=;
	b=3GRbztYlq9jBiVMlIg0QuGelkMWRSF+abCn1ip3frxHftRbzt8O5K495sUnDqo0NJ3He
	 v5K88VKUWVcAhTuGodKhUdaG66ShE6NJmk2KX7CHgUOhNaZ4+o5gaaDxf2E1tM8J2WNRS
	 rrQ/8l1mKXCWEtfUIkJpDH8shCvGQG+eAN3Xcc7YAe5scNHz6h4PLfeN4i21xR0hp4F4D
	 O3LU6VgyDDxYxHlxDFxV5WoKj13lL9te+YAeDj9DcfPNvl2VylfQ5tQ0vq/pq4+9La/CY
	 Q1iHAhqJorLjOM9mZp0tt6zE91NhCt62x4kXfXRWlguDZv1GwedJ9lW+JN26Ck5Gwaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XgqbQxa9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3ADB606A32F;
	Wed, 18 Nov 2026 18:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XgqbQxa9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE911F000C4;
	Wed, 18 Nov 2026 18:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026420;
	bh=zh500anFMlV6TOi+KvPOmQMfHRKyFW3fGN/910YM0gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XgqbQxa9gyDH0AwA6HyGqL55mA4PISNDglt38Z7MwAgBUU3S9t7SDbkfXx9hzQ4kN
	 hF/WuZ1LiXBL+pIZlE9/WuEEpbaLXFEfnF4BYC83v3nO40IpQUS+aJIbS8BF61Qc+H
	 q9KKacNgpwcpyIjh1795kMHGMMGWlrOSt6G1Kt6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1430/2151] clk: qcom: gcc-x1e80100: Dont poll the status bit of GCC_USB4_n_SYS_CLK
Date: Wed, 18 Nov 2026 15:52:45 +0100
Message-ID: <20261118150214.030538172@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit d42e0c55e6db7b8282e8dc63f7e70595da0f72f5 ]

These clocks are PHY-sourced and their halt bits seem not to update
reliably. Ignore it to prevent spurious warnings.

Fixes: 161b7c401f4b ("clk: qcom: Add Global Clock controller (GCC) driver for X1E80100")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-topic-hamoa_clk_usb4-v1-1-5d8d5225b598@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-x1e80100.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/gcc-x1e80100.c b/drivers/clk/qcom/gcc-x1e80100.c
index 104b1bf6a5010..827d6d52aa500 100644
--- a/drivers/clk/qcom/gcc-x1e80100.c
+++ b/drivers/clk/qcom/gcc-x1e80100.c
@@ -5464,7 +5464,7 @@ static struct clk_branch gcc_usb4_0_sb_if_clk = {
 
 static struct clk_branch gcc_usb4_0_sys_clk = {
 	.halt_reg = 0x9f054,
-	.halt_check = BRANCH_HALT,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x9f054,
 		.enable_mask = BIT(0),
@@ -5641,7 +5641,7 @@ static struct clk_branch gcc_usb4_1_sb_if_clk = {
 
 static struct clk_branch gcc_usb4_1_sys_clk = {
 	.halt_reg = 0x2b054,
-	.halt_check = BRANCH_HALT,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x2b054,
 		.enable_mask = BIT(0),
@@ -5818,7 +5818,7 @@ static struct clk_branch gcc_usb4_2_sb_if_clk = {
 
 static struct clk_branch gcc_usb4_2_sys_clk = {
 	.halt_reg = 0x11054,
-	.halt_check = BRANCH_HALT,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x11054,
 		.enable_mask = BIT(0),
-- 
2.53.0



