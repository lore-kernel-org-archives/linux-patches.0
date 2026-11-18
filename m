Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022425;
	b=u6JllZvXV/t8HrbgUqtBzNKSgT9Xf5QE9xmFUuzofW24jXWZx86QUpUaWvnPHTwdci/r
	 q289rP0GEyTZirijDUz8dizqan+GSYNoMJzxDgukaD3kvxV3gX/jSj4jIVIABmXQHqbFh
	 LF3NPirMG7VG1vzKtmJYzgEElPvHEBtrwo5tqA0MakniTmiBzsUfhz6KnPh5DSRc/3aZX
	 xHAEiyqseQzNm8V7Rdbwttl6mOMpZrcRvYqblz1QqU8kCwxELyvs00Q86QDKZjih5+GOD
	 cCPOyuujyY6BKMhZUCc4IPhRp+8w89IbD3dw+CRw4H4imYkIFNB6spxaEEErOioLoag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4oP/JLKKQgm5LVQb0TV0KKy+GMau4+OPXFJpLnta7cs=;
	b=lO8iYBSBmxOrDNV54C3rV2Wkgwg5RS2pBrgL7cTJr9JIeyLsfmHbJebIbMTxwggWRm+m
	 VbI/93NNzJh0+5GzH48lSP9ycRQVeS8api266wQ2C3p1shDflvXPS/OxuVIOH3iL0/+J9
	 U17o5OZWS8qysVEBot7aTnuY8QXvj2sI5DnByhNtC+PIFPs1hUjQHJiyGchX8L80bXv4v
	 JOaoE3VUwwV7hRFJ3COmgvF29DGYyb6QVRAAyeGDDEpKPymfxKAHrtolTakcsq80/3tMV
	 vSbgbVS5llzjOrP2Zr6VvaOIvjpe+j8W49eIQcf18OSsIAD/yskeMYqQKEa1hCiF6iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="G/5v/3xg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36645606A325;
	Wed, 18 Nov 2026 17:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G/5v/3xg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C73F1F000C4;
	Wed, 18 Nov 2026 17:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022425;
	bh=4oP/JLKKQgm5LVQb0TV0KKy+GMau4+OPXFJpLnta7cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/5v/3xglnT2dKM89nNrtvpxVgPAikVHB/8ZGif0LxQJfcH4eTlr6YXPDA31KTRHP
	 ThVumTrsB+h+6SVqw7fJCiW1/xU3uVQbhgnnnm5GxCcPGF+e9OtVQtTXPegQBArh6I
	 Fh4NZz76ut0CMSIYxRfRvio/vb3JOcNF3UdUl8UY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2629/2651] apparmor: advertise that sctp is being mediated
Date: Wed, 18 Nov 2026 16:04:29 +0100
Message-ID: <20261118150418.820922889@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 35b8ab3f36ac0fcd8fc910da0bed889b6c75c426 ]

Enable the test harness to detect that the kernel should be properly
mediating sctp.

Fixes: 7a82f9a06459f ("apparmor: fix check SCTP bind, and connect permission checks")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/apparmor/net.c b/security/apparmor/net.c
index 641d181544ac3..136d14226b97d 100644
--- a/security/apparmor/net.c
+++ b/security/apparmor/net.c
@@ -24,6 +24,7 @@
 struct aa_sfs_entry aa_sfs_entry_network[] = {
 	AA_SFS_FILE_STRING("af_mask",	AA_SFS_AF_MASK),
 	AA_SFS_FILE_BOOLEAN("tcp-fast-open",		1),
+	AA_SFS_FILE_BOOLEAN("sctp",		1),
 	{ }
 };
 
-- 
2.53.0



