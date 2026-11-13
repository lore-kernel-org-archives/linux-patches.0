Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590336;
	b=mruGrCCa3E1v+EUVyFM9vZjFgWxC/bonBsDT71bl+eWvdapaeaNGEzVshe2956k6Mg5j
	 aS4CHjfdR3QUWfVhVnvlYUci65+9G/mxiLlihU1hV3AktH4+HBvrWJP8rldgFy3NEuskQ
	 90kTtB6ppyG1dcp6oKPwg/F0OEZrzFe3oxwxfd5KX92MCpaiKrxRj2SwTPsh0SwWpiLjl
	 3d2TYFuT/rBBEguAF+ROu1sxG1wfMt+DQSqLJbluDn/9ZLF+nighKBhEx16fYXsO43uwo
	 i2joerv9KeEwAj6k7uiZHBzlvqbTEIzD3QmH73EpkCcljy4i2HxGvB1TCure0lGsnmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NzMPwbKH67/SDhMULMYvgAu4v6WhjfSLl3KF5qk1IfA=;
	b=qGMFJJOfbCQYJKVpvbmOCs7D6yAOJKvbqRUH3ysOnfrI7+CH9Af24BQPAKYnqJCZjdiS
	 0FMXelcx1Trff9r9TroAEs3DX+PJvZDz6Y/fdFlXYkHhF6AxVasJj1AtQ6HJaKkC9pSYm
	 G8gqcd/dxk1I2X3gYVEMgISfcVqrI/eZtD+FRQTR3NoTzdN+rgYy73ZbGTbE/IVxVGVpz
	 EV7cFzuhhCEuptLBKaboLGAxOd2kUu9HdnG6/C+rY4AdRi6IwwwkWqag7+vfBqOUqtFBM
	 mL+Gx336RxUdZpaJIFUufRDWO4V6EuV9GA3oI4WsKQn/XWnVQJ/oPhLvfOm+tDpxkKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WmpyMROg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D3F606D87A;
	Fri, 13 Nov 2026 17:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WmpyMROg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630011F000C6;
	Fri, 13 Nov 2026 17:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590336;
	bh=NzMPwbKH67/SDhMULMYvgAu4v6WhjfSLl3KF5qk1IfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WmpyMROgjKGENJbHfalnILtGQ2F0sAhN2GZVX2d/o7Sn+fb00a+xaM7C/w4twB2Nt
	 K7XeJW48/wrsFc6NRT5XH2SXmFxqnm0U4TaHiKpiSb0llpEq7wTKv7rFz4pYW6UJWO
	 rVK6R42O/PadsQrppviFsOY2hB94izmI/4zZ8EF0=
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
Subject: [PATCH 6.18 314/686] fs/proc/task_mmu: return -ENOTTY for unknown pagemap ioctls
Date: Fri, 13 Nov 2026 10:47:27 -0500
Message-ID: <20261113153831.581415803@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0f08913cfa529..823e8ee1b0953 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3179,7 +3179,7 @@ static long do_pagemap_cmd(struct file *file, unsigned int cmd,
 		return do_pagemap_scan(mm, arg);
 
 	default:
-		return -EINVAL;
+		return -ENOIOCTLCMD;
 	}
 }
 
-- 
2.53.0



