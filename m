Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A33A35BDC3;
	Fri,  9 Jan 2026 12:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962716; cv=none; b=dtFZtC7HpIy80vsYJG0VAExiL8RzKvbRYRe2GLuSibuAxQ1U90c5ATXF8p4ckeuRchDHomyJbAaLCAcRstB5SZeZTOKs6qtFdx9+lR3Ac+P1JIndA63ICAcWHGO362AAAD48Ez7CDi0U5267xjCOislszgiCoXlXo+l/b86fzi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962716; c=relaxed/simple;
	bh=fEOeyCQOka/7qhR6XfrQq/Tno3EJV8gHo/5QN2PNri4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=piTjwfZ4FtA3CojYcwVDRl3wWD+FOjXhJw/PT+oUd1b3AyBU80XpV9FfjRZiCncItKYZNMLoqlR4J+N2UP1AN1OJe+3IfQS2zELF4xWvavc+MAgLQz0mO8CMTGd/0f75AXa0RhcJrHmVaht6ygW/vicED6SkN+5jUJkgrn2zIP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nCr42Emf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nCr42Emf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADE4C4CEF1;
	Fri,  9 Jan 2026 12:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962715;
	bh=fEOeyCQOka/7qhR6XfrQq/Tno3EJV8gHo/5QN2PNri4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCr42EmfRBx/EJHWKgnMwLQw6AzTXszJGNgGHZEFxTQQNH2bc4IFWWRsZV1+HiC84
	 3A/zAVdu6NH5K0YI3VwxH9Dc1a23iL199UOBgZpMEayKIjYdTdb/6wyyElq/IGlQyG
	 S37bLaWg+TUk4FS5lf3bDqTrrCz95OharLTFtiLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hitz <christian.hitz@bbv.ch>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 463/634] leds: leds-lp50xx: LP5009 supports 3 modules for a total of 9 LEDs
Date: Fri,  9 Jan 2026 12:42:21 +0100
Message-ID: <20260109112134.972419367@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


