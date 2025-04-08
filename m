Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFD6268691;
	Tue,  8 Apr 2025 11:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110223; cv=none; b=JwWE2pU+P7TRqcaEIUBq9ZYRUzhTsdfYH9TMesulE413fRamHDBcHj5k0TiCWcowcphVtK1I8HzX9Kn+SEOtqOnpSA6MhIED8lPkkvG8Gfn7w1j7v5u+bPD82CYccxz3lg3GwjZ62OGdPgbY3C/Bh29j61e7xcbZ9wGDkq6HHKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110223; c=relaxed/simple;
	bh=v4w6duPkLl0byoCi/rVfX3o9uGV4rGwxextmcTQdRfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fhs6rHHS/BUp7geZUZsX3CD1j2sL5/m5sSiclYG2csJUR5KDwUvIBYtDi/S6KHO7CCQMJLHIUshF8yExWYGTddic6ID4YVOxP3DJ+xihZllilb3QbX3sX7XRh1xOUt51+fRGa4bu0xlpRftNCSE9X+Kd3Hv+Y1jQ3cQadJ/LIfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5RZM90P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5RZM90P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D472BC4CEE7;
	Tue,  8 Apr 2025 11:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110223;
	bh=v4w6duPkLl0byoCi/rVfX3o9uGV4rGwxextmcTQdRfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5RZM90PzhF9htaGe/8Wj+bWKNBhBMpjxEWwB2ON0MybZmw8bMlPqYezlcYW6In/o
	 v+pIyjlq1p3GRI8CfYQvpRhCWtL+2RZsUiE+9vrE9oPhHuLMJkBZ9sLaqzPU50IJF7
	 ssyXlTmZ5WJqQUNuunZFgorXbjTWXP2TDUjrJzr0=
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
Subject: [PATCH 5.10 173/227] fs/procfs: fix the comment above proc_pid_wchan()
Date: Tue,  8 Apr 2025 12:49:11 +0200
Message-ID: <20250408104825.504162613@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b955ba5db72cb..b09cc9e6d5914 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -415,7 +415,7 @@ static const struct file_operations proc_pid_cmdline_ops = {
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



