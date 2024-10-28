Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA762AF07;
	Mon, 28 Oct 2024 06:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098516; cv=none; b=YwIRtaMNbwKBpgQEBk9xLWd9rYxZ0IKZ4bc02tzDofgI2da50Al1TCXgeSr9VnqaDVZ8HtitusqXnXCqKg9uTaAZ9XwktuwOT53UogFJL+e5lRNIFkMtXle9mdIYXuciLSfYqDRFdhB3E+2Eu9viawq2eQnkCk+L7sWEQIE9788=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098516; c=relaxed/simple;
	bh=sJC3Kkq6/GRvJRkDCoUcShjBH1loeE2Ib/JYdt+xY1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUdaFSMOLyQqzVxVLS+cg34PVym+yftAAwUa7W55GOKXsGisxVs+of2feN1z+Pskv2BghCxVwqxAusrvPbrwMwuQtT8D4rnjztoi2sMFtLCs3DsCB4bQF6qDvoM/js8Mup/G65KPFAZkfVNCAw4mXyz9CMZZRKT8RN6iQh9nwkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJtK8zdL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJtK8zdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4D3C4CEC3;
	Mon, 28 Oct 2024 06:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098516;
	bh=sJC3Kkq6/GRvJRkDCoUcShjBH1loeE2Ib/JYdt+xY1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJtK8zdLiDDr63IzK2sgCF3pqmtd1Wn5TBLaOtj451eOQMyj/XcO5ofz/dlwLBjQ6
	 G4A0qapwZItOE+i4jpSBHltFqlsZRmzxLkkjJckQ5LoKFC8IFp6m2wRJ9KGgUZQvQ1
	 XGkQ2mGwPR7ARyCwnnzE+ETNIqhB399osT0QkiRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 6.11 253/261] Revert "fs/9p: fix uaf in in v9fs_stat2inode_dotl"
Date: Mon, 28 Oct 2024 07:26:35 +0100
Message-ID: <20241028062318.444310649@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <asmadeus@codewreck.org>

commit 26f8dd2dde6864558782d91542f89483bd59a3c2 upstream.

This reverts commit 11763a8598f888dec631a8a903f7ada32181001f.

This is a requirement to revert commit 724a08450f74 ("fs/9p: simplify
iget to remove unnecessary paths"), see that revert for details.

Fixes: 724a08450f74 ("fs/9p: simplify iget to remove unnecessary paths")
Reported-by: Will Deacon <will@kernel.org>
Link: https://lkml.kernel.org/r/20240923100508.GA32066@willie-the-truck
Cc: stable@vger.kernel.org # v6.9+
Message-ID: <20241024-revert_iget-v1-3-4cac63d25f72@codewreck.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_inode_dotl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 2b313fe7003e..ef9db3e03506 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -78,11 +78,11 @@ struct inode *v9fs_fid_iget_dotl(struct super_block *sb, struct p9_fid *fid)
 
 	retval = v9fs_init_inode(v9ses, inode, &fid->qid,
 				 st->st_mode, new_decode_dev(st->st_rdev));
-	v9fs_stat2inode_dotl(st, inode, 0);
 	kfree(st);
 	if (retval)
 		goto error;
 
+	v9fs_stat2inode_dotl(st, inode, 0);
 	v9fs_set_netfs_context(inode);
 	v9fs_cache_inode_get_cookie(inode);
 	retval = v9fs_get_acl(inode, fid);
-- 
2.47.0



