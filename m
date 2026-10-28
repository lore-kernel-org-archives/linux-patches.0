Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213985;
	b=J5dJeXx46B+nIxMmo8hxHIKeOPsP/RLV3j/au3luAHhoTk9YjjKsz8PR7tN00jQTtnPe
	 fcTVvFRv1ZkSNh76XtcnoxFcaAFXRz4r9Q2OBmenXXlfzT6NXd1YnmBQfQwnM7A6rnVTV
	 flf80VewV4b620iEN+Ezs0nhAKpG0GzMjYJJlbDOACcWEczckOOxrWvOlSjJEIcl6/PRa
	 gKX1Pov+BGm/em0OIxvvZk7Mhqn2/bZp3kFvfMAGSGh+Fi24sRGfoWGb2hYVh91kATzuH
	 QP3dyPn11tsurMZp+s2yNvZub85Rqvd7HT2YGHiJxg1+ekIlowQg+cT4VlDxsPRaCvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+/ugGtMiih1avRTMrZaHF5HCIKKwlbzTaeCDhOa18gU=;
	b=goUTvwSiL0oMxF5BG/CUeQ9Sd+Jwc6ymj0mC9oLqbdOh8pmSfOSDxKKQfDHs5pN6jsB9
	 QJoapao/v4kBJE2xDU2Ro9SKrqH63Uqd3ipGq+ZIxInRlt6MRu/xMNyvc4bfY1LPLdfxu
	 rDBWFCGXGLDiuaPsRA4MBwBRQUI4ca/8o0iQmR5j7VhAILnuWTpyKYs1o2O6iW28AT3rv
	 adNAWzhUekX69pLGMikpeAu2iKSMdTrvO4RGsgppgtdJ3fOB8X4SQCHZ5m+oD5TIsTgi2
	 jBxJaca5lzfi4yZuasZ2pyHa11PjFJ50HPpNpFGHrSY6lfTGCMUl1nI9l/pZqziBcaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Fq7S01V/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C466606A31A;
	Wed, 28 Oct 2026 18:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fq7S01V/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CF21F01825;
	Wed, 28 Oct 2026 18:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213985;
	bh=+/ugGtMiih1avRTMrZaHF5HCIKKwlbzTaeCDhOa18gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fq7S01V/rdMNlemZJApxNh8BE2HoAznhPFRuevw6K9pyc+pqmBdQ01iCJXcwMux/L
	 YzVqfXfqmqbP4aSzsTKx05lNcXnHwhCIV7CQ+8jUhqftqBgr09sBa3y2r18fzehoCt
	 qW2Wl7mLkGN1vZYrhwUka3J+wQkD51/nCGIlrsq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0698/1887] smb: client: stop flooding dmesg in smb2_calc_signature()
Date: Wed, 28 Oct 2026 17:46:34 +0100
Message-ID: <20261028170515.296126856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit a13ca780afab350f37f8be9eda2bf79d1aed9bdd ]

When having several mounts that share same credential and the client
couldn't re-establish an SMB session due to an expired kerberos ticket
or rotated password, smb2_calc_signature() will end up flooding dmesg
when not finding SMB sessions to calculate signatures.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 343d7fe6df9e ("smb: client: fix use-after-free of signing key")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 3a69f3500acde..e72c6933788e8 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -242,7 +242,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 
 	ses = smb2_find_smb_ses(server, le64_to_cpu(shdr->SessionId));
 	if (unlikely(!ses)) {
-		cifs_server_dbg(VFS, "%s: Could not find session\n", __func__);
+		cifs_server_dbg(FYI, "%s: Could not find session\n", __func__);
 		return -ENOENT;
 	}
 
-- 
2.53.0



