Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E5B6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3E5C433D2;
	Tue, 10 Jan 2023 18:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374980;
	bh=lasleWUw7vzBpGUvHnIfMOkjVTi4DEd7O+vWu2gOH94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRDe14YwWMuyjusAg8cxomQiQBHclKRAX3Q0h2Q1aEIZHJtav4UpUr6/pr3e5k1lN
	 9ax9/qdULQwNk6sqdFsHoydJO/RoRSp1SkktpOi7hEu+lWiXKh0Jsb9kGcwDWSDYUj
	 BClgMgqkpd/mXEZSmF/ffmhvs4E+iY1SSah8K2Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yufen <wangyufen@huawei.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.15 039/290] binfmt: Fix error return code in load_elf_fdpic_binary()
Date: Tue, 10 Jan 2023 19:02:11 +0100
Message-Id: <20230110180032.937297307@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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


