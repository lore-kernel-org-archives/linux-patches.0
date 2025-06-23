Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C0E4C62;
	Mon, 23 Jun 2025 21:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713575; cv=none; b=osmpynN3rtKD/wPAN2qHVKcthxyFUbA77zPHzuZlfw+7L8Yo6k3Uu0jeXZWB0Iq4eA/NVf3QToYaJ6mwmQMfBcUCvxwhEISH4ANHuPMOr6bd1foluGcWS+BiPwJyZKQT9Sq7vl3OvsY2UXkrPeNwbnbpQmxzmZGZVl5s6IO+Kj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713575; c=relaxed/simple;
	bh=E5ynI7/YTcVqjnsGpkvZwFumYYd3vW02uiAUs9pebyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNqmmJnJkuHPpvjsKWzloR382lHPFJzAIHYpfQP3AS7Rpqt7RCxRwh9q+ZUpOuoJFNMyyEVcAxLIA42WV3H94VK0OkX6+MVGccb6pTYiyRfLkjDxka6T+HU2ikx0+m4JA8D94A9OApjcLsaGAs+hRVFf+yehY209ZU+igSqTt/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYeLWlLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYeLWlLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9D1C4CEEA;
	Mon, 23 Jun 2025 21:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713575;
	bh=E5ynI7/YTcVqjnsGpkvZwFumYYd3vW02uiAUs9pebyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYeLWlLx6tAJ1kXeoJOg0R9uz3IAXwp2p3X6qny76qejvofq5RKqvhikyssKo7AMo
	 7TfgEysOJrQUt1RDmlm0PUbJ+FtXSuOLdpvdlILxt6CqETVSxeYjsz/9qPZxIbtYL6
	 ih2scXcjHoF0kVntvszjVSQRwClWDz9wd22XhkzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Imran Shaik <quic_imrashai@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 335/592] clk: qcom: gcc-x1e80100: Set FORCE MEM CORE for UFS clocks
Date: Mon, 23 Jun 2025 15:04:53 +0200
Message-ID: <20250623130708.422102902@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit 201bf08ba9e26eeb0a96ba3fd5c026f531b31aed ]

Update the force mem core bit for UFS ICE clock and UFS PHY AXI clock to
force the core on signal to remain active during halt state of the clk.
If force mem core bit of the clock is not set, the memories of the
subsystem will not retain the logic across power states. This is
required for the MCQ feature of UFS.

Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Reviewed-by: Imran Shaik <quic_imrashai@quicinc.com>
Link: https://lore.kernel.org/r/20250414-gcc_ufs_mem_core-v1-2-67b5529b9b5d@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-x1e80100.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clk/qcom/gcc-x1e80100.c b/drivers/clk/qcom/gcc-x1e80100.c
index 009f39139b644..3e44757e25d32 100644
--- a/drivers/clk/qcom/gcc-x1e80100.c
+++ b/drivers/clk/qcom/gcc-x1e80100.c
@@ -6753,6 +6753,10 @@ static int gcc_x1e80100_probe(struct platform_device *pdev)
 	/* Clear GDSC_SLEEP_ENA_VOTE to stop votes being auto-removed in sleep. */
 	regmap_write(regmap, 0x52224, 0x0);
 
+	/* FORCE_MEM_CORE_ON for ufs phy ice core and gcc ufs phy axi clocks  */
+	qcom_branch_set_force_mem_core(regmap, gcc_ufs_phy_ice_core_clk, true);
+	qcom_branch_set_force_mem_core(regmap, gcc_ufs_phy_axi_clk, true);
+
 	return qcom_cc_really_probe(&pdev->dev, &gcc_x1e80100_desc, regmap);
 }
 
-- 
2.39.5



