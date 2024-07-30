Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5FE1A6192;
	Tue, 30 Jul 2024 16:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357428; cv=none; b=kxqSrzw1Yu7TQQb0ZpEB/6oQ8r+VHXjnr5DndOJU8NUNnjEsnD1cjN+L0dTBPaXc/hPrPjGZX9JYgUOW2HulExGk8kweHT28yK+o3NVe+3amK+R1aI4kir2spc/ThyqqqeGztr94yIuD9oq3MudhVAw0ucppRRAQ52pKIpvbXsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357428; c=relaxed/simple;
	bh=t7H2ZeY+NIoZjXWhU+A/NYuK67HPRLXDG8R4GJrlDO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVX5YpiL3NfTF1EaR0CEDSKvMNpxtC1nGBfBY4hO1jjDlQHMjiF+xnG6wvFeW5Rk0spaWDeZszmOt3boiAPaW1QwolN05EkVfR7ejeYG7UTISarC13x2K6C5g+jNL+UOwjfJwTq84O7exC6g0wHt7MrB96l/ymSdu04cNu7z4FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jn3Jv3W4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jn3Jv3W4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E372FC32782;
	Tue, 30 Jul 2024 16:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357428;
	bh=t7H2ZeY+NIoZjXWhU+A/NYuK67HPRLXDG8R4GJrlDO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jn3Jv3W4AVO7RDBQF59u88p6T4x9dVBDSfpMsmex88dWzvSmPAxuRcTfqnCRWWWPj
	 uav/V2oamJV7fbD4+5EvSdiOx/b2emkZVXHEZS+D0NDSvILPNKIvDZHsfvywQM9/1n
	 lTM31TScRsOqaLabVqfYKF5Plg639EGau0Yl4Y5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 254/568] clk: qcom: gcc-sc7280: Update force mem core bit for UFS ICE clock
Date: Tue, 30 Jul 2024 17:46:01 +0200
Message-ID: <20240730151649.808254560@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2b661df5de266..bc81026292fc9 100644
--- a/drivers/clk/qcom/gcc-sc7280.c
+++ b/drivers/clk/qcom/gcc-sc7280.c
@@ -3467,6 +3467,9 @@ static int gcc_sc7280_probe(struct platform_device *pdev)
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



