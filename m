Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08E014A088;
	Wed,  5 Feb 2025 14:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765401; cv=none; b=T9X/No0F8V0ASIKRZ6E+jWfbBTu86FSPcqIoSJcvz46czOmcyRrreLyrNFOnrU2ZyibmIw13Zu7XQNIaU6q8GypnoIxYJkXzTRdJ9m+Am2UUb0e9Ugm2AZa3z9eXQOg1lmbmWblrmInVMhchGKTz1pRJJmYNlySlpn/l1q5R7UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765401; c=relaxed/simple;
	bh=ueJkCFqqdRaFZsFuL3jfXO0v7iUggH8zP0mEvdVfBsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rENLdPoT0G8fKY5jrEl/mXSydq9OK00Xxuxab+HKEF8JSx5RpSsdHdLGvBRTMQ2+lnYMzzFJhqiNoSS49+RtuFZEAGqg39yK92EWBM1/tHF3hMFJgyn0v5pS6mLU8MhmfQQ84G1YOtYzVlPDCYDedwRcn9ErrG2pJG8mAg1LA+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UeZ6GWLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UeZ6GWLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E308C4CED1;
	Wed,  5 Feb 2025 14:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765401;
	bh=ueJkCFqqdRaFZsFuL3jfXO0v7iUggH8zP0mEvdVfBsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UeZ6GWLO2ZY4NN+ZHVrDrlnarIcO4Fct5t9rrBW9t9FRgJJUEwGKxPNLJG7IC+YGa
	 flgPBN0K2jsSpLflWLtb1zyK3xMBa3uNRnUNBg9YdOBha6Z+zUv0YBePuebLz7merK
	 QtVUNA5rVOrOUetvvFx0dylVLCg2OAI1RTm3q1vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Drew Fustini <dfustini@tenstorrent.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 175/623] clk: thead: Fix cpu2vp_clk for TH1520 AP_SUBSYS clocks
Date: Wed,  5 Feb 2025 14:38:37 +0100
Message-ID: <20250205134502.930163157@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Drew Fustini <dfustini@tenstorrent.com>

[ Upstream commit 3a43cd19f1b8d3f57f835ae50cc869f07902c062 ]

cpu2vp_clk is a gate but was mistakenly in th1520_div_clks[] instead
of th1520_gate_clks[].

Fixes: ae81b69fd2b1 ("clk: thead: Add support for T-Head TH1520 AP_SUBSYS clocks")
Signed-off-by: Drew Fustini <dfustini@tenstorrent.com>
Link: https://lore.kernel.org/r/20241228034802.1573554-1-dfustini@tenstorrent.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/thead/clk-th1520-ap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/thead/clk-th1520-ap.c b/drivers/clk/thead/clk-th1520-ap.c
index d02a18fed8a85..4c9555fc61844 100644
--- a/drivers/clk/thead/clk-th1520-ap.c
+++ b/drivers/clk/thead/clk-th1520-ap.c
@@ -896,7 +896,6 @@ static struct ccu_common *th1520_div_clks[] = {
 	&vo_axi_clk.common,
 	&vp_apb_clk.common,
 	&vp_axi_clk.common,
-	&cpu2vp_clk.common,
 	&venc_clk.common,
 	&dpu0_clk.common,
 	&dpu1_clk.common,
@@ -916,6 +915,7 @@ static struct ccu_common *th1520_gate_clks[] = {
 	&bmu_clk.common,
 	&cpu2aon_x2h_clk.common,
 	&cpu2peri_x2h_clk.common,
+	&cpu2vp_clk.common,
 	&perisys_apb1_hclk.common,
 	&perisys_apb2_hclk.common,
 	&perisys_apb3_hclk.common,
-- 
2.39.5



