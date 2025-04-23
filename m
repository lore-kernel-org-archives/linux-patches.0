Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F377D290BD0;
	Wed, 23 Apr 2025 15:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421066; cv=none; b=G0OQnJnrfUh/DrHf9o9LWZPGMEkyiSeYaFIyZAiu48EoHLUdM1Tw/bQLRKgJvCziBVH6/MwLi8CnZ1Q1DbqarR8r0a65TgFm1b1VlAEYtL9hkqlyRvcoKm61EVP3X6HIIQUcRaY9X09KeqU4KguCMAPfnR817wnbxyVe0X6JGWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421066; c=relaxed/simple;
	bh=lH+nyJsISUp0HXm/3W6TAnswz5EbSmKY0GMhbPhsndg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GTdCuwLNEMZVbWDjVSiS56kVDViiIrg2/G3AKJn2MnNKGMm6h9IomwgkulHxMCVl5YuAxz1+Y68hZOpv7X+fr7zf/fXwUHq7Emh5xSS8rFCDxBbilKPHJ3cj+hfffSvjueMhz3flkhgl9T1sg8uk5qlGU1oqb7ITE1+CBTgDaPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HiQrzMK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HiQrzMK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2413EC4CEEB;
	Wed, 23 Apr 2025 15:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421065;
	bh=lH+nyJsISUp0HXm/3W6TAnswz5EbSmKY0GMhbPhsndg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HiQrzMK34kcLb+UxduG2+rCV3VkR4fVbH7duGNrajmvpHX39l8vSC4R0n2xFeHFiA
	 bv3YL2VdWmRXcQoBfdGtiWnnpDnO+voIu2KTOh6o6HEpUsOcalLjqZQ4A4Fwb5+BaG
	 m6jKyuibowD4gIFx+QrPmu2ZuDELw/CmIhO3uSE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 6.1 105/291] clocksource/drivers/stm32-lptimer: Use wakeup capable instead of init wakeup
Date: Wed, 23 Apr 2025 16:41:34 +0200
Message-ID: <20250423142628.651910520@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Torgue <alexandre.torgue@foss.st.com>

commit 96bf4b89a6ab22426ad83ef76e66c72a5a8daca0 upstream.

"wakeup-source" property describes a device which has wakeup capability
but should not force this device as a wakeup source.

Fixes: 48b41c5e2de6 ("clocksource: Add Low Power STM32 timers driver")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Rule: add
Link: https://lore.kernel.org/stable/20250306083407.2374894-1-fabrice.gasnier%40foss.st.com
Link: https://lore.kernel.org/r/20250306102501.2980153-1-fabrice.gasnier@foss.st.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/timer-stm32-lp.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/clocksource/timer-stm32-lp.c
+++ b/drivers/clocksource/timer-stm32-lp.c
@@ -168,9 +168,7 @@ static int stm32_clkevent_lp_probe(struc
 	}
 
 	if (of_property_read_bool(pdev->dev.parent->of_node, "wakeup-source")) {
-		ret = device_init_wakeup(&pdev->dev, true);
-		if (ret)
-			goto out_clk_disable;
+		device_set_wakeup_capable(&pdev->dev, true);
 
 		ret = dev_pm_set_wake_irq(&pdev->dev, irq);
 		if (ret)


