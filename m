Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D6911C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F2FC433C9;
	Mon, 28 Aug 2023 10:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218429;
	bh=/6/ebRManJFM9Rfjw5m0ILooi7nTyF+IHxQ+HaIjX+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERNnpJNjjYr5z3OS2cpBrpAIH7IB4H9+JD9FCFRRbkOPCIaypblKcGTV1baB+HU5j
	 wROyia7YdOzAP5BJOqSo/uYKEABUmj/0bR4Az7xTiZZCXjcAfXjt01U5FgCmH8ELNT
	 lGloVTyYolu+3px12eYSsMOHEZ/kUoM5BFwVBqdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 083/129] fs: dlm: change plock interrupted message to debug again
Date: Mon, 28 Aug 2023 12:12:57 +0200
Message-ID: <20230828101156.403709472@linuxfoundation.org>
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

[ Upstream commit ea06d4cabf529eefbe7e89e3a8325f1f89355ccd ]

This patch reverses the commit bcfad4265ced ("dlm: improve plock logging
if interrupted") by moving it to debug level and notifying the user an op
was removed.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Stable-dep-of: 57e2c2f2d94c ("fs: dlm: fix mismatch of plock results from userspace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/plock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
index 254d20eb6f4fd..7c9e873a01b78 100644
--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -167,7 +167,7 @@ int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 number, struct file *file,
 		spin_lock(&ops_lock);
 		list_del(&op->list);
 		spin_unlock(&ops_lock);
-		log_print("%s: wait interrupted %x %llx pid %d, op removed",
+		log_debug(ls, "%s: wait interrupted %x %llx pid %d",
 			  __func__, ls->ls_global_id,
 			  (unsigned long long)number, op->info.pid);
 		dlm_release_plock_op(op);
@@ -473,7 +473,7 @@ static ssize_t dev_write(struct file *file, const char __user *u, size_t count,
 		else
 			wake_up(&recv_wq);
 	} else
-		log_print("%s: no op %x %llx - may got interrupted?", __func__,
+		log_print("%s: no op %x %llx", __func__,
 			  info.fsid, (unsigned long long)info.number);
 	return count;
 }
-- 
2.40.1



