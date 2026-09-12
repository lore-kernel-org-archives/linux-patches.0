Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A5047CC94;
	Sat, 12 Sep 2026 12:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217919; cv=none; b=IZJoxD86NV3lBPVZNJPtmmpoIT+ZaKWvsAk07qUqQyUe4Ut3KMnYdXYPlv4rQDdXqIPHSZ621K0GKSJCUh/yCUq+2B0rQUCMO2RSLJ/XddsEAJnWQuuW+OGzOtksD1P1zlswhbhiU3RvVgKkE8oJDSlWC2xlWOOdETPQVvt6YpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217919; c=relaxed/simple;
	bh=FbNXTYTgiMXr8XxgEXlqumNh3jmJS+t7OmMeylmq+88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKEGlLWcGax9Llu9ejMViceGpaJew0zowKQHoenI/5xsYrvtBuBGSBs8ZPkI3WJlmBrueWvGk6GD5oMVq3l5CN4MZ7gPn8IyjHzF+SfJv+H4orTa7Y3QTOQXL9+Vgnr1kEwIRe+QPLsEH54Dx4Ls6YZFPPJuqnKdPvVBKUjbuok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dt1lqOCn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dt1lqOCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666031F000FF;
	Sat, 12 Sep 2026 12:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217918;
	bh=nxcCToQhpFjxkuk8xmMnrMb4SdUqiQXsmv+uAR77a54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dt1lqOCnCTQhEyQ1KsHhatFoKFOUBvSBtOzScEStrSN57fjtt9tEfqRG2wbM0mSr4
	 FyRHvfPyaVe67Ig7RNOuvPSuncjl991lBrPnDqlf6/cdBQX2KL+eI4Kr9v9KnsHk3D
	 3n6Zv9yYLchJSo2XU0xFNI35Nx0DUN4y7Ky4yxis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esteban Urrutia <esteuwu@proton.me>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1038/1376] phy: qcom: qmp-combo: Correct pre-emphasis table for QMP v4 DP PHYs
Date: Sat, 12 Sep 2026 08:57:44 +0200
Message-ID: <20260912065630.695210962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 643045c9024ea..2293fb72972c5 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -1474,7 +1474,7 @@ static const u8 qmp_dp_v4_pre_emphasis_hbr3_hbr2[4][4] = {
 static const u8 qmp_dp_v4_pre_emphasis_hbr_rbr[4][4] = {
 	{ 0x00, 0x0d, 0x14, 0x1a },
 	{ 0x00, 0x0e, 0x15, 0xff },
-	{ 0x00, 0x0d, 0xff, 0xff },
+	{ 0x00, 0x0e, 0xff, 0xff },
 	{ 0x03, 0xff, 0xff, 0xff }
 };
 
-- 
2.53.0



