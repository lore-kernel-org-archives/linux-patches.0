Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6735D1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89B3C433D2;
	Wed, 28 Dec 2022 16:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244043;
	bh=piUvQMO509sioVOhCXhr73PqNWxLxvZeWa/KjL4hG0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1R+3nohezd9410diczBDBE/Hu1OGsKhbofUftzEHlVXzxCTUUL3mdfpDnXiInuLH
	 tSkHV/83XuuifKoWN5XjzQRrjCNuvCBsciRub91kndikCif90coxZcm0MnJ8GZtfuN
	 /Py3M834/qgyx4zofqb1Uz+gN+nEeaO8STqs5rkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0600/1146] f2fs: fix to destroy sbi->post_read_wq in error path of f2fs_fill_super()
Date: Wed, 28 Dec 2022 15:35:39 +0100
Message-Id: <20221228144346.470401545@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chao Yu <chao@kernel.org>

[ Upstream commit 7b02b2201893a71b881026cf574902019ab00db5 ]

In error path of f2fs_fill_super(), this patch fixes to call
f2fs_destroy_post_read_wq() once if we fail in f2fs_start_ckpt_thread().

Fixes: 261eeb9c1585 ("f2fs: introduce checkpoint_merge mount option")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 3834ead04620..696f094c4505 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4523,9 +4523,9 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	f2fs_destroy_node_manager(sbi);
 free_sm:
 	f2fs_destroy_segment_manager(sbi);
-	f2fs_destroy_post_read_wq(sbi);
 stop_ckpt_thread:
 	f2fs_stop_ckpt_thread(sbi);
+	f2fs_destroy_post_read_wq(sbi);
 free_devices:
 	destroy_device_list(sbi);
 	kvfree(sbi->ckpt);
-- 
2.35.1



