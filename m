Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27983244664;
	Tue, 29 Apr 2025 17:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948686; cv=none; b=u0cHCfBxdjwYuEeOe7sPS5+Csgg0GNzNpoKJzL54vnCijnO+nTgRnfhRRXYoDa2TE1jFI5Zs4mOgZOjVuGe7Hty+tZgh5MobfW+S/G5ACK+6Ut4bkcYCfgoZEm7ax5ZpnFEH9uS1HLH7yOs+09bob1P2JEIEC01ndtDG3iaJCNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948686; c=relaxed/simple;
	bh=eiUrZMhSLdc/usUb7neiOuaSUZLdPKCQWMUeuJfATWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXYJBsx0EXUlPIIUqZ62bquAWT6Z4iVIf6R9YfobJ2aWKrKeoUOzeYKSTBYH/gsK5+1bHuc0CSXGhMowpNU9536KZ7MSZn1PVJYs8vWZ9VRvErSuurKznmcdaqTBIHE10GdcUA3XgREkO5lYGhSeGRt5KC6Mg3fcikGLSXhAhTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cuRU5XmX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cuRU5XmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA35C4CEEF;
	Tue, 29 Apr 2025 17:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948685;
	bh=eiUrZMhSLdc/usUb7neiOuaSUZLdPKCQWMUeuJfATWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cuRU5XmXIUZ9mmFcSkSaJL3fApCKVTqm9T22Pw1uMFhAyzvUg/5dbFqNtjKzA5Nj4
	 haXOkCeHr8qnhotlBF9HKcZrGmEEzBaoRgV7GlaHXGC6IPsp+wLCxcPLy+2C22ZdBj
	 ewHDUYtrT4KscbNBWnQ1qSvzb0U07bduzz+q9LUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.15 081/373] clocksource/drivers/stm32-lptimer: Use wakeup capable instead of init wakeup
Date: Tue, 29 Apr 2025 18:39:18 +0200
Message-ID: <20250429161126.484056530@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


