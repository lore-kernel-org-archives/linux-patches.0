Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036184;
	b=J5hEOnO0B+hklxvt6ZHPbCEA/nrc8lq4hdUsSPH3wE0RJ/BGG1H9f2lqCuxVb+5KZuoh
	 PNCDYa6i+DIU91k5n1u+ZFZQjUU0q/fqLQl4harHjc5NhaFhPID0hQqEMdBznM7uKGqSV
	 4A2ELnsn+bzfnemeKYosDyKFtnflkerzyQWY5ZLW/t++yXza36oaSs3XWfoy/B4tuOKmb
	 AbyWYwyPzL/dbWaDkB4w03LkFKviE85+pGWQvNElIOC0dw2URgRadIPKm7eKxhYkpkTbG
	 vDQI2XYz+09k9yVaCLEhhTXPoVAqgXJEZ1vC+uxLY1C7nNLMYXgjzdtFoy2U7ZWu8VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y58G7ETYamcuTJUarh+2EF4LhmeniR+ee23MgXppIXY=;
	b=276OhdzF45cCsL1VZP0Y03fsBni+FRfzGVsY/atjcmqOKm2iqPByWcN5owEyQQ9eiW3k
	 9G+80wr1CC2U94Ae3aGCLesCBSfXvl1bA0TiRL6cVS/ihr98vl3OEvm7LRkh313cGjXsz
	 tpOfxzOlJFzmi4PlW2XiNCFOAvxFfzTLrWJYIjZIfE4az5eifVpmCUfFmflmCES7NTEZY
	 BUuoDqMxk7JKsuO9UzyfsvWX6rKB95Tytw1yynxx8Q2ZnhRrLwEBAyPT/egbRNkOBZc5b
	 1JmB0GFbSGP2b6mQfnsgp2Imk56AnTp668yh/wudeQVjZAHbnwRfykYmzTTvWZPlIzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TGQxgByB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B06606A325;
	Wed, 18 Nov 2026 21:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TGQxgByB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2036A1F000CA;
	Wed, 18 Nov 2026 21:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036184;
	bh=Y58G7ETYamcuTJUarh+2EF4LhmeniR+ee23MgXppIXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TGQxgByBjy60DlAGp3R+EKSm3iD0NJLJWZaTFP9lsy/jxqHuwJH2w2MvGr0Th43xn
	 W1JgSqGPBpG8pXwkLIZ4TRvThrnD0+9Oksn/JZcrqe9sOJO42iHySdxwFSu67bKOkF
	 w+p4/hdqfy7DW475A8MnoLc41iTwjjpJMJLLg4oQ=
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
Subject: [PATCH 6.6 0926/3318] clk: qcom: gcc-ipq5018: mark gpll0_main clock as critical
Date: Wed, 18 Nov 2026 15:25:48 +0100
Message-ID: <20261118150347.320625936@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 292eaa154737f..6ab9c3f1f818a 100644
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



