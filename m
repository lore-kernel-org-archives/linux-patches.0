Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48D519F40A;
	Thu, 17 Apr 2025 18:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913246; cv=none; b=TkVeC+++RjdpvDsI3Kr0ObrAxTh4K9b+hyJqEP+pK1zoGG8aC6giIydXh2JbjdHI3HYBzEqrsvUUnknRcOCR9N5DaSiZ1QzYxWOulZM3el4B2XitwvM7XUGe12vBXIxvas/uVgXU+Q/7hS5hioxNmpCYHzJakmHGgHloKMhb+2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913246; c=relaxed/simple;
	bh=qeclHQY1g17+sANKP/Zd/uTfwOqlOTnf7MgfWP1YvkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BX8Alv3akNKg61MrRRWBGMdqrbv2Ngv/6LIFastioY1Y/xzMM//zg7XFOPujUpbV8jtFF6wlpBVR4uoJuEA0bWI8J5eFC+6Hjym7nxic0gOGTKP0ZmGvS9Xkggb0tLoUVnInnsc3tMgmMUxPpiFkol5FZNtLxPGJb12nZ+x9a7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UtOmxPGz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UtOmxPGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350C2C4CEE4;
	Thu, 17 Apr 2025 18:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913246;
	bh=qeclHQY1g17+sANKP/Zd/uTfwOqlOTnf7MgfWP1YvkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UtOmxPGzdwL9lkZYnaaa+upHl4XbOsIV8Li7VVdSEgLnqZWvJYLz71Dq5+3eQTlQ/
	 AT9cepIaJdEQIdtB0D+imMUoYxRY8h4Yy3GJh3canR9I+21QCUMygCd/IbZ6oVZgOm
	 n3zvk0kwslTW8Z9548s5iSlT43mZCB8PlNt2SmnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 6.14 276/449] clocksource/drivers/stm32-lptimer: Use wakeup capable instead of init wakeup
Date: Thu, 17 Apr 2025 19:49:24 +0200
Message-ID: <20250417175129.169147724@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


