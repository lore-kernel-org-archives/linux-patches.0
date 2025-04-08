Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CE01AAA32;
	Tue,  8 Apr 2025 12:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115803; cv=none; b=rbYkQ4U1rofDqjO1kCc4DM4BB9/WpVr2DG0BWLbweEobu2V4nyex7xhmGypPKgwBFOn9c1ALbtuCGnCevfdqZy270YaTei+YXn7F5wTghkobHV4dKTh4/44+ob9B9YioVQhjzBToriIhqhDGgpEcUjdifrLD2cxp5+Kzd251W7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115803; c=relaxed/simple;
	bh=kDU9jiqjC725864a22GjtjhhYim1q5pE5UjE1Bl55X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VpqM5sUNVWCZRZEVTIrGW+MVyo4O7h59LWYkQRUR0OdXQfTxO0jU4R0dlTBl0gBWVI7M1BSIkhANbpkPK2AOejutbvFi7SlldRWTAkao4Ug/kzCQNM+m0ed3Cx7IlpGyzRjtdXLYW6+nI/XkY5IxtlFIDmrMSkkJXfH3HKv0d60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4Ssbh9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4Ssbh9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2B6C4CEE5;
	Tue,  8 Apr 2025 12:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115802;
	bh=kDU9jiqjC725864a22GjtjhhYim1q5pE5UjE1Bl55X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z4Ssbh9HmN4+MJtxN6AwRo65xSmW/2CSmeUikq6vM/KrW7HHkIoAuPb5Glv2HERKK
	 UlPlbY6ScchqrdJQ4Ju/W2EldCHiM63iWvkCEUEm4gt/DbqoVNEES1oRb5tM7+UvXo
	 CZ0SknwDkz8GBw2beb0qlZBEwvB/8/HMFhHkaNG0=
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
Subject: [PATCH 6.1 109/204] fs/procfs: fix the comment above proc_pid_wchan()
Date: Tue,  8 Apr 2025 12:50:39 +0200
Message-ID: <20250408104823.531370643@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 82e4a8805bae6..fb169bdfd9a8e 100644
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



