Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5C7373BE1;
	Sat, 28 Feb 2026 17:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301544; cv=none; b=JYfywDkaFRyZ7aX7L6K8ve4G6+F3kE8+uZC9w1Idd9cWhCo15pliTUn0WEvzF65qDWuYttb7Et/Z0cW6VLSpqp2asjQXXB/0RTer0+jk5fVNrMCYZ/3HgJunrFGak6BzMEUIg8GI5OKCPjJYnrfb0eMV+2zHrx8CLsLOA1KAA6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301544; c=relaxed/simple;
	bh=THbQHgaq61jho7D5uWewRwo0XMnNLOZ1XtokK5cfmRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkAj7hsZMMP8tIjncsWL3MnKyvlu38U/W/3GvAy9jQBw/gvIO5JTlxC8Q5E7QZlzjMP0oNljsq9pBU8xgF7o5o1KdGaXsOhGtbBkHXe/+X3im9AAzSIfqXuU+ockaVde4Vmq5hwFuKTZgbCDm25/rugFn5yFC7jjSkaIFOANzEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlGmx39p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlGmx39p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3AFC116D0;
	Sat, 28 Feb 2026 17:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301544;
	bh=THbQHgaq61jho7D5uWewRwo0XMnNLOZ1XtokK5cfmRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlGmx39pVaCKLWdsiLDwXtGxf8UdpLCJe2XkE+nIWuajB2GA6TuwJ8KWfQ3sppvZA
	 5HZGhE7eo8iqcOzov1DUCGBk/fyQxeCzFshwHWZlU4ep1slOCRnTfEhtCq3tCwlHQQ
	 /GkvsoMV0gpL5xpo5ZYChEziVhEhE+Uey2UcfmLWvHS5umO2CbBLlx/Jz7mCzghhUX
	 /KwXy3hEOXTpMYepW17qpx7ms1RO4PLMGFTZuoStwDjsE5pUOpZTpAfqjmuGCBwTpT
	 98iusBjXyWDydW28OBcZR4a9lrz1zweKwcufeDybl0IWHLmkcFRv0OWNR6ylK5Tf04
	 IL6agscIc6NZg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ethan Tidmore <ethantidmore06@gmail.com>,
	stable@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 727/752] gpio: nomadik: Add missing IS_ERR() check
Date: Sat, 28 Feb 2026 12:47:18 -0500
Message-ID: <20260228174750.1542406-727-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit 58433885ee99e8c96757e82ccf6d50646c4dfe09 ]

The function gpio_device_get_desc() can return an error pointer and is
not checked for one. Add check for error pointer.

Fixes: ddeb66d2cb10f ("gpio: nomadik: don't print out global GPIO numbers in debugfs callbacks")
Cc: stable@vger.kernel.org
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Link: https://patch.msgid.link/20260214044531.43539-1-ethantidmore06@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-nomadik.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpio/gpio-nomadik.c b/drivers/gpio/gpio-nomadik.c
index 97c5cd33279d5..e22b713166d71 100644
--- a/drivers/gpio/gpio-nomadik.c
+++ b/drivers/gpio/gpio-nomadik.c
@@ -430,6 +430,9 @@ void nmk_gpio_dbg_show_one(struct seq_file *s, struct pinctrl_dev *pctldev,
 #ifdef CONFIG_PINCTRL_NOMADIK
 	if (mode == NMK_GPIO_ALT_C && pctldev) {
 		desc = gpio_device_get_desc(chip->gpiodev, offset);
+		if (IS_ERR(desc))
+			return;
+
 		mode = nmk_prcm_gpiocr_get_mode(pctldev, desc_to_gpio(desc));
 	}
 #endif
-- 
2.51.0

