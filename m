Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4C2387364;
	Sat, 12 Sep 2026 15:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225206; cv=none; b=L2AhXp2TpeqyslKF4UijyS907ivK2zOvsMN94Z1k5fSTLslJV+MaeLWPbbuBaS9yQ5BlIzLIsvF5bwPaqaKGFxh7e9uxeKQJHAO/OwIZMCTz2/QDvk2HvlgZcbKmzusU92vvOm2W6iX/okosh7K60sqbhbXIg2437942j9y/0dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225206; c=relaxed/simple;
	bh=ryvLdCNAFZSKDTXFJbR0n7NViy+Ta3UUnTZKXOQUqOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgmOusKJg03VXvIEauw8oOir271rYYT2tOpD3p6WzS7tCd+Llly8SMul4qk9Av3kFrD9AefL6DRCIfkswXjc3U7SrMnB+zWBJDw5VdQ4Qh/dw611oIXbEMobKd4M1Jetdn9HRvxY5kpVzA2EKxVHkS87YOMN/ZtTtXz/CezMHrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYQ01g2y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYQ01g2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882B21F000FF;
	Sat, 12 Sep 2026 15:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225205;
	bh=93BB/MBIEcdm5DrSetz2eGmuL4jI3eUeNOMaC93bQhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jYQ01g2yKfKgV5TiG/wf4793hZ4ZT4+d/EP/Qa0bofhUP3H7Y/np/RYz+ssnm/nZB
	 1wHAD29VOjwxQExMDTdiEBy3Due2VI1moYX03IJsOVdBhJs16kaczkLKQi5xt5DloG
	 MRxn9im85Lt6O3BwjRqrDHbNB3D8sF/bfyRP/CMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esteban Urrutia <esteuwu@proton.me>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1151/1424] phy: qcom: qmp-combo: Correct pre-emphasis table for QMP v4 DP PHYs
Date: Sat, 12 Sep 2026 08:59:43 +0200
Message-ID: <20260912065633.074334744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 54fb5fca1c422..0c7d383c79f76 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -1257,7 +1257,7 @@ static const u8 qmp_dp_v4_pre_emphasis_hbr3_hbr2[4][4] = {
 static const u8 qmp_dp_v4_pre_emphasis_hbr_rbr[4][4] = {
 	{ 0x00, 0x0d, 0x14, 0x1a },
 	{ 0x00, 0x0e, 0x15, 0xff },
-	{ 0x00, 0x0d, 0xff, 0xff },
+	{ 0x00, 0x0e, 0xff, 0xff },
 	{ 0x03, 0xff, 0xff, 0xff }
 };
 
-- 
2.53.0



