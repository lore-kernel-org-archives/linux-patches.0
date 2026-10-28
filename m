Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212070;
	b=xFFaEorEXDcySUtl4xmtpIeW6ebuTQNXLzk4T9nxla+8JzEfYo3PnuEsZvb3PuOZkXXI
	 wlOKGwCM3Ub/XvMf+gIwpZzjq2z65Q62A5ctcVr51hx95RKclXPujqQs6ul+wki9+6rB4
	 25jf+iT7/mzzMbJpTn4wBQi0eg42wynlG3dsklOlmOIephB8zn3BD8bAk8HtIMsdLe98X
	 Ni2QKNmY95wlINg8I43rX1rZzFIvydRMc+cmEVS9TkQOQ0GaYxTTVEggyndsbdZHWnSsm
	 vuIjtCsjY83kXJ8koHZHUE7u9RJOgBKjoYNyWeodTMo/A2AdX/Bc1JWvbXAXrubDNwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=drzyxQA4H/fkfBqZOlhbrY+sy/ViaUkogKwbLHoiVvg=;
	b=0JRzq9jIwOCbryBajqNjKTFOTds3+AYq2eqB+NTpK+XGtqV3hBEqSisFCCBixNPSapLj
	 lrU+RAOFoND2UIhrUKB1SigKbbi6+wVbAcCu1utUSwYp30ugrrhXR8fSYm8sFLi4FQy1L
	 3P1ktHkzDtPq1A13vX9rSJisE9BKoaNLHFmN86X9s7dEEcFSkiFk7oqN6zwQFYb0oDGGo
	 uwwl02GT6Ma4e5gHpThLuRWfLvudC9lg2GwRyHnqVGQb34D7VrydeQSbKof49QjNh5T6N
	 XFFHyN3U1X2bqbx/v2JyTtuf05s+AlIshiPOqSfrDr4sJai7fmzWQAVa7gHlwCTxH9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AntnKlJj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6166B606A31A;
	Wed, 28 Oct 2026 18:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AntnKlJj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B5D1F01825;
	Wed, 28 Oct 2026 18:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212070;
	bh=drzyxQA4H/fkfBqZOlhbrY+sy/ViaUkogKwbLHoiVvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AntnKlJjZroKfhuVsXUh2kawGlymrFAXGhGT7Nxdgm0YE5QqwlJ1m+4MbZLcrG+uc
	 0kDm9SHbRaBnQuYr/MvQ3cOHVYBtx2DjSu7AMg6eRmJWq4kyXEhuC7mW5ymCAjzrMU
	 lPKq/oCYrziYfXy98oyNbRksN2k471cj/wtvR5p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0028/1887] HID: sony: fix UAF of ghl_poke_timer / ghl_urb at driver unbind
Date: Wed, 28 Oct 2026 17:35:24 +0100
Message-ID: <20261028170459.865910143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doruk Tan Ozturk <doruk@0sec.ai>

[ Upstream commit a26705bd2e2728833e7a538ce91e58a5eeff496a ]

For GHL (Guitar Hero Live) dongles, sony_probe() arms a periodic timer:
ghl_magic_poke() (the timer callback) submits sc->ghl_urb, and the URB
completion ghl_magic_poke_cb() re-arms the timer with mod_timer().

sony_remove() drained the timer with timer_delete_sync() and then freed
the URB with usb_free_urb():

	timer_delete_sync(&sc->ghl_poke_timer);
	usb_free_urb(sc->ghl_urb);

timer_delete_sync() does not block re-arming, and while the URB is in
flight the timer is not pending, so the sync delete is a no-op. A URB
completion that runs after the delete re-arms the timer, and usb_free_urb()
only drops a reference -- it does not kill an in-flight URB. sc is
allocated with devm_kzalloc() and freed once sony_remove() returns, so the
re-armed ghl_poke_timer (embedded in sc) then fires on freed memory, a
use-after-free from timer softirq. This is a disconnect/rmmod race.

Poison the URB first, then shut the timer down, before freeing the URB.
usb_poison_urb() kills any in-flight URB and permanently rejects further
submissions, so a poke timer that is still pending cannot re-submit the
URB from ghl_magic_poke() in the window before timer_shutdown_sync() runs.
usb_kill_urb() would not suffice: it only cancels the in-flight URB and
leaves it submittable once it returns, so the pending timer could
re-submit it and put a fresh URB in flight over the freed sc.
timer_shutdown_sync() then drains any last callback and blocks re-arming.
The probe error path is unaffected: it is only reached before the timer
is armed.

Reproduced under KASAN on next-20260710 via dummy_hcd + raw-gadget
emulation of the GHL PS4 dongle (VID 0x1430 / PID 0x07bb): hid-sony binds
and arms the poke timer, the poke URB is held in flight, the driver is
unbound (freeing sc), then the URB is released. The completion re-arms the
timer on the freed sc, and the re-armed timer fires ~8 s later:

  BUG: KASAN: slab-use-after-free in ghl_magic_poke+0x98/0xb0
  Read of size 8 at addr ffff88810b02fd50 by task swapper/0/0
   ghl_magic_poke+0x98/0xb0
   call_timer_fn+0x35/0x2b0
   __run_timers+0x69c/0x9a0
   run_timer_softirq+0x173/0x2a0
  Allocated by task 169:  sony_probe
  Freed by task 338:      devres_release_group <- hid_device_remove (sony_remove)

Found by 0sec (https://0sec.ai) using automated source analysis.

Fixes: cc894ac55360 ("HID: sony: support for ghlive ps3/wii u dongles")
Cc: stable@vger.kernel.org
Assisted-by: 0sec:multi-model
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[ changed the old del_timer_sync() call to timer_shutdown_sync() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-sony.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index f7f7252d839ee..01745b5df2e4e 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -3085,7 +3085,9 @@ static void sony_remove(struct hid_device *hdev)
 	struct sony_sc *sc = hid_get_drvdata(hdev);
 
 	if (sc->quirks & (GHL_GUITAR_PS3WIIU | GHL_GUITAR_PS4)) {
-		del_timer_sync(&sc->ghl_poke_timer);
+		/* poison, not kill: a pending timer must not re-submit during teardown */
+		usb_poison_urb(sc->ghl_urb);
+		timer_shutdown_sync(&sc->ghl_poke_timer);
 		usb_free_urb(sc->ghl_urb);
 	}
 
-- 
2.53.0



