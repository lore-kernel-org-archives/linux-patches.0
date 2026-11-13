Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591133;
	b=y2hURhiaq73qk+POJy1w7kInj4gdatIk9kA9/J41WWTYV2Pk6RtPZN8PmuR0mNqvPWi3
	 tROkwgKCmr4Frj5zCWN3PV5NRTJoTbFf/l2vx/VdWz43fdpSajo4SQU4TslV8Gf8gnadX
	 0P35mirN8aqsNuLXsWD7imECO3lXX44/kUo2EXsy9PWhUlh1nLoC0nNwwzt4r6NT82Auf
	 3pT9r3kB6AxrMdhghlIL3pM8tAZ/ASCGTU3oezhk94Q5PihLv7QtBMJ6XYLY+vT1BN01u
	 65qa0Gzev/90Ffj9UYUt3vmbWH7K5YRbJU3bGe5XIM5d4XSToNf4cr9Nwjzx1CU/moA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rebx3nX0Xr640/114QzkM2H0N2uGZ31HnA/ISe0i4N4=;
	b=ni/5tv2rddwB79hg/QS5KqSzwZ6TKQrwiDebq1viUY3Agc30os6hBvgWwCtRp+6pfViC
	 6sgrEXjsyxWcTzfhRhxAg2x/y1iXYZlvuCtkajPKZ4ldAC7Ww5GjVcyH/ThAea3ZCOJ2i
	 Grlp1mYf5bkCF1rPSjvHI4f3k2Wu2mqXwy2MRMXFxt1HpogLPq3xgJGk+bYduaXHDb5CH
	 eqhrR9S3bTOXbJQ2BmRJK775ROYx3BzXJ3tOh7P6EvouYrjhDgUA0E4/Ya9E8RdHWMUse
	 MjZE42DHgENt1wQfXvZnQ3ZFgPNCVQlyhij+tOigieU72sZu7xpJl1FXAfJoMSLnrOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IHkTZ+Fu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13015606A88C;
	Fri, 13 Nov 2026 17:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IHkTZ+Fu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A0A1F000C7;
	Fri, 13 Nov 2026 17:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591132;
	bh=rebx3nX0Xr640/114QzkM2H0N2uGZ31HnA/ISe0i4N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHkTZ+Fuimv1+/KPeNk0MV4ITZb+epN7MwqVTmpUicqv5QnObxar2VYgZqamILBCH
	 3xJbbJkxj0mgaDESZmZ0L4SzbEVPfpTaKQPyhnTPgNaqxUmsiuTKQXWDvJ6d4g465i
	 SqoeHKYddl6+XRj38Lq4fvXOYezEjMEhRA7QoX5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengyu Liang <hengyul@cs.unc.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Andrei Vagin <avagin@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 279/670] fs/proc/task_mmu: return -ENOTTY for unknown pagemap ioctls
Date: Fri, 13 Nov 2026 10:47:23 -0500
Message-ID: <20261113153821.337308680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hengyu Liang <hengyul@cs.unc.edu>

[ Upstream commit bfc1d9724c78aa7570dbeb17207a21089f2d1b1a ]

Commit 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and
optionally clear info about PTEs") made do_pagemap_cmd() the ioctl
handler of /proc/<pid>/pagemap.

However, do_pagemap_cmd() returns -EINVAL for every command other than
PAGEMAP_SCAN. Before that commit, pagemap had no ioctl handler, and
the VFS returned -ENOTTY for these commands. As of now, they fail with
EINVAL, so tcgetattr() and isatty() on pagemap report EINVAL instead
of ENOTTY.

The issue can be reproduced with a simple C program:

    #include <fcntl.h>
    #include <stdio.h>
    #include <termios.h>

    int main(void)
    {
            struct termios t;
            int fd = open("/proc/self/pagemap", O_RDONLY);

            if (tcgetattr(fd, &t) < 0)
                    perror("tcgetattr");
            return 0;
    }

Before that commit, the result is:

    tcgetattr: Inappropriate ioctl for device

After that commit, the result is:

    tcgetattr: Invalid argument

This patch will return -ENOIOCTLCMD for unknown commands, as
procfs_procmap_ioctl() in the same file does, so that the VFS turns it
into -ENOTTY.

Link: https://lore.kernel.org/20261023181300.3366487-1-hengyul@cs.unc.edu
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/task_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 0f45320caf720..bc38ba6aa37ea 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2943,7 +2943,7 @@ static long do_pagemap_cmd(struct file *file, unsigned int cmd,
 		return do_pagemap_scan(mm, arg);
 
 	default:
-		return -EINVAL;
+		return -ENOIOCTLCMD;
 	}
 }
 
-- 
2.53.0



