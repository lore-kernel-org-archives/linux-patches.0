Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DCD160884;
	Tue, 18 Jun 2024 13:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715716; cv=none; b=Sqi2K5k89b2Zk1fyGJDp9k007HbHWml0FcVlszidAnrGYYfJLDoBZvqseq+AosObb2rVpz8kHPXAS4XG1O+Hk8BNwhT+pzrnxZxXbpK1ic5fGSvIs21xitI8/4xUYd1lXzBlr8PF1iAQG1QUh/kimOjjEc+uMWAdTDqenMtOTYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715716; c=relaxed/simple;
	bh=cocmOji3VJi3P1ZvRUVTBrWTmHjhj28LURUV+eq3sEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyAGmW98JGLE6CgRmVXoKoHxO6z3JAC1P2ApIdDs2Ricjdp87Epu3wdfC76W1j4hQe7islAHADfQ11bDmZbrkBfiD748MBaOLNR7iICUiInDI/xi8eLaql0w7EglQmuVlNudnrZjQtNOSMzzra1vEkupLnKhusV9m6OD0Krdg1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ozxQPayr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ozxQPayr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15A9C3277B;
	Tue, 18 Jun 2024 13:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715716;
	bh=cocmOji3VJi3P1ZvRUVTBrWTmHjhj28LURUV+eq3sEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ozxQPayrY6R2gLKDut9HpY67WI5h9ribJX8H3wTIhv2XwW7AESjukhcx03iVSdd+t
	 jwbG6FXOv0qwXtRUhgOMMzi9Nt8RoFzBsjPhe9661X+J8keOiUK0zQItaFftR65wMh
	 mEySQMssorhaC3Phu/qWAa0oRRnORMUZZ8YTl33M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff layton <jlayton@kernel.org>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 402/770] nfsd4: remove obselete comment
Date: Tue, 18 Jun 2024 14:34:15 +0200
Message-ID: <20240618123422.799471945@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 80479eb862102f9513e93fcf726c78cc0be2e3b2 ]

Mandatory locking has been removed.  And the rest of this comment is
redundant with the code.

Reported-by: Jeff layton <jlayton@kernel.org>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 5b0abdf8de27e..deaf4a50550d5 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -751,9 +751,6 @@ __nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type,
 	path.dentry = fhp->fh_dentry;
 	inode = d_inode(path.dentry);
 
-	/* Disallow write access to files with the append-only bit set
-	 * or any access when mandatory locking enabled
-	 */
 	err = nfserr_perm;
 	if (IS_APPEND(inode) && (may_flags & NFSD_MAY_WRITE))
 		goto out;
-- 
2.43.0



