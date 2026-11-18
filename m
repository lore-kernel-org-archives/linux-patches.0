Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044119;
	b=yOWIGre1PHHszqre82DNacK2XAgCrxFSpdE5wlZLdTDSrAnYEMjEed6ykQVsiJo/8xWb
	 2VV7fELmhmKqW5c013TFMAlI6H2nQY2mYUmvXyniMNPpQYyPziMevtxMjDj6Qj+Nmd9LS
	 kSd6TMVW4GyseWXBIRnH/Fun1zVwbKUM459JMwlwHOvP/ScPBlpvsRviHtxHeFDdLV31K
	 K65qWW4GjEupzvNuC6hjrUlTpdKoqt/aQuS6aMH039ZYdhu6RUQsATdeyHTMmCBXxlVAV
	 ucEW+zcH3nxUteZ+za9ftb8lYSkGOALLc4efsppjQKZhWrrsjjMrbYSgBm8GqmSUhEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=28rrBrjHQPTBT1ODGLA681bZxZWnzufKPgMca8MQpEA=;
	b=d+OTS6/DlY3vt7Aw2K908VbppplhEVdPSDtcNWaomDYzKDMBVTNy6YhLacCHINERnKyo
	 87Mm4fpFpplEVWuse0KFLvfcqhsetqOZchK95BTCGwKF4SpbtHNlfTKOozXZmWcoDoIVQ
	 cSBr273O99/vHTe2PmINbXJPAApKw4M8TDCoILMQRKq4cqOASQKyeVZqSnL8BhoZSUxTt
	 XBIHG1ogSwV3Vr5djYl0MdCpvH883MTik53odPu2TSri+MSVQzkddkTARg9w9AUcv89kZ
	 onGTHZcU226+btpZC4FV8MFuZhTDHPzhBchq4uU2IDOU4891XGuBHCqGZ3qeeBRQ1ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OuQpERZj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0726606A31C;
	Wed, 18 Nov 2026 23:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OuQpERZj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1821F000C4;
	Wed, 18 Nov 2026 23:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044119;
	bh=28rrBrjHQPTBT1ODGLA681bZxZWnzufKPgMca8MQpEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OuQpERZjFhCcSCGkNPXMtGC34L5MpALv+fD9ww5ScpxrRYPduHyxCUTiJCyYfmOi3
	 rf/SLyz+G6kQM3uoX50cqmESPDj7m05Ufj8ZIAHyykLJ8xBSHuM/QtLGRSs0qRp4GB
	 8g/Yyd7tN9G9labGwfrczjFLWiwaKu2PsYEKIZFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Daniel Starke <daniel.starke@siemens.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0452/2857] tty: n_gsm: fix missing modem controls after DLCI open in convergence layer type 2
Date: Wed, 18 Nov 2026 15:24:46 +0100
Message-ID: <20261118150217.655816796@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Daniel Starke <daniel.starke@siemens.com>

[ Upstream commit 11ea5a63d30ad6d305b1c22301cd99ff45a98c8d ]

The current implementation only updates the virtual V.24 control signals
after DLCI open in basic option mode. In advanced option mode with
convergence layer type 2 an empty data frame needs to be transmitted to
inform the peer about the initial virtual V.24 control signals. Not doing
so has two unwanted side effects:
1. hardware flow control status is unclear (initial CTS line is unknown)
2. DLCI user presence is not transmitted (initial DTR line is unknown)

Applications waiting on these lines can not start after a DLCI has been
opened until the first data frame has been transmitted.

Fix this by using gsm_modem_update() thoroughly which handles basic and
advanced option mode correctly. Add a flag in gsm_modem_update() and the
delegated gsm_modem_upd_via_msc() to control whether waiting for the MSC
command response is possible. Remove obsolete gsm_modem_send_initial_msc().

Fixes: 3cf0b3c243e5 ("tty: n_gsm: Don't block input queue by waiting MSC")
Cc: stable <stable@kernel.org>
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://patch.msgid.link/20260826063026.2472-1-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: Kept the tree's if (dlci->addr) form in gsm_dlci_open() without upstream's DLCI 0 keep-alive else branch, and deleted the helper whose comment text differs. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 47 ++++++++++++++-------------------------------
 1 file changed, 14 insertions(+), 33 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index db9382b573000..9d354a3260bf6 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -414,13 +414,12 @@ static const u8 gsm_fcs8[256] = {
 #define GOOD_FCS	0xCF
 
 static int gsmld_output(struct gsm_mux *gsm, u8 *data, int len);
-static int gsm_modem_update(struct gsm_dlci *dlci, u8 brk);
+static int gsm_modem_update(struct gsm_dlci *dlci, u8 brk, bool wait);
 static struct gsm_msg *gsm_data_alloc(struct gsm_mux *gsm, u8 addr, int len,
 								u8 ctrl);
 static int gsm_send_packet(struct gsm_mux *gsm, struct gsm_msg *msg);
 static void gsmld_write_trigger(struct gsm_mux *gsm);
 static void gsmld_write_task(struct work_struct *work);
-static int gsm_modem_send_initial_msc(struct gsm_dlci *dlci);
 
 /**
  *	gsm_fcs_add	-	update FCS
@@ -1835,7 +1834,7 @@ static void gsm_dlci_open(struct gsm_dlci *dlci)
 		pr_debug("DLCI %d goes open.\n", dlci->addr);
 	/* Send current modem state */
 	if (dlci->addr)
-		gsm_modem_send_initial_msc(dlci);
+		gsm_modem_update(dlci, 0, false);
 	gsm_dlci_data_kick(dlci);
 	wake_up(&dlci->gsm->event);
 }
@@ -3466,9 +3465,10 @@ static void gsm_modem_upd_via_data(struct gsm_dlci *dlci, u8 brk)
  *	gsm_modem_upd_via_msc	-	send modem bits via control frame
  *	@dlci: channel
  *	@brk: break signal
+ *	@wait: wait for the MSC command
  */
 
-static int gsm_modem_upd_via_msc(struct gsm_dlci *dlci, u8 brk)
+static int gsm_modem_upd_via_msc(struct gsm_dlci *dlci, u8 brk, bool wait)
 {
 	u8 modembits[3];
 	struct gsm_control *ctrl;
@@ -3485,41 +3485,22 @@ static int gsm_modem_upd_via_msc(struct gsm_dlci *dlci, u8 brk)
 		modembits[2] = (brk << 4) | 2 | EA; /* Length, Break, EA */
 		len++;
 	}
+	if (!wait)
+		return gsm_control_command(dlci->gsm, CMD_MSC, modembits, len);
 	ctrl = gsm_control_send(dlci->gsm, CMD_MSC, modembits, len);
 	if (ctrl == NULL)
 		return -ENOMEM;
 	return gsm_control_wait(dlci->gsm, ctrl);
 }
 
-/**
- * gsm_modem_send_initial_msc - Send initial modem status message
- *
- * @dlci channel
- *
- * Send an initial MSC message after DLCI open to set the initial
- * modem status lines. This is only done for basic mode.
- * Does not wait for a response as we cannot block the input queue
- * processing.
- */
-static int gsm_modem_send_initial_msc(struct gsm_dlci *dlci)
-{
-	u8 modembits[2];
-
-	if (dlci->adaption != 1 || dlci->gsm->encoding != GSM_BASIC_OPT)
-		return 0;
-
-	modembits[0] = (dlci->addr << 2) | 2 | EA; /* DLCI, Valid, EA */
-	modembits[1] = (gsm_encode_modem(dlci) << 1) | EA;
-	return gsm_control_command(dlci->gsm, CMD_MSC, (const u8 *)&modembits, 2);
-}
-
 /**
  *	gsm_modem_update	-	send modem status line state
  *	@dlci: channel
  *	@brk: break signal
+ *	@wait: wait for the MSC command
  */
 
-static int gsm_modem_update(struct gsm_dlci *dlci, u8 brk)
+static int gsm_modem_update(struct gsm_dlci *dlci, u8 brk, bool wait)
 {
 	if (dlci->gsm->dead)
 		return -EL2HLT;
@@ -3529,7 +3510,7 @@ static int gsm_modem_update(struct gsm_dlci *dlci, u8 brk)
 		return 0;
 	} else if (dlci->gsm->encoding == GSM_BASIC_OPT) {
 		/* Send as MSC control message. */
-		return gsm_modem_upd_via_msc(dlci, brk);
+		return gsm_modem_upd_via_msc(dlci, brk, wait);
 	}
 
 	/* Modem status lines are not supported. */
@@ -3568,7 +3549,7 @@ static void gsm_dtr_rts(struct tty_port *port, int onoff)
 		modem_tx &= ~(TIOCM_DTR | TIOCM_RTS);
 	if (modem_tx != dlci->modem_tx) {
 		dlci->modem_tx = modem_tx;
-		gsm_modem_update(dlci, 0);
+		gsm_modem_update(dlci, 0, true);
 	}
 }
 
@@ -3760,7 +3741,7 @@ static int gsmtty_tiocmset(struct tty_struct *tty,
 
 	if (modem_tx != dlci->modem_tx) {
 		dlci->modem_tx = modem_tx;
-		return gsm_modem_update(dlci, 0);
+		return gsm_modem_update(dlci, 0, true);
 	}
 	return 0;
 }
@@ -3822,7 +3803,7 @@ static void gsmtty_throttle(struct tty_struct *tty)
 		dlci->modem_tx &= ~TIOCM_RTS;
 	dlci->throttled = true;
 	/* Send an MSC with RTS cleared */
-	gsm_modem_update(dlci, 0);
+	gsm_modem_update(dlci, 0, true);
 }
 
 static void gsmtty_unthrottle(struct tty_struct *tty)
@@ -3834,7 +3815,7 @@ static void gsmtty_unthrottle(struct tty_struct *tty)
 		dlci->modem_tx |= TIOCM_RTS;
 	dlci->throttled = false;
 	/* Send an MSC with RTS set */
-	gsm_modem_update(dlci, 0);
+	gsm_modem_update(dlci, 0, true);
 }
 
 static int gsmtty_break_ctl(struct tty_struct *tty, int state)
@@ -3852,7 +3833,7 @@ static int gsmtty_break_ctl(struct tty_struct *tty, int state)
 		if (encode > 0x0F)
 			encode = 0x0F;	/* Best effort */
 	}
-	return gsm_modem_update(dlci, encode);
+	return gsm_modem_update(dlci, encode, true);
 }
 
 static void gsmtty_cleanup(struct tty_struct *tty)
-- 
2.53.0



