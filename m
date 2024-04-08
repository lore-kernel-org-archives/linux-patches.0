Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47ABC7C090;
	Mon,  8 Apr 2024 13:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584718; cv=none; b=YL3NC+CEB+aPjGC8Sr1ZAc7odrsYM6sj76t4r7u6N9NGdXXOBVX1ZP0WOFqOW/VkNg7J/dfUQSrOWz8qyXBZr5prdXUkxvg5nLviKFKfa6JL05ihCT7EJc1BcM/BQJou7FX8tL5G0jSbC31XuaY+++TLlh6ArKbbwWQ4wPhhxjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584718; c=relaxed/simple;
	bh=XeSCWEeS8lWdx6z5RPhyuF/7ss8SNkB8ASTF90nmMlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOg+xPYZX4yNzT4wYY5IqHqbS4isgrwl5AE6I2i9mjZZLD3GTsYlRPjhHxKM5A27tZCtwMPlD/XJmwOR+EXJea/SiKy7QyW7XijZQy6g7G/aevTABwE61JMN+iVl4k+gY/mEa/plDqz4WIrgS/bE72MPQH0yGX0G1aPy7ILtAo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TmCSKO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TmCSKO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A3CC433F1;
	Mon,  8 Apr 2024 13:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584718;
	bh=XeSCWEeS8lWdx6z5RPhyuF/7ss8SNkB8ASTF90nmMlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2TmCSKO6U8ImZ0kC37MVY/hbzQSuQbzla8NCeBUQZGEQ1P0tf3BE7ANOQeVXfS0ca
	 y1tqWVoeIf8j3TOZJL7mve2Ey45KuqvM3azVuf4SC04HVsIta4QHhYF4r7YwapyJ8/
	 7lvWmkpkQalDfsn4aDdkSBTi5BzpzSCvTCPf7Q0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 533/690] nfsd: add some comments to nfsd_file_do_acquire
Date: Mon,  8 Apr 2024 14:56:39 +0200
Message-ID: <20240408125418.964822147@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit b680cb9b737331aad271feebbedafb865504e234 ]

David Howells mentioned that he found this bit of code confusing, so
sprinkle in some comments to clarify.

Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 43bb2fd47cf58..faa0c7d0253eb 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1093,6 +1093,11 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	rcu_read_unlock();
 
 	if (nf) {
+		/*
+		 * If the nf is on the LRU then it holds an extra reference
+		 * that must be put if it's removed. It had better not be
+		 * the last one however, since we should hold another.
+		 */
 		if (nfsd_file_lru_remove(nf))
 			WARN_ON_ONCE(refcount_dec_and_test(&nf->nf_ref));
 		goto wait_for_construction;
-- 
2.43.0



