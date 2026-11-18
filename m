Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019441;
	b=TK2y9AaOLOBl/cReWFJqYH+2B0rl6Iu/ZNCrz4FGoG7rRBUc4H0XB04AbxGEf5hWrxca
	 FTR1/x6Hfct40OK0HPgy+/iUdpoc1blPljaMaxohgbT3tM/G6TBk8uxpUWqOBrxrbtcxw
	 tsuQp1x9Q6q5iTsmRvsBI93lSdODS81dAE7X8Ue0a4/r/CPtgEIvJftT/C3YzZm95lfbh
	 OKWy/cr/VVDBM3doSkzXyajSjbgTGmHwFZDXP34BSDfBq8ChAOXNtk0j6o725vo8L7zDA
	 I67UDLCQ+q+R1HuhIXtB2Dg1kB8OEbk6Xklqj78P6lSSGpMaYXrj5C4bX/QcYCgdlTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=8u9FJ7QEsKeWgQAnvDO5niBT93otPeSV6SxjKuXLaBc=;
	b=AEXDUkVGNVI/SIvccZ2dT8EI3+Qlt1DR3M7xd3wDg8D4UDfl4JDX6Ne8zq8Gi7smbdcH
	 TY6rrBwtEaBh6qCySjk9ChMKUnyusnsNqR+ai3BzggawnDWdaW3s1zd2FJ6GsBogPQfKX
	 /fVqWiq3JevLx4zsXLHNT43nvVqtKl5J+TYAwF5UA0YseLMEZdwuB/18um/pie6oxFWQM
	 Lw22LP7A8+wN4wKDXAHQIAUboZqwVb8D7XUb3aXuCWvAd5T3CVecXJs7hZqK+C5huueEw
	 DvN0RXRvtnNSlIo/Q4/ky+LlJ/zBR6QvT6nexXH64f2hD6QG3kWtm7lVUag//PzBYDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LuK6Mx4d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79F560A261B;
	Wed, 18 Nov 2026 16:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LuK6Mx4d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EBC1F000C7;
	Wed, 18 Nov 2026 16:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019441;
	bh=8u9FJ7QEsKeWgQAnvDO5niBT93otPeSV6SxjKuXLaBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LuK6Mx4dva2ncRN7wwDx23/QwZFMOfl+lcNGN4ftuEX0t5vId2F0BUgdHYY6fXWIS
	 sr4G+iHpGrIAf70RjoeGlv3ijJMGlY8aBGPe2aTNJrArfN5ZT1IvHDt/B6IGNp+Upr
	 Xnbn/d8hfxXA/8potZ3OqxwA74EFEPlnbh+IPJt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ali=20Ahmet=20Memi=C5=9F?= <aliamemis@disroot.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1597/2651] ALSA: seq: Wait for one RCU grace period when deleting all ports
Date: Wed, 18 Nov 2026 15:47:17 +0100
Message-ID: <20261118150345.371206929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memiş <aliamemis@disroot.org>

[ Upstream commit 7ca1731b8a129cafe258c578fa87b7c414c6d004 ]

Since the port list was converted to RCU, snd_seq_delete_all_ports()
calls synchronize_rcu() once per port under register_mutex. Closing a
client with 254 ports now takes about 1.6s and every other client
open or close waits for it.

Unlink all ports first, wait for a single grace period and then free
them.

Fixes: 4c252fbc06d6 ("ALSA: seq: Use RCU for the client port list")
Signed-off-by: Ali Ahmet Memiş <aliamemis@disroot.org>
Link: https://patch.msgid.link/20261010222543.1470723-1-aliamemis@disroot.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_ports.c | 41 +++++++++++++++++++++++++-------------
 sound/core/seq/seq_ports.h |  1 +
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/sound/core/seq/seq_ports.c b/sound/core/seq/seq_ports.c
index eb67eb0eeb147..b582d034437f1 100644
--- a/sound/core/seq/seq_ports.c
+++ b/sound/core/seq/seq_ports.c
@@ -248,17 +248,9 @@ static void clear_subscriber_list(struct snd_seq_client *client,
 }
 
 /* delete port data */
-static int port_delete(struct snd_seq_client *client,
-		       struct snd_seq_client_port *port)
+static void port_free(struct snd_seq_client *client,
+		      struct snd_seq_client_port *port)
 {
-	/* set closing flag and wait for all port access are gone */
-	port->closing = 1;
-	/* the port has already been unlinked from the client's port list;
-	 * wait for a grace period so that RCU readers still traversing the
-	 * list can no longer take a new use_lock reference, then drain the
-	 * outstanding references before freeing
-	 */
-	synchronize_rcu();
 	snd_use_lock_sync(&port->use_lock);
 
 	/* clear subscribers info */
@@ -272,6 +264,20 @@ static int port_delete(struct snd_seq_client *client,
 	snd_BUG_ON(port->c_dest.count != 0);
 
 	kfree(port);
+}
+
+static int port_delete(struct snd_seq_client *client,
+		       struct snd_seq_client_port *port)
+{
+	/* set closing flag and wait for all port access are gone */
+	port->closing = 1;
+	/* the port has already been unlinked from the client's port list;
+	 * wait for a grace period so that RCU readers still traversing the
+	 * list can no longer take a new use_lock reference, then drain the
+	 * outstanding references before freeing
+	 */
+	synchronize_rcu();
+	port_free(client, port);
 	return 0;
 }
 
@@ -302,18 +308,25 @@ int snd_seq_delete_port(struct snd_seq_client *client, int port)
 int snd_seq_delete_all_ports(struct snd_seq_client *client)
 {
 	struct snd_seq_client_port *port, *tmp;
+	LIST_HEAD(deleted);
 
-	/* unlink and delete each port; port_delete() waits for an RCU grace
-	 * period before draining the port, so concurrent lockless readers can
-	 * no longer take a new use_lock reference on it
+	/* unlink all ports first and wait for a single RCU grace period
+	 * before draining and freeing them, so concurrent lockless readers
+	 * can no longer take a new use_lock reference on any of them
 	 */
 	guard(mutex)(&client->ports_mutex);
 	list_for_each_entry_safe(port, tmp, &client->ports_list_head, list) {
 		list_del_rcu(&port->list);
 		client->num_ports--;
+		port->closing = 1;
+		list_add_tail(&port->delete_list, &deleted);
 		snd_seq_system_client_ev_port_exit(port->addr.client, port->addr.port);
-		port_delete(client, port);
 	}
+	if (list_empty(&deleted))
+		return 0;
+	synchronize_rcu();
+	list_for_each_entry_safe(port, tmp, &deleted, delete_list)
+		port_free(client, port);
 	return 0;
 }
 
diff --git a/sound/core/seq/seq_ports.h b/sound/core/seq/seq_ports.h
index 12ad86bf14890..ef1787d6c2dd6 100644
--- a/sound/core/seq/seq_ports.h
+++ b/sound/core/seq/seq_ports.h
@@ -49,6 +49,7 @@ struct snd_seq_client_port {
 	struct module *owner;		/* owner of this port */
 	char name[64];			/* port name */	
 	struct list_head list;		/* port list */
+	struct list_head delete_list;	/* used by snd_seq_delete_all_ports() */
 	snd_use_lock_t use_lock;
 
 	/* subscribers */
-- 
2.53.0



