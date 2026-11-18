Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019877;
	b=0IlpEvOKjGXIwph/2e3LWvk0F48ceo/1zglxOL1WJ6b2TnZgG9MNO9phD65vYYMNZVXZ
	 iidyI6s/nHReywODZg3sv9h7ECCVaBZP8QdS1qosn6cMpJIT/ti7vCtryHpczc6lqazXm
	 FJn3fWd8KFQAihMr/DyYj4xTz7SaWwiH7pS53AFU9unzAKp/NMASZHJwbE++N9NYwHksz
	 R7Ohrj0nbu7FGvEJ9e066IK3z7HL4HHayYXhsbClmswIwhXkkyIPm/VCfhmbt97ollU0E
	 47LacxVq5VtTZ6tkpy4zDVJ81K/YKtw6GrIZ988cOp9DYHkT034ZDXZdauWtfE7hoOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HnB+GxwraPOZBSBFmqjnbShOJ1LGPY10AvXPP+8NuPU=;
	b=OkFhnwjL7A9MlH6vZTg9rKFn5qTMjVG7j3PZguY+Sg+E5YGWO957aCOIFh4la3ypkU+c
	 Kj6HNQ+X64Wtw91qb7Wvoc7RZZRQqZkNupAK69aGVB0g5Vywrqc7l449XtohIHr/Tzcwo
	 KgBt+eZBm/dFI94rMLVBuOd48C2H0gCxNOSiTjKQYjSnkqHY8iNfF363WU0izNmSPIPmb
	 mHEgAzGZawKp3e/30ccxp8CcI2PHtLUxY4ZgXsNpbUTh1CQ0WznwIQVlGy20OYKA80QwQ
	 qFCmYOoEIgeMZynhq/YT4T6pXNoVwhoM+X0if5bLHTQzpuIZPMH3+ko/nKpIdfJMPAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pz6sHB3W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8DA606A331;
	Wed, 18 Nov 2026 16:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pz6sHB3W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152DA1F000C4;
	Wed, 18 Nov 2026 16:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019876;
	bh=HnB+GxwraPOZBSBFmqjnbShOJ1LGPY10AvXPP+8NuPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pz6sHB3WATK4IT66eshfvDtVG5TtDg65hVaBYMBqycOgAmZ5rNm348fNx7oDze6Ac
	 xhaTHav3LbXI4rh5+VIwJuFrW37u/G1mqwq7nXsleQ/TEOlGHTkS4Kv19blB1MHJNZ
	 GnCpqNUSil8IAC39nPztkh7kqukY4mUqEZh9fJh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1745/2651] clk: qcom: gcc-x1e80100: Dont poll the status bit of GCC_USB4_n_SYS_CLK
Date: Wed, 18 Nov 2026 15:49:45 +0100
Message-ID: <20261118150350.363067194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 8c146d62c0779..754d1e03c2fac 100644
--- a/drivers/clk/qcom/gcc-x1e80100.c
+++ b/drivers/clk/qcom/gcc-x1e80100.c
@@ -6049,7 +6049,7 @@ static struct clk_branch gcc_usb4_0_sb_if_clk = {
 
 static struct clk_branch gcc_usb4_0_sys_clk = {
 	.halt_reg = 0x9f054,
-	.halt_check = BRANCH_HALT,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x9f054,
 		.enable_mask = BIT(0),
@@ -6266,7 +6266,7 @@ static struct clk_branch gcc_usb4_1_sb_if_clk = {
 
 static struct clk_branch gcc_usb4_1_sys_clk = {
 	.halt_reg = 0x2b054,
-	.halt_check = BRANCH_HALT,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x2b054,
 		.enable_mask = BIT(0),
@@ -6483,7 +6483,7 @@ static struct clk_branch gcc_usb4_2_sb_if_clk = {
 
 static struct clk_branch gcc_usb4_2_sys_clk = {
 	.halt_reg = 0x11054,
-	.halt_check = BRANCH_HALT,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x11054,
 		.enable_mask = BIT(0),
-- 
2.53.0



