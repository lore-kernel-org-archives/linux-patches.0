Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214558;
	b=c9MZplKZiFDvXOQ8useRLvwecyk3PCdeKXtOT8CFnmEF0ie+/l8YBuB28dbuwvNLl/8r
	 GC+ETXNewyqINg/sfnNUQQhK4VpF+suhOW2Yfsky6tgJCMxvknqCJHB9a5uiaKfXbStem
	 GMWNqzZhtqFwbfd2rngLSfsqLqFToTJGWZ+Hg2dujLN2bDUJGpt7XepsjVYuGP/CDbC87
	 jcT5tgZkn7qYL5VadjMfrgdo1dnCkItewSNYDVT5IC1m66rkSQliWVD2nXOwy+7zWvgPm
	 GabFz06P/lC0LT0i0eTJ0VOCWuLafe8ddLvdsQ5yOXRJ0pion8QSWbH8uC4oYQKD6bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=av4mn03WTHrU+itXJhRvD9ZIEHh22J+GkAzDMEqfWqo=;
	b=QJeu82+WVQSg/7aAuAe7LiFCLqPGumskZNXY1lUfY1axlNMzZh7qT870dvhWnl7zVDvb
	 Tz2SgtKghQwarjZCFtjr8FUGMZDVkGAxtwk/p5Ub4IiL6VyaxZacYXEpvjgXBTOAm3ykQ
	 LSXxx92ff3LaN1N0oDJjyyhr8kZ8dmqAC4mrYSsWCngPfbPocuiVTWJgRKUFtTcDLnjnK
	 KGwyOEXueiNnYTZsQeAsQ+AXL/hsKzkg2g7pd9Y+u3RzfToc2kT015JcFh2hOvDF9AMHP
	 pfmAwCPrbwc7TWoVwCV5as7qP3eZm1btrqAQxPzlfJJFBVfaQv2Aj9H/xHYXIre465A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iYqnPSDp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3EE606A335;
	Wed, 28 Oct 2026 19:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iYqnPSDp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD9E1F01825;
	Wed, 28 Oct 2026 19:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214558;
	bh=av4mn03WTHrU+itXJhRvD9ZIEHh22J+GkAzDMEqfWqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iYqnPSDprJoNFHkCS/sYbnVUhP6WupFPOeQDQo1Gdh3yHErPutMxLbcz1pi87ghBj
	 XE9L7ps7j5ZHUYT5dchphoKlMFAKj2FbICaL91QYbJB6r7+6qCsRgFbeJDa2wlFwZp
	 NMC+c3yMVCqgLAvGe8wsokeORpJvYeuuEaI2mAYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seppo Takalo <seppo.takalo@nordicsemi.no>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0858/1887] tty: n_gsm: Dont block input queue by waiting MSC
Date: Wed, 28 Oct 2026 17:49:14 +0100
Message-ID: <20261028170518.947482217@linuxfoundation.org>
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

From: Seppo Takalo <seppo.takalo@nordicsemi.no>

[ Upstream commit 3cf0b3c243e56bc43be560617416c1d9f301f44c ]

Currently gsm_queue() processes incoming frames and when opening
a DLC channel it calls gsm_dlci_open() which calls gsm_modem_update().
If basic mode is used it calls gsm_modem_upd_via_msc() and it
cannot block the input queue by waiting the response to come
into the same input queue.

Instead allow sending Modem Status Command without waiting for remote
end to respond. Define a new function gsm_modem_send_initial_msc()
for this purpose. As MSC is only valid for basic encoding, it does
not do anything for advanced or when convergence layer type 2 is used.

Fixes: 48473802506d ("tty: n_gsm: fix missing update of modem controls after DLCI open")
Signed-off-by: Seppo Takalo <seppo.takalo@nordicsemi.no>
Link: https://lore.kernel.org/r/20250827123221.1148666-1-seppo.takalo@nordicsemi.no
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 374d013eada6e..db9382b573000 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -420,6 +420,7 @@ static struct gsm_msg *gsm_data_alloc(struct gsm_mux *gsm, u8 addr, int len,
 static int gsm_send_packet(struct gsm_mux *gsm, struct gsm_msg *msg);
 static void gsmld_write_trigger(struct gsm_mux *gsm);
 static void gsmld_write_task(struct work_struct *work);
+static int gsm_modem_send_initial_msc(struct gsm_dlci *dlci);
 
 /**
  *	gsm_fcs_add	-	update FCS
@@ -1834,7 +1835,7 @@ static void gsm_dlci_open(struct gsm_dlci *dlci)
 		pr_debug("DLCI %d goes open.\n", dlci->addr);
 	/* Send current modem state */
 	if (dlci->addr)
-		gsm_modem_update(dlci, 0);
+		gsm_modem_send_initial_msc(dlci);
 	gsm_dlci_data_kick(dlci);
 	wake_up(&dlci->gsm->event);
 }
@@ -3490,6 +3491,28 @@ static int gsm_modem_upd_via_msc(struct gsm_dlci *dlci, u8 brk)
 	return gsm_control_wait(dlci->gsm, ctrl);
 }
 
+/**
+ * gsm_modem_send_initial_msc - Send initial modem status message
+ *
+ * @dlci channel
+ *
+ * Send an initial MSC message after DLCI open to set the initial
+ * modem status lines. This is only done for basic mode.
+ * Does not wait for a response as we cannot block the input queue
+ * processing.
+ */
+static int gsm_modem_send_initial_msc(struct gsm_dlci *dlci)
+{
+	u8 modembits[2];
+
+	if (dlci->adaption != 1 || dlci->gsm->encoding != GSM_BASIC_OPT)
+		return 0;
+
+	modembits[0] = (dlci->addr << 2) | 2 | EA; /* DLCI, Valid, EA */
+	modembits[1] = (gsm_encode_modem(dlci) << 1) | EA;
+	return gsm_control_command(dlci->gsm, CMD_MSC, (const u8 *)&modembits, 2);
+}
+
 /**
  *	gsm_modem_update	-	send modem status line state
  *	@dlci: channel
-- 
2.53.0



