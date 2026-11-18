Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053372;
	b=QxxBPS7YwyLxFMJIy2PU9HmtTA6rmZ/zjX5ZmuZWXm4uIklBgCLagpPIztHrRs3wKKfV
	 N6AotYIzj+PNpEgILoXRXHB7SyLbKCQb0zqbgpVO+PJxSChI+9qqrXj3Yt27egFjwgWGT
	 JGgqSdEHKrcxiTQ9VS9SINj9/N/KCT/Bx+pK7XgXgiASHy7LzNHeJPwbmV+hFIb2dw5Cf
	 egvWIJm7om0Qroqn4aJoeLdFDH8RDyB4UdrPE774dHx+pWjV5STmZ/I5F/mOgdhiwhRsL
	 EAjkVbid5+B8byhSqE72+zQntJdoCe77aSPpKSXbT16yomdM+QI6gj/1MGK6XrKRVZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nQD5XONYDEiwp5giqPSjTNSRGwn1wCWjhES2g17tCFA=;
	b=18tdChEWmGCivm4lHdR5CwfPFXrZ6AY8Wy82Fa8iEy5v+YsYDBZtaOWSglWpZtUSccZl
	 zGglm2sYgCR/evfb3m9rWEhJBHJ3hvxmJ0FcuHdn3lNCR0AbyG+hACZ/k+b4zkw0T1QQJ
	 AOqjZdyUXoxqcuw04RgfKehDiPdY6cQi+W5dxF867HLcY8wSo7wSWgPiKX6KRt1rnfnFi
	 Q/FBTOmaBRS7p8rIqqQreyanY5+mAyDOWYqWeZzAilH2Qxxf8ZYWQMitScI+qN8flxqIA
	 QsEz8VsOE3VG1PhkA2EjFBlW7+APveo6KLaV+SmbLlAFb6EILkShdSEwXXvQI4AK9FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ynfOXhyI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0113606A325;
	Thu, 19 Nov 2026 01:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ynfOXhyI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5161F000C4;
	Thu, 19 Nov 2026 01:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053371;
	bh=nQD5XONYDEiwp5giqPSjTNSRGwn1wCWjhES2g17tCFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ynfOXhyI3rfM92Aa+ZQne2Ro/krHIPDlhP4dVwwSqi9Yp7ucMdBzg6YTcAqUL5WI0
	 na/05L0/oxPfA8XMkRhWOe1bwRvm8I3v49N8KuIVuhDHMXNL6wxBQ+7bNtVZ4Ch6jT
	 9WxTCfmc+kZxPYHj9ntlaPOD8osdB31r89HMqPWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0846/2214] batman-adv: dat: initialize orig_node of unfilled candidate slots
Date: Wed, 18 Nov 2026 15:42:02 +0100
Message-ID: <20261118150046.017909689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 4eb19a389d74f06901b4cd6f24b996b2e84eaefc ]

batadv_dat_select_candidates() allocates the candidate array without
zeroing it. batadv_choose_next_candidate() marks each slot as
BATADV_DAT_CANDIDATE_NOT_FOUND but only sets orig_node when an eligible
originator was found. In the following rounds,
batadv_is_orig_node_eligible() compares res[j].orig_node of all previous
slots against the evaluated originator. For slots without candidates, it
reads uninitialized memory.

The orig_node has to be cleared together with the
BATADV_DAT_CANDIDATE_NOT_FOUND type.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-b25d9aa4-10bb-427c-a145-ccaadc2a1bb9
Fixes: 785ea1144182 ("batman-adv: Distributed ARP Table - create DHT helper functions")
Acked-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/distributed-arp-table.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index 38c29d2051811..b57e3b3f16b92 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -583,6 +583,7 @@ static void batadv_choose_next_candidate(struct batadv_priv *bat_priv,
 	 * NOT_FOUND
 	 */
 	cands[select].type = BATADV_DAT_CANDIDATE_NOT_FOUND;
+	cands[select].orig_node = NULL;
 
 	/* iterate over the originator list and find the node with the closest
 	 * dat_address which has not been selected yet
-- 
2.53.0



