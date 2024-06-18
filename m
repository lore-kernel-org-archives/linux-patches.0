Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF7A50297;
	Tue, 18 Jun 2024 12:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714761; cv=none; b=kess3Ld80OutT6KXIDZww/N8qn9GCPctc322DVu64sHG8kMzbwnugaPb83OVveXER35qTtlvVgPLM8ZrZi32Icw9+CrIjnurRgOlOPFWT5/og1SUdqbC1QYofHz8nI5f6ItlHlRt+5KBREx7f5U5oRnNIDDqC5GxlCWXm8+C9xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714761; c=relaxed/simple;
	bh=mlFu3fjDw4lXkkfwt3GAYSaDmh6Hhc6BxS1DMLhox6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUTTr77HgYRegr1SMFdtfC4rYx8iAA4Rs9jWVG7S6MiQsQaeXvt4m4qy3uX5o+f8PxTeCMgO5C8Obn1liuqescFenxB5dJWnEFA/6wfDZw5dsxZizPP6yc3+3S46LqT5O4+rcLjsxXVgHa/AoKBHaX7EqlFDGoRc1CmR320B6II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRiUxu5j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRiUxu5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB752C3277B;
	Tue, 18 Jun 2024 12:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714761;
	bh=mlFu3fjDw4lXkkfwt3GAYSaDmh6Hhc6BxS1DMLhox6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRiUxu5jPJS1J5qXn6E7ah79oQqp8VjaWFZrbsJmoZcdjKB4c3uuFujHQ6fqT5bJr
	 JNkhyrfVABqJ9xFIaxbr8v56gdSPGlaz0EnX7S9rLTfh8PK612KKogClcUHnamL1NO
	 HjeOE4BotazEeubr0jeUsZIxFXAxR19FAN7TlNA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/770] NFSD: Replace READ* macros in nfsd4_decode_reclaim_complete()
Date: Tue, 18 Jun 2024 14:28:53 +0200
Message-ID: <20240618123410.369467183@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 0d6467844d437e07db1e76d96176b1a55401018c ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index d0f0b7cd4e74e..2c684f7e74650 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1738,16 +1738,6 @@ nfsd4_decode_free_stateid(struct nfsd4_compoundargs *argp,
 	return nfsd4_decode_stateid4(argp, &free_stateid->fr_stateid);
 }
 
-static __be32 nfsd4_decode_reclaim_complete(struct nfsd4_compoundargs *argp, struct nfsd4_reclaim_complete *rc)
-{
-	DECODE_HEAD;
-
-	READ_BUF(4);
-	rc->rca_one_fs = be32_to_cpup(p++);
-
-	DECODE_TAIL;
-}
-
 #ifdef CONFIG_NFSD_PNFS
 static __be32
 nfsd4_decode_getdeviceinfo(struct nfsd4_compoundargs *argp,
@@ -1904,6 +1894,14 @@ static __be32 nfsd4_decode_destroy_clientid(struct nfsd4_compoundargs *argp,
 	return nfsd4_decode_clientid4(argp, &dc->clientid);
 }
 
+static __be32 nfsd4_decode_reclaim_complete(struct nfsd4_compoundargs *argp,
+					    struct nfsd4_reclaim_complete *rc)
+{
+	if (xdr_stream_decode_bool(argp->xdr, &rc->rca_one_fs) < 0)
+		return nfserr_bad_xdr;
+	return nfs_ok;
+}
+
 static __be32
 nfsd4_decode_fallocate(struct nfsd4_compoundargs *argp,
 		       struct nfsd4_fallocate *fallocate)
-- 
2.43.0



