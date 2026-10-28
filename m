Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209526;
	b=ucDA1Q7SCe6WnioiTZh3YWu3D1I87hflHN01caITybX0O8NqL9mYRCo6KZSru9t393X8
	 1JVOwMgPe3hd3DaM2+w6CjC4jeTWpziexjrq3PEGkOGPa1aNWIvnuDv8CmvRUHWyPknO5
	 QQFoDD5E/xFqV5zTVVHsDb5+AcqupLUBozc6dit1GRBqRzyxvSoeCMt28gEUUhbNqEVkV
	 wZ+u2wpGcb4QX71GwH8fHKCC+/URetu9F1XuEh1qtn7IDcuHfMehbN5CjEp2XQ38ky+oM
	 fUAJ65STCBrgMORCax51jJ5vpHvhO4VyTipMlY7jJPE0OqaEJjqFSW4iU1r72pkENXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209526;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I8HMh8oFJXHxyqARGVltcqbBU7mLRyvxyT/uJkcp2e0=;
	b=GygeGiegmvScU48o7x4GLdgGBloomq0VYz2O/PmajtokKTSoDCr9NAA2niMAmSYmcq3c
	 YCpNJmE4v9GXLi8GNYUhrvZcGNtXwV5NKql/5Ot5XTt0KFmP9HkensU/5ubO+KW4fzNHD
	 7D9T3HG+xyrb4JY1/fNzyBIbUzRJRIAKb4hUKEZ3bWrQPZy/wZSF9+7n2Siv6cWMFdaii
	 7mfyiTTN5idEoF0SwKqwDT/K6v6xQ4rjgY7bTCQfbe4sFF7+MMOt+I5NjTuVeHpKvbf7y
	 7fo/LIlR/Qet8fb8IFsZvSvt5Uvs/Txm6SGL11DiY6084jd6yhDt5i8v3v6aR0TK9yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZYrtYjbA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A56606A31E;
	Wed, 28 Oct 2026 17:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZYrtYjbA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681331F01825;
	Wed, 28 Oct 2026 17:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209525;
	bh=I8HMh8oFJXHxyqARGVltcqbBU7mLRyvxyT/uJkcp2e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZYrtYjbAUe5mxi/gha+VBOBPOOQcBOFMFiWbnp1oy8WZ2JYhrAie8opRNntWPe9wj
	 Xr6tYHoLzMfI8FmWQtRSWXle+AZg+Lm3vHbT1VJLlatqRykR+RWQxEuSshzfsIc342
	 OevFZ8Rhdsta48nhKIit2oTml8JLaIW/IDgKFDp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Steffen Pfendtner <steffen.pfendtner@kernelscan.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 501/516] netfilter: nf_tables: always increment set element count
Date: Wed, 28 Oct 2026 18:00:53 +0100
Message-ID: <20261028170015.346580139@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit d4b7f29eb85c93893bc27388b37709efbc3c9a0e ]

At this time, set->nelems counter only increments when the set has
a maximum size.

All set elements decrement the counter unconditionally, this is
confusing.

Increment the counter unconditionally to make this symmetrical.
This would also allow changing the set maximum size after set creation
in a later patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
[ Backport to 5.10.y: 5.10 has no NFT_SET_ELEM_CATCHALL element class,
  so the catch-all exclusion from the upstream commit is dropped and
  every element is counted. ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 95a03b01014e7..867b5e152d677 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5841,8 +5841,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_element_clash;
 	}
 
-	if (set->size &&
-	    !atomic_add_unless(&set->nelems, 1, set->size + set->ndeact)) {
+	if (!atomic_add_unless(&set->nelems, 1,
+			       set->size ? set->size + set->ndeact : UINT_MAX)) {
 		err = -ENFILE;
 		goto err_set_full;
 	}
-- 
2.53.0



