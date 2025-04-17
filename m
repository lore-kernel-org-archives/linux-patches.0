Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B4D185920;
	Thu, 17 Apr 2025 18:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915786; cv=none; b=EdW87/sLpojIT9wdYPOa/rNCgGTwXHOL+Ks7updjtSqI/fc/D6gBNWB7Lplb9OGifpQRUdzz3XHQndig13Owr2jxQMVflN/pUlMwHCqbcWScBMhTKaR27emFQJAdjNcJGUkVhUBjsUxrl13Zgof3fA30inf/mV8S1UoNnKdRsCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915786; c=relaxed/simple;
	bh=D1uCwNXcEuI8j8DW+m1b9J1CwPAOBNW+pgjhgb/4BQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhDgfiVy4I9H9ncQZ7I/rG9GqIg45QT3nUeoKcv2DQCWIVtwjKXE3QS9xiIevN9n/lyt1M4q2ljkqkp7JBiZFTdEiRyfQrEhvjrkET2MAotxqw6pIuAcDq6MMZBCUDRFgdBK6JVsiSQwL0XIz6Q+Vz/E4kE/XGNCivn412RtVpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SZZICcOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SZZICcOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7985AC4CEE4;
	Thu, 17 Apr 2025 18:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915785;
	bh=D1uCwNXcEuI8j8DW+m1b9J1CwPAOBNW+pgjhgb/4BQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SZZICcOZcCKNo42aJelrJfEolRg6j35ChT7v1YM67cTg59ggONA3idArqjui56zVe
	 7Srl6dBgmIUlkOqzw/g3Cn+fz60DiOB5zaAWKSDnEO/kGm6B3Yg+Po6bFxRr1OBiHj
	 P2OU6wfw0kqbTKpAfLlcnnexqSG2ll+6rNHrX1h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 6.12 239/393] clocksource/drivers/stm32-lptimer: Use wakeup capable instead of init wakeup
Date: Thu, 17 Apr 2025 19:50:48 +0200
Message-ID: <20250417175117.214319518@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


