Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C60B611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AA9C433C7;
	Mon, 28 Aug 2023 10:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218872;
	bh=AsxAZo0IPjOJ5WOzYp5OFnbZCyqDg28M8n19duvOmWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyJMEA6GEgVRYD+elkEiOOWlwx+Jh5kefjOWIxEpj/5Ssu7W7WDrO+da+D2hMBwSS
	 O2CBByP7oMsQcQ8YSQDXWB5SU8JEwCQSyaD+4SkeWr2Xmq4b6flcplPtFhPqO0PxP7
	 bLbit4rW2S8oHyr1Mt8pcB+EhlHuZMIFNNotBRG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Matthew Wilcox <willy@infradead.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Peng Zhang <zhangpeng.00@bytedance.com>,
	Rong Tao <rongtao@cestc.cn>,
	Tom Rix <trix@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 086/122] radix tree: remove unused variable
Date: Mon, 28 Aug 2023 12:13:21 +0200
Message-ID: <20230828101159.268138704@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit d59070d1076ec5114edb67c87658aeb1d691d381 upstream.

Recent versions of clang warn about an unused variable, though older
versions saw the 'slot++' as a use and did not warn:

radix-tree.c:1136:50: error: parameter 'slot' set but not used [-Werror,-Wunused-but-set-parameter]

It's clearly not needed any more, so just remove it.

Link: https://lkml.kernel.org/r/20230811131023.2226509-1-arnd@kernel.org
Fixes: 3a08cd52c37c7 ("radix tree: Remove multiorder support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Rong Tao <rongtao@cestc.cn>
Cc: Tom Rix <trix@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/radix-tree.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -1134,7 +1134,6 @@ static void set_iter_tags(struct radix_t
 void __rcu **radix_tree_iter_resume(void __rcu **slot,
 					struct radix_tree_iter *iter)
 {
-	slot++;
 	iter->index = __radix_tree_iter_add(iter, 1);
 	iter->next_index = iter->index;
 	iter->tags = 0;


