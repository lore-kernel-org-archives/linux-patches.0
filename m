Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046617;
	b=PpCNv9J69aejP8jj0flnXnCJJnYxIEKsG+iXjikxT4ApybrUivrHMoymBp2MEY4j2ypl
	 6viYB7IKcIswvWQw3nIYmnAKslQyO3BdlC6liLpZQfsn0e4NrzvNs0z/Q5EODIE8WJPky
	 J2OcwIc8qnMMFpiZhQ3NPK5kdef2yJt3vB4NAVEO3bSNqxIxrLMx7pDMTA9PbufBvX1hD
	 TjxRxx6Ki/ybB9uFVy5xcd6Aj9EAr94ltNMjByBPhw8fPhuAZAB2Z7ZJDCQf/jWWosGX7
	 nnVgyreDzcmIv5U5/bH1rt+G8RcphViyRMKMbTEOMS2TQg4J1jhMvDrMlmIjobi30Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tl/R5RDsA9tX3/NBoNPRJ7sBAsbBSVda4b3t5P5zzr4=;
	b=hv/6IRw7XMW3Zck4i41UOU2KIZc/Ub0sxCcfF1zQGjWX70eNDf3P+rrQ8IItHP0Filxr
	 ZR6QES/88mMWKJGZOInznBepG+tDfIxrv35P4V5JrsU/TOBHlJYyLloIHlhJb2qQMHnVP
	 AOR8Lr2fUbkq7IYEyx/pMBhtFz0YxzbxDDPsq/DWPWZ2YWT7eR4yLyIazBYDr0rkS5AFH
	 Xsy9DfCGmEudwGGVGHGJ8rfHG85ABeZp8Rq98gb2gAY6vN1cJDM0WoFp4w/LFSQ7isGpi
	 IaPww9pAbFxdmK9OI3I1l6Jt7v4aE8hq1nMWL+Io6KWsXVZcFeZzKud4Z6Y052q4z5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YRBZOZs0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FF1606A32C;
	Thu, 19 Nov 2026 00:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YRBZOZs0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F771F000C6;
	Thu, 19 Nov 2026 00:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046617;
	bh=tl/R5RDsA9tX3/NBoNPRJ7sBAsbBSVda4b3t5P5zzr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YRBZOZs0ULkTnoJdJ3zyU0lNQ/bSOfqHfh1rv+NgLlgnOiH8tJ1ftXbFPNzLXgVBl
	 aFgWAMiR1uuytlKVXXA4/m3UHOC979wP8J4YZtEDC8ok5lg/ov/SaZdszG85UBT8IG
	 Y9VvnHUZJtgfeQ0A9XSBwy2Bx5PpG/C/2hWUR48o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1346/2857] batman-adv: tt: send ROAM_ADV on each roamed back client
Date: Wed, 18 Nov 2026 15:39:40 +0100
Message-ID: <20261118150249.883198394@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit aff4d5d10f2dcb4a9b604e27414dafa1d51b6406 upstream.

When a ROAMING_ADV is received for an announced local client,
batadv_roam_tvlv_unicast_handler_v1() creates a global entry with the
BATADV_TT_CLIENT_ROAM flag set.

If the client sends a frame again before the next TTVN commit,
batadv_tt_local_add_roam() is expected to announce this return via a
ROAM_ADV frame. But this doesn't happen because the global entry (created
by the first ROAMING_ADV) carries BATADV_TT_CLIENT_ROAM until the new
originator announces the client.

Let batadv_tt_local_add_roam() always handle a roamed back client -
independent of the ROAM flag of the global entry:

* trigger sending of the ROAM_ADV frame(s)
* remove the (with the roaming) associated global entry

Cc: stable@vger.kernel.org
Fixes: 068ee6e204e1 ("batman-adv: roaming handling mechanism redesign")
[ adjust code still in batadv_tt_local_add ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 6e41824db11c8..a2b38e5980615 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -775,7 +775,8 @@ bool batadv_tt_local_add(struct net_device *soft_iface, const u8 *addr,
 	/* Check whether it is a roaming, but don't do anything if the roaming
 	 * process has already been handled
 	 */
-	if (tt_global && !(tt_global->common.flags & BATADV_TT_CLIENT_ROAM)) {
+	if (tt_global &&
+	    (roamed_back || !(tt_global->common.flags & BATADV_TT_CLIENT_ROAM))) {
 		/* These node are probably going to update their tt table */
 		head = &tt_global->orig_list;
 		rcu_read_lock();
-- 
2.53.0



