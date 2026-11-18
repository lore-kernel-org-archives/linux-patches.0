Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046295;
	b=gk6UBF69gwvWxoH4yVoN/iu0jZeAURkJF09V3uycJEHjh/ta5gVOLfXlCfC428n4DzqM
	 G55i6okPxTQJBpz9IsIKjZRZOXjodzKjBoKBMbN7vI3ktx7UCTtB994x0LqUOLrLqF6RZ
	 HLqX9sfMNAavauJ0H+xMaD7i9LGa3vdcYZZopMjbZ5ER0dXWks+UrCjBMfSjMrSQ2PPkG
	 7EceyW/NQ+K+69JAs1LwbBeZqdZovOKmhGNFDcrsuc95/tnyq0/n4tuYMKklZgDvcDuGr
	 2q9N1gfsTuj1MV+NxfvpupAoLNp4v/jdqqQRC7XgUswlpCB37hkFs9tiRF3x1G84A4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q2Qll5KClE+gh9SNsXCQ4TG8/5OLn3dQC5MS4tHQpy0=;
	b=THBrpG0V+W4JIlB1BLYmrvHH0rlnQwPlFnKbDwaOdzXP4zR3QEpV1uiPM2N7q3Hecc5e
	 oEBVV2fjFEfaQuIuQlAzX+Sb2/SVw+6MAzcMzX7mujwUuB5ZkXEuW9zqiS7HHQy1rupsm
	 GEuP5LQ8UbcOAaaWr8q2/2FYSFKnaFuLpSyyqfN6Tnjg5uNyLc/xtr0Jv1jE7mvvEvDhf
	 hZf2l+wNQnJFvnzAzDClHtsKAnnt++uLqT3QdT8uTfTN6ocdrJSsHlSS8vIduTMgXy+EE
	 U2MZQMcLBujU9bOvBNTwtyxOd6klurjOmOMUA0bgfR1TziZnz3agrb2qq7qRl8p63gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CyrGV3SV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7DB606A32C;
	Wed, 18 Nov 2026 23:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CyrGV3SV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F5E1F000C4;
	Wed, 18 Nov 2026 23:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046295;
	bh=q2Qll5KClE+gh9SNsXCQ4TG8/5OLn3dQC5MS4tHQpy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CyrGV3SVuNM7v7fdfxiJxT3+L4xhp03YE1vE39ANbB0YvqI0mqXbDGscaj4LlWfLz
	 VD9Lf6oRImdccuvhxTzmhULYyjM5ZO6oXQW2mvqvEQE6TNjsMdUcH6fbYE8SzQjxQt
	 5ASa576dLl1KhhQh5QrWjmBMQMYcYu4PiVHCDmgA=
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
Subject: [PATCH 6.1 1230/2857] mm/memfd: make f_pos accesses atomic
Date: Wed, 18 Nov 2026 15:37:44 +0100
Message-ID: <20261118150245.849192342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4b6c8e5ccd971..b27c505956d9b 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -324,6 +324,8 @@ SYSCALL_DEFINE2(memfd_create,
 		goto err_fd;
 	}
 	file->f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
+	/* a regular file like any other: POSIX.1-2008/SUSv4 Section XSI 2.9.7 */
+	file->f_mode |= FMODE_ATOMIC_POS;
 	file->f_flags |= O_LARGEFILE;
 
 	if (flags & MFD_ALLOW_SEALING) {
-- 
2.53.0



