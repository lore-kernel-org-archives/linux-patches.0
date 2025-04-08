Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652ED2641CC;
	Tue,  8 Apr 2025 11:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112921; cv=none; b=I6hvBQIPvUYX/agQAnIuW0XlfmkN1iD4lDckGEEJV0W8BR5HNpSsx0JYSwMSja7vdsXw0TiYavH+HAraQgb9/U+gVIUEg93G4E2al0DAhZAzLKNlxkM81spiRqETBqCPFPV/uhJT17YC3M68B8hHg0qU5iwjEK6I4F47jI0Gpig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112921; c=relaxed/simple;
	bh=Da+1M8F/Y/0XUZ7E9h8LM1Z1AAgO+idBTe1Oc/LOHcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0bkNhVUOj7PXsmAia8WZ6FCYhTpdGeo8YdjAIhoD6dn+BU1ywd1B5G7Ad6vGpKDRF8uitW4QjeFcRUGAGxPERYmwU1CsvAtOzgcOiw/V8p71gSaIxpqBLiK/X39wI2QpLadNqIHhU3SfiOnAGgCAPMvQNnGvhntgq0FgHKW5L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qmuxZl5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qmuxZl5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC742C4CEE5;
	Tue,  8 Apr 2025 11:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112921;
	bh=Da+1M8F/Y/0XUZ7E9h8LM1Z1AAgO+idBTe1Oc/LOHcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qmuxZl5rDanXMKumgqktid6Sfg3GyVGXYL2U/WKE7ZJi0to/z7/DfW2/EBinTUNMt
	 ZlQWhuIh5IV8PDEWBsfacgukzWbTLTiNOsYYS4P9vZG5os/jxasGuXFEsUFMwjPPy0
	 O15VP3kv8EDhAC5vHu6OiEZY4f8In9tvQ43NhJqs=
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
Subject: [PATCH 5.15 210/279] fs/procfs: fix the comment above proc_pid_wchan()
Date: Tue,  8 Apr 2025 12:49:53 +0200
Message-ID: <20250408104832.012484227@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d0414e566d30a..3405005199b61 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -416,7 +416,7 @@ static const struct file_operations proc_pid_cmdline_ops = {
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



