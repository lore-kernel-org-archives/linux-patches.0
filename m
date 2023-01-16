Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973A46FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86C9C433D2;
	Mon, 16 Jan 2023 16:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888053;
	bh=mO0ziDS60yhaXrgsLEhVLWX0o/s9J7j4rqQf+uv5keQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXmDbR+HJy6qxUex75Ie1j3zl028uu13a/8VMH45/GSZqyxJFOitLXCt3syaxfyoq
	 IpaKGi+IXYeXGO0qhfkwN8xFdG0SjI1Fa0vc5UE0DEUr3bVmIatt7Wz/IPjJiaka1D
	 OBA6H516vQEfkcGmFKVQjJBOkHXwU5UCGnMG41o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yufen <wangyufen@huawei.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 382/521] binfmt: Fix error return code in load_elf_fdpic_binary()
Date: Mon, 16 Jan 2023 16:50:44 +0100
Message-Id: <20230116154904.205786574@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit e7f703ff2507f4e9f496da96cd4b78fd3026120c ]

Fix to return a negative error code from create_elf_fdpic_tables()
instead of 0.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/1669945261-30271-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/binfmt_elf_fdpic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 60896c16f103..64d0b838085d 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -439,8 +439,9 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 	current->mm->start_stack = current->mm->start_brk + stack_size;
 #endif
 
-	if (create_elf_fdpic_tables(bprm, current->mm,
-				    &exec_params, &interp_params) < 0)
+	retval = create_elf_fdpic_tables(bprm, current->mm, &exec_params,
+					 &interp_params);
+	if (retval < 0)
 		goto error;
 
 	kdebug("- start_code  %lx", current->mm->start_code);
-- 
2.35.1



