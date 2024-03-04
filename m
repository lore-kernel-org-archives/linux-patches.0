Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D421F92C;
	Mon,  4 Mar 2024 21:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588952; cv=none; b=cfQbiDwwQs8nXnSaLncgQkK4wmus+8f8h0hDFqDegfXR1a5mQ909shw2Gf9qBmeG8byua3H7nwUQngTjRe4vwDGbxcRb7IqYohz7fjVrtILlnsLabOwm7r0YdmJrK3UT5q29H7Lb4YvIIh0aW4Gqrw/bAgoy86tINhtkigXcApc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588952; c=relaxed/simple;
	bh=d1y2Zr2qq0MJOop7IQR/mD5nxezq5rsJOPgmYjRa8cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjCWBVYuE6NhVO8pl9GtEifUCxQK7TS5/RUBAc2kAq5RrivNm3moQWdQwVRtTNjv72F5AGa+CZl1aEmqpryjO4qj3URBXktPLpTqPpAiAVmkcvC+ozLsl0TkvyIjyKsXpqObomZvr9cXotR4Trttf1swhMrPio2k2GGC7YWQ/4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTg32dd5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTg32dd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37ACAC433C7;
	Mon,  4 Mar 2024 21:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588952;
	bh=d1y2Zr2qq0MJOop7IQR/mD5nxezq5rsJOPgmYjRa8cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTg32dd5T+r0t/fiXoQdGONyAUaHZerh2uQLwNE3dThekBlrsR/zqxjaUhLr1Okwv
	 GG4SiDznF9OWLy3z9QN/QcM15CEirHpqxu9AH0ZhAasi2cFegihGSPFeZpEOxcdhFI
	 5Xk3UbpbRAaq9yOmH2GQL61I1kPWHg0eNWARLsvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 144/215] NFSD: Remove redundant assignment to variable host_err
Date: Mon,  4 Mar 2024 21:23:27 +0000
Message-ID: <20240304211601.616151908@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1317,7 +1317,6 @@ nfsd_create_locked(struct svc_rqst *rqst
 		iap->ia_mode &= ~current_umask();
 
 	err = 0;
-	host_err = 0;
 	switch (type) {
 	case S_IFREG:
 		host_err = vfs_create(&init_user_ns, dirp, dchild, iap->ia_mode, true);


