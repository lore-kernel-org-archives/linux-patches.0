Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B92D23BD1B;
	Fri,  4 Sep 2026 05:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499057; cv=none; b=QHpGP/rdckFHm6EtVPLIh0GpFSW6zR3g2HdAbHrTblyArp9YjPUUfzJZ1EN6uKqWHgVceOHagwJMhxaNULhI+rZShfwFfed97HKhS4CWcWprROhMczsaEQ6gaKSwsUu9ICwrq9/QSsMHjacAKJ4KbqlN9VL4IPtx36PWOdwFc+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499057; c=relaxed/simple;
	bh=JcQEmVPlk/dz220v9FjZ55/oBP7+CYgKiS62ac96XkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKvJqQArRrZvY0giEHhdvvKFntAwm+9dGF//egN3PLS6B2eYinfaIoOi4eiCjpsMyTLIBsPQUG1ZrPbPv1ZEEksowi9zT+QxZ5zWon8YSiRAKkWCEiv0LNdwUrQ87c3iO7DvU07dQEjJSJlYE0MZtarYhdof6u2fDGKKXnRP0Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=toF0Oz8P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="toF0Oz8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4A91F00A3D;
	Fri,  4 Sep 2026 05:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499055;
	bh=EIHP/mYZOwWHnstRfrdQxfU7SGKMEjPq/WJEFsWmSII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=toF0Oz8Ptgbl5FZKtXf0W/cU/+JAsRb84fu59MhWt087x7sesUnkqMyoZCRh4FXy0
	 /7+O1scpRhTOyMkT5RYix61Qop9ysCjCZIEzrKlPdqjXwBXDAa+wqzFGc3y812LzRm
	 wnIOC32yGeXEe+MiYSLHEBokNzOphcpzs6BTREI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yemu Lu <prcups@krgm.moe>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 282/713] fat: restore original value when fat_ent_write failed
Date: Fri,  4 Sep 2026 06:54:10 +0200
Message-ID: <20260904045810.161364967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yemu Lu <prcups@krgm.moe>

commit 64d9183203eebe33de6188b70a8c1e91f52885db upstream.

fat_ent_write() may have committed the new link to the primary FAT but
then failed on the mirror copy, leaving the chain pointing to new_dclus
even though the caller will free it.  Restore the original value to keep
the chain consistent.

Link: https://lore.kernel.org/20260525085649.781643-1-n05ec@lzu.edu.cn
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yemu Lu <prcups@krgm.moe>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fat/misc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -133,7 +133,11 @@ int fat_chain_add(struct inode *inode, i
 		ret = fat_ent_read(inode, &fatent, last);
 		if (ret >= 0) {
 			int wait = inode_needs_sync(inode);
+			int old = ret;
+
 			ret = fat_ent_write(inode, &fatent, new_dclus, wait);
+			if (ret < 0)
+				fat_ent_write(inode, &fatent, old, wait);
 			fatent_brelse(&fatent);
 		}
 		if (ret < 0)


