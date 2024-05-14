Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E652F12C554;
	Tue, 14 May 2024 11:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686651; cv=none; b=uFusSjLr84GEk4osEVCLbFST0BXurD53h5eOmsHCpxQXrcs8+93sZO8tPO9fmqBdZpVkdKPF6s4hwQ0cbfC0oGY7tbYnx7N2/yVoQf1L8fpRuKpKdXM7pCIB28vg43ZdgqZE1Uvg7b39ZKs6PWgdR4peg6gVVAsBHG1YOnpG6Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686651; c=relaxed/simple;
	bh=Tlr+8oj6hm8aYYX0KCYqWV8EcDI+shbJJHjggsjnqy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETyjU0+zlXwNkGynSR+T29VWTY1ELbbPcong/oGsGnFqMgpIOGw+3ZOqgzEfRz1Xy6v7jgMqY+olpG/zsD2Vg+5pjmiMFJEL046qcVIRorkywzOVawFgxTe3V7A4gXu5iz1udSssTpNIl5pqEM6k5Yj/42ZOvXiCLLjaWXk5urU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUyTaP43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUyTaP43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D20EC2BD10;
	Tue, 14 May 2024 11:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686650;
	bh=Tlr+8oj6hm8aYYX0KCYqWV8EcDI+shbJJHjggsjnqy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUyTaP438WYSg/g5zpU2a5A7Z+4qR3Hy8ZgwQU39en8X6gWUUBNSxqhe6g21N0yj/
	 kT3psV9lQuJRmE0VKFMuMBVUe7POyX3Lcvci3HL95cgy+XSYDZeBjlv59EOTD1XKin
	 VdL35iDX9175mviiYmXGTSxqz5joxZdsR4tkq2NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	syzbot+355c5bb8c1445c871ee8@syzkaller.appspotmail.com,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 210/236] kmsan: compiler_types: declare __no_sanitize_or_inline
Date: Tue, 14 May 2024 12:19:32 +0200
Message-ID: <20240514101028.333130213@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Potapenko <glider@google.com>

commit 90d1f14cbb9ddbfc532e2da13bf6e0ed8320e792 upstream.

It turned out that KMSAN instruments READ_ONCE_NOCHECK(), resulting in
false positive reports, because __no_sanitize_or_inline enforced inlining.

Properly declare __no_sanitize_or_inline under __SANITIZE_MEMORY__, so
that it does not __always_inline the annotated function.

Link: https://lkml.kernel.org/r/20240426091622.3846771-1-glider@google.com
Fixes: 5de0ce85f5a4 ("kmsan: mark noinstr as __no_sanitize_memory")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: syzbot+355c5bb8c1445c871ee8@syzkaller.appspotmail.com
Link: https://lkml.kernel.org/r/000000000000826ac1061675b0e3@google.com
Cc: <stable@vger.kernel.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler_types.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -226,6 +226,17 @@ struct ftrace_likely_data {
 # define __no_kcsan
 #endif
 
+#ifdef __SANITIZE_MEMORY__
+/*
+ * Similarly to KASAN and KCSAN, KMSAN loses function attributes of inlined
+ * functions, therefore disabling KMSAN checks also requires disabling inlining.
+ *
+ * __no_sanitize_or_inline effectively prevents KMSAN from reporting errors
+ * within the function and marks all its outputs as initialized.
+ */
+# define __no_sanitize_or_inline __no_kmsan_checks notrace __maybe_unused
+#endif
+
 #ifndef __no_sanitize_or_inline
 #define __no_sanitize_or_inline __always_inline
 #endif


