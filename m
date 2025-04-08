Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309CA26B091;
	Tue,  8 Apr 2025 12:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116769; cv=none; b=EPYcwNL6F3fxmKOEldiUaXUC+Qtgwyf4IbkNvzExM59mGAgXAFyGRaHZyiV9KlExQrL99yz7SW8z8y1UC/KuJbmX0zIjxPWZLKuT03k5JU6dFEMGHGOZ3JOKkDQ+UNtojM4tewwJSwMwe5FudbR8yN2BabwYFHVqP99DNooS75w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116769; c=relaxed/simple;
	bh=pXRiarFSBNhTXUoRRpS6qx3qJWxEtLLARWl5fZEKNm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ighjMne87PgH7P+9KRnnacXs4U2OEtvBLvK+KP9OGObNhwz+v+5srWvCAXJug0WL/ZiTaZjiFNrK3i4jalZYOCJD64Zs6UyIjxDbOw1/UU0tBNsoR9phzb8DlipM7lV+9aZ30YlUCYiY1zpKUX58DAg+XJZoBqfNbiyCdszxTyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SuAezHEO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SuAezHEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870C1C4CEE5;
	Tue,  8 Apr 2025 12:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116769;
	bh=pXRiarFSBNhTXUoRRpS6qx3qJWxEtLLARWl5fZEKNm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SuAezHEOsaoOs/2zY+faZJg2vR7FviYlHT6n7rZzY3PCLf6P7HApPUDbYSpaQXwV+
	 0Sk4lQ4bn2MzXfhfdTgE0m9I1RbZkVujf7O4EuKYtL7JdtZLc/kTbJHVquB9KWC7Hl
	 KQmP/bMZSkmu1lRap1kromoio5nRBBgzPhsinHgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Kees Cook <kees@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 222/423] fs/procfs: fix the comment above proc_pid_wchan()
Date: Tue,  8 Apr 2025 12:49:08 +0200
Message-ID: <20250408104850.898465822@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 6287fbad1cd91f0c25cdc3a580499060828a8f30 ]

proc_pid_wchan() used to report kernel addresses to user space but that is
no longer the case today.  Bring the comment above proc_pid_wchan() in
sync with the implementation.

Link: https://lkml.kernel.org/r/20250319210222.1518771-1-bvanassche@acm.org
Fixes: b2f73922d119 ("fs/proc, core/debug: Don't expose absolute kernel addresses via wchan")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index b31283d81c52e..a2541f5204af0 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -417,7 +417,7 @@ static const struct file_operations proc_pid_cmdline_ops = {
 #ifdef CONFIG_KALLSYMS
 /*
  * Provides a wchan file via kallsyms in a proper one-value-per-file format.
- * Returns the resolved symbol.  If that fails, simply return the address.
+ * Returns the resolved symbol to user space.
  */
 static int proc_pid_wchan(struct seq_file *m, struct pid_namespace *ns,
 			  struct pid *pid, struct task_struct *task)
-- 
2.39.5



