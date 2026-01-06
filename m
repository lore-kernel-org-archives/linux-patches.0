Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B790A3644AD;
	Tue,  6 Jan 2026 17:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721991; cv=none; b=BO3ADPonfhVUX0tt0wlCBet/SorPHJ+76P3z6fwRq/R/+qLTxvPL3YnY74JZ8TN60dRmCyxN1Z/lqfX8yq4B0GBJSXZcxvEmhUQ1vdR/Goj60DyweBgvRkFFJ4LTb5P7pznpOzT5oMKlvQi3VGAmp4MEP8jB6W40I5J/L5dKP8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721991; c=relaxed/simple;
	bh=dMFqU0nAmj+3+Y+JEGITtab6RHIushZDj9sfdEE6I08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HB9jATZx8i875YoTpaDQVgaewpTvYHNsQa4UxZGw8POwaGSFSNz8Sbf10aGfBkrgPsKlJ9a1JiPlR12m2ndXOWn85anXuYWp98SfCjQs5HyPnw+B5bJUFqrlBA7d5VBRK+boRery84G+LvUBxYzWrWsAhT3u0QhT+FAHX40uDbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nab9x8iq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nab9x8iq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3619BC116C6;
	Tue,  6 Jan 2026 17:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721991;
	bh=dMFqU0nAmj+3+Y+JEGITtab6RHIushZDj9sfdEE6I08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nab9x8iqL5xac/qnRuN90e20qF1hd2eByWjX4XJMqJ6tOTOAJdy7cv1pRNdTYlaww
	 nRRNN0FIYGN7wOHiu4Md4vDupy0FyOoryJyRu+81OjdbfuuM/K143sZgsMc8lpkr6w
	 iB9ibO9zILm13Ouo12bgxd/kwJagT7NesAeuChks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hitz <christian.hitz@bbv.ch>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.18 133/312] leds: leds-lp50xx: LP5009 supports 3 modules for a total of 9 LEDs
Date: Tue,  6 Jan 2026 18:03:27 +0100
Message-ID: <20260106170552.654558671@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Hitz <christian.hitz@bbv.ch>

commit 5246e3673eeeccb4f5bf4f42375dd495d465ac15 upstream.

LP5009 supports 9 LED outputs that are grouped into 3 modules.

Cc: stable@vger.kernel.org
Fixes: 242b81170fb8 ("leds: lp50xx: Add the LP50XX family of the RGB LED driver")
Signed-off-by: Christian Hitz <christian.hitz@bbv.ch>
Link: https://patch.msgid.link/20251022063305.972190-1-christian@klarinett.li
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lp50xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/leds/leds-lp50xx.c
+++ b/drivers/leds/leds-lp50xx.c
@@ -54,7 +54,7 @@
 /* There are 3 LED outputs per bank */
 #define LP50XX_LEDS_PER_MODULE	3
 
-#define LP5009_MAX_LED_MODULES	2
+#define LP5009_MAX_LED_MODULES	3
 #define LP5012_MAX_LED_MODULES	4
 #define LP5018_MAX_LED_MODULES	6
 #define LP5024_MAX_LED_MODULES	8


