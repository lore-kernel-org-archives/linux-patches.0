Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDD944376;
	Thu, 15 Aug 2024 13:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729517; cv=none; b=S/OdETjq31vwgm3WLioGb1mEo2jE2ddDkmOIXyxb4fM5l6c2BCSNfC9RG9N6s3Hf4xHyaLZ47kTril0qjv/RNMG1tm5l0GF/lHQ0c0b4xzpfN5KUErKGtuP8YZpeGvqkHAMOk53swNPecFXb/sEoLEdvGVAeJEZ6E7gxG4+u6JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729517; c=relaxed/simple;
	bh=el+J/50cEo01kdZnB2iK7tSX1hwBb0RdlZw/1QOlHZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3HLgdxVmuhyo9NZKG4xMnYYc7Bgw8ikrwlSazv2Va3Z11va/rVls4Gs3+9NblKdALWHHabrKj9HMX8rnelRPx94/CLbE1Ql7aGOcqECtwt+CPi9EvCEq8UYLb0o+kj7Xj6/gb/Cdkb3ElaBdsNFTBydqognWdeecKtV18Cw4T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HoVdBefK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoVdBefK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D92C32786;
	Thu, 15 Aug 2024 13:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729516;
	bh=el+J/50cEo01kdZnB2iK7tSX1hwBb0RdlZw/1QOlHZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoVdBefKL0igqJcvVhMfjpt9CgrUIEclOcK3n/GAC/O8RspOJFAlv5AmFd8YzOEUo
	 PlJCTn5iX1BgAFN+JqNZQfrLQIVLOXcKGiFWzRQiAFhkpDJ+BUNRv2zUTKBA08FWdg
	 ROoqn/JjoF5qBTEuEnl3zOYz14wm4SieSAQMKLxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/484] clk: qcom: gcc-sc7280: Update force mem core bit for UFS ICE clock
Date: Thu, 15 Aug 2024 15:19:40 +0200
Message-ID: <20240815131946.006542531@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d10efbf260b7a..76d5a9f49d8e6 100644
--- a/drivers/clk/qcom/gcc-sc7280.c
+++ b/drivers/clk/qcom/gcc-sc7280.c
@@ -3573,6 +3573,9 @@ static int gcc_sc7280_probe(struct platform_device *pdev)
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



