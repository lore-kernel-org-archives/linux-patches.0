Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624239;
	b=I9Ao1C6m6/+M70oslKDawsnjos19UKZ32v7JLMYliWtC3xxZ/C9jOxlbGVl7tLFJDZ3O
	 RwdzefUy9hCejD2J6f5Mczbjhc50xG+iSQjbK+t8cne8RqjMcDFMf2ecTCTGXSEL2scLx
	 QRNcQimKKK51QKy4Fu1T3O4akAXJrw06AESa6aKXTgKHmHkzY/o4zNcfi5FAHpRgvoUO5
	 Kmd9KAMXtfIfzqmSLuFC49iUuW88EznLZNi7bTGiWygq14Fu81SFCVxIAhzpW40unfeWC
	 o7gaDuVilgBk/1NIDXmVX0yc8olMn/blwpshdoSJ9+3hjWRj9gM4i5E8WA0wptR1a2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sr1PIzUQWcq7cSohqijrziMOv3CDhTxP/IGQitx3xSs=;
	b=0lDCfWUkNd5qvS8IaYw9y71oql3pzrbuvM1fOJsMrZ6JJn28IBFB5FTOv/V0JX4AMseT
	 xPG2rSY8x3sIiD1VHBUALTfPDhPnPjRUHs1e3l9igTFWxlSDOcF22ppg79WV5YwbvSvP9
	 Wr8F55qmWk8Me3f6fnm503lLJshD4bGEUycul4qv8RjVKZjB1Wdt7XmrY70ZYGGUZWH1s
	 6GmJyAoOb8U3PR5s+FFF1Tg85dD43odVXennNgaE61kBRHgcShtli/S1T8yiaW1jlaUGO
	 EA/zNr+2l3twYR+KTt8GaydCSZTD7bEmM+QLxbJa4zbNNYPx+PSq7xCqlah3gebSQSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="U/4lUlr1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E400606A686;
	Wed, 25 Nov 2026 16:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U/4lUlr1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A161F000C0;
	Wed, 25 Nov 2026 16:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624239;
	bh=sr1PIzUQWcq7cSohqijrziMOv3CDhTxP/IGQitx3xSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U/4lUlr13cFZZZapUwUTo0vfweg72yENgYMoNmJ5VzzRiFnF8WHy6Qwnp91pRIx6+
	 9PvDWAYuFnqWCP9v8pB7HS9KA/WLomE5Hehau4lj7XLV2pLL/aXq0EClp86/pM0tBg
	 FUFp5GICAitqTtuHeqZUUNEQgDcsEjH21r3pw5+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiakai Xu <xujiakai24@mails.ucas.ac.cn>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/816] tipc: reject attaching bearer of different media to the same occupied device
Date: Wed, 25 Nov 2026 15:27:11 +0100
Message-ID: <20261125143851.143259285@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Tung Nguyen <tung.quang.nguyen@est.tech>

[ Upstream commit 0a0257228be902ff09608bcaf19ae7c6d58b028f ]

Currently, two bearers of different media types can be added to the
same device (e.g., "eth:eth0" and "ib:eth0") via tipc command:

tipc bearer enable media eth dev eth0
tipc bearer enable media ib dev eth0

For each command execution, tipc_enable_l2_media() is called:

tipc_enable_l2_media()
 dev_get_by_name()
  dev_hold()

As a result, device->dev_refcnt is incremented twice, but the second
bearer replaces the first one. This causes a leak in device->dev_refcnt.

Fix this by rejecting a bearer with a different media type when the
device is already occupied.

Fixes: cb30a63384bc ("tipc: refactor function tipc_enable_bearer()")
Reported-by: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
Closes: http://lore.kernel.org/netdev/20260918013509.1853952-1-xujiakai24@mails.ucas.ac.cn/
Signed-off-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20261029030522.8306-1-tung.quang.nguyen@est.tech
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bearer.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 24dcb8aa32330..e057d0c6786c4 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -285,17 +285,50 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 	bearer_id = MAX_BEARERS;
 	i = MAX_BEARERS;
 	while (i-- != 0) {
+		struct net_device *dev;
+
 		b = rtnl_dereference(tn->bearer_list[i]);
 		if (!b) {
 			bearer_id = i;
 			continue;
 		}
 		if (!strcmp(name, b->name)) {
+duplicate:
 			errstr = "already enabled";
 			NL_SET_ERR_MSG(extack, "Already enabled");
 			goto rejected;
 		}
 
+		/* udp media can be used together with any media */
+		if (b->media->type_id == TIPC_MEDIA_TYPE_UDP ||
+		    m->type_id == TIPC_MEDIA_TYPE_UDP)
+			goto priority;
+
+		dev = __dev_get_by_name(net, b_names.if_name);
+
+		if (!dev) {
+			res = -ENODEV;
+			errstr = "no device for the media";
+			NL_SET_ERR_MSG(extack, "No device for the media");
+			goto rejected;
+		}
+
+		if (rtnl_dereference(b->media_ptr) == dev) {
+			char *dev_name = strchr((const char *)b->name, ':') + 1;
+
+			/* Not allow altname of occupied device */
+			if (strcmp(dev_name, b_names.if_name) &&
+			    b->media->type_id == m->type_id)
+				goto duplicate;
+
+			/* Not allow eth and ib to attach to the same device */
+			errstr = "same dev for different media";
+			NL_SET_ERR_MSG(extack,
+				       "Same dev for different media");
+			goto rejected;
+		}
+
+priority:
 		if (b->priority == prio &&
 		    (++with_this_prio > 2)) {
 			pr_warn("Bearer <%s>: already 2 bearers with priority %u\n",
-- 
2.53.0



