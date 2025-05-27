Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2D042A9B;
	Tue, 27 May 2025 17:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367703; cv=none; b=H1zogNCjm1wwTGjfkMXSQYQJkNEnwrjTGbg1+dN9YIVjwOMyzy30Y2rPicTd/qXfR80stE7iV9tWHU4Sk+evXALF6r2fFIn7oHgfhkTvs3eHi7xh/daqCPgjxmipLhh5GeSqU3JMZmXpnU1q31okqgaofjOK0cirpLQocBVN0lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367703; c=relaxed/simple;
	bh=nxlDCBG55nCVxl89UQ6LBtZG3mxMdalNsWVaq3iR9Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JEa9NL8Uuezit+0zsYcI7djya8yOpnmSE6KK0tgHV/wR9DUzrezGfV+WlqtVeXrHm2IQzWayh/1z7Pe2+p4NwKz+d7EpA3I5xtF3EV2CuWu9Nv4A+WU2FMqTMwKbRKzmCHvSU3Mn6r/bOLTKKdsDEpy1jJHeU7UXFZLBdUbCfdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pr4YEs3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pr4YEs3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2D5C4CEE9;
	Tue, 27 May 2025 17:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367703;
	bh=nxlDCBG55nCVxl89UQ6LBtZG3mxMdalNsWVaq3iR9Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pr4YEs3uyXmTLarY6BFvY5lzV4icNuxnbiztF4Hm6wf8fZCGvDRUZEHxRlwQzNMV5
	 YxceID+XtDcnqGCFt0wN6nty2XjfiMmZbS3N7rQcDp0BRAJ2eVg76vEegjUZcqnV7x
	 QlHDgeqG9/TKqW7R4VVVqE9u9ZTN5fcAihwpf0NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Will McVicker <willmcvicker@google.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 472/783] phy: exynos5-usbdrd: fix EDS distribution tuning (gs101)
Date: Tue, 27 May 2025 18:24:29 +0200
Message-ID: <20250527162532.352014930@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

[ Upstream commit 21860f340ba76ee042e5431ff92537f89bc11476 ]

This code's intention is to configure lane0 and lane2 tunings, but for
lane2 there is a typo and it ends up tuning something else.

Fix the typo, as it doesn't appear to make sense to apply different
tunings for lane0 vs lane2.

The same typo appears to exist in the bootloader, hence we restore the
original value in the typo'd registers as well. This can be removed
once / if the bootloader is updated.

Note that this is incorrect in the downstream driver as well - the
values had been copied from there.

Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
Tested-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Tested-by: Will McVicker <willmcvicker@google.com>
Link: https://lore.kernel.org/r/20241206-gs101-phy-lanes-orientation-phy-v4-4-f5961268b149@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/samsung/phy-exynos5-usbdrd.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/samsung/phy-exynos5-usbdrd.c b/drivers/phy/samsung/phy-exynos5-usbdrd.c
index 46b8f6987c62c..28d02ae60cc14 100644
--- a/drivers/phy/samsung/phy-exynos5-usbdrd.c
+++ b/drivers/phy/samsung/phy-exynos5-usbdrd.c
@@ -1513,8 +1513,11 @@ static const struct exynos5_usbdrd_phy_tuning gs101_tunes_pipe3_preinit[] = {
 	PHY_TUNING_ENTRY_PMA(0x09e0, -1, 0x00),
 	PHY_TUNING_ENTRY_PMA(0x09e4, -1, 0x36),
 	PHY_TUNING_ENTRY_PMA(0x1e7c, -1, 0x06),
-	PHY_TUNING_ENTRY_PMA(0x1e90, -1, 0x00),
-	PHY_TUNING_ENTRY_PMA(0x1e94, -1, 0x36),
+	PHY_TUNING_ENTRY_PMA(0x19e0, -1, 0x00),
+	PHY_TUNING_ENTRY_PMA(0x19e4, -1, 0x36),
+	/* fix bootloader bug */
+	PHY_TUNING_ENTRY_PMA(0x1e90, -1, 0x02),
+	PHY_TUNING_ENTRY_PMA(0x1e94, -1, 0x0b),
 	/* improve LVCC */
 	PHY_TUNING_ENTRY_PMA(0x08f0, -1, 0x30),
 	PHY_TUNING_ENTRY_PMA(0x18f0, -1, 0x30),
-- 
2.39.5



