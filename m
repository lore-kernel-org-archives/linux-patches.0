Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA5A15CAB
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FBDC433C1;
	Tue,  8 Nov 2022 13:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915385;
	bh=zSP33KqARZAgZYWHHLJ/wz0v3g+GCkvJdeQnr/fl68Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xDjWkd9GSksID9KPzaWoAuq3A3YnZ6msbTfKtHqXAwsgH9SgUBk8D6kpnqH4jjKQK
	 eUNEoiyKCKOHNqQWQJHmYjYbOwxeZboDhOlHjghSL9ksxWCV55Ki5ZgeOhZ/qRmz11
	 Tt+P8uN3t+vYz7pAbHNHQj1+HPaOWUPks6a/KWd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/74] ipvs: use explicitly signed chars
Date: Tue,  8 Nov 2022 14:38:44 +0100
Message-Id: <20221108133334.357580689@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit 5c26159c97b324dc5174a5713eafb8c855cf8106 ]

The `char` type with no explicit sign is sometimes signed and sometimes
unsigned. This code will break on platforms such as arm, where char is
unsigned. So mark it here as explicitly signed, so that the
todrop_counter decrement and subsequent comparison is correct.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index a189079a6ea5..e913ab0096cb 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1225,8 +1225,8 @@ static inline int todrop_entry(struct ip_vs_conn *cp)
 	 * The drop rate array needs tuning for real environments.
 	 * Called from timer bh only => no locking
 	 */
-	static const char todrop_rate[9] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
-	static char todrop_counter[9] = {0};
+	static const signed char todrop_rate[9] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
+	static signed char todrop_counter[9] = {0};
 	int i;
 
 	/* if the conn entry hasn't lasted for 60 seconds, don't drop it.
-- 
2.35.1



