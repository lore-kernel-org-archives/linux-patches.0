Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243A842046;
	Mon,  8 Apr 2024 13:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584536; cv=none; b=oRRPKxCWy8AL1ipaxbb3VDOJglDTcKuxw/YbjdqqNaSu6pXCH9xuuZvK7uuO76YavzgAsjmWpnHD2gL4ZfPiH42W+0V9c2QPOe9xVXXlTwab1rUtGXyc9VkNB50GXAgxIhI/9rAh0Yan7NMLhfmjDH/1PelTZWsLYbA/s/oKgO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584536; c=relaxed/simple;
	bh=H0ElYoehbUpd1RpRcSWs02ETbTmpiNR0veIvioz6uJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDJIjytqZf7SL5M9JlEVZQ0oRgf95EzKWScje4tjh2mSJhrhlyAkh8CsWqaUVa1Dd7TChoFalGGYQuMn3I47yVNxzVUTVflkSuC0j9PzDcu002wVzhptbDzKAtF09WsUMhF6cbX2mUH2lcLWj+L31O0zc8ouGg1o7qejmvHtvBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bz7cDlir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bz7cDlir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AD8C433F1;
	Mon,  8 Apr 2024 13:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584536;
	bh=H0ElYoehbUpd1RpRcSWs02ETbTmpiNR0veIvioz6uJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bz7cDlirS9GfdMA3E1SJU1YxIjPlqGlGkZ+1ICCgT8e/nRKMtP8P4kD8/OkQIRDys
	 fFPBQ7mwpZfrrb56UhAJPQhrIsPOFKz9Esy9nxZeN9I4Gkxc8sDPdouPTqhyVyGo+A
	 Z08rPB9Xp19nM4rhpH0vkuoa9QrGOt8T2xb7FkPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 471/690] NFSD: Remove redundant assignment to variable host_err
Date: Mon,  8 Apr 2024 14:55:37 +0200
Message-ID: <20240408125416.667785590@linuxfoundation.org>
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 69eed23baf877bbb1f14d7f4df54f89807c9ee2a ]

Variable host_err is assigned a value that is never read, it is being
re-assigned a value in every different execution path in the following
switch statement. The assignment is redundant and can be removed.

Cleans up clang-scan warning:
warning: Value stored to 'host_err' is never read [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/vfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 9215350ad095c..88a2ad962a055 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1306,7 +1306,6 @@ nfsd_create_locked(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		iap->ia_mode &= ~current_umask();
 
 	err = 0;
-	host_err = 0;
 	switch (type) {
 	case S_IFREG:
 		host_err = vfs_create(&init_user_ns, dirp, dchild, iap->ia_mode, true);
-- 
2.43.0



