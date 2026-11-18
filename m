Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059364;
	b=D/X7efIeTFbO0FnvCSsIulzHo09LIWJ3G+cZG4gO5kYfGKI3r9YwgpSY4TjIYxnylnGy
	 Iv1eEwBkeuXipP/c406TnR6U38UY1+8w9TPIugFj8zgwPPwsYZBmhPiu9LsURnnot0YQL
	 Or70zfsBtgRWEuB0BAQajCm+myP7pFWyTjp71Sv0567Y6GuvyhqFEu8sSXLK/r8Wndf4v
	 mmYndb6q7DaQ9dFItHpaEupq7Akst2N24aACtijD+JBTIl1eUzaRuBSugqjAXP0dz/7BD
	 7z1BMXzXP2XgFETPqbEdU8/Gf+rQdMm99OurzYYCZ+Wck0tPvJYAqI3k0dNA5s97BjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sBCGBBjci+LFRcY5+A5XK0LbwHdf6ErgILTvL01ohOM=;
	b=GNF1W6ysc4CeXqpr6Cj80i2bNYBkLygaPkuLqcZBwRfAZLo0sI3j2n3RxG8Sb+m5uNrk
	 cN3CtcaHXjSXJJb3A6YrE9yaGDD2IIO07REwZHadI5jsroQuBR7k6odRKMp+U+1SixYZS
	 FJQtZhYT8pf0ECURUMABiWRhIvcEC1oC51sHugyHrlKwa7Xsa/Ia8ZydBZHfdGLa0Hkq1
	 TUBLeiePz20Np83LQq7DgME5OA7K+BCVD1ShTTQWei0nb/w0UjbaAsgVuLjk/RrN/tPPS
	 RHe9e3FbBfTeFfRFd67eiwd/+h+IiRzXjmG9y15z/hk945ayaQAzSriJYHLFKtZrmmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=om3wgICw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A80606A320;
	Thu, 19 Nov 2026 03:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=om3wgICw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E855F1F000C4;
	Thu, 19 Nov 2026 03:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059364;
	bh=sBCGBBjci+LFRcY5+A5XK0LbwHdf6ErgILTvL01ohOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=om3wgICwzO3EH8iE+pCfCaNvJ/EhpdRtU5cb7Y9YqCHmhgyCK63cH2qIcMPI7yDX6
	 Hs6Sl77bs5Enh+zPuszggE/Bixe83oL/cyqv7Qswz+Ja2I23WVaa/B6WrwYJ4LghCT
	 VBtA/xW+8PU3Jqxjfjtfs7/TWTidrj7cckrg5KKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0798/1848] batman-adv: tt: clear ROAM flag when re-adding a pending local client
Date: Wed, 18 Nov 2026 15:47:16 +0100
Message-ID: <20261118145949.796908069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit cc2186d7854785b30d423f5d43757b086b300e55 upstream.

When a ROAMING_ADV is received for an announced local client,
batadv_tt_local_mark_removed() sets BATADV_TT_CLIENT_ROAM, queues a
DEL|ROAM change and marks the entry as BATADV_TT_CLIENT_PENDING. If the
client sends a frame again before the next TTVN commit,
batadv_tt_local_add_existing() only clears the PENDING flag and returns
early. The ADD cancels the queued DEL, but the entry keeps the ROAM flag:

* batadv_is_my_client() reports the client as not served by this node
* batadv_tt_local_client_is_roaming() reroutes unicast frames for it to
  the node which sent the ROAMING_ADV

The ROAM flag is only removed with the next frame of the client.

Since BATADV_TT_CLIENT_ROAM is set together with BATADV_TT_CLIENT_PENDING,
it has to be cleared also at the same time with BATADV_TT_CLIENT_PENDING
when the client roamed back.

Cc: stable@vger.kernel.org
Fixes: 068ee6e204e1 ("batman-adv: roaming handling mechanism redesign")
[ adjust code still in batadv_tt_local_add ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 96a2078d9c387..23d34e1b48eec 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -659,6 +659,7 @@ bool batadv_tt_local_add(struct net_device *soft_iface, const u8 *addr,
 	int hash_added, table_size, packet_size_max;
 	bool ret = false;
 	bool roamed_back = false;
+	bool added = false;
 	u8 remote_flags;
 	u32 match_mark;
 
@@ -685,7 +686,7 @@ bool batadv_tt_local_add(struct net_device *soft_iface, const u8 *addr,
 			 * flag can be reset like it was never enqueued
 			 */
 			tt_local->common.flags &= ~BATADV_TT_CLIENT_PENDING;
-			goto add_event;
+			added = true;
 		}
 
 		if (tt_local->common.flags & BATADV_TT_CLIENT_ROAM) {
@@ -766,10 +767,12 @@ bool batadv_tt_local_add(struct net_device *soft_iface, const u8 *addr,
 		goto out;
 	}
 
-add_event:
-	batadv_tt_local_event(bat_priv, tt_local, BATADV_NO_FLAGS);
+	added = true;
 
 check_roaming:
+	if (added)
+		batadv_tt_local_event(bat_priv, tt_local, BATADV_NO_FLAGS);
+
 	/* Check whether it is a roaming, but don't do anything if the roaming
 	 * process has already been handled
 	 */
-- 
2.53.0



