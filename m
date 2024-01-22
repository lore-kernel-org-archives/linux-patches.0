Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6CF1487F4;
	Tue, 23 Jan 2024 00:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969174; cv=none; b=NCWtSrr+SZRTUQWY1JpkP0aojiQyOvFphtdsfRI8n9iy2u/L14OPpyyicXhkZ/rLoVgkzHK/pW+p53G1oQ3UZPBRsvQQTPK5SQj3Wih5ovmvvUqHzkhSkmw7yKieF9URk4GgUYRJwT8QWqPoYH4hKG+LFAz8HzfM71msbJQmeZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969174; c=relaxed/simple;
	bh=SZSPUgwS7CgqDawq0ZYFeF/RqO14I/PK/yF7Js/6bLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oS7vor2iw87C1b7HSOlx+XgTo6NjzjoCPsHNXK03mErJB53cCnwjoZbsmZ+aeVHopqBjVHjuXUsvCZQVRy2oPU+X4Bv0tD8ReT8U1lNx7KEXVzux/yMTRlAwUh77yMBf7RVxPZe1gUzciLuH63R6b6JBCNqTN8rccVyEhibWICU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+bgqlVs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+bgqlVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C861AC433C7;
	Tue, 23 Jan 2024 00:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969174;
	bh=SZSPUgwS7CgqDawq0ZYFeF/RqO14I/PK/yF7Js/6bLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+bgqlVs3f4sTqPpKph4HbIIQh+XV8nwea6aiw0ij5EOWfXn1nfSPhaxB5ND3nTUh
	 5kS24B9G7K3TMACbutGdAx3tqe/l2VjTXicyR8H3e4pVQjh80ZJ0Y/Zrpaxoc6Zk9t
	 yJNBADk/PFfGjN2WRhXGZnV/j+eZwykHoV29LcBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 073/641] dlm: fix format seq ops type 4
Date: Mon, 22 Jan 2024 15:49:37 -0800
Message-ID: <20240122235820.322970769@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 367e753d5c54a414d82610eb709fe71fda6cf1c3 ]

This patch fixes to set the type 4 format ops in case of table_open4().
It got accidentially changed by commit 541adb0d4d10 ("fs: dlm: debugfs
for queued callbacks") and since them toss debug dumps the same format
as format 5 that are the queued ast callbacks for lkbs.

Fixes: 541adb0d4d10 ("fs: dlm: debugfs for queued callbacks")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/debug_fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 42f332f46359..c587bfadeff4 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -748,7 +748,7 @@ static int table_open4(struct inode *inode, struct file *file)
 	struct seq_file *seq;
 	int ret;
 
-	ret = seq_open(file, &format5_seq_ops);
+	ret = seq_open(file, &format4_seq_ops);
 	if (ret)
 		return ret;
 
-- 
2.43.0



