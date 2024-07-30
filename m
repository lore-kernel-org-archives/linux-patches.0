Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0B118B46A;
	Tue, 30 Jul 2024 17:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359703; cv=none; b=I16J9Km0eW6ObqJ9tka6kJRxXvtFrhsr4aFTzxRx6f8hY1Es79PfUFSUxC1m2Yd+SbzFXTBlIft43dRDI5UPmaIYKya8GVE18bf0pa1yR4+Py1unbiweQNdy5vFdy/jqV/9u05d5suXxYlS4Fh6oBsvJO4Njc2/zLH5P1C6GGgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359703; c=relaxed/simple;
	bh=kxV+NtCvypYYexnGQq8FnrI+9OK+b1DHB58rtwROR7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+R1jph4hzbusshmf1SJS7xDdilWNhYLecw48DK+tYtvDm2rZS37zVVGD4wSujSr9W3nXI8pLn8q1tv503wNmJhmmDtt6LPxN69bT6EGEe5XO2yDqFzMFr4tGO6A5C7vPBZjVw4754e8YBZ37ZugZj42fkBLb0lPubv2yEBgXTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9hYaYpG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9hYaYpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C7DC32782;
	Tue, 30 Jul 2024 17:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359703;
	bh=kxV+NtCvypYYexnGQq8FnrI+9OK+b1DHB58rtwROR7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9hYaYpGwyIEfmq3m4dH4WbStrqTrIEgkxlokTh1O5LKL+n/jTiSLo3bKSTKN+KIU
	 ZHdb2aEtiKmGsXttYuH1veVvicdyn3ej9KRzYhMohcRgOkxMXRJfGq4Tvxxd+AMHZ+
	 XaaGcSJpcYi8vnokvzKjx0PobjQK4PrzdakXK/8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	Kees Cook <keescook@chromium.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Sourav Panda <souravpanda@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 521/809] lib: reuse page_ext_data() to obtain codetag_ref
Date: Tue, 30 Jul 2024 17:46:37 +0200
Message-ID: <20240730151745.317188861@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suren Baghdasaryan <surenb@google.com>

[ Upstream commit fd8acc0097b91fab3104fa8a66ce2fd9cf8b0c11 ]

codetag_ref_from_page_ext() reimplements the same calculation as
page_ext_data().  Reuse existing function instead.

Link: https://lkml.kernel.org/r/20240711220457.1751071-2-surenb@google.com
Fixes: dcfe378c81f7 ("lib: introduce support for page allocation tagging")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pgalloc_tag.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/pgalloc_tag.h b/include/linux/pgalloc_tag.h
index 9cacadbd61f8c..acb1e9ce79815 100644
--- a/include/linux/pgalloc_tag.h
+++ b/include/linux/pgalloc_tag.h
@@ -15,7 +15,7 @@ extern struct page_ext_operations page_alloc_tagging_ops;
 
 static inline union codetag_ref *codetag_ref_from_page_ext(struct page_ext *page_ext)
 {
-	return (void *)page_ext + page_alloc_tagging_ops.offset;
+	return (union codetag_ref *)page_ext_data(page_ext, &page_alloc_tagging_ops);
 }
 
 static inline struct page_ext *page_ext_from_codetag_ref(union codetag_ref *ref)
-- 
2.43.0



