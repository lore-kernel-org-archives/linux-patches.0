Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8219326A0B3;
	Tue,  8 Apr 2025 12:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114877; cv=none; b=X01qlZOS6foGOpp5K/46iO9ZyMBkiUUxrhoLLKDvINfcy+OQ+WAB61qT8NSqAFHkRRvZaqCl1+/uERgW/w4aSN2lyzBiyba86snomUgc8tkqBuo30vjmDEX1WB2N1hrIhDoNaKX6wXoum4DsKbJZr8uebtTEbTvWuIaJerpF0Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114877; c=relaxed/simple;
	bh=9PalclusiZb+8GvFTtKzDWjT5q4iCq5vQEpvYX2uP0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrHm5Cc8WUrmhBOf1YCU5iKedtzRAQCSdHFbp/SJJy+LX0EzcHLyWMm0IQYPJtW7X8J7UvQzmZRyRpwkJNbhUrmZ5v+dmHSBsWcfUaZPB1ihikVaac7/qqC6cDcLcWHmroZmNtaCiBRLZTsRsK+cPPQOCuMgb14WYizHDW5dEsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YWPDsLhV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YWPDsLhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7368FC4CEE5;
	Tue,  8 Apr 2025 12:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114875;
	bh=9PalclusiZb+8GvFTtKzDWjT5q4iCq5vQEpvYX2uP0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWPDsLhV478JxyUiUvSh6KHCd51QmiOO/NnNVbbp1uafrmN0TIhmev5ncfz09EGUh
	 WIhU3KAQH78zpsMELe4QWfsOW4FPaC3E2SvZMw2YfbH2Omc/2U4RTO7NzL0IDzeejU
	 c1LGq+1OGqO6dddf61C/JQHuFL1OwUGoFINGyCl8=
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
Subject: [PATCH 6.13 268/499] fs/procfs: fix the comment above proc_pid_wchan()
Date: Tue,  8 Apr 2025 12:48:00 +0200
Message-ID: <20250408104857.900672838@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 0edf14a9840ef..75a36388c302b 100644
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



