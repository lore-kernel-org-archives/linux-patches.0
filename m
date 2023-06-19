Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7479CC123
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 11:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F97C433C8;
	Mon, 19 Jun 2023 11:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172535;
	bh=FwNNMK1fYAwHxhAtvQ/0qQ8i12BYWFmqaz1Og7XFLMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7bn8kwvyhXDUpsMQD2N52nPGynwucwa7Z75BXtubuQyBxnrj6ZE/VjQEcXnufbQp
	 3gBYS/uX7oXyOmWcY9vcqZcj4sbKdWx7JpQMBnM12aVZ7JSqujFpWw9GFgJIUFl/6l
	 6S2Xt2ByxDlOHWSIqO4Wj/aDiMdnArNGHdyl2TDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 103/107] net: Remove DECnet leftovers from flow.h.
Date: Mon, 19 Jun 2023 12:31:27 +0200
Message-ID: <20230619102146.235352133@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guillaume Nault <gnault@redhat.com>

commit 9bc61c04ff6cce6a3756b86e6b34914f7b39d734 upstream.

DECnet was removed by commit 1202cdd66531 ("Remove DECnet support from
kernel"). Let's also revome its flow structure.

Compile-tested only (allmodconfig).

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Acked-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/flow.h |   26 --------------------------
 1 file changed, 26 deletions(-)

--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -54,11 +54,6 @@ union flowi_uli {
 		__u8	code;
 	} icmpt;
 
-	struct {
-		__le16	dport;
-		__le16	sport;
-	} dnports;
-
 	__be32		gre_key;
 
 	struct {
@@ -153,27 +148,11 @@ struct flowi6 {
 	__u32			mp_hash;
 } __attribute__((__aligned__(BITS_PER_LONG/8)));
 
-struct flowidn {
-	struct flowi_common	__fl_common;
-#define flowidn_oif		__fl_common.flowic_oif
-#define flowidn_iif		__fl_common.flowic_iif
-#define flowidn_mark		__fl_common.flowic_mark
-#define flowidn_scope		__fl_common.flowic_scope
-#define flowidn_proto		__fl_common.flowic_proto
-#define flowidn_flags		__fl_common.flowic_flags
-	__le16			daddr;
-	__le16			saddr;
-	union flowi_uli		uli;
-#define fld_sport		uli.ports.sport
-#define fld_dport		uli.ports.dport
-} __attribute__((__aligned__(BITS_PER_LONG/8)));
-
 struct flowi {
 	union {
 		struct flowi_common	__fl_common;
 		struct flowi4		ip4;
 		struct flowi6		ip6;
-		struct flowidn		dn;
 	} u;
 #define flowi_oif	u.__fl_common.flowic_oif
 #define flowi_iif	u.__fl_common.flowic_iif
@@ -207,11 +186,6 @@ static inline struct flowi_common *flowi
 	return &(fl6->__fl_common);
 }
 
-static inline struct flowi *flowidn_to_flowi(struct flowidn *fldn)
-{
-	return container_of(fldn, struct flowi, u.dn);
-}
-
 __u32 __get_hash_from_flowi6(const struct flowi6 *fl6, struct flow_keys *keys);
 
 #endif


