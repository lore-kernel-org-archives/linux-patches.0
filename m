Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059032;
	b=r6E5ZZ5y0fMbXWCRdrNT5Eocm/MTNB0SpOTp1dil+8llMyPbBb8mwoZkvgjYjgwf1MSm
	 u0W6SRULaD5rJ2LwezNGyxYTc2Y66gGKZiZ+hBPFyVHXtab5gQNslIPIo54Dj8AlzGjuG
	 unOEntbrtGIAIWV3T+ABFnbFshI6fmWBu6EUsHJYlkEXgXlB0Sv3ODpuSwff54V8U2e33
	 g6p+3AIwPwJ5S5MxDQCI8uAMmgif8YBPHusIwq8ZLD3g/vQ0hRwUEOij6nq60a3NaMPj5
	 TzX9D/Elc9umeXz1kF8Gff9DsGpi0BDbF0VAtyf0oBby9Ak9iCwLWLaeJGq0kNlqGMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jtmrzoQouEdVkfOiuRoaMg30V4j01eduiHwdih2/85Y=;
	b=qmYPGB3SoKzo2X4oZtvpo0y3sOmrf1ChkvM6kg7dqKLw52+O7QUUnztsUCDP8DAG0VUb
	 s3efuNVgRQHPKXdlo9S00NClJNoHqHKRMyYajKuGMqhyFKmIt645AZSc6D9oR11ZMUEAy
	 lYfaxEelw4pjJm8AgPolykli4zpTkKy1O+gEsjEUjLmXKH27FINCNeJfYXJP+ZxvCoIpV
	 1vG97BWAXhpZglKk6587wxTLIdSVk8svOQcB9OaNhmq+zHgyYqteAFOG/Xh8YcIS/sND+
	 sUqxWT6svQhU1ocdgyRJHSuLZBKvNUlZ/UXIwmTmyrtxSHFr4po88clwywgOefzdu2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yORNDcvi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3227606A326;
	Thu, 19 Nov 2026 03:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yORNDcvi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9591F000C4;
	Thu, 19 Nov 2026 03:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059032;
	bh=jtmrzoQouEdVkfOiuRoaMg30V4j01eduiHwdih2/85Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yORNDcvipsT636TXP7cRVsejhpkf8PAqAQgoD44MYIg4cmOOd1XPXUpyDcmFOXoPh
	 NJMdm9mYRXlCiMt8Tdi4oe9o5zK79kanPfn7PhZlybFSQHDfvAQz9acsK8iG5riWoY
	 m/B5RQQFtPIlGhTt2l3isvWBARhnZm8vQEbkm7tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Rik van Riel <riel@surriel.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0696/1848] mm/memfd: make f_pos accesses atomic
Date: Wed, 18 Nov 2026 15:45:34 +0100
Message-ID: <20261118145945.030972586@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 5426cd43a4d28f1041c9ca45955121b921f29548 ]

Commit 9c225f2655e3 ("vfs: atomic f_pos accesses as per POSIX") made
read(), write() and lseek() on a shared open file description of a regular
file serialize on ->f_pos_lock.  The flag that asks for it,
FMODE_ATOMIC_POS, is set in do_dentry_open().  A memfd is a regular file
too, but its struct file comes from alloc_file_pseudo() and never passes
through do_dentry_open(), so it does not get the flag:

  CPU0                                CPU1
  write(memfd, "a", 1)                write(memfd, "b", 1)
    pos = file->f_pos  (= 0)
                                        pos = file->f_pos  (= 0)
    vfs_write(..., &pos)
                                        vfs_write(..., &pos)
    file->f_pos = pos  (= 1)
                                        file->f_pos = pos  (= 1)

One of the two bytes is overwritten.  Two threads writing 100000 bytes
each, one at a time, to a memfd end up with a file that is far shorter than
200000 bytes, while the same program on a tmpfs file never loses a byte.

Set the flag when the memfd is created.  As for any other regular file the
lock is only taken if the file is reachable in more than one way, and
nothing a memfd does in read or write waits for another operation on the
same file.  This cannot be done for all alloc_file_pseudo() files: anon
inode files such as eventfd are S_IFREG as well, and a blocked read holding
->f_pos_lock would lock out the write that is supposed to wake it.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 9183df25fe7b ("shm: add memfd_create() syscall")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: minor description tweaks ]
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-4-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memfd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memfd.c b/mm/memfd.c
index 8ce796ca5bfa4..a0a0233cadeb4 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -326,6 +326,8 @@ SYSCALL_DEFINE2(memfd_create,
 		goto err_fd;
 	}
 	file->f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
+	/* a regular file like any other: POSIX.1-2008/SUSv4 Section XSI 2.9.7 */
+	file->f_mode |= FMODE_ATOMIC_POS;
 	file->f_flags |= O_LARGEFILE;
 
 	if (flags & MFD_ALLOW_SEALING) {
-- 
2.53.0



