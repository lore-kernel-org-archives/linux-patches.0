Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E69936404D;
	Sat, 12 Sep 2026 08:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203070; cv=none; b=K19V30YkAbNvBCnpfjNmswP1JJnQrWxbckHyk7d9GzX/gY/COPdtvuRLrYdrVKnDqeXf26q04ITjLl58jCK/ewKF4ENwGMUj7sf9ChusfNpsbm7sp11UxxFYXsyTEr9r7VcrnbLghhrXMaGsQuZ/MxrKUgCPSiGHNKJ3CXDnuCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203070; c=relaxed/simple;
	bh=r97TA9NO1vg78kUyH1ZaOfbVhHYUeia0fTRM1R+IF9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEQH3c6ZojC+Y1OEikNycs3x0lc0i/j4i67KxBHBs3ixig5uIkkAyKetcuolPI1uOz+NNMKfwRZlM9z+2wbuY/n1oChi/9AwqRXGlpRHBCme87kkKRzlTwjHMD8vf+HlLfTnnN2imF5e7Uf8m0tIupkHzFYhNRsM6+U/yiZFBVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O4d6wTnE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4d6wTnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC74D1F000FF;
	Sat, 12 Sep 2026 08:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203069;
	bh=L29QOrrGkVKn20l7Kka8kpAdfBac2EBnoDcvrz9KEbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O4d6wTnE9zxkd13tHG7HflFWv46jQZFK/AjBXGfLpGZRIZ9jx85RT7ZQLe6mGtvCJ
	 Po0sbS75PhUS3ZNEEj8CR2VnVDlqR8nltc9o4av96f2oFCpeKA36n08X163pBZjjZs
	 j0T4U4S773pDgvn31XiEbg8ixBWsWRG1HJOPgC6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esteban Urrutia <esteuwu@proton.me>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1334/1815] phy: qcom: qmp-combo: Correct pre-emphasis table for QMP v4 DP PHYs
Date: Sat, 12 Sep 2026 08:51:24 +0200
Message-ID: <20260912065720.340157387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Esteban Urrutia <esteuwu@proton.me>

[ Upstream commit 481807f939077059db278edd0467e7e609b6c9a7 ]

Comparing sm8350 and sm8450 tables, this seems to be a typo.

Fixes: ef14aff107bd ("phy: qcom: com-qmp-combo: add SM8350 & SM8450 support")
Signed-off-by: Esteban Urrutia <esteuwu@proton.me>
Link: https://patch.msgid.link/20260711-sm8450-qol-qmp-v2-1-d14353bd6ff4@proton.me
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index cdcfad2e86b1d..a72c3b9654ecd 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -2108,7 +2108,7 @@ static const u8 qmp_dp_v4_pre_emphasis_hbr3_hbr2[4][4] = {
 static const u8 qmp_dp_v4_pre_emphasis_hbr_rbr[4][4] = {
 	{ 0x00, 0x0d, 0x14, 0x1a },
 	{ 0x00, 0x0e, 0x15, 0xff },
-	{ 0x00, 0x0d, 0xff, 0xff },
+	{ 0x00, 0x0e, 0xff, 0xff },
 	{ 0x03, 0xff, 0xff, 0xff }
 };
 
-- 
2.53.0



