Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211941;
	b=MxKfc/5V8QM4YwWoftteF0PePVfb3Emx59n3XIQYv8uXFCMGzd6DfKNGmuBslV6+KvrM
	 OEtW6kWqPnWuCgr7eM0cCxaxJSkQS5+kIWMEDZu7HxcWOcFO5yxB5k7qzPAUt02xHDXl7
	 H/wylFo9JDnRTHYclq6d0cZ4Bt4SsQc5zfiaq2qTd71ZYaMgkqCnYZjxzEmzsGU1lRHij
	 6Pxu0Iquj/5lwEe/+Ed8YPE7VcP7LS6s4ACjROtD1PZupFUfM1nXwCn0IEv8X1RzfSEzY
	 tMmD5hrNS3Y1i4HWYcGY3PWPxlxHYBJFIyvpiGukPUAxE542n1FLyTGMe9RL3BP6+mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sz8S27vhnUI+cgCqIz4u1uyQpE50fmICMnPqVo88Rxc=;
	b=qSkxrAqNpkQWugOPtk9oEGpzLeg2al3MWEJHNVbG/9NVDUa21sF/quicIrDO/JwtQlM6
	 vJQfamaXPse+jqPsk0sj8b6jSfTsLBuGKWlg+wckoQ2vMKaZGtrJZGafqyiF5bZ9CD9qx
	 bLRyr1fjPeFNWKbpFn8+PqThDjuwz86HennkRqkDAOSUhLpDTIAoVfeYWudp8+ekIp1vR
	 qG6Tbn/w2li/ot+RBXx2dPnv16VP1oQgg/XgyoeHzy6KchFeQ9exkUtk/pKGDFPO1r+4l
	 B0fpkRb5EWXYt+gKX2b9x1FOpXke8uZBwyv86W+e29uuMP0bgRQKYnJUGp3REv/dN+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bloZkHne;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4021606A31A;
	Wed, 28 Oct 2026 18:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bloZkHne
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29451F01825;
	Wed, 28 Oct 2026 18:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211940;
	bh=sz8S27vhnUI+cgCqIz4u1uyQpE50fmICMnPqVo88Rxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bloZkHne/+usXMJZiNsDnI9643Nc5WIxHKBgtUxHmgVOXafqutx1AS1CYBkL8nfew
	 tPCULirGdmiu0TB6Ng+cxdvt9HMMJN/EV2Y4O19/t1Pj9/GCXu4MbKj2cgjyraa/6n
	 e2csXGxcqt2rH3xYUYi6VlewFgKr6xPfnWhR0lRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Steffen Pfendtner <steffen.pfendtner@kernelscan.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 552/571] netfilter: nf_tables: always increment set element count
Date: Wed, 28 Oct 2026 18:01:39 +0100
Message-ID: <20261028170021.133959509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6a6b42923f504..a883e06bb87be 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6583,10 +6583,13 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_element_clash;
 	}
 
-	if (!(flags & NFT_SET_ELEM_CATCHALL) && set->size &&
-	    !atomic_add_unless(&set->nelems, 1, set->size + set->ndeact)) {
-		err = -ENFILE;
-		goto err_set_full;
+	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
+		unsigned int max = set->size ? set->size + set->ndeact : UINT_MAX;
+
+		if (!atomic_add_unless(&set->nelems, 1, max)) {
+			err = -ENFILE;
+			goto err_set_full;
+		}
 	}
 
 	nft_trans_elem(trans) = elem;
-- 
2.53.0



