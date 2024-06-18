Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E9E1AC44E;
	Tue, 18 Jun 2024 13:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716673; cv=none; b=Em7Zna4yV2CW0xQWUTHjGh4mgSBRt1arxnhTjGv9XTQbUYNOVzahfYnevJ6x9PqXMbghdyJ7JXjfavNR6L04AXO2r1HNI2wOim2R1Si1+YFDoVxpGmUbTFew/ONRPa8RVIyf7vOs8pDI/zIiTgey25uh668pm3wvj3DmBe799P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716673; c=relaxed/simple;
	bh=Q4uAproVJYtZ1Z3JZ8Zy4GvnzQzMqI2mw/u33mgo5o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiUDJDu+E8AhhiZp8Ej6BS0ExS34v2gECTlMrp1VuxzU/mL7quwRvEOLSUpMcednKgG6sN/hDSzL+At3hN15vuQgjXYExNMtWq7cWTA79xg8XbX/++oR3vNJuo3S007y3riiWhQU0YNRsA7lRBMiIUQscoyQGSfCIbORBYVFLJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKYLCvgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKYLCvgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2641C3277B;
	Tue, 18 Jun 2024 13:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716673;
	bh=Q4uAproVJYtZ1Z3JZ8Zy4GvnzQzMqI2mw/u33mgo5o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKYLCvguZqQLsKgjVmbUOXV53/ooH4AE747DZCaK4WjodEXPSbKzdwxhzBE2DUEfE
	 2NTMQWFNeTeYPCBJ5LLT1mXD582YDaJPkY9vQEt9bGGWIHOsFIVI4l4tUo92Y3+8uZ
	 FSR8zAoIP4Qmzohfd/gBZYR+Xvg8THCp4tnZV/po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 683/770] NFSD: Remove redundant assignment to variable host_err
Date: Tue, 18 Jun 2024 14:38:56 +0200
Message-ID: <20240618123433.644046627@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 4ff626c912cc3..aae81c5cecb94 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1322,7 +1322,6 @@ nfsd_create_locked(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		iap->ia_mode &= ~current_umask();
 
 	err = 0;
-	host_err = 0;
 	switch (type) {
 	case S_IFREG:
 		host_err = vfs_create(dirp, dchild, iap->ia_mode, true);
-- 
2.43.0



