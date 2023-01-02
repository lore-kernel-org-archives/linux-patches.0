Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2327128EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95432C433EF;
	Mon,  2 Jan 2023 11:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658937;
	bh=lasleWUw7vzBpGUvHnIfMOkjVTi4DEd7O+vWu2gOH94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=df+2g6DNUS23MhFlgKdv9C+Saqo1oGEQQH3gqUsj7J4hftsCU5B3/DEq0YZWOgXK4
	 pX5zZG4zmdK68nZ9pfPPI8jVwVkuM5YtHWWh+0hXowGEXJM4X/24WdhByhsq0YVDA8
	 dd6cbRgHeQd/lgjeugRM0uP6ygyntAAzzxbWhCL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yufen <wangyufen@huawei.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.0 56/74] binfmt: Fix error return code in load_elf_fdpic_binary()
Date: Mon,  2 Jan 2023 12:22:29 +0100
Message-Id: <20230102110554.488816763@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
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


