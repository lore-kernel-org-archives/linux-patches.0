Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1639F78285;
	Mon,  8 Apr 2024 13:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583917; cv=none; b=Zr5ZmusEgjs/pbtJ3kYxCsTrLLOWgGBnmjfuDUbuTP7mz2cR5nRKR1iThg/n1ztmdqUMfj32rzrd+BFOem0D376R3aKupY3G5jXnrsaWq01C/cpqMNkdVhTI/r0hEHj8P+GhXuDg93ttaver5ED2NhZiZyuq0ArxjscSQz/0q+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583917; c=relaxed/simple;
	bh=+qwZ4vMiT5qVJBZGkTlfKTlMTYvbA/0lD1yA17w/34c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+K+hXjFTtYqNWBY+iJI4Bqh/jx3gsiyafD12240oFZf1cJHjniubax+aG8oN6Q0pa+xNE/SPix/IxryZkrr6ugNy4R5qZVJULx5UFYMMVE8ERb4s5NgLMI7dj7AqO2WtxjKbMgqyDWOUzk22gIje58UdlyWyVyNB7JsggHTTBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKexc9MZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKexc9MZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9284DC433F1;
	Mon,  8 Apr 2024 13:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583917;
	bh=+qwZ4vMiT5qVJBZGkTlfKTlMTYvbA/0lD1yA17w/34c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKexc9MZmdg7OX6YGBzplY2K1nP2BdZoL0R+st7iA3VbzqXVW0QOGwiSJ/wz9Gv3B
	 BQF7KqlinVPJnnMSf3OeE+0uDwC3S2zea54evQdRXt0n3ACKEygXgQ/ur31uZPR2uj
	 lJD4mpBuvrHOOWNLVMbWmXrQK0+jSDjmMlqdzTT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 302/690] fanotify: enable "evictable" inode marks
Date: Mon,  8 Apr 2024 14:52:48 +0200
Message-ID: <20240408125410.536698578@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 5f9d3bd520261fd7a850818c71809fd580e0f30c ]

Now that the direct reclaim path is handled we can enable evictable
inode marks.

Link: https://lore.kernel.org/r/20220422120327.3459282-17-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify_user.c | 2 +-
 include/linux/fanotify.h           | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index b4d16caa98d80..4471043955f87 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1814,7 +1814,7 @@ static int __init fanotify_user_setup(void)
 
 	BUILD_BUG_ON(FANOTIFY_INIT_FLAGS & FANOTIFY_INTERNAL_GROUP_FLAGS);
 	BUILD_BUG_ON(HWEIGHT32(FANOTIFY_INIT_FLAGS) != 12);
-	BUILD_BUG_ON(HWEIGHT32(FANOTIFY_MARK_FLAGS) != 9);
+	BUILD_BUG_ON(HWEIGHT32(FANOTIFY_MARK_FLAGS) != 10);
 
 	fanotify_mark_cache = KMEM_CACHE(fsnotify_mark,
 					 SLAB_PANIC|SLAB_ACCOUNT);
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 3afdf339d53c9..81f45061c1b18 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -68,6 +68,7 @@ extern struct ctl_table fanotify_table[]; /* for sysctl */
 				 FAN_MARK_ONLYDIR | \
 				 FAN_MARK_IGNORED_MASK | \
 				 FAN_MARK_IGNORED_SURV_MODIFY | \
+				 FAN_MARK_EVICTABLE | \
 				 FAN_MARK_FLUSH)
 
 /*
-- 
2.43.0



