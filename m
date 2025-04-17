Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975461D07BA;
	Thu, 17 Apr 2025 18:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914553; cv=none; b=RSAh/cyWA+mtp+YNM6eWF+H3ssfTNyyxCMwVlslF8x0QQSjB3+ZSkeWTK06OLtQUQbW9ema17/xhlifatmLWovJmN5MsCQZULmjxFBq9GNiM4GhEvoV3kBaCVxSr9F+4SWYvnupZe38DuzVB7vONSRpMxaARfkpzu+YGwraJm04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914553; c=relaxed/simple;
	bh=mBPfHKW2h2kvUAJja9iteFStmOAh4WORV8SqQ1gSPfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/YjeOxhZEKuY1HeLrwcUibepcvFrVlJAlHxqMSQgxB3d9puOfHPdGi4vKHJ5N3L4GLxn0rdP7F6qJVh/JNypZN4G5Eos4GJT4pbXHujz7spwEOYl8cFftSMIBAbUi2fAk3pyzAp7/njILcvJbX9mHG6By9RlIqkEWY6ebr3s9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQfidMdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQfidMdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A8CC4CEE4;
	Thu, 17 Apr 2025 18:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914553;
	bh=mBPfHKW2h2kvUAJja9iteFStmOAh4WORV8SqQ1gSPfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQfidMdv5JG1Hp/9jC1tkT1sw7eFBPGp1WobARbwh4MY9TRWkL1rsQZvLhW36Khbb
	 VqXm0y1CQtoQmUXowNtxR3pyPqWm0lRBGac8+Ccl2TKSyPUbAMNjZ/qelq5Hpbc8Xz
	 rPvpNeId6h5RGb2glBlnmva+Dnbt8BzBh+JbzkT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 6.13 254/414] clocksource/drivers/stm32-lptimer: Use wakeup capable instead of init wakeup
Date: Thu, 17 Apr 2025 19:50:12 +0200
Message-ID: <20250417175121.638846574@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


