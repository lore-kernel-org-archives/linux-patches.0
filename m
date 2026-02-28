Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D3D43636C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301092; cv=none; b=MmHpvCObbTWe/pwFcfvvVEMr96wSrwBK8GPdFtnI320u85En7RKEM0fpNxJaombsUG3SKOIsd+Nb4OLStnaAM1Fru6w82z1wiCTIzDnP5qMKkaoCZP8jzjaDScckCM5GcinMtCHaFf1LoqNB3ABDCVqlasiAid+WqPE7ldmH15w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301092; c=relaxed/simple;
	bh=4anH0qLG+21ObCdiuICIxYxlQmKcgpgfT4QMiejqsEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNJGRtwU0XrkF6koFh03x3vwv5gJXrQYXq57PLSemFmupHL/CxbJPHsjZtlJ2EQInmYbKZM7JhoMidrJkfHxbr3n8duj6vMTUk2/ZuuLO9GzyPZmr0N7sYUE7pt9phQmm2b4Z1Q/ZMHzHO3FQlhhJprOfdkRk8ZtOd+Faa5Ibtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=plU4xT61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="plU4xT61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A15C19424;
	Sat, 28 Feb 2026 17:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301092;
	bh=4anH0qLG+21ObCdiuICIxYxlQmKcgpgfT4QMiejqsEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plU4xT61uFwopeBaailHHAkMpPYI5kQ4fc6oS2cWQSC/V+QQvi3aoWnTulLxoBuK/
	 fji0bvLSrzN/6LZarcfQcZGtJYHLQ7/h7SV8gBtBtbl/edOxWKV4iKCqYHowfi6zvW
	 dR26JX7n8LErCIMq0+8LNLn2tMjK/KnWbXJz98dhIiaE7w7xqebwMBaUYoVf/SqLf/
	 xc6yRZ57Vsd9ZZluLeXy8NnkdLe4c1zptXokHCUaa/Q2gJYg3Pl7z5XOTWMsAgYUop
	 s8TKK1kZQd6uYjH/UHMrN3fBhTwKZn/D0OmJGbrTNDIwMOrd+ZtHNuzsxq+6fN00M7
	 aW0YJE7Hi/txw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 243/752] ipv6: annotate data-races in ip6_multipath_hash_{policy,fields}()
Date: Sat, 28 Feb 2026 12:39:14 -0500
Message-ID: <20260228174750.1542406-243-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 03e9d91dd64e2f5ea632df5d59568d91757efc4d ]

Add missing READ_ONCE() when reading sysctl values.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260115094141.3124990-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ipv6.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index f0936df7567e3..7e984e75f3345 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1010,11 +1010,11 @@ static inline int ip6_default_np_autolabel(struct net *net)
 #if IS_ENABLED(CONFIG_IPV6)
 static inline int ip6_multipath_hash_policy(const struct net *net)
 {
-	return net->ipv6.sysctl.multipath_hash_policy;
+	return READ_ONCE(net->ipv6.sysctl.multipath_hash_policy);
 }
 static inline u32 ip6_multipath_hash_fields(const struct net *net)
 {
-	return net->ipv6.sysctl.multipath_hash_fields;
+	return READ_ONCE(net->ipv6.sysctl.multipath_hash_fields);
 }
 #else
 static inline int ip6_multipath_hash_policy(const struct net *net)
-- 
2.51.0

