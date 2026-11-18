Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015554;
	b=iVakHNOh+aIqZLxJd4qUPEhBUhADvVxHU6t0rSTQr7rMiS2xNfVVE1pbtrMz8iILXVdn
	 v5iyOPMBLaU0ItwubeInPvsogoBOpkt1cv16HvoC7JXVwIGn+3YS19WfgKwvc/JnkwL0a
	 ZXp/t2uGTU7x5mCNkeqOZVw37RSxwSLYhsC8ywTpK/Yi6KAgnl6xdAVAPNuh+FKSIkNgt
	 +dhoPbgTYwkeOWhNS3sorylrB6BAxGzeKYarVpPZou4B8oCwIWlC0ro5p1LoUBD30aaJj
	 8NlShokgLhgi6tHpRN6G60i65Iab9gvLMq63aZDQlrd9sT/0uqa5BN/LECa00NDWscA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gUdL75uNZEgdZVXXndDr8t0JQgiIVKifk9GIINjEhVE=;
	b=HQp8SxzxghgqflYZagDWXMa5sUL4ZzdIqk7dTg8hmlp2x65XFqVc87ZugsHlBjdB8HO3
	 OVV9uf/6l+6juG64snlse4DAj/Qv2sNwNhtsM0AaNKr0rHeVnVDNjwB13/GafR0oAisjF
	 WjlmWF0G88pqiLh3Btw6BTX7mW+iW/TE7M9qu5YgHCDjNeXOj7wcixBrltaqiqcDTf217
	 A9ftoJtgKd5EN0Rv/fXsF1zllyeeg7coPrfX12STYP9rR1PVrgyKkUSCoidrDDHe1Y+XJ
	 b0MLOcrtdWyiJ0bZ6c5CEL1gsUl65409DavV31nZFvRs3X92//NRsrL53r/Z0iAL2Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wJ9eqQwD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A032F606A325;
	Wed, 18 Nov 2026 15:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wJ9eqQwD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85431F000C4;
	Wed, 18 Nov 2026 15:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015554;
	bh=gUdL75uNZEgdZVXXndDr8t0JQgiIVKifk9GIINjEhVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wJ9eqQwDhHdANkUOkkMoOfmu37buwdkZVwl2ubtzhPRBdyjhiUb1OnqR0sVYDnzy3
	 iHg9bZ8NQtYBswT/W0sOh3Ki9ZouHGvd640Etm7Q0RVrdQ7phqZa+jLyLKyU6Ndb1D
	 E25qS2p9Szwu6Eamqj0qhwZqoYXepd8us9BntfNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Julius Bairaktaris <julius@bairaktaris.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0216/2651] wifi: mac80211: fix swapped fq_overlimit/fq_overmemory in aqm debugfs
Date: Wed, 18 Nov 2026 15:24:16 +0100
Message-ID: <20261118150255.650702780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Julius Bairaktaris <julius@bairaktaris.de>

[ Upstream commit 25f3f2ff88ae604a3b473b501fc55d58fcb0f5eb ]

The two scnprintf arguments for fq_overlimit and fq_overmemory are in the
wrong order, which results in the aqm debugfs file showing the overmemory
count under the fq_overlimit label and vice versa.

Fixes: 2a4e675d887b ("mac80211: Export fq memory limit information in debugfs")
Reviewed-by: Toke Høiland-Jørgensen <toke@toke.dk>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
Link: https://patch.msgid.link/20260904090626.92727-1-julius@bairaktaris.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index e38631d7cfb42..1f914b48e3bbe 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -96,8 +96,8 @@ static ssize_t aqm_read(struct file *file,
 			"RW fq_quantum %u\n",
 			fq->flows_cnt,
 			fq->backlog,
-			fq->overmemory,
 			fq->overlimit,
+			fq->overmemory,
 			fq->collisions,
 			fq->memory_usage,
 			fq->memory_limit,
-- 
2.53.0



