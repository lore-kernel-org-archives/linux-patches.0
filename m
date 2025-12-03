Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D1C3314C4;
	Wed,  3 Dec 2025 15:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777150; cv=none; b=qWf/cJQm8zRPbF7U2YYGplKCmVNwk1+50CXA5Hf+qIJ2W/H0g3brJODtyHxVRXRmuElu+zRnHakonir1+QUeYUbF4Gcc8GNIzm8dT4mfDbcsZ4BS69Z5bhGhpO7WU7GdcPi5BAi/h6xrtSCRoVSOoSva9vToIOloY1oV2GRwKck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777150; c=relaxed/simple;
	bh=77GfZBLXmPAmrlxPUvNLiGoB1RknwuqwA6zOk5R2j/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaBodyrUoFj8YlADjcwGwMGToJLikrfmXxaRJswDOMzxouCJelJAXBUoY+pOn0ME5ynxfi2Ljh2QRKssTQDwOd81ypG0JWyMMg/hnDjmhbqJCJ/kZLC8t4zJ+nxbaNQG4qqrCkN83UFSGDO/Vipl3OCrm/cf5tLA4M1dJTcrI+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TApmiGX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TApmiGX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0368AC116C6;
	Wed,  3 Dec 2025 15:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777150;
	bh=77GfZBLXmPAmrlxPUvNLiGoB1RknwuqwA6zOk5R2j/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TApmiGX86BMfLkgzr/OxYwlAVRm4eo2rIH11Yaf6Bn5ZVc8YxCCsrsGeXPAhvEmie
	 TYfO+NmjNOhMNqvUiw2YLyem5sBdQUAvjZmIi9ft9IFyzzKaa8VluON/sIYPtQ42ME
	 RmVFyNiUrnF0+w7diRunSlkBYGOoX2kPHmNorK0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoon Dong Min <dm.youn@telechips.com>,
	ChiYuan Huang <cy_huang@richtek.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.17 097/146] regulator: rtq2208: Correct buck group2 phase mapping logic
Date: Wed,  3 Dec 2025 16:27:55 +0100
Message-ID: <20251203152350.010613317@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChiYuan Huang <cy_huang@richtek.com>

commit 45cc214152bc1f6b1cc135532cd7cdbe08716aaf upstream.

Correct buck group2 H and F mapping logic.

Cc: stable@vger.kernel.org
Reported-by: Yoon Dong Min <dm.youn@telechips.com>
Fixes: 1742e7e978ba ("regulator: rtq2208: Fix incorrect buck converter phase mapping")
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://patch.msgid.link/8527ae02a72b754d89b7580a5fe7474d6f80f5c3.1764209258.git.cy_huang@richtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/rtq2208-regulator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/rtq2208-regulator.c b/drivers/regulator/rtq2208-regulator.c
index 9cde7181b0f0..4a174e27c579 100644
--- a/drivers/regulator/rtq2208-regulator.c
+++ b/drivers/regulator/rtq2208-regulator.c
@@ -543,14 +543,14 @@ static int rtq2208_regulator_check(struct device *dev, int *num, int *regulator_
 
 	switch (FIELD_GET(RTQ2208_MASK_BUCKPH_GROUP2, buck_phase)) {
 	case 2:
-		rtq2208_used_table[RTQ2208_BUCK_F] = true;
+		rtq2208_used_table[RTQ2208_BUCK_H] = true;
 		fallthrough;
 	case 1:
 		rtq2208_used_table[RTQ2208_BUCK_E] = true;
 		fallthrough;
 	case 0:
 	case 3:
-		rtq2208_used_table[RTQ2208_BUCK_H] = true;
+		rtq2208_used_table[RTQ2208_BUCK_F] = true;
 		fallthrough;
 	default:
 		rtq2208_used_table[RTQ2208_BUCK_G] = true;
-- 
2.52.0



