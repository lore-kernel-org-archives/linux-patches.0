Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6F83C1FEE;
	Thu, 15 Jan 2026 17:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498323; cv=none; b=e+w7/wPQFun8uBBicgbwRllM6K8iPhjO/AghyK8gKvZWmJMbq0SYSA3hx0Cfeg/uD9IeXhoAKKKzqQBK+3BQ1BV+HQZ4HWM2nL9kDtn79+/8owPX8N2DzfLaHEBnwUSpmORoG/8z9LG6TT1RQ9073jbS1XDJcd85l3uqbX6qpos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498323; c=relaxed/simple;
	bh=rjszt0kbrzJ/T/RgPbsl0avD4J2Ift9E704ul508C3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bxhmy60BO8YLqanmJ6q1kOvoooT5d9E7I7Cg/7NWgew9rsKWO6lVzUwckI8B66TaAPiid+EcE/BqqcF0b1d0A3+syr4Lbw0pE0j3fu13eaRU+vsEQBdmmFJSgRHkPz8ckrEv4vD0Q6KKuFx7XXJrS+FTh/TMblcVt0juLKryOM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EAwr0tFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAwr0tFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AA4C116D0;
	Thu, 15 Jan 2026 17:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498323;
	bh=rjszt0kbrzJ/T/RgPbsl0avD4J2Ift9E704ul508C3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EAwr0tFBFsK4lfGSYVMvOw+3TLbZgINt5+BgE6bVasrJqlNhJf2y4o8G6WjvdIf7t
	 Xa9hL0wUa2QiROIF4YfxYqQXSHFnThoGQX4x4hs3BRh/48LI/jn2G2FOKp9qIBae/V
	 rpJVEg6VEtWOYhKorlvP+SkNuML2soCquKpXsdA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hitz <christian.hitz@bbv.ch>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.15 384/554] leds: leds-lp50xx: LP5009 supports 3 modules for a total of 9 LEDs
Date: Thu, 15 Jan 2026 17:47:30 +0100
Message-ID: <20260115164300.138423573@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


