Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7692FE076;
	Tue,  6 Jan 2026 17:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720903; cv=none; b=cCkHBV+8VVWiOMG5HZyAL4eOa6a49K5+jH3GTgU7e38BtdMP4IWwNefNwylJG/sYXX3vJeh04amky8UDD3YWIxjtMGlSfa4KJ7rjK9gdpZjItweNg8J65r2qO7USbIouEs69NzOKlBncjB3hLc8SM+m8IP2Fll/TFBTnYc83x60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720903; c=relaxed/simple;
	bh=J0M6THuPidHZSq/hndcr6yNWZbrDw10ioJrpzqT2A0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKQ38WszBwfeBrl42gAP27AbFDYo6BEiicAGOz1n4xewTPiw52ve7iE7eHIpb1gs0EWDHK3GN+paRMT1xgycEKgxy2IceWHVJDwHSYI6Y9kyN8PRQ7W3AABG+fH2of8tvy/uSCgnaWTPtGnsY001USO/YWrf0M9KcEnLmSyFLIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5b3Oczy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5b3Oczy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E8FC116C6;
	Tue,  6 Jan 2026 17:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720903;
	bh=J0M6THuPidHZSq/hndcr6yNWZbrDw10ioJrpzqT2A0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5b3Oczyz82hE0sL7oOEDGMB5SDQB2ClPVocASkIlXy9/Ff3jzF7ewaPKFOSgcp8C
	 OamM390CSEO7diouDMrwc7lNtzQ5ktFotOx2I0w7NpPJsTXqLtulppW+FGnNhoS0JB
	 aWgFRxHpfbUAsRorFaG9KImf7FS4vY5rIxFCLJyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hitz <christian.hitz@bbv.ch>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.12 376/567] leds: leds-lp50xx: LP5009 supports 3 modules for a total of 9 LEDs
Date: Tue,  6 Jan 2026 18:02:38 +0100
Message-ID: <20260106170505.249797594@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -56,7 +56,7 @@
 /* There are 3 LED outputs per bank */
 #define LP50XX_LEDS_PER_MODULE	3
 
-#define LP5009_MAX_LED_MODULES	2
+#define LP5009_MAX_LED_MODULES	3
 #define LP5012_MAX_LED_MODULES	4
 #define LP5018_MAX_LED_MODULES	6
 #define LP5024_MAX_LED_MODULES	8


