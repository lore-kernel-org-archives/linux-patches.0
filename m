Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E83B19049B;
	Mon, 23 Jun 2025 21:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715504; cv=none; b=Zfcym3Ck0lbAVgLY967XC38ZCkf6fgJ4ik5m2DDJaj9T8yYpRLfvRRUea5fqD/qUsFY0dCE6sNkAB59V9ZqykaAA8jNRM8HDohKEHU0tHrbFwP4lx3AVBuybZhV66CIzGE/Hb0h2F9FCqITmChtGXh3eH24p/N4DI27ITNqK9ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715504; c=relaxed/simple;
	bh=wMkvFMrWauqMirl0oE3OCBorj/1NVQ20v6++lNcGD1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3kq7022oyAlAPg5ILRrYFrbCQ/C+qwtcRM2Lc5pKfigqGbd6oDWQXT3Hl66eCBvGcq05Y4N/CFTVqwkNoJ+hJTvEUWRxn1jtTddH6f4r5afsCZiOlwhFiwqHjOZrMvaqWmgA0iRbLwAv0vKOM4K5AfTGgPKg+N1AaMJY5npF1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFOLd3Hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFOLd3Hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA209C4CEEA;
	Mon, 23 Jun 2025 21:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715504;
	bh=wMkvFMrWauqMirl0oE3OCBorj/1NVQ20v6++lNcGD1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yFOLd3Hv7WYpnFIY6xR6DXO13JvhN4hHQ7pdiKD3l7zrqwZLTSf2/mT/8vUtK4NZ2
	 c40ar1GmmMbTsvhtzBOisaa8j0PAnUD8WNx1nYRexs5XEApM82wVzzVSjDM4hecFzF
	 gKQhsORJJYiCyV6G+zViP5qLOpybqHAlP4lDQ/10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Imran Shaik <quic_imrashai@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 210/414] clk: qcom: gcc-x1e80100: Set FORCE MEM CORE for UFS clocks
Date: Mon, 23 Jun 2025 15:05:47 +0200
Message-ID: <20250623130647.259860315@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



