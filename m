Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032926;
	b=lWeo4VNx+566hcBxLZrEkra0k/iHZ8HULXyY8TWLQdKka6xn0cmvMCDID6ym5OizYqsV
	 A8BcGmRCIedHXaYj3CLUJeogJRqRoWwVPXvD1Cbn/5jHhWNIaVGkjz02hFQM1vCGQ3+O4
	 ut1l8jB3/5cBIdYnB7fqUYYO5ZZN6lk3fWlNpHXGI1EK5qby91UJQG6sCCj6P4Ut+u5nT
	 e9HvGg4bnbc8kEa88IZmyLpp1NItSISO2GqPSyQBy367/C32aiPrMg9pvPxYZPPDjtqFW
	 toFhCXRHMFgYJ6/TLaEAabz4s+bMYv6Cfw4H992pcqZk+217JzUSXgQy5UoW7NQ4lhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NNVZB0LzFXhMzIEuEYltzB4C7Qn/4TriiImq0brJghw=;
	b=f0ZnbPzAffDgGcY8JdKIoiF7Qjbo5z8doaOnkBU1m/4SrtyfNxG6FUkZ8uYe9VJFKzOH
	 lhq6OW1neBHEpULUWAdoBmRZziIfKkErP+fuYYbm5VwjZz55ebFR70m8VA+UVzJSHwb6l
	 nxpilSKVhQdABQjtfHggog6GzT3YPTnNBYecWnjytQMFEJRjmjSRirGUZfpbB5XENVg/f
	 iPrAiFRf0cunbwbtc/ob8YfXi/54pgU1wtoqxoBMISMmQsXqaJa3PTDYJ+UaEmYDOtRsH
	 iiEtkC9WJl3PNbVNPm4v+inXj0WYY228RmEMq3lkJbQOmdGaRJCNPHlrkd2eTy89n0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C21QjfMM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796D3606A32A;
	Wed, 18 Nov 2026 20:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C21QjfMM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757011F000C4;
	Wed, 18 Nov 2026 20:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032926;
	bh=NNVZB0LzFXhMzIEuEYltzB4C7Qn/4TriiImq0brJghw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C21QjfMMwNMHMSxIp9zI9MwwG+NhancP2/2nqgm1g9sAgY75e2F/DQlDz+OEKQ4jO
	 poA5pZbaP09OKnrv4KfsTmx7hyYessjawhdCxxxwJRScgbzxBsxHRdr5hbJn0dYX1e
	 TatorkejU+Xi12kMoX4yh1vScZtUTyEMFj7awYeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1558/1756] ALSA: seq: Allow system notification in atomic
Date: Wed, 18 Nov 2026 16:01:25 +0100
Message-ID: <20261118150111.349041927@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 10a29de13bbc7ca92ae85184cf2f966c4ce3b69b ]

Currently the system notification helper assumes only the non-atomic
delivery.  For allowing an event delivery in non-atomic context, add
the atomic flag to the helper function.

This is a preliminary change for the support of UMP EP/FB
notification.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250110155943.31578-8-tiwai@suse.de
Stable-dep-of: 9b30046de03a ("ALSA: ump: Drain sequencer callbacks before freeing their client")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_clientmgr.c |  2 +-
 sound/core/seq/seq_system.c    |  9 +++++----
 sound/core/seq/seq_system.h    | 21 +++++++++++++--------
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 4dc5b15029e45..55014bfc02570 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -1541,7 +1541,7 @@ int snd_seq_client_notify_subscription(int client, int port,
 	event.data.connect.dest = info->dest;
 	event.data.connect.sender = info->sender;
 
-	return snd_seq_system_notify(client, port, &event);  /* non-atomic */
+	return snd_seq_system_notify(client, port, &event, false);  /* non-atomic */
 }
 
 
diff --git a/sound/core/seq/seq_system.c b/sound/core/seq/seq_system.c
index 80267290190d0..d8ed05b1705e1 100644
--- a/sound/core/seq/seq_system.c
+++ b/sound/core/seq/seq_system.c
@@ -76,26 +76,27 @@ static int setheader(struct snd_seq_event * ev, int client, int port)
 
 
 /* entry points for broadcasting system events */
-void snd_seq_system_broadcast(int client, int port, int type)
+void snd_seq_system_broadcast(int client, int port, int type, bool atomic)
 {
 	struct snd_seq_event ev;
 	
 	if (setheader(&ev, client, port) < 0)
 		return;
 	ev.type = type;
-	snd_seq_kernel_client_dispatch(sysclient, &ev, 0, 0);
+	snd_seq_kernel_client_dispatch(sysclient, &ev, atomic, 0);
 }
 EXPORT_SYMBOL_GPL(snd_seq_system_broadcast);
 
 /* entry points for broadcasting system events */
-int snd_seq_system_notify(int client, int port, struct snd_seq_event *ev)
+int snd_seq_system_notify(int client, int port, struct snd_seq_event *ev,
+			  bool atomic)
 {
 	ev->flags = SNDRV_SEQ_EVENT_LENGTH_FIXED;
 	ev->source.client = sysclient;
 	ev->source.port = announce_port;
 	ev->dest.client = client;
 	ev->dest.port = port;
-	return snd_seq_kernel_client_dispatch(sysclient, ev, 0, 0);
+	return snd_seq_kernel_client_dispatch(sysclient, ev, atomic, 0);
 }
 
 /* call-back handler for timer events */
diff --git a/sound/core/seq/seq_system.h b/sound/core/seq/seq_system.h
index 4fe88ad403461..a118f7252b62a 100644
--- a/sound/core/seq/seq_system.h
+++ b/sound/core/seq/seq_system.h
@@ -10,16 +10,21 @@
 
 
 /* entry points for broadcasting system events */
-void snd_seq_system_broadcast(int client, int port, int type);
+void snd_seq_system_broadcast(int client, int port, int type, bool atomic);
 
-#define snd_seq_system_client_ev_client_start(client) snd_seq_system_broadcast(client, 0, SNDRV_SEQ_EVENT_CLIENT_START)
-#define snd_seq_system_client_ev_client_exit(client) snd_seq_system_broadcast(client, 0, SNDRV_SEQ_EVENT_CLIENT_EXIT)
-#define snd_seq_system_client_ev_client_change(client) snd_seq_system_broadcast(client, 0, SNDRV_SEQ_EVENT_CLIENT_CHANGE)
-#define snd_seq_system_client_ev_port_start(client, port) snd_seq_system_broadcast(client, port, SNDRV_SEQ_EVENT_PORT_START)
-#define snd_seq_system_client_ev_port_exit(client, port) snd_seq_system_broadcast(client, port, SNDRV_SEQ_EVENT_PORT_EXIT)
-#define snd_seq_system_client_ev_port_change(client, port) snd_seq_system_broadcast(client, port, SNDRV_SEQ_EVENT_PORT_CHANGE)
+/* normal system notification event broadcast */
+#define notify_event(client, port, type) \
+	snd_seq_system_broadcast(client, port, type, false)
 
-int snd_seq_system_notify(int client, int port, struct snd_seq_event *ev);
+#define snd_seq_system_client_ev_client_start(client) notify_event(client, 0, SNDRV_SEQ_EVENT_CLIENT_START)
+#define snd_seq_system_client_ev_client_exit(client) notify_event(client, 0, SNDRV_SEQ_EVENT_CLIENT_EXIT)
+#define snd_seq_system_client_ev_client_change(client) notify_event(client, 0, SNDRV_SEQ_EVENT_CLIENT_CHANGE)
+#define snd_seq_system_client_ev_port_start(client, port) notify_event(client, port, SNDRV_SEQ_EVENT_PORT_START)
+#define snd_seq_system_client_ev_port_exit(client, port) notify_event(client, port, SNDRV_SEQ_EVENT_PORT_EXIT)
+#define snd_seq_system_client_ev_port_change(client, port) notify_event(client, port, SNDRV_SEQ_EVENT_PORT_CHANGE)
+
+int snd_seq_system_notify(int client, int port, struct snd_seq_event *ev,
+			  bool atomic);
 
 /* register our internal client */
 int snd_seq_system_client_init(void);
-- 
2.53.0



