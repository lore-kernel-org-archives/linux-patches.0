Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058983;
	b=oq1NJqmdLPRMM77T64dfn7mMNUvLs4hkz54JTG1YnPYJVJWvLYykgwMGmQiMW5EXzpfh
	 ZKQIAdlkXvpGAOuFU3aY6UBWdxIANsOYFggQJ76OxMckEhTYsCRNw7WFa1wqLjWDuXifN
	 Kvk6AlNo3c2fzpcZqrxTnE+LCOxZDuWN4ehWe57QSvUJfUfxkbR9qqY7Q2hyv9F9j9EUh
	 NVlp2m6hDsWTCsCETQ8DBtyXgxbH9xdGL55HaSK3x+OnGkq9ku8BWOcLyG6s1TiYaQ3ma
	 HZ/SafL8PicSgD8JP1f0p/fpjTh9POlvU0pLgzbyBfO88ZYYuz7kZuoztOOAKSSW15A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x1H2SRQp5OpTorUJK+Y+62N+L+5LSU7W0fSwd/3oWXg=;
	b=4Qt2DJ5aSZ4YA5QUYaicS5QLexUkOGZ+/W9LIxiPHL+5NaT0/sdlKiBjdSk1L/EbRsPv
	 f5CLDao4yplXqK/GsqPpEIpdjS7Th2QyBwmtxBxq2qUfttlbqLJJUxTKENFDdyo3wlfhU
	 J937QpUKUN2WcN/uP+AYVLD7AC0VDyeyOGC8uGfUNHNxKPpVg3W8z3Vf37XyektWfpteM
	 MFGlc2aT926SjbElKdcwUmBVxhyjsRYfpEOx+5giwAoZns5oTN8vsDqtsYt95O5BNwSNF
	 4kizkjSX/mAiIoXvPPa99o6F2Zs68HT1O7k+YRFV8B6RuCd0m4WK8VNzAA8y5hQzJkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZZYDccPM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C5E606A32A;
	Thu, 19 Nov 2026 03:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZZYDccPM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96971F000C4;
	Thu, 19 Nov 2026 03:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058983;
	bh=x1H2SRQp5OpTorUJK+Y+62N+L+5LSU7W0fSwd/3oWXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZYDccPMbyovxqVi00wXZIh7hnLOn3SOt94gkY/q93NT8ONCoOaIwnIT246u+Zxnl
	 JY3CIolcNwb9V78VbfB4wUFHX1z0x7Ra3VX97pDgRxt2rJz1xMMUWma9PUqCXgSOCi
	 6mibUypUI8xFOHGEbiGWmJe/7PnAqtk+2rflnsqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijing Yin <yzjaurora@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0681/1848] wifi: cfg80211: fix out-of-bounds read in valid_rule()
Date: Wed, 18 Nov 2026 15:45:19 +0100
Message-ID: <20261118145944.509661717@linuxfoundation.org>
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
index 6ab5d8971d10f..07490c7a25bed 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -669,6 +669,9 @@ static bool valid_rule(const u8 *data, unsigned int size, u16 rule_ptr)
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



