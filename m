Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C658826AAB6;
	Tue,  8 Apr 2025 11:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111735; cv=none; b=G63ga63zJJYw6tbtlq6XrV1/SALFuQcyw2NnqulQOl42yNplmK23hN470pkBUoQEFcmOtv8cQILYvoOkZw/4A5eIgw8+hno0yD+ey1BdjXOrFdPM1mc32baRoiyZskg8hLU1A2SEl10DWcVIWBV4FTZbI2rmCWFMDU4sklq9fTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111735; c=relaxed/simple;
	bh=WA06bfI5ncP3p+QieHI0/+qufJiyGdVP3DLipoVc3QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPdfr31L7+GJCYZbp7nuiB3yqU7Pa5Ub1luJcHhooR7M/4mEd6KvYGwcxEezqVW7uUOSIIXrkteA/7U0jszUXFiTmV0J3De/UeASf467jutOMFwhzKvLCqwj5wy9YN/CfTeIHPYdWaMlk0OrXnFlxchzM/00X8WHHwXFxcmJ+yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ezj2g/J1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ezj2g/J1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE22AC4CEE5;
	Tue,  8 Apr 2025 11:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111735;
	bh=WA06bfI5ncP3p+QieHI0/+qufJiyGdVP3DLipoVc3QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ezj2g/J1WtTK0w/WJoAlnksPHi4Ad1i5qF4BGRkjgaMdw+p+4JY+IjGhv2fnY7Fto
	 4wWs+TmztO6q0Z1TDMVKsajdeAr+JHDz9P5JhQq5haCEiVF9YCuXHiil5huwTgjcJf
	 63Q/bnEzYRdiAg+NrTrnCVozePXz02CIOebB/6AU=
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
Subject: [PATCH 6.14 539/731] fs/procfs: fix the comment above proc_pid_wchan()
Date: Tue,  8 Apr 2025 12:47:16 +0200
Message-ID: <20250408104926.814078509@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index cd89e956c3224..7feb8f41aa253 100644
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



