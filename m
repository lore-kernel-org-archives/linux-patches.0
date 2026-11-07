Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063327;
	b=reGhtouiggna/31qWc3Mne0eU3YXgW/1TJAY159ggotP4q/rNY5pXvybUBWqnXm7POXG
	 JUkgk8sJTsUKkefeKfo5MaZiZKJ5bYU6FeG46/OvyBzXXRbQsyh11USEJ/wdKgeMFGvxX
	 Niw2cKPspSyWHL2K6B41NgeacPyo0KwwqH8TLCYRrR6j5VZiPDy2bArqEaX/eqVy/Wmv1
	 8QEh74ZlfuDyqXB0YDQhBtLe0DgMoXxFdL/Jc197bN0guys1TDMkJCOI567pQcMSdXCXm
	 09/rAxmSbXE3hBisKFCL3uN2/f5MSEcEeqIVwX8zlVTsml+IpPAsD/1DzZcX2zaVo8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063327;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SN/491jxQ6PxBRrIdy357ci/BrzC75P4R6mUKTK3ms8=;
	b=eXYHEoeQNt88uvTPCw5KksbnMJdQSknC1cwAaaP/pbaPI7rfSbHc9d5pY+E6B7cCwnSz
	 YQQjWq1IuMwMH8MTsaSy4ESJwLGW+09GhG1sRIkZaNoDoibqR5MsBlVlDjVaHBWvKgGbs
	 e0lpaEJt5I7yCzhRMTeJIlje+zEdhDhvivDMWwguWNffRr2QZQlLZCTZb22OVlSEgdyNh
	 ulcuR9hXp1HPY8lq8LMi020Td2uTHf2fdmT3kT6lL6MKGVv0nx4TRGcuOGbi1tKgL0lIT
	 PBhagoClJZVkYCILzd4FJbE/mTquylCZK6Mdwmw7mtKyu1gtmsW/cIMj1X5B9tkBdvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x03IpBrG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896C4606D810;
	Sat,  7 Nov 2026 14:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x03IpBrG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FE91F008A1;
	Sat,  7 Nov 2026 14:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063327;
	bh=SN/491jxQ6PxBRrIdy357ci/BrzC75P4R6mUKTK3ms8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x03IpBrGpjYaY7vqBdgO5IsPkhUo3RumBanSk5EO6EsHNGN3+z8hVoZ8oz1Fmvhrj
	 2UMa9KrIlxbskTZYbmeZgkuRo2ACBExb+PUsIU4mJAI+lVlECdcTlo2PiCszCE4q5p
	 4n7aojOSdRmlKc/f5JEELqpIVhD3Z8PMpxl1nH1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Luo Jie <jie.luo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 511/869] clk: qcom: ipq-cmn-pll: Assign .num before accessing .hws
Date: Sat,  7 Nov 2026 08:53:13 -0500
Message-ID: <20261107134910.900208286@linuxfoundation.org>
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

From: Aamir Ahmed <elb12345@hotmail.co.uk>

[ Upstream commit 231bbd135772390522be3656b34b49ea3039eccf ]

hw_data->hws[] is annotated with __counted_by(num), so hw_data->num
must hold the element count before the array is accessed.
ipq_cmn_pll_register_clks() assigns it only after storing the fixed
rate output clocks and the CMN PLL, and the unwind loop under
unregister_fixed_clk reads .hws[] with .num still zero. Both are
out-of-bounds accesses under CONFIG_UBSAN_BOUNDS.

Move the assignment to right after the allocation.

Fixes: f81715a4c87c ("clk: qcom: Add CMN PLL clock controller driver for IPQ SoC")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Reviewed-by: Luo Jie <jie.luo@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/AS8P251MB000187BDFAD98A21F4C356E9C8BD2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/ipq-cmn-pll.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/ipq-cmn-pll.c b/drivers/clk/qcom/ipq-cmn-pll.c
index 369798d1ce427..e01c8ccf17311 100644
--- a/drivers/clk/qcom/ipq-cmn-pll.c
+++ b/drivers/clk/qcom/ipq-cmn-pll.c
@@ -351,6 +351,8 @@ static int ipq_cmn_pll_register_clks(struct platform_device *pdev)
 	if (!hw_data)
 		return -ENOMEM;
 
+	hw_data->num = num_clks + 1;
+
 	/*
 	 * Register the CMN PLL clock, which is the parent clock of
 	 * the fixed rate output clocks.
@@ -377,7 +379,6 @@ static int ipq_cmn_pll_register_clks(struct platform_device *pdev)
 	 * is configured to 12 GHZ by DT property assigned-clock-rates-u64.
 	 */
 	hw_data->hws[CMN_PLL_CLK] = cmn_pll_hw;
-	hw_data->num = num_clks + 1;
 
 	ret = devm_of_clk_add_hw_provider(dev, of_clk_hw_onecell_get, hw_data);
 	if (ret)
-- 
2.53.0



