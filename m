Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D70113BC31;
	Tue, 18 Jun 2024 12:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715505; cv=none; b=ZwonVr7pbB+Dwj3gVFTlI0X2M8gCiGUoyw90nJBDU1JvtxYH1yscwJOVKF+xSfHB+6Jnh3KMwAuqeiymzYne9bT6UNXVIvpR7OjxwlheuOxQR9nvx5/c0qdnsBvYGFwyr6zI5OBVM+ug5ScmW2xWWpgJZ6hbcNWJ9nXX06wo+RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715505; c=relaxed/simple;
	bh=ghmis1VlKYAroaafmY+GeZf+nwdp5v+uMx5ZuHQtwPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u81MKx+JAO840QgwsomroQsX0cvKx7R8xBA514D//pE4bpcuYA1/TBrra1xbmnpOamJHA/C2uJGtoEmjuh8dw8bQiHOcGwanv+KbMtQVJWDS1PCK/W5B2gDvISljhz8LJ0Wt5n/l3aYXnyAzP7xr5UDfmUr7WtvrVQG7ygjWuZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FibAnD63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FibAnD63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11144C3277B;
	Tue, 18 Jun 2024 12:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715505;
	bh=ghmis1VlKYAroaafmY+GeZf+nwdp5v+uMx5ZuHQtwPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FibAnD63WkPQBeqxmUfUZ2Gir09oH9xN9Gky1JPaDH732aTORjaWJC6mLtqcXmelN
	 XueCpO/9Mka76V9lwcJzPzEoZvnHYQjnYuJLjosIHYVxa9JOvi7gNEwidwurOSXKC6
	 Z8amOoN1VipXD8UESdX5Y8EtsaYASax/lDxt/bTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Bobrowski <repnop@google.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 331/770] kernel/pid.c: remove static qualifier from pidfd_create()
Date: Tue, 18 Jun 2024 14:33:04 +0200
Message-ID: <20240618123420.046144662@linuxfoundation.org>
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

From: Matthew Bobrowski <repnop@google.com>

[ Upstream commit c576e0fcd6188d0edb50b0fb83f853433ef4819b ]

With the idea of returning pidfds from the fanotify API, we need to
expose a mechanism for creating pidfds. We drop the static qualifier
from pidfd_create() and add its declaration to linux/pid.h so that the
pidfd_create() helper can be called from other kernel subsystems
i.e. fanotify.

Link: https://lore.kernel.org/r/0c68653ec32f1b7143301f0231f7ed14062fd82b.1628398044.git.repnop@google.com
Signed-off-by: Matthew Bobrowski <repnop@google.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pid.h | 1 +
 kernel/pid.c        | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index fa10acb8d6a42..af308e15f174c 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -78,6 +78,7 @@ struct file;
 
 extern struct pid *pidfd_pid(const struct file *file);
 struct pid *pidfd_get_pid(unsigned int fd, unsigned int *flags);
+int pidfd_create(struct pid *pid, unsigned int flags);
 
 static inline struct pid *get_pid(struct pid *pid)
 {
diff --git a/kernel/pid.c b/kernel/pid.c
index 4856818c9de1a..74f0466757cbf 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -550,10 +550,12 @@ struct pid *pidfd_get_pid(unsigned int fd, unsigned int *flags)
  * Note, that this function can only be called after the fd table has
  * been unshared to avoid leaking the pidfd to the new process.
  *
+ * This symbol should not be explicitly exported to loadable modules.
+ *
  * Return: On success, a cloexec pidfd is returned.
  *         On error, a negative errno number will be returned.
  */
-static int pidfd_create(struct pid *pid, unsigned int flags)
+int pidfd_create(struct pid *pid, unsigned int flags)
 {
 	int fd;
 
-- 
2.43.0



