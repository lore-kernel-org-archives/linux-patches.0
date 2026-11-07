Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064128;
	b=lb1DddE0cRWAT5X0ixzp6vE7KNl3f79RvQkRDi3iXKHYNYflxq/npPYfx5ogLxv9j8o5
	 LNJp/uzPudCS/mye8yYRsjakzbw2bPY4XtuHOwnIJMAFdf6WIAPf4driozWdxlab702jK
	 Nc9jbH4woZ4/M6XgOsTuFovTZ48yxTvg/Gyk0XwPkmKMyrUgj+3zKlfnWzovghKWpvZmt
	 ImmsoXu8orAEYr+M+y6Oy6z081AQClWa6puHvFlsEL/0TtgSK4RzXqMk8hCnmH0NxiYwY
	 M7EmuzSgMmBcC2sYPecMe3m5eSa4ThePKoOC+ui18I2YRp527oe1dEVnswRgQMhsJ9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3zStns22S6JzQBhfdK2t6ySUV/TO61Upvj9/cTXtgdo=;
	b=yn1xZrRmjwKGKLM2Jkc9xg7YsKu6Efs52R4jUDsaWHD4DUWztEgW82y2p/XxxHvOJzwK
	 PD/1WB/EroPMrvxl4evGnuObCTacXCHTMp5LGIV5q5v3V7JbrLo5Y3nSuxExMZxdimCzZ
	 tadeHhwQ1K9zN3QTKQERpNX4NepTXbL6zmNEQrPwEjJR5uc80DMEL45LHJyn8zZzu90MG
	 9xHrTx20DnRYWNfG0/hr+xLF09HYwzsB4z4aFFjr1S55sQXVrd3nRFnuS3A9bi6RT/vZJ
	 2tv+CXd+FqR9BOFzHYB4T+krYm/ra8Wreinbz21IS+bGo1NoQDuy6icYMhl9t4PCtnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JDs4RSat;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68CF606B88B;
	Sat,  7 Nov 2026 15:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JDs4RSat
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5598B1F0089F;
	Sat,  7 Nov 2026 15:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064127;
	bh=3zStns22S6JzQBhfdK2t6ySUV/TO61Upvj9/cTXtgdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JDs4RSat0YqVCPM5CQwB7BGrCoQQh2k8hKo/LqsqHgnF38JwzrQYe0odONZq+b9Gv
	 Th+Zh1lwkTDYA/PFFzNYkRwb57IBCx54H/hx2/Asms3cbhvHwwwgIOacwRCg3RWN+s
	 zdg/hBj0BzyLyFPAkqpu4O8/UExQjvmn4OQEN9Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Stanislaw Pal <kuncy7@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0280/1257] clk: qcom: gcc-ipq5018: mark gpll0_main clock as critical
Date: Sat,  7 Nov 2026 08:42:56 -0500
Message-ID: <20261107134947.208209941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 33f9cb56cc28d002511e471be74f8ff241984178 ]

On IPQ5018, the APCS core clock feeds the CPUs. It can use
different clocks as its parent, but during system boot it
utilizes GPLL0.

Under some cicumstances, the 'gpll0_main' clock is getting
disabled during kernel start which results in a system hang
then the hardware watchdog restarts the board after a while.

This can happen when a driver gets a clock in its probe function,
then releases it either directly or by devres cleanup on probe
failure.

For example, since v6.18 the kernel often fails to boot on the
TP-Link Archer AX55 v1 board by using the in-tree dts. In the
failing configuration, the 'ipq-cmn-pll' driver is built into
the kernel and the problem is caused by the pm_runtim_put()
call in the ipq_cmn_pll_clk_probe() function. Due to this call,
runtime pm disables the 'gcc_cmn_blk_ahb_clk' clock asynchronously
which results in disabling 'gpll0_main' as well.

Mark the clock as critical in order to avoid such hangs.

Cc: stable@vger.kernel.org
Fixes: e3fdbef1bab8 ("clk: qcom: Add Global Clock controller (GCC) driver for IPQ5018")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Mieczyslaw Nalewaj <namiltd@yahoo.com>
Tested-by: Stanislaw Pal <kuncy7@gmail.com>
Link: https://lore.kernel.org/r/20260918-ipq5018-mark-gpll0_main-critical-v1-1-fbe8f27a0106@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5018.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/clk/qcom/gcc-ipq5018.c b/drivers/clk/qcom/gcc-ipq5018.c
index 594dae3bac4c1..46da652956fb0 100644
--- a/drivers/clk/qcom/gcc-ipq5018.c
+++ b/drivers/clk/qcom/gcc-ipq5018.c
@@ -68,6 +68,15 @@ static struct clk_alpha_pll gpll0_main = {
 			.parent_data = gcc_xo_data,
 			.num_parents = ARRAY_SIZE(gcc_xo_data),
 			.ops = &clk_alpha_pll_stromer_ops,
+			/*
+			 * During system boot, this PLL feeds the CPUs.
+			 * Mark it as critical to ensure that CCF does
+			 * not disable it, even if there are no active
+			 * consumers. This is needed to avoid a system
+			 * hang caused by turning off the clock driving
+			 * the CPUs.
+			 */
+			.flags = CLK_IS_CRITICAL,
 		},
 	},
 };
-- 
2.53.0



