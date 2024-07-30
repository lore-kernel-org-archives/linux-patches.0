Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270451A6199;
	Tue, 30 Jul 2024 16:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356345; cv=none; b=UEvV/gPShqOXLp59w/WshEA4JA42ba3vyEVTFWa5kNPUbRzQAdG2hZEqt46wLCWhJ3T8Lmxc/eUEmlpAWLZRa0TkFhvzY25jE09SjOD83g9XquBusnVA7gUyGkRdyVgiFkNrw5nZIhlL0L9Ccmzkvz6E/aeQcXCbV/HhS5UJ1B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356345; c=relaxed/simple;
	bh=o6ORou4B3uCFKXnWqkvMpP2BsJdd4brHkjPagoQJdnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgfS6SsC+ABNYZhUbzC68uSpt6xGnT74cYTyskiqum4WBa9tzUH7m1GUzrKAESKr+pTwGhlCOd9wGlKSaKNOjBN/XRTE2tjn04OEuuF/rn7Q4bRm0/C631uiEcxcEWxKFrn/qu92MJ6WcSWLRhhVtpDnne17Jd1VU/p33JdOSwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jqk4s8yc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jqk4s8yc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817C9C32782;
	Tue, 30 Jul 2024 16:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356345;
	bh=o6ORou4B3uCFKXnWqkvMpP2BsJdd4brHkjPagoQJdnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jqk4s8ycC9nAkRtFsnGL/vPAfdKPn/ydFcxLD/kJ7U9ohesQCYfI1lkdCBdVDRcd3
	 hAozavyQ0YRcbdgwHq04drVzauNiTGQbte7BOFQzW0Kf04c1hjauwgMZYU3fJdhV/M
	 5vAqpHqkLmb1TbSez3y0tBcd5WlMpAQQZiWJoJUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 183/440] clk: qcom: gcc-sc7280: Update force mem core bit for UFS ICE clock
Date: Tue, 30 Jul 2024 17:46:56 +0200
Message-ID: <20240730151623.021664964@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit f38467b5a920be1473710428a93c4e54b6f8a0c1 ]

Update the force mem core bit for UFS ICE clock to force the core on signal
to remain active during halt state of the clk. When retention bit of the
clock is set the memories of the subsystem will retain the logic across
power states.

Fixes: a3cc092196ef ("clk: qcom: Add Global Clock controller (GCC) driver for SC7280")
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240531095142.9688-3-quic_tdas@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sc7280.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/qcom/gcc-sc7280.c b/drivers/clk/qcom/gcc-sc7280.c
index 46d41ebce2b08..2067e39840cb4 100644
--- a/drivers/clk/qcom/gcc-sc7280.c
+++ b/drivers/clk/qcom/gcc-sc7280.c
@@ -3469,6 +3469,9 @@ static int gcc_sc7280_probe(struct platform_device *pdev)
 	regmap_update_bits(regmap, 0x71004, BIT(0), BIT(0));
 	regmap_update_bits(regmap, 0x7100C, BIT(13), BIT(13));
 
+	/* FORCE_MEM_CORE_ON for ufs phy ice core clocks */
+	qcom_branch_set_force_mem_core(regmap, gcc_ufs_phy_ice_core_clk, true);
+
 	ret = qcom_cc_register_rcg_dfs(regmap, gcc_dfs_clocks,
 			ARRAY_SIZE(gcc_dfs_clocks));
 	if (ret)
-- 
2.43.0



