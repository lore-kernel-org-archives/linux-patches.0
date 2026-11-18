Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026423;
	b=rvoXojy4Gn+mV3cTs0w7JhWaesahrQuP9qK2CiLjOPQQ73fIXhX1NoRX+Qo7PnLEQjzz
	 X9JzKNz4fAjT9aie34y2UeYfrnl9OauwSy99Vk/5xGGpTTjkK9meH4iSG8TbAJfZ7h0bl
	 I+78DqmEVV5EEIjuWqKvpzSfYR3rHOM5pGBz/7TZ/K5DfsSDRxTYmpl+DL35IsG8cskPJ
	 J5CxW4zqgVOiACOCC9srE1hjfN2nFmcGnWeQR+A6xLFjkD/vfUhrPTOgHFMlldaljQeTa
	 mH0VnruQ9CrCoxZtR07SsF0+wi/xm5TM8xy8MLzoAyeII+y/AkB43Fr7zZRZHzNpnbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fAaQd2A1cps+HLJU1jIqR6ZunSIXZsujJ/Muan0hUac=;
	b=SlL2ec5kF0uMxko7h3PwIivyo/htz/0LCD6qYkYO8+IDw9eX3OstM5NRA576drT8WfsZ
	 psOQPWWaFC899J8dBnfP4AI3OiyHuPKD8M7Wr6me6n7mRKySsu1Dc7omg7Qln74vHauKS
	 6U6y2lt3AXGELGPItnTQQIdDnttpPrpE/kqo6ZN1Ika13O4hNVq50/zAOcO0FKYdDP0G7
	 l7QQWjvTaWgUzoOxxL3hPA4K6+gGzc6dTm0cNLmfVHMFo4g1E1feYu5g/hYXG1wTU8NEG
	 ijuXkkUFP5HCvmtTBmiLdGvA3HndkcgrhRztW2gJFxXi1py+l90yIw3OC9aHys8g+0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2weE6VgZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58DF606A325;
	Wed, 18 Nov 2026 18:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2weE6VgZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C921F000C5;
	Wed, 18 Nov 2026 18:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026423;
	bh=fAaQd2A1cps+HLJU1jIqR6ZunSIXZsujJ/Muan0hUac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2weE6VgZsYl52kHF7R3CM+8m5ACXpT01kf236Z8WmfpCu9U9oGw4uAAaaUyh5+B6n
	 x+r/eF25REYQ0KQUO+kAc35W6dS9WUy3yJjyHoJntD7huX2QZxUuiKKfiYJUtwLCct
	 gJ5nX+eGqXm845MCLf7ECj+1PEP2sVEnw9nafAoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1431/2151] clk: qcom: gcc-ipq5424: Fix TME reset register offsets
Date: Wed, 18 Nov 2026 15:52:46 +0100
Message-ID: <20261118150214.064080523@linuxfoundation.org>
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

[ Upstream commit 3732dccb8d75b2cddc8857f3944cb7482ef4b46a ]

The GCC_TME_BCR and GCC_TME_SEC_BUS_BCR offsets exceed the regmap maximum
of 0x3f024. Regmap therefore rejects accesses to both registers, leaving
the resets ineffective while the reset operations report success.

The offsets appear to contain typographical errors. Use 0x10000 for
GCC_TME_BCR, matching the offset used on IPQ9574 and the surrounding
register layout. Use 0x1a030 for GCC_TME_SEC_BUS_BCR, placing it in the
same register block as GCC_SEC_CTRL_BCR at 0x1a000.

Fixes: 21b5d5a4a311 ("clk: qcom: add Global Clock controller (GCC) driver for IPQ5424 SoC")
Assisted-by: LLM
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916-clk-qcom-gcc-ipq5424-fix-tme-bcrs-offsets-v1-1-0fa10674908a@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5424.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-ipq5424.c b/drivers/clk/qcom/gcc-ipq5424.c
index 71afa1b86b723..6f5c6caf4e411 100644
--- a/drivers/clk/qcom/gcc-ipq5424.c
+++ b/drivers/clk/qcom/gcc-ipq5424.c
@@ -2945,7 +2945,7 @@ static const struct qcom_reset_map gcc_ipq5424_resets[] = {
 	[GCC_QUPV3_SPI0_BCR] = { 0x04000, 0 },
 	[GCC_QUPV3_SPI1_BCR] = { 0x05000, 0 },
 	[GCC_IMEM_BCR] = { 0x0e000, 0 },
-	[GCC_TME_BCR] = { 0x100000, 0 },
+	[GCC_TME_BCR] = { 0x10000, 0 },
 	[GCC_DDRSS_BCR] = { 0x11000, 0 },
 	[GCC_PRNG_BCR] = { 0x13020, 0 },
 	[GCC_BOOT_ROM_BCR] = { 0x13028, 0 },
@@ -2956,7 +2956,7 @@ static const struct qcom_reset_map gcc_ipq5424_resets[] = {
 	[GCC_UNIPHY2_BCR] = { 0x17064, 0 },
 	[GCC_WCSS_BCR] = { 0x18004, 0 },
 	[GCC_SEC_CTRL_BCR] = { 0x1a000, 0 },
-	[GCC_TME_SEC_BUS_BCR] = { 0xa1030, 0 },
+	[GCC_TME_SEC_BUS_BCR] = { 0x1a030, 0 },
 	[GCC_ADSS_BCR] = { 0x1c000, 0 },
 	[GCC_LPASS_BCR] = { 0x27000, 0 },
 	[GCC_PCIE0_BCR] = { 0x28000, 0 },
-- 
2.53.0



