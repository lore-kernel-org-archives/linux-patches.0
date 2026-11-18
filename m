Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023634;
	b=hORiFH6XjWUhE0JHw/TR3ih0Mw071Bar4HySyF8UTsYa9PSISBBVjVY9Sn73P86HRItB
	 hdrfBVIHp7V80AC4LBAUqC9cD86W0f+sP0XhhfvIz2LAy5ri5B4U36Z8uy1EiQzhBXWO3
	 eOVNyhAX7CZGl1TfZ3SuOaMK9MgQzJXSAeA7PTf7n2Q/AWlMncq8c4M/XedGj/fHjzRWd
	 /3JGhJbg9aUuq7Afp1qgptY7HqW/nNeaRWyAD5pIcvlvYKmvzKr25BRSKgwZQxSr6gpNW
	 B4sWuGu9Gly80Vky/Kcxu3pyaek+t+1jF44ug1edeRIJJzRWVPBddMPpSidQiLTqhKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xachDWFFF4fn3qBQUdml+Ok1J6fljXXZ6XSeO962JUI=;
	b=JTBwecLa199oBYtTH/F6lqf9hxJdZP5DvFHoamWUga+WIjAZ8DXdj876armgInYuHJxb
	 8zkVUH6t6DJWD4TXJ6ztQ6KmISOcolOMoLdGopmCWMcCaVBPERsq/Y2PPs1xLUH60IxmE
	 yVgcevK2QEKssrbWmcbMgeAJ7KE50YC+Dp2ZDz2B0k4auTDUrfMX/Ezd72npp2XK58qlR
	 R5SeVyfLcxVQwPR1P53ICCqdTrRhH16Fx0H0Wn0z+vQgJmPRll3mGBNK5qTJggz3JMscd
	 YGjH6BTKgpLv6rAYry6d64gABwRJQM9agXSlRTGlCO0DYFz9emNDhp+ofUmhwaUhteQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1M53pH/i";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6C8606A31C;
	Wed, 18 Nov 2026 17:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1M53pH/i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B0F1F000C4;
	Wed, 18 Nov 2026 17:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023634;
	bh=xachDWFFF4fn3qBQUdml+Ok1J6fljXXZ6XSeO962JUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1M53pH/i96NiwDE7PaqD+ZRvUiAXYoKLU+lMm5J94S54K0q1AlgsnplpCqwFnRVyM
	 HdnsPztrpFOcwkb3vgHCDnkw401z7CdC5BaILF9dCSsoC+Fid54lY3Ph2rLKdPOIrC
	 BGZv31QxYmyY1Oybh3ev2U2mguRzOex7KagXXCBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0440/2151] wifi: mac80211: Fix the return value in mesh_path_add() kernel-doc
Date: Wed, 18 Nov 2026 15:36:15 +0100
Message-ID: <20261118150138.069218487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 5c7b043cb1ef4bca9aa2e793dab862c0989d59c3 ]

mesh_path_add() has returned the new (or the already existing) struct
mesh_path, or an ERR_PTR(), since commit ae76eef027f7 ("mac80211: return
new mpath from mesh_path_add()"), but its kernel-doc still says
"Returns: 0 on success". Describe the pointer.

Fixes: ae76eef027f7 ("mac80211: return new mpath from mesh_path_add()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260912072840.50710-1-kmehltretter@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 8653f7fd52ce8..5b492ed5e5a35 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -679,7 +679,7 @@ void mesh_fast_tx_flush_addr(struct ieee80211_sub_if_data *sdata,
  * @sdata: local subif
  * @dst: destination address of the path (ETH_ALEN length)
  *
- * Returns: 0 on success
+ * Returns: the new or the existing path on success, an ERR_PTR() on failure
  *
  * State: the initial state of the new path is set to 0
  */
-- 
2.53.0



