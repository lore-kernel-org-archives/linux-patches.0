Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066191D89F5;
	Tue, 15 Oct 2024 11:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992960; cv=none; b=INitYZ4M7yyDMMKyIsCbLG19BsxY4L8NKBjRq4P6FGuNHkzxzqwg+7wUxnbtj/BOAgG8OP2rKadWLLHmw9gf0YcHOB6lfJvxaGHPCg1/elpjNUTZPgR/V/ak+5LM5JeKi/3PHLsF8DydOrZdr17Ufnr06wax2RxDWnzfNOnHTss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992960; c=relaxed/simple;
	bh=6yKwNAsRD3xs/REQi7UPPpUqE/yCSN/HjGEbv1XXY+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1+76Hy8tpoTqW/apNWG7v/T0mksT2vkwJZ32yQ5GDG0g6x/v0+kvVS9zE6+EWyY1yUlrVquM6bNfA2sw6dNW7NL57vHM5oDrhVcTIVPO4D+vEOpIWX4wcTmdJbm4hIL3HeIz+hm/zMU5P+zH35FHz9F4UMPctNmFjPuYny4ioo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B5O4dEOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5O4dEOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA17C4CEC6;
	Tue, 15 Oct 2024 11:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992959;
	bh=6yKwNAsRD3xs/REQi7UPPpUqE/yCSN/HjGEbv1XXY+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B5O4dEOwPnoJp90oCFTR1N3WUnVnaTJyt1znIIjnTKg1IPVpBpM6XEBS014HNtHaO
	 6E3IbWWZn+oNZbDxYpsICXYJxpFq0yX+rThkWJxcG+8i7kDrqYdCMaDb91s3qoK6So
	 g/ky3+FGbUt/mYP5oX81nrmqw6LPKXsVmDkkyGhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 269/691] f2fs: clean up w/ dotdot_name
Date: Tue, 15 Oct 2024 13:23:37 +0200
Message-ID: <20241015112451.024051469@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit ff6584ac2c4b4ee8e1fca20bffaaa387d8fe2974 ]

Just cleanup, no logic changes.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 884ee6dc85b9 ("f2fs: get rid of online repaire on corrupted directory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/namei.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 80bc386ec6980..966578587bbe3 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -454,7 +454,6 @@ static int __recover_dot_dentries(struct inode *dir, nid_t pino)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
 	struct qstr dot = QSTR_INIT(".", 1);
-	struct qstr dotdot = QSTR_INIT("..", 2);
 	struct f2fs_dir_entry *de;
 	struct page *page;
 	int err = 0;
@@ -492,13 +491,13 @@ static int __recover_dot_dentries(struct inode *dir, nid_t pino)
 			goto out;
 	}
 
-	de = f2fs_find_entry(dir, &dotdot, &page);
+	de = f2fs_find_entry(dir, &dotdot_name, &page);
 	if (de)
 		f2fs_put_page(page, 0);
 	else if (IS_ERR(page))
 		err = PTR_ERR(page);
 	else
-		err = f2fs_do_add_link(dir, &dotdot, NULL, pino, S_IFDIR);
+		err = f2fs_do_add_link(dir, &dotdot_name, NULL, pino, S_IFDIR);
 out:
 	if (!err)
 		clear_inode_flag(dir, FI_INLINE_DOTS);
-- 
2.43.0



