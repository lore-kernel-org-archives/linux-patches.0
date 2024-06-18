Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA971AB535;
	Tue, 18 Jun 2024 13:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716593; cv=none; b=TkI2KbEogK4zwGwvpeH/nSfa3+H/1OkZ7guWdWZXoEohtDYxIG2TEtpOAPMAgjgN6xySKOO7OsaBLroQsRs+zUHcHX/VN4iBI9zmJsAz8xnTywEg2zerRiDTP6GzVy1EnHsGuIXwQO4NYA6zEhI3W9CG28OeeRjC+DpX+i2/yfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716593; c=relaxed/simple;
	bh=pQa4851lhRVMqglU6ridmr/BvrbJLi3HRmZnZ5fprbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrBBvKtpoV6smU5XG3cNK+Lk9MVLqgKxIVchg9ikmkGs8xGUAsH0xYYMUwt2KSgng7YRaZ8Ygmeck+2VkHkOMBGTU22qamker5ikvOvVKWIPtePeVslBEHmsG2qAUOWAzA2HsBgTRcOfvoYiL7iOJ0xa4NmbVDjXf1lFS1jBz98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xU5kl1bc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xU5kl1bc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018EEC3277B;
	Tue, 18 Jun 2024 13:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716593;
	bh=pQa4851lhRVMqglU6ridmr/BvrbJLi3HRmZnZ5fprbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xU5kl1bc7HXDUOT2cJ4fnrhCN1oNd/caKqDFD01l3a0MfglKrBBOpbZ3F7Ay7i3iy
	 c0sYP6Bxlw2d6eQzznBaK9MKIfGQpmhLh3F8nqKnkMIdLCmCWxJgzBfkmJ3AoDlxjb
	 KrqpdvPQlHVH0L+sdYy/463c8n8ChFwoS1VJRH6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 698/770] NFSD: Update file_hashtbl() helpers
Date: Tue, 18 Jun 2024 14:39:11 +0200
Message-ID: <20240618123434.218697966@linuxfoundation.org>
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

[ Upstream commit 3fe828caddd81e68e9d29353c6e9285a658ca056 ]

Enable callers to use const pointers for type safety.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index dcbf777dc58d3..90505095d7e0c 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -721,7 +721,7 @@ static unsigned int ownerstr_hashval(struct xdr_netobj *ownername)
 #define FILE_HASH_BITS                   8
 #define FILE_HASH_SIZE                  (1 << FILE_HASH_BITS)
 
-static unsigned int file_hashval(struct svc_fh *fh)
+static unsigned int file_hashval(const struct svc_fh *fh)
 {
 	struct inode *inode = d_inode(fh->fh_dentry);
 
@@ -4686,7 +4686,7 @@ move_to_close_lru(struct nfs4_ol_stateid *s, struct net *net)
 
 /* search file_hashtbl[] for file */
 static struct nfs4_file *
-find_file_locked(struct svc_fh *fh, unsigned int hashval)
+find_file_locked(const struct svc_fh *fh, unsigned int hashval)
 {
 	struct nfs4_file *fp;
 
-- 
2.43.0



