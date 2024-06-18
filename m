Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A78815A84E;
	Tue, 18 Jun 2024 13:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716754; cv=none; b=R13nDshmACVml24cu3BaXbUMca8jxi4Hk6Cr+P2mvxsrSmNC7qjeHBvNQ+xzGCFFVpfJtkKLJb+h95ezq9NPxksc6e5a3xAtljq66tDVOyqZseCeZp+7PnPBb4SMm76Q6nPQZJaHi4L97Q4j83W+CYpXhu8UcWUaNCTgX0EQmfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716754; c=relaxed/simple;
	bh=e8lGS/VR1EPED2axxLc7KD151Uex0q7qvjkZs34r08A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGlpNqa8R77iNfVhrspIDku/4bkcnGs5O/VXWFP38c0ebk0XWe2Qkc5No4RZNsuztPJczAJZJmkgE2hXMgN1NdVFeDB9ToTPCdF+W2kg1u9h06L7Cg92/2tdprSqJ2DCUK5PGbg+eOl3B5wwE2bhAG9NgEsGzZdaEF0hYreFo+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ts8G7JQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ts8G7JQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841FDC3277B;
	Tue, 18 Jun 2024 13:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716753;
	bh=e8lGS/VR1EPED2axxLc7KD151Uex0q7qvjkZs34r08A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ts8G7JQQQyOt5p2MU5xJYESzjIlAxkj2oltDgEMyas343bkxRWqLby1oYhPEtXrtg
	 YWWASYy4tPWDhh3IXsg7gbkLafvdzMuHLLuu6cwFf0af9PSRBAlKpUVCtPAqeZkgX/
	 coDQCafoXvWRG/Rd7xiur7RwMbONGbqMdbvq2Rqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 750/770] nfsd: update comment over __nfsd_file_cache_purge
Date: Tue, 18 Jun 2024 14:40:03 +0200
Message-ID: <20240618123436.222065183@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 972cc0e0924598cb293b919d39c848dc038b2c28 ]

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 786e06cf107ff..1d4c0387c4192 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -906,7 +906,8 @@ nfsd_file_cache_init(void)
  * @net: net-namespace to shut down the cache (may be NULL)
  *
  * Walk the nfsd_file cache and close out any that match @net. If @net is NULL,
- * then close out everything. Called when an nfsd instance is being shut down.
+ * then close out everything. Called when an nfsd instance is being shut down,
+ * and when the exports table is flushed.
  */
 static void
 __nfsd_file_cache_purge(struct net *net)
-- 
2.43.0



