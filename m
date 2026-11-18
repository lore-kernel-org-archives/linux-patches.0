Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026438;
	b=sbd0gZuwCeoL+jJM1zbhb/dSc9v/x2bvm3KfvhimKP6os5fJ3XBEsyNI7YXsayqLvkGS
	 gbm84jRQoONmuYKjkhSiwtTlnyUn0PTvT0Sh8KsmCKMhhReKbtMHL2yuSHePwcV1PixXj
	 Z4wIAbOK3fx4DrHQsy2sj5EukwbSUCd7PWLinntHoQ/ZCdK6srqX6w44JUnRz9Sg2fZUo
	 EmE0424Z40uSpv/SfgZyETJtOaCkjG/auPatYc6BisvgaK8Zz23/Qmmf/BUBrZ+UWyoBU
	 YQnIUBnhm/8ImW7VOLOvT8EMLY9KZnCl2ksF/fvh6KI+C1DESiCR5zvCLe+2PcvMaTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/xJR7jXlScfh1Zf4y8KEOoR0UoOjMrwsMbMXKlaZyb8=;
	b=LqLraV+GDhXNpa3CQCgwT8b5mv5D6Zo+jy231gRWua0TWHlfUtcCwYpPQl/tZ5meJhza
	 L9ahPciB/Q78qBzJNQFzT7+C1cUqCnsMQbkVA83xhhJqlUKsZVIdWfglcWujJic9aS56A
	 6ReIq+1X5WXvGzc7WjfD9XlGcM78djYUa5QeVDrOqkj69gPeiqYYPVIfLdkcGQ4oRDQtn
	 yAZgIsBfI67M4dKrh4LJ9RHzMcHIbMizik4pfCW/MXahXcV3CJ18771uEEK7mzx+jEf6g
	 /Xp4s65a6BecIuMxG4rF7rdJddJSxg9Jh/bqdUElwBrz/6i/mKitLJg/xemW7VVIaHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GJ7c3W0H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8B4606A32A;
	Wed, 18 Nov 2026 18:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GJ7c3W0H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478A21F000C4;
	Wed, 18 Nov 2026 18:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026437;
	bh=/xJR7jXlScfh1Zf4y8KEOoR0UoOjMrwsMbMXKlaZyb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJ7c3W0H7x45URBORs5lhGrm8zuGQJRJ3bO4DWSqBiQvsrC2RkseKtP2CXX1Voc5E
	 vx9JCe+VJ6nmPdPg6S5lQsk0eMkXkN7kE4TTKoboUqlzDsdLduM+MuZ2/NV+6S0Sfj
	 UfkRlJX5S1X/nxru2Ex9MQHEMh/fA7VK8VNC7XUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1436/2151] clk: qcom: rcg2: Propagate force-enable status errors
Date: Wed, 18 Nov 2026 15:52:51 +0100
Message-ID: <20261118150214.249179727@linuxfoundation.org>
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

[ Upstream commit 8c0f93e10fa9e34009817bd37bb75c1b5a691fa2 ]

clk_rcg2_is_enabled() returns either a hardware status or a negative
regmap error. The force-enable polling loop treats every nonzero return as
an enabled clock, so a failed status read is incorrectly reported as
success and clock reconfiguration can continue with unknown hardware
state.

Check for negative returns before testing the enabled status and propagate
the read error to the caller.

Fixes: 7ef6f11887bd ("clk: qcom: Configure the RCGs to a safe source as needed")
Assisted-by: LLM
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260917-topic-qc_clk_fixes-v1-2-5531cb00514b@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rcg2.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index b6e30985deab6..a7d4dfc107e53 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -1330,7 +1330,10 @@ static int clk_rcg2_set_force_enable(struct clk_hw *hw)
 
 	/* wait for RCG to turn ON */
 	for (count = 500; count > 0; count--) {
-		if (clk_rcg2_is_enabled(hw))
+		ret = clk_rcg2_is_enabled(hw);
+		if (ret < 0)
+			return ret;
+		if (ret)
 			return 0;
 
 		udelay(1);
-- 
2.53.0



