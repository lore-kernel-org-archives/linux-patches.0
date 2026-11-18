Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056141;
	b=Q/VMQscUxkFdc/mFBv1z8873/xatewv1p1sYgWWZbPD1qfUUeJf6/dCsCTAePvbD4B2S
	 P2t//8EVxLsOaQ8+8uNTMJD70otsEX8c/4EUFaiGiVXpFJLZcytKBNqRzlMTNYF9yvo9x
	 QD6cdepabH7Qwf6qpHXnmr8Sw/fOSqa+kuIBr1AbVPDLRZAeXJflWvZBlWZBx1aTMT4HE
	 yYRTWqGJFcy+bX/ex0He4GBNW5Kxa1f+ZTHlmGElAfbWnCXmWUGLnVmwGtHzlgt39gPps
	 XAhp6E/l9zFvdM2Z8lzPAHDQ6B8As5M7hRHEq2ihT+13S79mCxZC4HJ3TyezhLxFGmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H6I7YDcmjnyc4b/bn3JgQDqgpEStKfvYwBnV8erZMPE=;
	b=DbKs8xTe+jE7CNDeAc55F61VomdENbbJX42TMMDeECMAIq1JbPX+a/REmScEP2ZVSIwW
	 kT8CLbbjjVQttY7+DpAAZeDSjYgv0jim9WiENwF6912iF+xr+xFHdDSZiOMeOaDcAXVl6
	 hCJ5ah4XCKs7cTmaKyfH5Jizc5jx4jVC8zcxB0LyIKiULpHCg/JE8da86SKUB8AFUuWvc
	 W+O6gZe2xrtTXh/oh3lizfwEFnwnAHf17cbjHVLmorihBUuyHGQBxlOUvYL4rBGaBng70
	 xv9vdTH6tB5pFkeIR0Wjsh2tXSRwEGKo/l1+k1piYZ7KvG67TFk7nddViwqLalVP+RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JoiTgrc5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759F8606A31C;
	Thu, 19 Nov 2026 02:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JoiTgrc5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B141F000C4;
	Thu, 19 Nov 2026 02:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056141;
	bh=H6I7YDcmjnyc4b/bn3JgQDqgpEStKfvYwBnV8erZMPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JoiTgrc5PbIA7ql14yg+PvKGm790ZlOAc2Z4dbY9nNPYk6pGtdktT7cl/7qLRILUX
	 sii0rzdnqSND5EiSnVnELKTMWyesIE0JzudG8NVxHJGPFWJ+Oc8iJ8FPabzZbO01By
	 fRQr1PkCOZ3cFHGHr64apJQSTWR1J63F+JhPzIjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1882/2214] clk: qcom: mmcc-sdm660: Fix MDSS AHB clock HWCG register offset
Date: Wed, 18 Nov 2026 15:59:18 +0100
Message-ID: <20261118150126.533754770@linuxfoundation.org>
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
index 04e2b0801ee42..7a9d59727d3bc 100644
--- a/drivers/clk/qcom/mmcc-sdm660.c
+++ b/drivers/clk/qcom/mmcc-sdm660.c
@@ -2022,7 +2022,7 @@ static struct clk_branch csiphy_ahb2crif_clk = {
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



