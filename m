Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6D527381E;
	Tue, 21 Oct 2025 19:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076524; cv=none; b=SKUeLn/cU3ZGsvHpK2uVlI4HLabktLMksDi8RM1a7K3qg5fZ4shDasedYAV/Cbx+rn5/idZMRqoqXC5cjX9BMPq2Gq3vws/D/jfmxbWDd5Ks4ete0CdvLcgEiS8S2sxsrO5SdmJy0xMytFJ7uKni0EzhtUqOUJdwxIw0MQ0/ltk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076524; c=relaxed/simple;
	bh=Hi1epSTKvEogTwbFkI4ogsZaDU5OfQsxfaxKS95hvOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZE7ay8+72RkbnVTVpVSEYpJr37ge/WkmzesWg7NP1W3TtJvzwzuTjskpfHI6cP9UYtRX86eT4NeookYH2bnBLT2Kn74wfzHJeF4k6yma4xQ8TX6GkHvOMW/+5tYLj8rKWJhD71yf6D8bSogMcZ7xxgUXnyqNJJxU0bGitWzFfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjt+CUey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjt+CUey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAED1C4CEF5;
	Tue, 21 Oct 2025 19:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076524;
	bh=Hi1epSTKvEogTwbFkI4ogsZaDU5OfQsxfaxKS95hvOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjt+CUeyw7q2rEbM7+fmCNkSea6kRbVt9NX+1MerzXKZVJJMP2XlqHXX1vwLWqI2Y
	 HZtW6KC5TugCaPohzlrGOreHmjKv4IPlsY8uyofoYhJfC/+BKKnxqtuuw2f1fzLEKU
	 XM1DlpLuu8uNeukciaSV+6YRtcw1QHdHnJt8ArQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/105] drm/bridge: lt9211: Drop check for last nibble of version register
Date: Tue, 21 Oct 2025 21:51:03 +0200
Message-ID: <20251021195022.962479389@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

From: Marek Vasut <marek.vasut@mailbox.org>

[ Upstream commit db74b04edce1bc86b9a5acc724c7ca06f427ab60 ]

There is now a new LT9211 rev. U5, which reports chip ID 0x18 0x01 0xe4 .
The previous LT9211 reported chip ID 0x18 0x01 0xe3 , which is what the
driver checks for right now. Since there is a possibility there will be
yet another revision of the LT9211 in the future, drop the last version
nibble check to allow all future revisions of the chip to work with this
driver.

This fix makes LT9211 rev. U5 work with this driver.

Fixes: 8ce4129e3de4 ("drm/bridge: lt9211: Add Lontium LT9211 bridge driver")
Signed-off-by: Marek Vasut <marek.vasut@mailbox.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251011110017.12521-1-marek.vasut@mailbox.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt9211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt9211.c b/drivers/gpu/drm/bridge/lontium-lt9211.c
index 4d404f5ef87eb..ea192c90b543e 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9211.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9211.c
@@ -120,8 +120,7 @@ static int lt9211_read_chipid(struct lt9211 *ctx)
 	}
 
 	/* Test for known Chip ID. */
-	if (chipid[0] != REG_CHIPID0_VALUE || chipid[1] != REG_CHIPID1_VALUE ||
-	    chipid[2] != REG_CHIPID2_VALUE) {
+	if (chipid[0] != REG_CHIPID0_VALUE || chipid[1] != REG_CHIPID1_VALUE) {
 		dev_err(ctx->dev, "Unknown Chip ID: 0x%02x 0x%02x 0x%02x\n",
 			chipid[0], chipid[1], chipid[2]);
 		return -EINVAL;
-- 
2.51.0



