Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D856A79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C63FC433EF;
	Thu, 12 Jan 2023 14:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533774;
	bh=lasleWUw7vzBpGUvHnIfMOkjVTi4DEd7O+vWu2gOH94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MN25qHDkBpo7sIbEBdoJ1JyLYWswqRcYjfmF6cFnBy14B8mn+L2uFtnt+SQNeYElM
	 36zBn1DWEar6mPNxYrMmQVEc/a/HezWA70qpRegFtdX5rLcerF/Hvx3S9RF3vyS5hD
	 BaPas/ePy4ReVShaszo/SYUNyFUMOM19QKvRDC+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yufen <wangyufen@huawei.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.10 587/783] binfmt: Fix error return code in load_elf_fdpic_binary()
Date: Thu, 12 Jan 2023 14:55:03 +0100
Message-Id: <20230112135551.478066905@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

commit e7f703ff2507f4e9f496da96cd4b78fd3026120c upstream.

Fix to return a negative error code from create_elf_fdpic_tables()
instead of 0.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/1669945261-30271-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_elf_fdpic.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -434,8 +434,9 @@ static int load_elf_fdpic_binary(struct
 	current->mm->start_stack = current->mm->start_brk + stack_size;
 #endif
 
-	if (create_elf_fdpic_tables(bprm, current->mm,
-				    &exec_params, &interp_params) < 0)
+	retval = create_elf_fdpic_tables(bprm, current->mm, &exec_params,
+					 &interp_params);
+	if (retval < 0)
 		goto error;
 
 	kdebug("- start_code  %lx", current->mm->start_code);


