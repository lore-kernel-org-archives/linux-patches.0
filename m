Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591087;
	b=b+bZYtWvT+fUa9HduqMZBlIV5zXcLaTgG3v0yQnojO9+ADQKa9lLmWYpvr2gIq+O/b8d
	 1N/WuvetqvxXM4BE6ZllTPDFrvW8SrEkseVLSEo/eqccriXk078n17JaVegW85yRANX6T
	 nF955TMPWDDCMrvzRpfvGlKZtdaR13sIl3Zy/GzYEciBtNfCAY82OPWvSe6wwapGsPPii
	 hdftszz3/ntabBePMfjhrIztoLVG/dlEirXRCBXolcJQpsWigK1zvYwMC0vfHqrrkZuS9
	 StqZvtJ96xOSSXQH6Ng11uFEx1iOI6Yeowws16gLg1eOPEqrjLpVsV5+h3zioxxV2lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wZ7Qh5CeoP+pxFQskj32Z1cMgiGJ6EUnltvpYFDgvdw=;
	b=VJIFu++8DAXht9xiLIC0AvobqHGDIiDuvGA0o42M5oUzUx3SnSdkyZF8mezFdVAf/LVT
	 UOQBEssHWlh4oR/uT5WJULQ6InBte6V2YvqXh0htQ6Hvfr/4GIW4RrJzptUyzD34fCHgG
	 oxd48XU6wa9nxVWyg1Tv/u4kBbs4r1FAy3mg9LX8ShzUC2E11lboSVBcPle5LZLiH2sO0
	 R7SbJyx9HgR5EaffZrH0MnTTbjwaU/gqUxc0vZDkTAa+5v5zO1w/X+1U8Bo1N8mx3Ufhl
	 UTYBIc3fIJISNwgc8KPH0zx1ql5m7gs+hQ0Eu5n52yO64Q/m82WctUk83YAL5PFkX1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qGIswJYS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D78606B364;
	Fri, 13 Nov 2026 17:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qGIswJYS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611911F000C4;
	Fri, 13 Nov 2026 17:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591087;
	bh=wZ7Qh5CeoP+pxFQskj32Z1cMgiGJ6EUnltvpYFDgvdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qGIswJYSdgkltvVDEzvzHhhVQQpykxAS6+uZljLc/OHgkvG+z+8w0GDrmsbdcm4hv
	 3M4r6ch6C4innZf19N3nxRjqDGK7xzXOIKH35wArSk5YYC1coXIrIpvUTcPozC0ivo
	 X5Et0ykZC4aDF3kE5OJda0DOgk4PuQHscxGpVusA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 196/670] batman-adv: dat: initialize orig_node of unfilled candidate slots
Date: Fri, 13 Nov 2026 10:46:00 -0500
Message-ID: <20261113153818.631068522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 45e58b348bd77..39d74b908d640 100644
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



