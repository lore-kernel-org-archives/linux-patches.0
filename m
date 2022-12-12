Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D971A28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFB9C433D2;
	Mon, 12 Dec 2022 13:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852072;
	bh=R4x7psRlPUMF5lwLakU0Rk7V+V8YrqjfCKSwZ6+ROjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=neV1XvJmd5OMoGvhCja4R03w2dvRXTXEU5TT9rSEPmVOJhaTn6Wjv82dX3aLS0xy8
	 SVHzH+BCQvRihFxbNJ1oWOnpQ3tsDp4vjIL1c9U8C4TFcJyTIgvn85oJklHtPWVNdy
	 WOmTHNm+Yr2MFsLyyaJVagrwX02HuxdzJFMji70M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/123] block: move CONFIG_BLOCK guard to top Makefile
Date: Mon, 12 Dec 2022 14:18:07 +0100
Message-Id: <20221212130932.445448138@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 4c928904ff771a8e830773b71a080047365324a5 ]

Every object under block/ depends on CONFIG_BLOCK.

Move the guard to the top Makefile since there is no point to
descend into block/ if CONFIG_BLOCK=n.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20210927140000.866249-5-masahiroy@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 998b30c3948e ("io_uring: Fix a null-ptr-deref in io_tctx_exit_cb()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile       | 3 ++-
 block/Makefile | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index bc1cf1200b62..0acea54c2ffd 100644
--- a/Makefile
+++ b/Makefile
@@ -1150,7 +1150,8 @@ export MODORDER := $(extmod_prefix)modules.order
 export MODULES_NSDEPS := $(extmod_prefix)modules.nsdeps
 
 ifeq ($(KBUILD_EXTMOD),)
-core-y		+= kernel/ certs/ mm/ fs/ ipc/ security/ crypto/ block/
+core-y			+= kernel/ certs/ mm/ fs/ ipc/ security/ crypto/
+core-$(CONFIG_BLOCK)	+= block/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
diff --git a/block/Makefile b/block/Makefile
index 41aa1ba69c90..74df168729ec 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -3,7 +3,7 @@
 # Makefile for the kernel block layer
 #
 
-obj-$(CONFIG_BLOCK) := bdev.o fops.o bio.o elevator.o blk-core.o blk-sysfs.o \
+obj-y		:= bdev.o fops.o bio.o elevator.o blk-core.o blk-sysfs.o \
 			blk-flush.o blk-settings.o blk-ioc.o blk-map.o \
 			blk-exec.o blk-merge.o blk-timeout.o \
 			blk-lib.o blk-mq.o blk-mq-tag.o blk-stat.o \
-- 
2.35.1



