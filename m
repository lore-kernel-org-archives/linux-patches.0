Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019970;
	b=M0bCScISOS+uQ3LvU0qyUAb0GCxu/x47FCtSn8dkDASrgMQjo1zAeoG/LjSOM8XNqz1h
	 0RFVO5yx51fVKMM3d/2uncCrlWhvgzReKYtUPZbJt28epTr0ss3GY2vugARDOty/fc5jp
	 sSgoyKttbFy8i1IWNyhvrK6mKSjYn5uGfABDmBEfSPC8WIqcu3qcwIBUbkIyTwOzg2p7h
	 /e68g/PRn2OyOBpjbt3+rGS9L/0JbASYYfvpgrO4s2B4SnH6g1Yt5q+O/3z4JlCz6//wN
	 O7aJVIV31xr1Ui157gWBraB7DSWbxEUOB7F+dApj5vqqNfqiOORDpk2s2+jgmTnDfLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xc9eTAW3UF+F4XkHEmJjLHlrOWADAuEA8mj9oQ9EVXw=;
	b=gsargWPZShyJXQX0jiO6thnT1M5fhgppn7tgez4Ek/YAbcxdqYoVBisMh5DreqJSQU/N
	 YlwHMwlGGi3+Jp/woSmrrm0Et2dyOtH1XmsA0uFA+wnjtA+hDWUqm+2Msz6mrRdIsmpGx
	 wS8r4ncuCzidDoJGzmWr7vjEPQWmLX5f6IVh5AnneYRCpPROG02VoO7zntzOCFptmubUi
	 wm1j1F3KXBDZtGetvY+rb03nWN9kLmP61WiJu9i8oytrb9VFEDRj2v6Y6h7MzMntopXaY
	 +llBnRaMHtxSvPGxOSHwP432bo9dex85ibyelfMTuMhtDcN53+MhA5JL8eFWjAsBT2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnO7cmdx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A288C606A31C;
	Wed, 18 Nov 2026 16:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnO7cmdx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17961F000C4;
	Wed, 18 Nov 2026 16:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019970;
	bh=Xc9eTAW3UF+F4XkHEmJjLHlrOWADAuEA8mj9oQ9EVXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lnO7cmdxuQ9z3MUZxBE3kI2poxX9wyv6g9LBOSV1fWtoKI+wKIgXNz4OFA48HpetL
	 v9GUvqv3rLm5kFKgvMUhmlkB1fq30CWQqlfiOJiapr8OxYEgZ9xMwFnbttoZsEVTi+
	 L9RSDwRwKBIY3Po+xWRjpyoqYHIQO5IwyXDrGTlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1748/2651] clk: qcom: mmcc-sdm660: Fix MDSS AHB clock HWCG register offset
Date: Wed, 18 Nov 2026 15:49:48 +0100
Message-ID: <20261118150350.453044255@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit c5f338329a2d0d60f7874aa7a1addaa0e4e75a3b ]

The MDSS AHB clock HWCG bit resides in the same register as the branch
enable and halt status bits, at offset 0x2308. The current HWCG register
offset of 0x8a004 exceeds the regmap maximum of 0x40000, so regmap rejects
the read in clk_branch_in_hwcg_mode(). Since the read error is ignored,
the helper uses an uninitialized value to decide whether to skip the
halt status check.

Correct the HWCG register offset so the helper reads the actual hardware
clock gating state.

Fixes: 5db3ae8b33de ("clk: qcom: Add SDM660 Multimedia Clock Controller (MMCC) driver")
Assisted-by: LLM
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916-clk-qcom-mmcc-sdm660-fix-mdss-ahb-hwcg-offset-v1-1-30dcf09d907c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/mmcc-sdm660.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/mmcc-sdm660.c b/drivers/clk/qcom/mmcc-sdm660.c
index 200f986de9651..9f8b8e29fa0f3 100644
--- a/drivers/clk/qcom/mmcc-sdm660.c
+++ b/drivers/clk/qcom/mmcc-sdm660.c
@@ -2017,7 +2017,7 @@ static struct clk_branch csiphy_ahb2crif_clk = {
 static struct clk_branch mdss_ahb_clk = {
 	.halt_reg = 0x2308,
 	.halt_check = BRANCH_HALT,
-	.hwcg_reg = 0x8a004,
+	.hwcg_reg = 0x2308,
 	.hwcg_bit = 1,
 	.clkr = {
 		.enable_reg = 0x2308,
-- 
2.53.0



