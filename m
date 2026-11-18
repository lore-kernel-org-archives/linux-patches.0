Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053321;
	b=p2uuLbILjOULr5pmoH76DZq0UQFNh7nOelJgM/b+i813dWU7hzBOGx4MvRuctlFbBkUz
	 Z64OVqzsKL75GY+aN3ILs0V3Ad7ly7dCzLFt5LHCHO18XWwGBNGzXbgs5PRaq/EeReLIF
	 IGvYWxHBoXBj4sGe7BYhUfRg/iGDuDoidYdDx60WEefRGhLy6sScWsW+NK/Vsq7N6x6Jw
	 Erz9U/arzXvXDNm437yJ+ycfbMHwL3i2bEEbAwoqPKV5kppKXBiFZJAu0l1VzB0+DTrYH
	 eUJkrqQxpMiFE0z8yf1PdeNPYQkhKyiZGJdkgWrugfW0yl+83rys/HqlnDM8gCWNuBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nNB0AyDNse3FyuaUtskeDB/ZrjaC8dzcp1GBRT2SqG8=;
	b=JTra1RAzc3VSH6fU8KUTrjB6Lu7PPwRDeOUSRO0y5ICHYYTioAr24Fkw0/Y9nqjJF0kf
	 nHtY3+nmXduHJopDCwtNNjcWnt8PL0VrLbJ5zSJJjUYM4rsEmJ9IwsyoDZ0ZRiD2sFPbD
	 vsVPss7+w3XcYJheZNtP+aZ1+gyKLKKDvWxRGeUKx3k95R6Plko4IaptXs6lFCQj3qa4w
	 2AGURBEvo2P6RcygBrxjzBOtki0325n+eDKmTKoFINLBBwqFDmHHCplLlMRArlVz29R5Z
	 j4usdVVa8Pw6W1EoGB9BmVxMpD0QotnaLqyItt5oYtnabBvObz/UqjAm9BdI7ceAJjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dPspFl8F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E355606A331;
	Thu, 19 Nov 2026 01:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dPspFl8F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FD41F000C4;
	Thu, 19 Nov 2026 01:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053321;
	bh=nNB0AyDNse3FyuaUtskeDB/ZrjaC8dzcp1GBRT2SqG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dPspFl8FPVnBk4DJaQMTCM3n+uUQPP72fmsZaIcVr3pD/8//5Kb7LaM7cXmoyRI7+
	 X89kMmBSHqsPhccK1v9H/71/IBH9bDSZpYpggCgVlTYAq/akBXn9HDj8UZuyJ2GXaL
	 jinvVL+2YPNl344mS6hQ62qjAINFI0CYIqCuabf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijing Yin <yzjaurora@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0841/2214] wifi: cfg80211: fix out-of-bounds read in valid_rule()
Date: Wed, 18 Nov 2026 15:41:57 +0100
Message-ID: <20261118150045.845145398@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijing Yin <yzjaurora@gmail.com>

[ Upstream commit 9d8ec0b5b5295bd23d979d1b2b905de25c36fff2 ]

valid_rule() validates a struct fwdb_rule from the regulatory database
firmware file, but bounds checks only the first byte of the structure,
the length field itself.

It then uses that length, which comes straight out of the file, to
decide whether the optional fields are present, and reads rule->wmm_ptr
at offset 18 of the 20-byte structure once the length claims 20 bytes or
more.

A rule placed in the last bytes of the file therefore makes the parser
read up to 19 bytes past the end of the firmware image. The image comes
from vmalloc() in kernel_read_file(), so with the rule at the end of a
page the read falls into the guard page and oopses, with no memory
debugging enabled.

A length of at least offsetofend(max_bw) but below offsetofend(wmm_ptr)
takes the other branch, so valid_rule() returns true having read nothing
out of bounds, and the database is accepted. regdb_query_country() does
not re-check the rule, and reads rule->start, rule->end, rule->max_bw
and rule->cac_timeout off the end of the kmemdup()ed copy.

A malformed regulatory.db is parsed by cfg80211's own
request_firmware_nowait() at init time, and on demand from user space
through NL80211_CMD_RELOAD_REGDB, which needs CAP_NET_ADMIN but no
wireless hardware. Both paths require write access to the firmware
search path and CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=n.

Bound the whole declared rule, not just its length field. The existing
check on sizeof(rule->len) is still needed, since rule->len has to be
shown to be inside the file before it can be read, so the new test goes
after it. A rule reaching past the end of the file is now rejected,
which fails the database rather than reading out of bounds. That also
gives regdb_query_country() the bound it already assumes.

Fixes: 230ebaa189af ("cfg80211: read wmm rules from regulatory database")
Cc: stable@vger.kernel.org
Signed-off-by: Zijing Yin <yzjaurora@gmail.com>
Link: https://patch.msgid.link/20261015133159.1499728-1-yzjaurora@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f9a3c4f25e294..f8d9e9333a23a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -688,6 +688,9 @@ static bool valid_rule(const u8 *data, unsigned int size, u16 rule_ptr)
 	/* mandatory fields */
 	if (rule->len < offsetofend(struct fwdb_rule, max_bw))
 		return false;
+	/* the rule must lie entirely within the database */
+	if ((u8 *)rule + rule->len > data + size)
+		return false;
 	if (rule->len >= offsetofend(struct fwdb_rule, wmm_ptr)) {
 		u32 wmm_ptr = be16_to_cpu(rule->wmm_ptr) << 2;
 		struct fwdb_wmm_rule *wmm;
-- 
2.53.0



