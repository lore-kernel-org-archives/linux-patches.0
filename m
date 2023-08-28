Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D81E11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E66C433C8;
	Mon, 28 Aug 2023 10:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218424;
	bh=1KXtW8hgmZ2UJOjYejH7oKhBEByM0MeHEFeQG01rUFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aEeWP2hAxTI0rv8qjAUSsxQaNzauWysubQHhH68jl2JbYFhYJR1Xz0X56vEBvkz/4
	 6ZAlntck/LpFwdMXmHMQ93djfqsVqjLFXsVZy6BplJZ2WAupFkn1uJpqqe0OO4fsMf
	 ImMNRPcLzSr9jCFDSf3r2P0UMag47UrKAsOt1KzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 082/129] fs: dlm: add pid to debug log
Date: Mon, 28 Aug 2023 12:12:56 +0200
Message-ID: <20230828101156.355661499@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 19d7ca051d303622c423b4cb39e6bde5d177328b ]

This patch adds the pid information which requested the lock operation
to the debug log output.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Stable-dep-of: 57e2c2f2d94c ("fs: dlm: fix mismatch of plock results from userspace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/plock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
index 7e26e677c6b24..254d20eb6f4fd 100644
--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -167,9 +167,9 @@ int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 number, struct file *file,
 		spin_lock(&ops_lock);
 		list_del(&op->list);
 		spin_unlock(&ops_lock);
-		log_print("%s: wait interrupted %x %llx, op removed",
+		log_print("%s: wait interrupted %x %llx pid %d, op removed",
 			  __func__, ls->ls_global_id,
-			  (unsigned long long)number);
+			  (unsigned long long)number, op->info.pid);
 		dlm_release_plock_op(op);
 		do_unlock_close(ls, number, file, fl);
 		goto out;
-- 
2.40.1



