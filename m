Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214310;
	b=2mc4innngxttoWBUVix8YeVuEAhFDBTELDkFu+r14XDTE9bbDFMSogbW/8FEgrKzEtXp
	 cwXfdLhmV/qqnCsst74gzCjLRH1Vf06EFe5DQA4WK2utfSw8E0G/Xbhk8CKwm7i0WslYp
	 LLa5P1/xlPvjhakkMeo+L771NOoy2l1mkxtJxYHJ++Bj+j2xmGOMsN6H6BIV7MriF8fgc
	 /tH1hjw5HrE3CtKRcjUXOStPsqY+hFpbPiNYQqSmeRJHTKIgkQLt9h54vKRBQpKDe/YdT
	 YJSVKD24E76sUP+dyi+o4dpSjYDhH1YjnLmm1DgKPeiF+ubuxL2mwrHXdsis05+I41w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9mIhsMgc22G/nZtgDdn+JF63bckCuF+Ep1rx+4XQNqU=;
	b=mmTtFI6RTE1Cg1K/zrfxI3R4DnifOng5N/wQlPoJEtYMWh1ltsLxZO/JOAZqaOWyuPoD
	 PpHbdHavCP4PrWRhrcKE4c4QZDcjYKaRMtOGSaAcLGteW7cx2tdYvOXL0K1Eo5hpUrrE7
	 +i/2eBlPn5kTwuuUnpv7V9wGigf9lxnv5e320Dmj7jB7v7kkWZn3k3vMJgFzt+1BlSk6w
	 ERlkYNvJwvhRiExRZ+RCMjEMPTk2F1o7d4dNd3vdbRSJvKLva4B67KM0THO71NzNDwa5f
	 qh6hr2umJg8yLUzW6pNXp1me5a9NPqH4K6xBqPo1Y7xb36HhPGcaovXS9a8GAmzPiHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DumP0dC5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD0B60A3830;
	Wed, 28 Oct 2026 19:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DumP0dC5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3A21F01825;
	Wed, 28 Oct 2026 19:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214309;
	bh=9mIhsMgc22G/nZtgDdn+JF63bckCuF+Ep1rx+4XQNqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DumP0dC5lKon7CkHhorMWuRqmmscRO2JwpuwfGJ/j+nkx1x3UVrhWhDUYyM25HHZU
	 LxbqJsfg59FuPdj0zMn8RjJlc6Onbp8H4w1hShtJXWI8REvtaNpTFtbG5O1ma8FmBX
	 YGFBrQktsC91OmNtbp3ZYu+nFPqaaKwVYF7xHTTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5d0bdc98770e6c55a0fd@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0770/1887] fs/ntfs3: Keep write operations atomic
Date: Wed, 28 Oct 2026 17:47:46 +0100
Message-ID: <20261028170516.962196825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit 285cec318bf5a7a6c8ba999b2b6ec96f9a20590f ]

syzbot reported a NULL pointer dereference in __generic_file_write_iter. [1]

Before the write operation is completed, the user executes ioctl[2] to clear
the compress flag of the file, which causes the is_compressed() judgment to
return 0, further causing the program to enter the wrong process and call the
wrong ops ntfs_aops_cmpr, which triggers the null pointer dereference of
write_begin.

Use inode lock to synchronize ioctl and write to avoid this case.

[1]
Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
Mem abort info:
  ESR = 0x0000000086000006
  EC = 0x21: IABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x06: level 2 translation fault
user pgtable: 4k pages, 48-bit VAs, pgdp=000000011896d000
[0000000000000000] pgd=0800000118b44403, p4d=0800000118b44403, pud=0800000117517403, pmd=0000000000000000
Internal error: Oops: 0000000086000006 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 UID: 0 PID: 6427 Comm: syz-executor347 Not tainted 6.13.0-rc3-syzkaller-g573067a5a685 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : 0x0
lr : generic_perform_write+0x29c/0x868 mm/filemap.c:4055
sp : ffff80009d4978a0
x29: ffff80009d4979c0 x28: dfff800000000000 x27: ffff80009d497bc8
x26: 0000000000000000 x25: ffff80009d497960 x24: ffff80008ba71c68
x23: 0000000000000000 x22: ffff0000c655dac0 x21: 0000000000001000
x20: 000000000000000c x19: 1ffff00013a92f2c x18: ffff0000e183aa1c
x17: 0004060000000014 x16: ffff800083275834 x15: 0000000000000001
x14: 0000000000000000 x13: 0000000000000001 x12: ffff0000c655dac0
x11: 0000000000ff0100 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
x5 : ffff80009d497980 x4 : ffff80009d497960 x3 : 0000000000001000
x2 : 0000000000000000 x1 : ffff0000e183a928 x0 : ffff0000d60b0fc0
Call trace:
 0x0 (P)
 __generic_file_write_iter+0xfc/0x204 mm/filemap.c:4156
 ntfs_file_write_iter+0x54c/0x630 fs/ntfs3/file.c:1267
 new_sync_write fs/read_write.c:586 [inline]
 vfs_write+0x920/0xcf4 fs/read_write.c:679
 ksys_write+0x15c/0x26c fs/read_write.c:731
 __do_sys_write fs/read_write.c:742 [inline]
 __se_sys_write fs/read_write.c:739 [inline]
 __arm64_sys_write+0x7c/0x90 fs/read_write.c:739
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762

[2]
ioctl$FS_IOC_SETFLAGS(r0, 0x40086602, &(0x7f00000000c0)=0x20)

Reported-by: syzbot+5d0bdc98770e6c55a0fd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5d0bdc98770e6c55a0fd
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index f2d1df2c988a9..b825862d74f95 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -1049,25 +1049,28 @@ static ssize_t ntfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ssize_t ret;
 	struct ntfs_inode *ni = ntfs_i(inode);
 
+	if (!inode_trylock(inode)) {
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return -EAGAIN;
+		inode_lock(inode);
+	}
+
 	if (is_encrypted(ni)) {
 		ntfs_inode_warn(inode, "encrypted i/o not supported");
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		goto out;
 	}
 
 	if (is_compressed(ni) && (iocb->ki_flags & IOCB_DIRECT)) {
 		ntfs_inode_warn(inode, "direct i/o + compressed not supported");
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		goto out;
 	}
 
 	if (is_dedup(ni)) {
 		ntfs_inode_warn(inode, "write into deduplicated not supported");
-		return -EOPNOTSUPP;
-	}
-
-	if (!inode_trylock(inode)) {
-		if (iocb->ki_flags & IOCB_NOWAIT)
-			return -EAGAIN;
-		inode_lock(inode);
+		ret = -EOPNOTSUPP;
+		goto out;
 	}
 
 	ret = generic_write_checks(iocb, from);
-- 
2.53.0



