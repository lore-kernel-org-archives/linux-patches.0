Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585615;
	b=Ty5LOUNWCtUSjCj/27uewQezM8BMqdiZzXhfLhnMaPJ7llLxYpQaD658gRkmRWWuJyJF
	 MVx0ocrK7J/wkTfuQXYrvaNunGn/yEQyAPyebO/8B2FwgMgX8pFP6OlMvBMeeOMApotce
	 snoGga6vOIrajOBO+BTb21CxBI1qYVj23tp5FigD3vqHEHG0txD5i8B9f4ECr2v3caPuy
	 ddX15JOV39p/klTy1kxpQjPXz0683HzsrWcoZa3kSM3EnKuStQ1BGFGj0pVGRvlugYrM6
	 wiK0tpn0BcFZH7Smduqz3A8SKQ9ouNb71Ugxl1hzloeKQ3jojVYMreMUPXf5WouYadg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=PgbfntyMfhJ1+n4jgpOE937JXAseunfOqn5+nbTRD3U=;
	b=WmkeScYqh5WxV2CvvwtbuC8G1EM7p2Ve+tx7CiMRbl266bup0Kbgc9m8vIyrqC6xtjUc
	 uNOa6t0KJTL0kFU4kRdcEszV1DMy3bwkvhr5aXcVAPidwTz1hCIFvoXYz9ZZm5+wTTZz4
	 ZDMVDOrUr8zZLFa7fOZ8UoTzOeiXTnJGkLYU1FKsMXHr5drmP0fOvUkjv8MAjm0xxKk+N
	 HEImV3tIgcI9A50vKJfbhQMvscoBIGofO642Q57iisaJQzcJ+wB+yjoiUvMArM6TC4JB+
	 y2k6zAUitzwPy1842u5/5rF0Wm0uoRw2yYXMdmgCXUujwQ+l2Oerphus3xsnnIEXLYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P7eurjSM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAE56070221;
	Fri, 13 Nov 2026 16:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P7eurjSM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7581F000C4;
	Fri, 13 Nov 2026 16:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585615;
	bh=PgbfntyMfhJ1+n4jgpOE937JXAseunfOqn5+nbTRD3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P7eurjSMlMOCGXekW2fQKjnToJln6oabW3b7lwNze5P04NmvPoevGPdOqm7k8ss0A
	 c0F7y2xkZjasQ5MWVKXjQkL5K17rnlTlynEuSaEC1O80DSzI67hnTPYFYj4loJAjfq
	 B8ZEdAFH+o9Fg5cn3H/eix8xiZ6DQJupjRHRf8TE=
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
Subject: [PATCH 7.3 231/507] fs/proc/task_mmu: return -ENOTTY for unknown pagemap ioctls
Date: Fri, 13 Nov 2026 10:48:55 -0500
Message-ID: <20261113153802.324384763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index a2db957aa7996..2eaa79ab11389 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3314,7 +3314,7 @@ static long do_pagemap_cmd(struct file *file, unsigned int cmd,
 		return do_pagemap_scan(mm, arg);
 
 	default:
-		return -EINVAL;
+		return -ENOIOCTLCMD;
 	}
 }
 
-- 
2.53.0



