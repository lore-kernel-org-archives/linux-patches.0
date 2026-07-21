Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C9335C6B1;
	Tue, 21 Jul 2026 21:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669331; cv=none; b=IBTGiSL4c7MwVpRSzcaTcDCOZR8tP4DkLljhsM92rLP1ANIRaOL752Le3ucV/hApbibxWfuEF8DAxBxIeQJiqk1soNEU2E+Aup63thHgxkEnkFrASgq4Hnk6WgdyVRWpGZxjJwXd3icyYt7NkLqdaARaaxSju+/V7j6tCFc4KPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669331; c=relaxed/simple;
	bh=u2bjtW6tBjee9EdJnCYw5JX9nVp4i+U5kXgESM+jTy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvr/Tt3BAtlTIvObUvqXoQ/WTfs/Bn5koLTbE8zlrp+meCg5zG3DoK37OL8obxhsGIyWG6XrkT91WVb3797EtcYq/Mh1Zevzt4zXzkLZg1jZUuLrUd7zryL9IvhJSVTKYVrPxtBo32pnfoRIjqTnh0u2TG+jXZr+/rTkLr2ZJms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kueTaVTE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kueTaVTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE861F00A3A;
	Tue, 21 Jul 2026 21:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669326;
	bh=pgcuavKUyv4+RVqF4sbI3Yx2Ip3iCpVMplrDefXVNKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kueTaVTEWm79yI222ikzMiUkbv0uka7uiYAfj9GQRRfpx5TMYYRE/2V/C6Gw3slNJ
	 aUjNZIz6t0V9wNqifS0bdgXvpYuqSyWVT2+B5eUuICmOYT0qPnwV4bHTi4cQf1Zwbt
	 xaYa7FviW/cIqI42Fz4dA3ZQvQFkgTHFG17Xc1sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Varney <pbvarney@protonmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0511/1067] clk: qcom: a53: Corrected frequency multiplier for 1152MHz
Date: Tue, 21 Jul 2026 17:18:32 +0200
Message-ID: <20260721152436.045531568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Phillip Varney <pbvarney@protonmail.com>

[ Upstream commit bb56147ea9fce98ebde1d367335ba006cba61fbd ]

The 1152MHz frequency entry for the a53 currently selects a multiplier of 62, giving 1190MHz. This changes the mulitiplier to 60 giving the intended 1152MHz.

Signed-off-by: Phillip Varney <pbvarney@protonmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: 0c6ab1b8f894 ("clk: qcom: Add A53 PLL support")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260605005502.313928-1-pbvarney@protonmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/a53-pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/a53-pll.c b/drivers/clk/qcom/a53-pll.c
index f9c5e296dba2a0..c878d4001da52d 100644
--- a/drivers/clk/qcom/a53-pll.c
+++ b/drivers/clk/qcom/a53-pll.c
@@ -20,7 +20,7 @@
 static const struct pll_freq_tbl a53pll_freq[] = {
 	{  998400000, 52, 0x0, 0x1, 0 },
 	{ 1094400000, 57, 0x0, 0x1, 0 },
-	{ 1152000000, 62, 0x0, 0x1, 0 },
+	{ 1152000000, 60, 0x0, 0x1, 0 },
 	{ 1209600000, 63, 0x0, 0x1, 0 },
 	{ 1248000000, 65, 0x0, 0x1, 0 },
 	{ 1363200000, 71, 0x0, 0x1, 0 },
-- 
2.53.0



