Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214538;
	b=vOSCoJRt9DJFZMosFk5ETWV71i9yrG2CxB0UzQBAKhyZ/jgt6wKjHN0AIKumJUQBGS9Y
	 L0disK0ZcRaAl51R3bCJD5smi7tURTMx/oYlcdTxccRV84YTJzHO3BBl6ZE4XueWCyLYH
	 8E3Hy2HhqVST/QPanZMNmDuwYLpGUgGAbOGmlgVo7m+UOziMN11THXiROKw5oAxIk7sFN
	 h9CDjF51KzHPmkw0X+1YllCs7E/5L6nI+/RBjNC8O5JvaFxFipVKqDAdlrlm5H708zcEY
	 QaFleohTKuxfBejGiPlZCVnShlDlBq7SF+nurJGo1PgKON9+RpAw7epnq1XBxJxzIDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AXVxra/Ldazn0B6eP9u2Jcr4IMdRthCeuUArCOPxex0=;
	b=ZSR5gj4MR7owSDxavVsjzfTWscd/JWCD1JqnX7g93AMDreXIX2+zBtbQFXaTq2GLFqv5
	 Nbz8P8aJ2X2o7yxmd78XI8zmTHBdbkYhmpLAEIF26kXZNMdoVQJdvMIm1ep3s+IeURD1Y
	 5iFuhLRCVFtmFGzXizb5WuKTtluTzZN2MtKu7J3ByvAfck6BvIPcsT7SpQrFNbL7VBZdp
	 Sg/c9r720SQziY+fdcBPkZGI7FN/BZWptbbYwKD+Wob/gE/lfEv4vnkpn24s/83jkgSQV
	 xCK/bS/CXZaGvldkc6BpY+BsSBafbjjPf3uwlKkUJxt+yPHIhiVwLGhSmLau+nGQfRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kTPnE2Zm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735AF60A260C;
	Wed, 28 Oct 2026 19:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kTPnE2Zm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AFF1F01825;
	Wed, 28 Oct 2026 19:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214538;
	bh=AXVxra/Ldazn0B6eP9u2Jcr4IMdRthCeuUArCOPxex0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kTPnE2ZmHiD6BAGXRyl2lKfbTuZD3GDHW4ongRKewHHYYFm8WKIB4uiW8bZ39vE5A
	 eO4hWnWNRuzzRL71zXX+TjALMJfeZbYyh98tDz/DYWTr7bPa5kRURbmoNwqvAve0Fk
	 nrtRf11suuHUdHzfP4RikjqhNzpBe+YOuU2SwGGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Starke <daniel.starke@siemens.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0857/1887] tty: n_gsm: add parameters used with parameter negotiation
Date: Wed, 28 Oct 2026 17:49:13 +0100
Message-ID: <20261028170518.925385050@linuxfoundation.org>
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

From: Daniel Starke <daniel.starke@siemens.com>

[ Upstream commit 2ec7a802a04c545ceea96bf67ee818d8bb0349e2 ]

n_gsm is based on the 3GPP 07.010 and its newer version is the 3GPP 27.010.
See https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=1516
The changes from 07.010 to 27.010 are non-functional. Therefore, I refer to
the newer 27.010 here. Chapter 5.4.6.3.1 describes the encoding of the
parameter negotiation messages.

Add the parameters used there to 'gsm_mux' and 'gsm_dlci' and initialize both
according to the value ranges and recommended defaults defined in chapter 5.7.

Replace the use of the DLC default values from the 'gsm_mux' fields with the DLC
specific values from the 'gsm_dlci' fields where applicable.

Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20221103091743.2119-2-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 3cf0b3c243e5 ("tty: n_gsm: Don't block input queue by waiting MSC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 58 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 165a70ab1f004..374d013eada6e 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -40,6 +40,7 @@
 #include <linux/tty.h>
 #include <linux/ctype.h>
 #include <linux/mm.h>
+#include <linux/math.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
@@ -75,7 +76,12 @@ module_param(debug, int, 0600);
 
 #define T1	10		/* 100mS */
 #define T2	34		/* 333mS */
+#define T3	10		/* 10s */
 #define N2	3		/* Retry 3 times */
+#define K	2		/* outstanding I frames */
+
+#define MAX_T3 255		/* In seconds. */
+#define MAX_WINDOW_SIZE 7	/* Limit of K in error recovery mode. */
 
 /* Use long timers for testing at low speed with debug on */
 #ifdef DEBUG_TIMING
@@ -160,7 +166,12 @@ struct gsm_dlci {
 	int prev_adaption;
 	u32 modem_rx;		/* Our incoming virtual modem lines */
 	u32 modem_tx;		/* Our outgoing modem lines */
+	unsigned int mtu;
 	bool dead;		/* Refuse re-open */
+	/* Configuration */
+	u8 prio;		/* Priority */
+	u8 ftype;		/* Frame type */
+	u8 k;			/* Window size */
 	/* Flow control */
 	bool throttled;		/* Private copy of throttle state */
 	bool constipated;	/* Throttle status for outgoing */
@@ -285,7 +296,9 @@ struct gsm_mux {
 	int adaption;		/* 1 or 2 supported */
 	u8 ftype;		/* UI or UIH */
 	int t1, t2;		/* Timers in 1/100th of a sec */
+	unsigned int t3;	/* Power wake-up timer in seconds. */
 	int n2;			/* Retry count */
+	u8 k;			/* Window size */
 
 	/* Statistics (not currently exposed) */
 	unsigned long bad_fcs;
@@ -1079,12 +1092,12 @@ static int gsm_dlci_data_output(struct gsm_mux *gsm, struct gsm_dlci *dlci)
 		return 0;
 
 	/* MTU/MRU count only the data bits but watch adaption mode */
-	if ((len + h) > gsm->mtu)
-		len = gsm->mtu - h;
+	if ((len + h) > dlci->mtu)
+		len = dlci->mtu - h;
 
 	size = len + h;
 
-	msg = gsm_data_alloc(gsm, dlci->addr, size, gsm->ftype);
+	msg = gsm_data_alloc(gsm, dlci->addr, size, dlci->ftype);
 	if (!msg)
 		return -ENOMEM;
 	dp = msg->data;
@@ -1148,19 +1161,19 @@ static int gsm_dlci_data_output_framed(struct gsm_mux *gsm,
 	len = dlci->skb->len + overhead;
 
 	/* MTU/MRU count only the data bits */
-	if (len > gsm->mtu) {
+	if (len > dlci->mtu) {
 		if (dlci->adaption == 3) {
 			/* Over long frame, bin it */
 			dev_kfree_skb_any(dlci->skb);
 			dlci->skb = NULL;
 			return 0;
 		}
-		len = gsm->mtu;
+		len = dlci->mtu;
 	} else
 		last = 1;
 
 	size = len + overhead;
-	msg = gsm_data_alloc(gsm, dlci->addr, size, gsm->ftype);
+	msg = gsm_data_alloc(gsm, dlci->addr, size, dlci->ftype);
 	if (msg == NULL) {
 		skb_queue_tail(&dlci->skb_list, dlci->skb);
 		dlci->skb = NULL;
@@ -1217,7 +1230,7 @@ static int gsm_dlci_modem_output(struct gsm_mux *gsm, struct gsm_dlci *dlci,
 		return -EINVAL;
 	}
 
-	msg = gsm_data_alloc(gsm, dlci->addr, size, gsm->ftype);
+	msg = gsm_data_alloc(gsm, dlci->addr, size, dlci->ftype);
 	if (!msg) {
 		pr_err("%s: gsm_data_alloc error", __func__);
 		return -ENOMEM;
@@ -1343,8 +1356,9 @@ static void gsm_dlci_data_kick(struct gsm_dlci *dlci)
 static int gsm_control_command(struct gsm_mux *gsm, int cmd, const u8 *data,
 			       int dlen)
 {
-	struct gsm_msg *msg = gsm_data_alloc(gsm, 0, dlen + 2, gsm->ftype);
+	struct gsm_msg *msg;
 
+	msg = gsm_data_alloc(gsm, 0, dlen + 2, gsm->dlci[0]->ftype);
 	if (msg == NULL)
 		return -ENOMEM;
 
@@ -1370,7 +1384,8 @@ static void gsm_control_reply(struct gsm_mux *gsm, int cmd, const u8 *data,
 					int dlen)
 {
 	struct gsm_msg *msg;
-	msg = gsm_data_alloc(gsm, 0, dlen + 2, gsm->ftype);
+
+	msg = gsm_data_alloc(gsm, 0, dlen + 2, gsm->dlci[0]->ftype);
 	if (msg == NULL)
 		return;
 	msg->data[0] = (cmd & 0xFE) << 1 | EA;	/* Clear C/R */
@@ -2081,6 +2096,13 @@ static struct gsm_dlci *gsm_dlci_alloc(struct gsm_mux *gsm, int addr)
 	dlci->gsm = gsm;
 	dlci->addr = addr;
 	dlci->adaption = gsm->adaption;
+	dlci->mtu = gsm->mtu;
+	if (addr == 0)
+		dlci->prio = 0;
+	else
+		dlci->prio = roundup(addr + 1, 8) - 1;
+	dlci->ftype = gsm->ftype;
+	dlci->k = gsm->k;
 	dlci->state = DLCI_CLOSED;
 	if (addr) {
 		dlci->data = gsm_dlci_data;
@@ -2710,7 +2732,9 @@ static struct gsm_mux *gsm_alloc_mux(void)
 
 	gsm->t1 = T1;
 	gsm->t2 = T2;
+	gsm->t3 = T3;
 	gsm->n2 = N2;
+	gsm->k = K;
 	gsm->ftype = UIH;
 	gsm->adaption = 1;
 	gsm->encoding = GSM_ADV_OPT;
@@ -2750,7 +2774,7 @@ static void gsm_copy_config_values(struct gsm_mux *gsm,
 	c->initiator = gsm->initiator;
 	c->t1 = gsm->t1;
 	c->t2 = gsm->t2;
-	c->t3 = 0;	/* Not supported */
+	c->t3 = gsm->t3;
 	c->n2 = gsm->n2;
 	if (gsm->ftype == UIH)
 		c->i = 1;
@@ -2759,7 +2783,7 @@ static void gsm_copy_config_values(struct gsm_mux *gsm,
 	pr_debug("Ftype %d i %d\n", gsm->ftype, c->i);
 	c->mru = gsm->mru;
 	c->mtu = gsm->mtu;
-	c->k = 0;
+	c->k = gsm->k;
 }
 
 static int gsm_config(struct gsm_mux *gsm, struct gsm_config *c)
@@ -2776,12 +2800,16 @@ static int gsm_config(struct gsm_mux *gsm, struct gsm_config *c)
 		return -EINVAL;
 	if (c->mru > MAX_MRU || c->mtu > MAX_MTU)
 		return -EINVAL;
+	if (c->t3 > MAX_T3)
+		return -EINVAL;
 	if (c->n2 > 255)
 		return -EINVAL;
 	if (c->encapsulation > 1)	/* Basic, advanced, no I */
 		return -EINVAL;
 	if (c->initiator > 1)
 		return -EINVAL;
+	if (c->k > MAX_WINDOW_SIZE)
+		return -EINVAL;
 	if (c->i == 0 || c->i > 2)	/* UIH and UI only */
 		return -EINVAL;
 	/*
@@ -2829,6 +2857,10 @@ static int gsm_config(struct gsm_mux *gsm, struct gsm_config *c)
 		gsm->t1 = c->t1;
 	if (c->t2)
 		gsm->t2 = c->t2;
+	if (c->t3)
+		gsm->t3 = c->t3;
+	if (c->k)
+		gsm->k = c->k;
 
 	/*
 	 * FIXME: We need to separate activation/deactivation from adding
@@ -3362,9 +3394,9 @@ static int gsm_create_network(struct gsm_dlci *dlci, struct gsm_netconfig *nc)
 		pr_err("alloc_netdev failed\n");
 		return -ENOMEM;
 	}
-	net->mtu = dlci->gsm->mtu;
+	net->mtu = dlci->mtu;
 	net->min_mtu = MIN_MTU;
-	net->max_mtu = dlci->gsm->mtu;
+	net->max_mtu = dlci->mtu;
 	mux_net = netdev_priv(net);
 	mux_net->dlci = dlci;
 	kref_init(&mux_net->ref);
-- 
2.53.0



