Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65082611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74F7C433C8;
	Mon, 28 Aug 2023 10:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219457;
	bh=7y+qwDiD5wacyFR2J1LIJ6Hxr7NFaaNeVhPYr/ZDEmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zeUNG8LK29Xe6L7Vca7wm9D+nUDkTT4JImu10eGdv11qAduxEAa8UCTSBuby+ITKY
	 VyK6+8ObC/LGOXE6QlpokOSKdUCnWbxVOSTf3sl3oXOmOmB477i/4mWQgemN0cgiYk
	 /yKVQWmzPkOKtsM7Hgww3hJ/DH8y2SX9JNcvfY5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 42/89] net: remove bond_slave_has_mac_rcu()
Date: Mon, 28 Aug 2023 12:13:43 +0200
Message-ID: <20230828101151.593968272@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101150.163430842@linuxfoundation.org>
References: <20230828101150.163430842@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 8b0fdcdc3a7d44aff907f0103f5ffb86b12bfe71 ]

No caller since v3.16.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e74216b8def3 ("bonding: fix macvlan over alb bond support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bonding.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/include/net/bonding.h b/include/net/bonding.h
index e4453cf4f0171..6c90aca917edc 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -699,20 +699,6 @@ static inline struct slave *bond_slave_has_mac(struct bonding *bond,
 	return NULL;
 }
 
-/* Caller must hold rcu_read_lock() for read */
-static inline struct slave *bond_slave_has_mac_rcu(struct bonding *bond,
-					       const u8 *mac)
-{
-	struct list_head *iter;
-	struct slave *tmp;
-
-	bond_for_each_slave_rcu(bond, tmp, iter)
-		if (ether_addr_equal_64bits(mac, tmp->dev->dev_addr))
-			return tmp;
-
-	return NULL;
-}
-
 /* Caller must hold rcu_read_lock() for read */
 static inline bool bond_slave_has_mac_rx(struct bonding *bond, const u8 *mac)
 {
-- 
2.40.1



