Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C904A1EA72
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC85C433C8;
	Tue, 25 Jul 2023 10:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282182;
	bh=mT/9TBZTj5ExxycItBcyg1vhw2lyBctivTPlTSmjo0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1SNPlQcK9XgylY69WF5MXCfP3rGseAIDYh44/cQ/+/d8x+wOHDahEjeBYdmuymif5
	 ffhGsyLoCW3FVPY6Z9fs91zRYhF8Uw+ShEBxXr3roJ5ONprMI+IKB6C4zt5dve4zQB
	 Qe8nKIJzmGa88ga3epnJ5gD6u6a5P273z81AL0Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.4 009/227] selftests/mm: mkdirty: fix incorrect position of #endif
Date: Tue, 25 Jul 2023 12:42:56 +0200
Message-ID: <20230725104515.168067875@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Colin Ian King <colin.i.king@gmail.com>

commit 25b5949c30938c7f26dbadc948b491e0e0811c78 upstream.

The #endif is the wrong side of a } causing a build failure when
__NR_userfaultfd is not defined.  Fix this by moving the #end to enclose
the }

Link: https://lkml.kernel.org/r/20230712134648.456349-1-colin.i.king@gmail.com
Fixes: 9eac40fc0cc7 ("selftests/mm: mkdirty: test behavior of (pte|pmd)_mkdirty on VMAs without write permissions")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/mkdirty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mkdirty.c
+++ b/tools/testing/selftests/mm/mkdirty.c
@@ -321,8 +321,8 @@ close_uffd:
 munmap:
 	munmap(dst, pagesize);
 	free(src);
-#endif /* __NR_userfaultfd */
 }
+#endif /* __NR_userfaultfd */
 
 int main(void)
 {


