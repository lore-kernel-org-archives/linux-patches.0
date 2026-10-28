Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215558;
	b=WCGKl1F60RzviagbMFEX3My7sd3WSMiZW/4G2LIG9+mRflRQ4IhnWpfkuA5jfZKhYACf
	 CL/xYTjmVtm1o7zOM9z4NX84oAbH6WnG9J5Tyccq58/O6YzefEUfc4fd6k+g5kvWNq0aS
	 8AUm0SyuVJc1cxlDguj+N1gLKZ6q/MxObR4sz+DDkcJLou8EdLbX3y7kZ8EesTZ0rgaYO
	 a2bFgv7Rq0JlLwpxJuP4TZGVAf/G5fg1HZ8C2ehQuJJBtOliHZ6sHqYkDt8bLvhs2jQAg
	 xTOO34ONYSvwe+E9vldOX56maI4Xa3vD2465F+Ol+XMuSE9U8HzMI29e6HadjMkI9SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5WAz6PgC/n867ulwLjvlHoNsplmrAMHX3TcQJHVxyos=;
	b=DpwqTbKV47+DNK9KdNx7qJbRY1jUzZIsobrmhTz7Jn4Ve+bWXU3zUNzXplZm4UmDjXjF
	 2lfxv9r8KYCQGz+TayjrtSpKPmBCeptFQhxSeGiRFPNgCL50rL6uIYRdVUNmYhqpYowWP
	 DJ0dPVUd4IUSjtwo7e0FZNslXWWPaDDERRUAfX/xP9sbYIVzHoi3zNFrqnGGsvhYIsWcW
	 8FIDV1RzfyfR1ChLThgdXa3c8yNYJOgMliCzEhmoxXkiQfN8utwCAZE8AJwV4gsCfrEul
	 Mp62rfsOGX/Or43sb1bM/g1wSbZ4aeefqJ5moqtOujqWQp6leW/nGYC/ikp0kKhqflA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uzHaEXJq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681C9606A31C;
	Wed, 28 Oct 2026 19:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uzHaEXJq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779461F01825;
	Wed, 28 Oct 2026 19:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215558;
	bh=5WAz6PgC/n867ulwLjvlHoNsplmrAMHX3TcQJHVxyos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uzHaEXJqtlR2YWp7SatDQCKccK9kAYRLtZ1tr+TqVjbmNSaIyRvIugxq2MwhHSpMy
	 dB/J7GeKH2Nea/stQAtqZHvZx34ldfVKgIpVHWP2WPhSaP7x1j7R3MTxykIwt7s14y
	 Hsn37Mi3KJV4AjZgqJDe8V980o4Ag1M6tvLno5vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1252/1887] ALSA: seq: Drop superfluous filter argument of get_event_dest_client()
Date: Wed, 28 Oct 2026 17:55:48 +0100
Message-ID: <20261028170527.916968817@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 3531df81dca2f42accbc11821c5fa28e4104efd5 ]

All callers of get_event_dest_clienter() pass 0 to the filter
argument, and it means that the check there is utterly redundant.

Drop the superfluous filter argument and its check as a code cleanup.

Link: https://patch.msgid.link/20240819084757.11902-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: efc86691e4d8 ("ALSA: seq: Fix kernel heap address leak in bounce_error_event()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_clientmgr.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 0b0a2f7c07879..07b1b8bf7e3cb 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -68,7 +68,7 @@ static int bounce_error_event(struct snd_seq_client *client,
 			      int err, int atomic, int hop);
 static int snd_seq_deliver_single_event(struct snd_seq_client *client,
 					struct snd_seq_event *event,
-					int filter, int atomic, int hop);
+					int atomic, int hop);
 
 /*
  */
@@ -515,10 +515,8 @@ static int check_port_perm(struct snd_seq_client_port *port, unsigned int flags)
 
 /*
  * check if the destination client is available, and return the pointer
- * if filter is non-zero, client filter bitmap is tested.
  */
-static struct snd_seq_client *get_event_dest_client(struct snd_seq_event *event,
-						    int filter)
+static struct snd_seq_client *get_event_dest_client(struct snd_seq_event *event)
 {
 	struct snd_seq_client *dest;
 
@@ -533,8 +531,6 @@ static struct snd_seq_client *get_event_dest_client(struct snd_seq_event *event,
 	if ((dest->filter & SNDRV_SEQ_FILTER_USE_EVENT) &&
 	    ! test_bit(event->type, dest->event_filter))
 		goto __not_avail;
-	if (filter && !(dest->filter & filter))
-		goto __not_avail;
 
 	return dest; /* ok - accessible */
 __not_avail:
@@ -578,7 +574,7 @@ static int bounce_error_event(struct snd_seq_client *client,
 	bounce_ev.data.quote.origin = event->dest;
 	bounce_ev.data.quote.event = event;
 	bounce_ev.data.quote.value = -err; /* use positive value */
-	result = snd_seq_deliver_single_event(NULL, &bounce_ev, 0, atomic, hop + 1);
+	result = snd_seq_deliver_single_event(NULL, &bounce_ev, atomic, hop + 1);
 	if (result < 0) {
 		client->event_lost++;
 		return result;
@@ -624,7 +620,7 @@ static int update_timestamp_of_queue(struct snd_seq_event *event,
  */
 static int snd_seq_deliver_single_event(struct snd_seq_client *client,
 					struct snd_seq_event *event,
-					int filter, int atomic, int hop)
+					int atomic, int hop)
 {
 	struct snd_seq_client *dest = NULL;
 	struct snd_seq_client_port *dest_port = NULL;
@@ -633,7 +629,7 @@ static int snd_seq_deliver_single_event(struct snd_seq_client *client,
 
 	direct = snd_seq_ev_is_direct(event);
 
-	dest = get_event_dest_client(event, filter);
+	dest = get_event_dest_client(event);
 	if (dest == NULL)
 		goto __skip;
 	dest_port = snd_seq_port_use_ptr(dest, event->dest.port);
@@ -716,8 +712,7 @@ static int deliver_to_subscribers(struct snd_seq_client *client,
 			/* convert time according to flag with subscription */
 			update_timestamp_of_queue(event, subs->info.queue,
 						  subs->info.flags & SNDRV_SEQ_PORT_SUBS_TIME_REAL);
-		err = snd_seq_deliver_single_event(client, event,
-						   0, atomic, hop);
+		err = snd_seq_deliver_single_event(client, event, atomic, hop);
 		if (err < 0) {
 			/* save first error that occurs and continue */
 			if (!result)
@@ -862,7 +857,7 @@ static int snd_seq_deliver_event(struct snd_seq_client *client, struct snd_seq_e
 		result = port_broadcast_event(client, event, atomic, hop);
 #endif
 	else
-		result = snd_seq_deliver_single_event(client, event, 0, atomic, hop);
+		result = snd_seq_deliver_single_event(client, event, atomic, hop);
 
 	return result;
 }
-- 
2.53.0



