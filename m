Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC1D1EC00E;
	Wed,  6 Nov 2024 12:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897091; cv=none; b=F4AMdOhC6hZW/7U3VUxG3uQs1kv9QMiCehfRPdvdc3nHiMxbxr6GbIvyq8xWoxpjHGyc6YlM/Ix6DECCxMthDaTPcoxAY14G1pYzLjSmu9MZXvuqbKJpHCHFLGULmCu960FhNW+P8/65thmYXac0EaEygcRmEFZElnoSF/B//N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897091; c=relaxed/simple;
	bh=pPzeuPjorpWpwOvl92GfV6AZ+QWUY5u3rGLMWXxTBK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJsVSHMvFffHsQsFNhev1thAZXqOqoDj3LiHSNZXLMCWAG1fxxDRiC0fZAr3fs6inKaGKEFDyAGJE1O+CGdtuWKN7N9aYaAhnP423AfS+zcUKR3lf83OiEJEsGlPmMdRhKlLjcTEbNQrOOjDRbI7xsMgtNf10gfQP1vUNDiQEPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xBhpcyg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xBhpcyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BBAC4CECD;
	Wed,  6 Nov 2024 12:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897091;
	bh=pPzeuPjorpWpwOvl92GfV6AZ+QWUY5u3rGLMWXxTBK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xBhpcygTUWCEfpv2FD30+B+PkvBEfu6IpPZIz9cStHJBhCSuehRy/NQox0ACJOYp
	 /NfGxieZi2XOgV6hltkzQ+gnotrec4DyEk3jAwZAbrGxB/wUwDCbt7EcNZDyKThUNy
	 0ai8BWtbQ7RXoPQqST5m3lrmXzIPi3MFQZUskxyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcello Sylvester Bauer <marcello.bauer@9elements.com>,
	Marcello Sylvester Bauer <sylv@sylv.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/126] usb: gadget: dummy_hcd: Set transfer interval to 1 microframe
Date: Wed,  6 Nov 2024 13:04:23 +0100
Message-ID: <20241106120307.770826012@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marcello Sylvester Bauer <sylv@sylv.io>

[ Upstream commit 0a723ed3baa941ca4f51d87bab00661f41142835 ]

Currently, the transfer polling interval is set to 1ms, which is the
frame rate of full-speed and low-speed USB. The USB 2.0 specification
introduces microframes (125 microseconds) to improve the timing
precision of data transfers.

Reducing the transfer interval to 1 microframe increases data throughput
for high-speed and super-speed USB communication

Signed-off-by: Marcello Sylvester Bauer <marcello.bauer@9elements.com>
Signed-off-by: Marcello Sylvester Bauer <sylv@sylv.io>
Link: https://lore.kernel.org/r/6295dbb84ca76884551df9eb157cce569377a22c.1712843963.git.sylv@sylv.io
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/dummy_hcd.c b/drivers/usb/gadget/udc/dummy_hcd.c
index 4f9c6e86456fe..32a03de215d37 100644
--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -50,6 +50,8 @@
 #define POWER_BUDGET	500	/* in mA; use 8 for low-power port testing */
 #define POWER_BUDGET_3	900	/* in mA */
 
+#define DUMMY_TIMER_INT_NSECS	125000 /* 1 microframe */
+
 static const char	driver_name[] = "dummy_hcd";
 static const char	driver_desc[] = "USB Host+Gadget Emulator";
 
@@ -1303,7 +1305,7 @@ static int dummy_urb_enqueue(
 
 	/* kick the scheduler, it'll do the rest */
 	if (!hrtimer_active(&dum_hcd->timer))
-		hrtimer_start(&dum_hcd->timer, ms_to_ktime(1), HRTIMER_MODE_REL);
+		hrtimer_start(&dum_hcd->timer, ns_to_ktime(DUMMY_TIMER_INT_NSECS), HRTIMER_MODE_REL);
 
  done:
 	spin_unlock_irqrestore(&dum_hcd->dum->lock, flags);
@@ -1994,7 +1996,7 @@ static enum hrtimer_restart dummy_timer(struct hrtimer *t)
 		dum_hcd->udev = NULL;
 	} else if (dum_hcd->rh_state == DUMMY_RH_RUNNING) {
 		/* want a 1 msec delay here */
-		hrtimer_start(&dum_hcd->timer, ms_to_ktime(1), HRTIMER_MODE_REL);
+		hrtimer_start(&dum_hcd->timer, ns_to_ktime(DUMMY_TIMER_INT_NSECS), HRTIMER_MODE_REL);
 	}
 
 	spin_unlock_irqrestore(&dum->lock, flags);
-- 
2.43.0



