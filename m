Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062966;
	b=RxTskI+LTdZdGl+xln0UUqysqYAEUDLpsVQk5aTkw/my/T4LIcsLya7O9S/WGgxM/0Jy
	 pBccWJbDI9S7cCjOO1LepYFfU/oAmExIGuR04Gln9VPmA0hTR0s/73jJKgMyok78vuCuh
	 LTqPqhIhsAEDlh9wGDgpLXVSNfLutw0mRcDwAWXs4P0+Yje6R1+HTNCKMNE90yL7s4ECz
	 aaPkb1ATps6v8rnnRgx8hluIa0VO83RiNvAcIkoqUasEFrkV6Ue9EjaQ9+fvcHLDljZ9A
	 alVtp4UNamzMZbKk5JkI0YeM1o6Vnu4iKPRJQknn23FqGAOJQ/F2hn3rcVOQV+1x7Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062966;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SfmRZJFaclQHblRCmt5QqeDewN0Q7VhunNZQzsTVmnc=;
	b=MzFgIvy/PjuSH1i8cpJDqRKCeh1P9+J9KPMjG5gou5VlIs8c3uf3tl+wCtrHlYLmclN5
	 TqEkb0sLTqOwTQFUmdvD2Syq232FMCkFkBzBz5sRSXtGeQ/kPfc946X05yWGgYwk/AbkN
	 zBy5Fg6BpTYemrSy88ei8Kadk4MC/Q329vaPTqDhmPGZrnFb4XkgbFIV/Xsr9DnUUc7w1
	 3k6EJ9zcS2bvkQ/DHYdqMFKXebGGOvJNQ4yjG54xyHUwSBzsDUEV3TL3N8g9BNlzd60sb
	 RU0mm5sEMnlCrCpI9PxWMqBcZjIH8fl78X17MJ3z+WUyL3LmpVAjstFrEc25QNo3o9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BUjpAH7s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C966D606A330;
	Sat,  7 Nov 2026 14:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BUjpAH7s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7440E1F0089F;
	Sat,  7 Nov 2026 14:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062965;
	bh=SfmRZJFaclQHblRCmt5QqeDewN0Q7VhunNZQzsTVmnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUjpAH7shgBXIRPi7THr+CMnzTrCjwlh2WJXldj1cEwwojJ1b7NnO6MISfOzkxYjz
	 1EZC2jCldSgaZ8IEf8kIQ3DmgZWYrvDcz9ox0+Nd39PE9ZD7rVtcbHTWRc2cn1Fw8H
	 BkJu0EGcIWdOVLj86Eyxay3h4Tj/TElr5fjpCDuE=
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
Subject: [PATCH 6.18 226/869] clk: qcom: gcc-ipq5018: mark gpll0_main clock as critical
Date: Sat,  7 Nov 2026 08:48:28 -0500
Message-ID: <20261107134859.535771699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 64792cda06202..e2d01cdc39c96 100644
--- a/drivers/clk/qcom/gcc-ipq5018.c
+++ b/drivers/clk/qcom/gcc-ipq5018.c
@@ -69,6 +69,15 @@ static struct clk_alpha_pll gpll0_main = {
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



