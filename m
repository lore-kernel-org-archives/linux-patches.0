Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031666;
	b=2IUSEvmcGdFX/N5Fa8GX1DPI38+cJRDYWXnWjTziqXDp7W+crXmoIgilj46uUXSXaAVi
	 Iu3SfKzZo9ajJd6tUc+IZZC8BzlazJ1J8/b+C5Mja4bwqZU/umnzueJzbdme9Yu0uoixQ
	 d+oYGRuK8s544HLxOjM3FnCBmasLhMW40jtrpq7qI8RJ5sU9KZAsp50/7W843NKluYuxA
	 /TY7FjP9u7ZlkhIHOalToAIBMP4apN6C89rMn8UBH+2YJq+smcZ4BgLqX+2Bo+Vb9clzn
	 l2Wn1wGg2vc8HU1W7hc9LOjUfuQym3G1QF52SsA+aMFDD32vr0KxlAQUh7LuH6fOZEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4L5Jd025/Cp9HuGU4ARk4NbXhYWtHASOVs1c/fkXn80=;
	b=ISsz7sZF0Hui85G3yme370rsjzqhNhYIswi3Bxw4w6GKrxCdKYajBv63ZFChOqCPR64m
	 ibpWUpyJxnkILasHlLPFVqWq2I8SnGJkszcq++IX9pZA6KiuRtafEDuG31CUu63sfU4MK
	 64yt3XHUqWyRZylo+KNvhbBjR7CrPoVDUGmi++GGfJsHbt6FN4bEKxK9OvVmiegW1i4xD
	 YZkcxIlLANKfy8XuwMeP6n2l4c8ns/lyGYaSKYNGCpbwvMvVOr2aHOS7ja3WNk4T6lP+W
	 x2HCphuNCAZLXCtVitijtgEXz4EWGf4D2fVC7C0Ng8koxn1r1Ni2kvJXPG2V8mDdUzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TxSKJVDt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CAE606A325;
	Wed, 18 Nov 2026 19:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TxSKJVDt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F2C1F000C4;
	Wed, 18 Nov 2026 19:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031666;
	bh=4L5Jd025/Cp9HuGU4ARk4NbXhYWtHASOVs1c/fkXn80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TxSKJVDtHvpmHnDp+YB6ZoAQBETfU/p7u7ijiQV43IGBV8Y6R2tEAkJIW0uNxI+xB
	 ba0HpnV+dXSPaf6DDpnyoiGhaxXwdjhbNe3hp/BQSfdEcfGszBh+gaQ9NWPvZiy/Xa
	 pCJIs0Ix41KzF0lT2cLO0AF4thDn4tyFz9m+Qz4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1137/1756] clk: qcom: mmcc-sdm660: Fix MDSS AHB clock HWCG register offset
Date: Wed, 18 Nov 2026 15:54:24 +0100
Message-ID: <20261118150055.319259726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b9f02d91004e8..889cee2090a1f 100644
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



