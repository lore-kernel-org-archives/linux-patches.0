Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739BC13BC35;
	Tue, 18 Jun 2024 12:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715562; cv=none; b=g6hFbqrhXIvDH4R39yxRLLDcenVFCTCBhwhJWeztSkbKVC8tnS+/Xjt4nhp4N5ffD+EtKlpCfk6CVTUpaKu12vIdliuaJ7IqD9UWuIXLw2xy5i4atq7M2w6DrVHGhsl/HXGRv75a7mfEaWD5bsTDoeHHNXTglE4AYpy9fzYmmq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715562; c=relaxed/simple;
	bh=/JrLa1tbT/yDwdEWVAjKh3beCfaE/AT9TOT/TPJMrlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msAgS0MaBeQA+UdrKnhWLGxkmYO9eI8kpeSdz8Ev9PwXSF7+R+V9iZgjv7g4xHTwjUw4DUQtzVJMrCbypV9jiW+1ZRIGOsOJ8gnbsqvKJHeRQvAr/QP1jBZCurP8Vd3jXWb5ttyqibmbxMb0tEfJcJLWpThttDivGo5IYcCbB5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ne4L+Qd+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ne4L+Qd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC482C3277B;
	Tue, 18 Jun 2024 12:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715562;
	bh=/JrLa1tbT/yDwdEWVAjKh3beCfaE/AT9TOT/TPJMrlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ne4L+Qd+a/o67k6YhvqBO/G+iCukWRgFhgffQXz8X5jpvCnPHCi9OmGRB2l8VsXwe
	 GILTy4RE+6qihBmpmdbM1u6FlbH96VhCOJ4ZfAofoN78m60Uo+qsTU96Jq1hkzK7G+
	 RoG5lh8cYyjV+6oieE5WBfv3wfA2zJED2UZw1b1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 343/770] NFSD: remove vanity comments
Date: Tue, 18 Jun 2024 14:33:16 +0200
Message-ID: <20240618123420.504203099@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit ea49dc79002c416a9003f3204bc14f846a0dbcae ]

Including one's name in copyright claims is appropriate.  Including it
in random comments is just vanity.  After 2 decades, it is time for
these to be gone.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c                   | 1 -
 include/uapi/linux/nfsd/nfsfh.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 05b5f7e241e70..2c493937dd5ec 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -244,7 +244,6 @@ nfsd_lookup_dentry(struct svc_rqst *rqstp, struct svc_fh *fhp,
  * returned. Otherwise the covered directory is returned.
  * NOTE: this mountpoint crossing is not supported properly by all
  *   clients and is explicitly disallowed for NFSv3
- *      NeilBrown <neilb@cse.unsw.edu.au>
  */
 __be32
 nfsd_lookup(struct svc_rqst *rqstp, struct svc_fh *fhp, const char *name,
diff --git a/include/uapi/linux/nfsd/nfsfh.h b/include/uapi/linux/nfsd/nfsfh.h
index 427294dd56a1b..e29e8accc4f4d 100644
--- a/include/uapi/linux/nfsd/nfsfh.h
+++ b/include/uapi/linux/nfsd/nfsfh.h
@@ -33,7 +33,6 @@ struct nfs_fhbase_old {
 
 /*
  * This is the new flexible, extensible style NFSv2/v3/v4 file handle.
- * by Neil Brown <neilb@cse.unsw.edu.au> - March 2000
  *
  * The file handle starts with a sequence of four-byte words.
  * The first word contains a version number (1) and three descriptor bytes
-- 
2.43.0



