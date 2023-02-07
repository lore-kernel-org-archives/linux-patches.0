Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6C72C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB028C433D2;
	Tue,  7 Feb 2023 13:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775376;
	bh=9coTdfSi7CWiqCTfnTd3UaRRGvyWyZLaAMTnOvJXqxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lu+ltb8Uc6hXbvoNgOvRyM8HB+jAaCGr0v11leGnOBKLbFdC3BrdgJsXW4kxCpl6s
	 +TjJQVIvFr9ZR+PRjn0bO0WHdJF94o9b+ui84ICQqimu0YePyD4JS2/tKL32V15CTE
	 WHraLy/COXKcHWB1Dxe/iH/0yPFUsi1wq7j87Ses=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/120] fix iov_iter_bvec() "direction" argument
Date: Tue,  7 Feb 2023 13:56:31 +0100
Message-Id: <20230207125619.632024358@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit b676668d99155e6859d99bbf2df18b3f03851902 ]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index ef4a8e189fba..014860716605 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -332,7 +332,7 @@ static int fd_do_rw(struct se_cmd *cmd, struct file *fd,
 		len += sg->length;
 	}
 
-	iov_iter_bvec(&iter, READ, bvec, sgl_nents, len);
+	iov_iter_bvec(&iter, is_write, bvec, sgl_nents, len);
 	if (is_write)
 		ret = vfs_iter_write(fd, &iter, &pos, 0);
 	else
@@ -469,7 +469,7 @@ fd_execute_write_same(struct se_cmd *cmd)
 		len += se_dev->dev_attrib.block_size;
 	}
 
-	iov_iter_bvec(&iter, READ, bvec, nolb, len);
+	iov_iter_bvec(&iter, WRITE, bvec, nolb, len);
 	ret = vfs_iter_write(fd_dev->fd_file, &iter, &pos, 0);
 
 	kfree(bvec);
-- 
2.39.0



