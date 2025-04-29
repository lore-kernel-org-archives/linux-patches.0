Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A05127453;
	Tue, 29 Apr 2025 17:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946884; cv=none; b=DcDbdHx4Rp7XWhF9K2J8pxGITBiblaZCcuqOgG/WDcveqzKlw/qlVw/oXZ5GmhQmfJeyhSohEVHrLIQ9BOXHtSi1qhNx4B8GGE7GkX/KfCTcs2tBlPTidFiiLnB5o9xVK7rS7DBSwBbDZi+maM+5DO7WyO3C4zjkv0O3X3MZ2D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946884; c=relaxed/simple;
	bh=zFb/Oe4iQABbmPbaWW6LmsHm0ZBMF9nD0bvXj2A4WVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kn4eX2y74V6zel14xubWAvmoZGhJIzkZ6gXbQdBwJqmqrRbD+oOCkpb/wLzYnDc7ySR1AWR/G4cDDh+ETt1al7yIg0s3v1bM4oFqCov/sKIOO+/MEG+EghAw0uLo1MI31m8zpm+XQEvlq9wnuxn7BgyNrMElqEJ7dA8Uak+YdZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+C+xW8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+C+xW8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CC4C4CEEA;
	Tue, 29 Apr 2025 17:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946884;
	bh=zFb/Oe4iQABbmPbaWW6LmsHm0ZBMF9nD0bvXj2A4WVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+C+xW8dUOqttLiabt6wEoI9x0YuoVBruefNK7g3siPmYvDKaWewKp55eNEbhRevg
	 cDf4PG544oxFM0D8E4zHAbi2LOiqUi9cXYXrnkSkAjElgJpM7Lkd7Viy6W7dVZlCfe
	 QGNfptuH6tjfSAvMzyHDuoldJEKml/i25Ut7ckUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.10 070/286] clocksource/drivers/stm32-lptimer: Use wakeup capable instead of init wakeup
Date: Tue, 29 Apr 2025 18:39:34 +0200
Message-ID: <20250429161110.732129139@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


