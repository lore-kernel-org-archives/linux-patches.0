Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765DF30BF63;
	Mon, 13 Oct 2025 15:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369617; cv=none; b=GS6FVJn/O/ntxSWpFVHlKWJu1Ojf+fCd+neA2MbxsT7CSULuNzGrSso+7eWN9DxQPCgTot6z0Puc31D/p/XITytsYx7ZChLLj90GEvcu+2tTZHXOnkSAqfexP1x+ea/ADGZUwMDCYTl3/AUpfWWJE+QTDiYQ6DeFzS+BCX+62kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369617; c=relaxed/simple;
	bh=3CpiIlcG9po4F9c2NGdSatt8mUUZsnrgsLtns01K948=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/RLGT2/yfFSzaTQf+t636i33hfVEfnwpmfT6FngzZPzE+jKBfe46okPAWXb1vAhquaOlObfW31kDf8PjqZ/0pvrQPTzADs+sdiO4FKb65xEx+BEctLuk9VpcVacKYhmltdW92THFDT0dq+9l1kL2UyR2Nh8/B7KPtNb2QyyjKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjTbQLWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjTbQLWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC19FC4CEE7;
	Mon, 13 Oct 2025 15:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369617;
	bh=3CpiIlcG9po4F9c2NGdSatt8mUUZsnrgsLtns01K948=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CjTbQLWGBBrZFhJnHqwWjeN4FeidLyTtnKDqcC4PTNxbOBhURGcXhVkbZXfQpv7FX
	 bh0fObCNoQdBVeKsrg9GfxIzFPQjdT5l0CduEgEK7jFgDvWE9pG6dTd3JwRk/E99YQ
	 0hRuDkZJbZGUnpvbcqU0zSFkZVMfbTCKmVEMYd3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Pin-yen Lin <treapking@chromium.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 276/563] HID: i2c-hid: Fix test in i2c_hid_core_register_panel_follower()
Date: Mon, 13 Oct 2025 16:42:17 +0200
Message-ID: <20251013144421.271701885@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 5c76c794bf29399394ebacaa5af8436b8bed0d46 ]

Bitwise AND was intended instead of OR.  With the current code the
condition is always true.

Fixes: cbdd16b818ee ("HID: i2c-hid: Make elan touch controllers power on after panel is enabled")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Pin-yen Lin <treapking@chromium.org>
Acked-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/aK8Au3CgZSTvfEJ6@stanley.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 99ce6386176c6..30ebde1273be3 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -1189,7 +1189,7 @@ static int i2c_hid_core_register_panel_follower(struct i2c_hid *ihid)
 	struct device *dev = &ihid->client->dev;
 	int ret;
 
-	if (ihid->hid->initial_quirks | HID_QUIRK_POWER_ON_AFTER_BACKLIGHT)
+	if (ihid->hid->initial_quirks & HID_QUIRK_POWER_ON_AFTER_BACKLIGHT)
 		ihid->panel_follower.funcs = &i2c_hid_core_panel_follower_enable_funcs;
 	else
 		ihid->panel_follower.funcs = &i2c_hid_core_panel_follower_prepare_funcs;
-- 
2.51.0



