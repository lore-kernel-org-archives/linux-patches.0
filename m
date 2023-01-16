Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEEE46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BE0C433EF;
	Mon, 16 Jan 2023 16:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885142;
	bh=7NtsNkiy6I8Bo08AC+C1iUXJg2+S5FRpeyeYohkHdgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFOCg3GHkefj7/164ZFtAj/xKkYyXS7isk8aER6Fz3L/5DSOF4bkZ0JvRL+VLSNiE
	 fGoHEaPMI6Ov1uAqgV+AJ6zAvMTurzcq5D03uosjVdaEsMgTk9nnp4YI96geEdxUV9
	 ANqvf9wJE07X6fNcVObm5hXPusfNIN8zU0J+usKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willy Tarreau <w@1wt.eu>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 66/86] tools/nolibc: fix the O_* fcntl/open macro definitions for riscv
Date: Mon, 16 Jan 2023 16:51:40 +0100
Message-Id: <20230116154749.785473332@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit 00b18da4089330196906b9fe075c581c17eb726c ]

When RISCV port was imported in 5.2, the O_* macros were taken with
their octal value and written as-is in hex, resulting in the getdents64()
to fail in nolibc-test.

Fixes: 582e84f7b779 ("tool headers nolibc: add RISCV support") #5.2
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/arch-riscv.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/include/nolibc/arch-riscv.h b/tools/include/nolibc/arch-riscv.h
index 511d67fc534e..8c0cb1abb29f 100644
--- a/tools/include/nolibc/arch-riscv.h
+++ b/tools/include/nolibc/arch-riscv.h
@@ -11,13 +11,13 @@
 #define O_RDONLY            0
 #define O_WRONLY            1
 #define O_RDWR              2
-#define O_CREAT         0x100
-#define O_EXCL          0x200
-#define O_NOCTTY        0x400
-#define O_TRUNC        0x1000
-#define O_APPEND       0x2000
-#define O_NONBLOCK     0x4000
-#define O_DIRECTORY  0x200000
+#define O_CREAT          0x40
+#define O_EXCL           0x80
+#define O_NOCTTY        0x100
+#define O_TRUNC         0x200
+#define O_APPEND        0x400
+#define O_NONBLOCK      0x800
+#define O_DIRECTORY   0x10000
 
 struct sys_stat_struct {
 	unsigned long	st_dev;		/* Device.  */
-- 
2.35.1



