Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590208;
	b=vJHgqVergQFEY8NqLbWZJXJ1/rUJ/eIvacP5nkTLSlwJEKw3zrwSSXQFFci9c9F7fLia
	 BB17mZbsGRUclQVL2HN1JXIKAi6SxmnC2Agqm8+LarRSzTqM7pRvMcy/ibf/wglydCrvr
	 GSAl4EkRg8tWDWdnOnqAj6QhvfXUpYyF3eUM0zj5afOpi8xorhXZWegDh5aMMyDp1mf1F
	 E5I/PLx3XRVglCdIY/FPPRcOJUqDrrBEhnrBxn0QqxZrRGbQDxuAmosisDb7ZWCsAoDie
	 G7rWFbN352qYqKGjtMIcMNcGQbR7RNi3SOI7MjhxaJ522Dv52EbMlHVT7Yb8D8Ncxlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ABEtN1VPRB5DibrEdgjeBM7IMaMW01iZi+TOU2T1LyQ=;
	b=Ap8Riw8PBKD0ez3CZDVfxP0L7nqVy6IDo0JH5lQIFuBgIqvLwIrlmLTu2EQC8+rdj6nB
	 yBc9AKV7ffI9sft82PIw/gSlxsDr//Ako8Xu/Hv9mM+emJf2tdmfKdriArek3hUX2/Lt8
	 RkLSD2lJsp8+e3WeDDtFjpmTlnJ3iDDVSo3gXbv9aWn4FYTo97TecTfXqe/9tzxKKfE5J
	 QmKv7pG4EAInWHWdPAvuq5lNkrQy+Sj2YYqpCPKjSgqn3zlI2xiBYi7/EMww45F/DuBhk
	 mqmn/qvFl6tb5F1xqPsv+VdjAowRXVSn3yOhIVe94znD8i/kBhFCUFposytdL72wk7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q1XvcTx0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878F3606A8B2;
	Fri, 13 Nov 2026 17:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q1XvcTx0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3394F1F000C9;
	Fri, 13 Nov 2026 17:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590208;
	bh=ABEtN1VPRB5DibrEdgjeBM7IMaMW01iZi+TOU2T1LyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q1XvcTx0znqLj+ot+Oji15fRUCjQXVGaZx59pTVaZ3I3gSfm19jKmoUpMD+zgh97S
	 Pkb+di/56FBUT/NHQeyefZCAH9dUvT8PA2BvXm5KhLrxW/pwmCIOOYUbDX74v6ON2B
	 1YCURZbOb519LrnjFzz0x4D6+C4KnRE3fGOrVyJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 212/686] batman-adv: dat: initialize orig_node of unfilled candidate slots
Date: Fri, 13 Nov 2026 10:45:45 -0500
Message-ID: <20261113153828.220708917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 72717e2952ab9..126a546fa033d 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -582,6 +582,7 @@ static void batadv_choose_next_candidate(struct batadv_priv *bat_priv,
 	 * NOT_FOUND
 	 */
 	cands[select].type = BATADV_DAT_CANDIDATE_NOT_FOUND;
+	cands[select].orig_node = NULL;
 
 	/* iterate over the originator list and find the node with the closest
 	 * dat_address which has not been selected yet
-- 
2.53.0



