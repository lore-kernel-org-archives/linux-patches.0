Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F3115A853;
	Tue, 18 Jun 2024 13:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716748; cv=none; b=QlHFF1XrAG7nkPtbRkAMxQkeggVzqt9kvGToebT+6NpG+u/h8En4VF36g5jq6Z28MYHLEWB2icY+JNrL5kwjz+jJkY6t1iBewtmlTGQiEPtIUWYmemH0ovV3pTPgSJQ3I2TEDRbEWF/xr4SGlURSKPDPHSzIS0eDjsKZo7LsWUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716748; c=relaxed/simple;
	bh=3SugNpL6oJMBcjB+HJvFLDu8yEmB9cFAW9wYgKU3bpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPJXlekIoz9TkFXwpPuAkj34Bwqgnx+IbW3jyUr0JqUJY7vjQ07YJToor7Lw7tG2DvvgSD13yCfNt7r8v/PiuXHzAMM7UjZUjMY17PLZOGjnkngeHdNV0JPTWkN17TWfBnT9ym0Spx3auHD1ns8iOuoPTyJYCgZPJr1KGKCrslQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxJFOZSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxJFOZSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D156C3277B;
	Tue, 18 Jun 2024 13:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716748;
	bh=3SugNpL6oJMBcjB+HJvFLDu8yEmB9cFAW9wYgKU3bpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxJFOZSmOEKNxfUSUM6rRhbhxvr7iV/J2wg/TUV6UB9xl9nS/mrw4w1ze17RvXHFv
	 x5304suhpTcWqnwYSGdX9bot6s3iuA5sjfmODUIkTYIY9vcnZrZ9mgtMomIsa5LO9A
	 ChxprZvQOXXPzWn0W/ML4+oOuds9hWUAyWiW/pG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 748/770] nfsd: add some comments to nfsd_file_do_acquire
Date: Tue, 18 Jun 2024 14:40:01 +0200
Message-ID: <20240618123436.142841922@linuxfoundation.org>
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

[ Upstream commit b680cb9b737331aad271feebbedafb865504e234 ]

David Howells mentioned that he found this bit of code confusing, so
sprinkle in some comments to clarify.

Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



