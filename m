Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157874F68C3;
	Wed, 30 Sep 2026 15:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783055; cv=none; b=ozzwd2zYO9rwSWJkf/kZE1mJtUMOvBXp7zy5MPgSQ7RXbLw/+A11ikOU7UeXRoN6Iu9xwOV+BIKQnrrsMulxSPy0aHwbVGrxGUMPJCvec5CRopzluVE07WGLEo8EFbQIQC73kK6l+GvIAdVlOoJWAJ0YW2v0wiqxA+jF/sZSIk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783055; c=relaxed/simple;
	bh=5ROrPfK3afVyVPOjDmoTDCKuX61GqO8TWkd3VffvV+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLaLq+fnqDDdimogr1iNomEbWIeEvAUDs4uEoHquCZEjxE+olsbEwCIj7SVSkpVvyL1YABPRWBslWwq/yG0B+brWZP13nQsk/Zjt4GLdfjosn80SVhzMSWgI2iSrigdkhfQqkeNFRKvYYJ492zKEe8j7WGv44Y/Tii6paksD/h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqQSaDWx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqQSaDWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E395C1F000FF;
	Wed, 30 Sep 2026 15:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783049;
	bh=QgVwRzjWlWFv2qyino0F9gfZkwbzGslbC+Lz2sgVuck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pqQSaDWxZbT/fPx6i+/9pUfukKy62w1sPjIq/xcucHEC0w7k2kjRIxvF+VgInNRlI
	 xEGs1swXBvPH+DnQde7uBesDLOM6zq6vxHpWMYpJPSKotuaGQsH1UGzcIZSknFF2Rf
	 Asx47AC9kCoW3MfrG8MLAIqqclGWpTNeX4WaqarQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paul Mackerras <paulus@samba.org>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Jiri Slaby <jslaby@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 207/595] tty: make tty_ldisc_ops::hangup return void
Date: Wed, 30 Sep 2026 17:21:40 +0200
Message-ID: <20260930152352.187356687@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit 28f194da4a2c4d431552025a4386edaffab181bd ]

The documentation says that the return value of tty_ldisc_ops::hangup
hook is ignored. And it really is, so there is no point for its return
type to be int. Switch it to void and all the hooks too.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Acked-by: Mark Brown <broonie@kernel.org>
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20210914091134.17426-4-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 9feb069e5ed0 ("ppp: ppp_async: simplify tty disc_data access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/driver-api/serial/tty.rst | 2 +-
 drivers/input/serio/serport.c           | 3 +--
 drivers/net/can/slcan.c                 | 3 +--
 drivers/net/ppp/ppp_async.c             | 3 +--
 drivers/net/ppp/ppp_synctty.c           | 3 +--
 drivers/net/slip/slip.c                 | 3 +--
 include/linux/tty_ldisc.h               | 2 +-
 sound/soc/codecs/cx20442.c              | 3 +--
 sound/soc/ti/ams-delta.c                | 3 +--
 9 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/Documentation/driver-api/serial/tty.rst b/Documentation/driver-api/serial/tty.rst
index dd972caacf3ee..4b709f392713d 100644
--- a/Documentation/driver-api/serial/tty.rst
+++ b/Documentation/driver-api/serial/tty.rst
@@ -58,7 +58,7 @@ close()			This is called on a terminal when the line
 hangup()		Called when the tty line is hung up.
 			The line discipline should cease I/O to the tty.
 			No further calls into the ldisc code will occur.
-			The return value is ignored. Can sleep.
+			Can sleep.
 
 read()			(optional) A process requests reading data from
 			the line. Multiple read calls may occur in parallel
diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index 33e9d9bfd036f..1016cc95fffd1 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -243,7 +243,7 @@ static int serport_ldisc_compat_ioctl(struct tty_struct *tty,
 }
 #endif
 
-static int serport_ldisc_hangup(struct tty_struct *tty)
+static void serport_ldisc_hangup(struct tty_struct *tty)
 {
 	struct serport *serport = (struct serport *) tty->disc_data;
 	unsigned long flags;
@@ -253,7 +253,6 @@ static int serport_ldisc_hangup(struct tty_struct *tty)
 	spin_unlock_irqrestore(&serport->lock, flags);
 
 	wake_up_interruptible(&serport->wait);
-	return 0;
 }
 
 static void serport_ldisc_write_wakeup(struct tty_struct * tty)
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 972827db819a5..d1833aafc40cd 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -662,10 +662,9 @@ static void slcan_close(struct tty_struct *tty)
 	/* This will complete via sl_free_netdev */
 }
 
-static int slcan_hangup(struct tty_struct *tty)
+static void slcan_hangup(struct tty_struct *tty)
 {
 	slcan_close(tty);
-	return 0;
 }
 
 /* Perform I/O control on an active SLCAN channel. */
diff --git a/drivers/net/ppp/ppp_async.c b/drivers/net/ppp/ppp_async.c
index 86bd14220aa0a..ffc74744a7fe7 100644
--- a/drivers/net/ppp/ppp_async.c
+++ b/drivers/net/ppp/ppp_async.c
@@ -247,10 +247,9 @@ ppp_asynctty_close(struct tty_struct *tty)
  * Wait for I/O to driver to complete and unregister PPP channel.
  * This is already done by the close routine, so just call that.
  */
-static int ppp_asynctty_hangup(struct tty_struct *tty)
+static void ppp_asynctty_hangup(struct tty_struct *tty)
 {
 	ppp_asynctty_close(tty);
-	return 0;
 }
 
 /*
diff --git a/drivers/net/ppp/ppp_synctty.c b/drivers/net/ppp/ppp_synctty.c
index 11725cab4912b..85b0ac03a1c39 100644
--- a/drivers/net/ppp/ppp_synctty.c
+++ b/drivers/net/ppp/ppp_synctty.c
@@ -245,10 +245,9 @@ ppp_sync_close(struct tty_struct *tty)
  * Wait for I/O to driver to complete and unregister PPP channel.
  * This is already done by the close routine, so just call that.
  */
-static int ppp_sync_hangup(struct tty_struct *tty)
+static void ppp_sync_hangup(struct tty_struct *tty)
 {
 	ppp_sync_close(tty);
-	return 0;
 }
 
 /*
diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index 0373e3253e583..9c04e327c26af 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -915,10 +915,9 @@ static void slip_close(struct tty_struct *tty)
 	/* sl_uninit() has dropped the slip_devs[] entry by now */
 }
 
-static int slip_hangup(struct tty_struct *tty)
+static void slip_hangup(struct tty_struct *tty)
 {
 	slip_close(tty);
-	return 0;
 }
  /************************************************************************
   *			STANDARD SLIP ENCAPSULATION		  	 *
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index 572a079761165..18a2c0c8ac4d7 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -196,7 +196,7 @@ struct tty_ldisc_ops {
 	void	(*set_termios)(struct tty_struct *tty, struct ktermios *old);
 	__poll_t (*poll)(struct tty_struct *, struct file *,
 			     struct poll_table_struct *);
-	int	(*hangup)(struct tty_struct *tty);
+	void	(*hangup)(struct tty_struct *tty);
 
 	/*
 	 * The following routines are called from below.
diff --git a/sound/soc/codecs/cx20442.c b/sound/soc/codecs/cx20442.c
index 161be8b7d1317..3a23d4a0ee0c6 100644
--- a/sound/soc/codecs/cx20442.c
+++ b/sound/soc/codecs/cx20442.c
@@ -252,10 +252,9 @@ static void v253_close(struct tty_struct *tty)
 }
 
 /* Line discipline .hangup() */
-static int v253_hangup(struct tty_struct *tty)
+static void v253_hangup(struct tty_struct *tty)
 {
 	v253_close(tty);
-	return 0;
 }
 
 /* Line discipline .receive_buf() */
diff --git a/sound/soc/ti/ams-delta.c b/sound/soc/ti/ams-delta.c
index fbd75732a68b3..b83e36db6367f 100644
--- a/sound/soc/ti/ams-delta.c
+++ b/sound/soc/ti/ams-delta.c
@@ -332,10 +332,9 @@ static void cx81801_close(struct tty_struct *tty)
 }
 
 /* Line discipline .hangup() */
-static int cx81801_hangup(struct tty_struct *tty)
+static void cx81801_hangup(struct tty_struct *tty)
 {
 	cx81801_close(tty);
-	return 0;
 }
 
 /* Line discipline .receive_buf() */
-- 
2.53.0



