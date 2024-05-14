Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760B26311D;
	Tue, 14 May 2024 11:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685813; cv=none; b=bUufsOJdGa8csenTxv/wKaBjiM9328IUQmyCZXXIXAFTZ1sbDPA6YNw8CEv44yaPpb52PV/8DazkAGDPEwvj9LWPd1M3wnsMeVJcOM5h2iOhEnCHbCHNnZPkx77AX3KtO5YJOQbDAR0csdeuZ3dh0MYDLd/sJAq3ucdYy5F0zis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685813; c=relaxed/simple;
	bh=HgciT3FTJZIhAKhPirME02yFWU2ZYAsq5wlc+QmP9L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6F/KdicijqHFxug7dl3Jr+m9HAsBP6IpGoaae5B084Q6xS4l3YR7QZqz2IZttW3gIqUW3H9EaRZw2R49/nUKxGsEZqpC4yCZUwVwYR4jqW7UJ1Edcazfmxx2wj62HdDrrSZFQLSJnN4TXQkRnw6Az7/cP5Js3dieGzON8cZ2yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zaEnyLs0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zaEnyLs0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D221CC2BD10;
	Tue, 14 May 2024 11:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685813;
	bh=HgciT3FTJZIhAKhPirME02yFWU2ZYAsq5wlc+QmP9L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zaEnyLs0pzgJmW67puKEc+lF3xNYltk5aCyyzXcpP0eoSER/3TrfDzuXhWzN3i1gU
	 cbWIQfHLd39v9ey9hd3IlDuSx2ESNifWXoQhOmI/wYQ7xt3Z5Mb64Mw641DEoaixhx
	 lHJCVDR5MY5Bz3GWjo6ug34x8FQovams2Yz8Q2vs=
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
Subject: [PATCH 6.6 252/301] kmsan: compiler_types: declare __no_sanitize_or_inline
Date: Tue, 14 May 2024 12:18:43 +0200
Message-ID: <20240514101041.771789675@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -280,6 +280,17 @@ struct ftrace_likely_data {
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


