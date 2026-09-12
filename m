Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C8D47140D;
	Sat, 12 Sep 2026 11:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210807; cv=none; b=iTjpjqCAcFtlWKrAsJ1pSAayjTfagWnJ9VwlqGmq4/aJn5KKvFZ0mf8jjnWBePFSoWO64Pmmzm3Y6KNVT/atbaY2wTpYc8L8osVWeC51BDYVU4K6OjUZ9qecDaapPiIGKhl6Kn7G/k6Un/m8Wkf+IV9vx9YESy1Z+KvWqUWYgEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210807; c=relaxed/simple;
	bh=mER55j+SWJdM0z4Sp4UY998So29sivkuYqw3YqTUrkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFFA0w5E0Bu2b7T8WMywYWxtZYPgrFAZgd5svsBGhKNwPZB0kjxZJqbvNJUIhViAOOZXJpbFM+dtXC3Z83CRHaDsenXxsoJfe2jymvyZEUSMuVL4fvfn7O8MCDYNeAjBa21v9ZcJTddloz5lt0e+XNugLWtwzdL4NZCOxp0+wGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1W/g0Tt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1W/g0Tt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D9E1F000FF;
	Sat, 12 Sep 2026 11:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210805;
	bh=fTCnrF4YKCFYsDHbg9BvLnDyOWM0A37hZwi12quKpcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C1W/g0TteHmH7PyzJZJt+/hnPBO7Z0graH3zunAOFxkshM63R1R9uN4MmpqMnbObY
	 oXsxOHr3cATgZpZcAgkD7DskTfw4Gd1l3gEbTDOlztp1TBf325M19w7JIG0oiqxOaN
	 w2pPBfODWMtNkePnKTltW8IhDmrXxzX8N4HsSpz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esteban Urrutia <esteuwu@proton.me>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1099/1518] phy: qcom: qmp-combo: Correct pre-emphasis table for QMP v4 DP PHYs
Date: Sat, 12 Sep 2026 08:54:28 +0200
Message-ID: <20260912065648.312800257@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7b5af30f1d028..0c611ad34dfe9 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -1691,7 +1691,7 @@ static const u8 qmp_dp_v4_pre_emphasis_hbr3_hbr2[4][4] = {
 static const u8 qmp_dp_v4_pre_emphasis_hbr_rbr[4][4] = {
 	{ 0x00, 0x0d, 0x14, 0x1a },
 	{ 0x00, 0x0e, 0x15, 0xff },
-	{ 0x00, 0x0d, 0xff, 0xff },
+	{ 0x00, 0x0e, 0xff, 0xff },
 	{ 0x03, 0xff, 0xff, 0xff }
 };
 
-- 
2.53.0



