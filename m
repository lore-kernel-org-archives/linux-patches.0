Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52922E337E;
	Tue, 15 Jul 2025 13:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585872; cv=none; b=nlKHlA4/Cg6BYoooOm72sViLFRvWG34lsmQBk7j365GEoxQSFOQEJy1GvBsCLQZT+CaJui38B2RjI4HibzFk7CEBqyaHnYK0KUXkW+h/1khy0j2Dsv+uIfvxYtpu9f2lQrCG9T/D0iHL7XC+t6g70TMQoOR/XmKqqi4b1nW9tBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585872; c=relaxed/simple;
	bh=Dp8NPdjm3Jq5IPm2DhbioNgTS+CH6S3RtgXH/vTCfro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmvDW8TmiskwlUWz1i+jD9uE+SQAWsu+t6hXEKokKwFw2/qmbzn5HcKKtycXeur6gEpLg8hRlJx79vXyWYXknwJ/tYMaok3l/aSOpexUMo0tXiiyMd84Z/yDTynIZlAwwOJ9Vdpkgf8EMS3mxEs+Eg0mR8Nbgw3Nlq41gygmPXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9stPkac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9stPkac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA26C4CEF7;
	Tue, 15 Jul 2025 13:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585872;
	bh=Dp8NPdjm3Jq5IPm2DhbioNgTS+CH6S3RtgXH/vTCfro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C9stPkacl5Shbp7zgduSDTYcNhEncYERBs8RTFiQSEfVD1seYSr2R37CzxVxZqkU9
	 YkYZr50XsYJtrmpSBHJlsQXFyldRawjpfIfyFmY+/MWodaHrrzeTa+VhFmf8u5PyyH
	 htbK9glkbfUub5ATXf4zHw+S4M3k5F44uubDACFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/109] pinctrl: amd: Clear GPIO debounce for suspend
Date: Tue, 15 Jul 2025 15:12:25 +0200
Message-ID: <20250715130759.252477221@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 8ff4fb276e2384a87ae7f65f3c28e1e139dbb3fe ]

soc-button-array hardcodes a debounce value by means of gpio_keys
which uses pinctrl-amd as a backend to program debounce for a GPIO.

This hardcoded value doesn't match what the firmware intended to be
programmed in _AEI. The hardcoded debounce leads to problems waking
from suspend. There isn't appetite to conditionalize the behavior in
soc-button-array or gpio-keys so clear it when the system suspends to
avoid problems with being able to resume.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hans de Goede <hansg@kernel.org>
Fixes: 5c4fa2a6da7fb ("Input: soc_button_array - debounce the buttons")
Link: https://lore.kernel.org/linux-input/mkgtrb5gt7miyg6kvqdlbu4nj3elym6ijudobpdi26gp4xxay5@rsa6ytrjvj2q/
Link: https://lore.kernel.org/linux-input/20250625215813.3477840-1-superm1@kernel.org/
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/20250627150155.3311574-1-superm1@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 75bff325a4251..ba38173d3ed3c 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -933,6 +933,17 @@ static int amd_gpio_suspend_hibernate_common(struct device *dev, bool is_suspend
 				  pin, is_suspend ? "suspend" : "hibernate");
 		}
 
+		/*
+		 * debounce enabled over suspend has shown issues with a GPIO
+		 * being unable to wake the system, as we're only interested in
+		 * the actual wakeup event, clear it.
+		 */
+		if (gpio_dev->saved_regs[i] & (DB_CNTRl_MASK << DB_CNTRL_OFF)) {
+			amd_gpio_set_debounce(gpio_dev, pin, 0);
+			pm_pr_dbg("Clearing debounce for GPIO #%d during %s.\n",
+				  pin, is_suspend ? "suspend" : "hibernate");
+		}
+
 		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 	}
 
-- 
2.39.5



