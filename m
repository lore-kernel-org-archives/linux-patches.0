Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A842F156F30;
	Tue, 30 Jul 2024 17:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358878; cv=none; b=uCqLknlVOUqoAq+CKOgONHx8wWXvkWuIQ4w8ykIADwg9zOzfJ8ItTYoCovzhmyxPNEqfNjD+p/B/EgQ2KBX562eBOEac7YN8N7EJmVNXHUPMPMCJE7osp8XAkV3o8RIisT5ntiRs9OS6M0RbwT3szkUkoh2hiJnlN8+GEY4Xu5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358878; c=relaxed/simple;
	bh=JeAJm6fMixA7OL6vNe8JUIWlG2WgBijHAcwhTjLBsIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYg/uj+x+bZzkjdLW9aIeEDnP7hR0gAb5q7H7dIdY4uufT+2AOn99y7Vf/eUhqEgs2geFfsorrQ5NFfDvivoAXGF9b09WCIk0JEWGjPVrWaZCy0Rtqzq4W5Ol2+TgCVI8IDHK0C+2RcgG5txnvzP1PfosoSPPtNzrWGIE829Cmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qstPT9XZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qstPT9XZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A57FC32782;
	Tue, 30 Jul 2024 17:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358878;
	bh=JeAJm6fMixA7OL6vNe8JUIWlG2WgBijHAcwhTjLBsIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qstPT9XZGeAxlKoX6huTkEARzLBDgTuOzIEoPFdgJ1pzARbhlJJ5JT/tA0LQcodxT
	 ncS+V3EfjLLh3wqrYbwnSQeyVPXLfvPtkXS9ldqm9nUhIiTg/ke8eoCj0jfb3pDEiO
	 /60U2242tKpm86JkdH3f0yfpIXzpB8WwMXhUfsEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 392/809] clk: qcom: gcc-sc7280: Update force mem core bit for UFS ICE clock
Date: Tue, 30 Jul 2024 17:44:28 +0200
Message-ID: <20240730151740.163643738@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index f45a8318900c5..67ea9cf5303fa 100644
--- a/drivers/clk/qcom/gcc-sc7280.c
+++ b/drivers/clk/qcom/gcc-sc7280.c
@@ -3463,6 +3463,9 @@ static int gcc_sc7280_probe(struct platform_device *pdev)
 	qcom_branch_set_clk_en(regmap, 0x71004);/* GCC_GPU_CFG_AHB_CLK */
 	regmap_update_bits(regmap, 0x7100C, BIT(13), BIT(13));
 
+	/* FORCE_MEM_CORE_ON for ufs phy ice core clocks */
+	qcom_branch_set_force_mem_core(regmap, gcc_ufs_phy_ice_core_clk, true);
+
 	ret = qcom_cc_register_rcg_dfs(regmap, gcc_dfs_clocks,
 			ARRAY_SIZE(gcc_dfs_clocks));
 	if (ret)
-- 
2.43.0



