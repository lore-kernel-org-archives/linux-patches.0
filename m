Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585420;
	b=It072LAlLJGJeyHKQMuOWvfViM2up8lcJQx7VzBkMbaC1trfxqFPXiPu/1GrIQx0S8aU
	 9XfWGMoIDtJRIQV77pb25hodfqdQ4suFT+0ach8qtZVruSX1sTmht8KP22UI1ETaY8ys1
	 aHi1rmx1XIUsezNkMBphaNWEi8C3m3YYtLnokcyYZl1SJ2LXTwbUKfA4NybqRKuLwRuGn
	 rdXZ1pzKe1AON/B6jb65ch/kutbG38426vPpe234oxWHuPgfz03wVLUb6wa3q502IfY94
	 RD3iK/znTrl137V01/fvbOxBwqM5Tn6upfzCOJgXUi9bI0PVNDRgm7Y294g3i72HzpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Wx+/P7/wMp9cN9d3GJ7h5srjtNlxSEgvljQi4E5Q4Gc=;
	b=U2E0Ka4GoaTud+kGXhQzlliS9jOOLgwr+COkWqgEsMewG7Ld+VFJDSsq1n7hUabCDxep
	 w+QORK993DH0AL26Jt2+RB4CGDhOOQWW3ay6W8ux4ZfWBiK/NFn/0STwB2o/nMn/eDZq5
	 jREpD+bLobu151Z5SMAEz9ehAKbEzzZSyV00+sJwOtgsKzZ3iZR/UEt4//vQBkj2ykP09
	 82ArYZqpFR6ANKID5P6UbUhEEQ3P8JhUMwLD6N/Df+0+0zgMwl2HQeZl58LThexOeaUOJ
	 eF+cMO7CINPRo8Y5tTiQgTdvWcn11OZhxfolnuztg1VF/kkQk2+6Ytdip3/HvLr+5Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yar1QjfH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBBB606A88C;
	Fri, 13 Nov 2026 15:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yar1QjfH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7A01F000C5;
	Fri, 13 Nov 2026 15:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585419;
	bh=Wx+/P7/wMp9cN9d3GJ7h5srjtNlxSEgvljQi4E5Q4Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yar1QjfHUVo2mh36TgIkBOxDeLElLoEdJzDLHtctkceQ+Uav8P3eXm+COCe6lO/y9
	 x1kynXm5RM+RANRBvAV79cLIX3OfHjAIMHhO/mU0pjN5eAoRy/BkY8CgmLXpQh+3Ny
	 nbsW110GSrFlSIqvrCop6pvONxX6gSN5bRNrutMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 084/507] batman-adv: dat: initialize orig_node of unfilled candidate slots
Date: Fri, 13 Nov 2026 10:46:28 -0500
Message-ID: <20261113153756.702964364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 011cfdc47fab4..86791ddc148f6 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -653,6 +653,7 @@ static void batadv_choose_next_candidate(struct batadv_priv *bat_priv,
 	 * NOT_FOUND
 	 */
 	cands[select].type = BATADV_DAT_CANDIDATE_NOT_FOUND;
+	cands[select].orig_node = NULL;
 
 	/* iterate over the originator list and find the node with the closest
 	 * dat_address which has not been selected yet
-- 
2.53.0



