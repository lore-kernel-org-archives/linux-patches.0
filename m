Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022036;
	b=1bgjLmo0tQV/7oB3fwgvvkMbFRTcfk+HTtLcJx9jEzGSjztcr7pWp3ZEZ2+NW3hj7nF8
	 Xujl+JZ/6jAnXBXppiI5P6qbiGhqJqVSSs2SpwV2ArfGQ4PpnZahrnv5/Ea7i7ALrpWvY
	 FZ4ellN2MxRIfB7VF0maMhLSVvtwZgppsyhtbfyFp/qUDYoASLRefcxq3DFqEKEI6R0Q/
	 ruSBAEspt9xPpLeWnm6rxqp3C9H01PfeVo1c85RmFuVMimPAByFEHDE0CaZOstQvQEENN
	 R8wTmV6y8n6kvfRAbWFDVcJdRJ7n7WHxObcrz+SEZtHyxVXE5J2LBe9tlIsly4Z4cjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DiwHzUv2gLDtsHYHpquLaUeE9WPA7VL/HV44Lz2HlVw=;
	b=5jmISK/Jssr5LRPZSQToeQ3ZUChTmsEMGlEdNAvkvG4/neYImBCPhingqGpnqeTwDaop
	 3WDrT+StMhAiR4mi6xVhhPd1pK6sEMz/upAOaOvpJqA2aC5Y0J4Uw9X+WCLfUeSL7UO5e
	 o7kdSAyIqEtEY2w6u38SUQsYpAkvjrofT1NfOza+P6VbE7OtAaBsAkSOWPlABJs5zeebw
	 59rEQlmSQk6fQoHRZ9KyEKoi+uFBTxqRd2ZRilkVnuBkhUCyPk5JbYSguCR1FwwRKSZmK
	 S5pWTrycmBXBji8atjdSimQ16/D+s0hWBZlfU8pLUhJiHudl9/8rehnrRBhKSz2y+bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=El13mzZv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CF0606A32C;
	Wed, 18 Nov 2026 17:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=El13mzZv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E721F000C6;
	Wed, 18 Nov 2026 17:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022036;
	bh=DiwHzUv2gLDtsHYHpquLaUeE9WPA7VL/HV44Lz2HlVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=El13mzZvpD8tzqN2wQcL59p9QufxFBzyIdYsN4pc4sd6qSIW+QDLsuBOlAF13ar7U
	 lmico5xP/DxD7akETgQhHVrgkPB6JGBqwASilVAOGBAK+Lz/w0pHXoIkrOKcTdTnUw
	 lZ8Yqo4Ej84zF840Jla00V49RwO//EiLOmTYSA68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7be6ad5cb228286af3e3@syzkaller.appspotmail.com,
	Slawomir Stepien <sst@poczta.fm>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2519/2651] fs/ntfs3: handle partial allocation in attr_data_get_block_locked()
Date: Wed, 18 Nov 2026 16:02:39 +0100
Message-ID: <20261118150415.377711384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slawomir Stepien <sst@poczta.fm>

[ Upstream commit ec67e8d61eb40a4e69b16d8931da217352447367 ]

When allocating clusters for a sparse or compressed attribute in
attr_data_get_block_locked(), the requested virtual cluster number (vcn0)
is aligned down to a frame boundary (vcn). The function then attempts to
allocate a full frame of clusters.

If the disk is nearly full and highly fragmented, attr_allocate_clusters()
might only manage to allocate a small fragment and return success with a
partial allocation length. If this partial allocation is so small that it
does not even reach the originally requested vcn0 (i.e., end <= vcn0), vcn0
remains unallocated (a sparse hole).

When the code subsequently calls run_lookup_entry() for vcn0, it finds the
original SPARSE_LCN entry, which triggers a WARN_ON(1).

Fix this by adding a check to verify if the partial allocation reached
vcn0. If it did not (vcn0 >= end), treat this as an -ENOSPC failure and
jump to the undo1 label. This safely rolls back the partial allocation,
restores the original size, and repacks the runs, leaving the inode in a
consistent state before returning the error to the caller.

WARNING: fs/ntfs3/attrib.c:1236 at attr_data_get_block_locked+0x1980/0x25d0
fs/ntfs3/attrib.c:1236
RIP: 0010:attr_data_get_block_locked+0x1980/0x25d0 fs/ntfs3/attrib.c:1236
Call Trace:
 <TASK>
 attr_data_get_block+0x1f1/0x2a0 fs/ntfs3/attrib.c:979
 ntfs_fallocate+0xd3d/0xf70 fs/ntfs3/file.c:670
 vfs_fallocate+0x663/0x7f0 fs/open.c:338
 ksys_fallocate fs/open.c:362 [inline]
 __do_sys_fallocate fs/open.c:367 [inline]
 __se_sys_fallocate fs/open.c:365 [inline]
 __x64_sys_fallocate+0xbf/0x110 fs/open.c:365
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Fixes: 099ef9ab9203 ("fs/ntfs3: implement iomap-based file operations")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+7be6ad5cb228286af3e3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7be6ad5cb228286af3e3
Link: https://syzkaller.appspot.com/ai_job?id=3c9dee6e-001d-4972-8bf6-f6c960708246
Signed-off-by: Slawomir Stepien <sst@poczta.fm>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 7b74adb2e8684..bc923c33013fc 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1249,6 +1249,10 @@ int attr_data_get_block_locked(struct ntfs_inode *ni, CLST vcn, CLST clen,
 	total_size = total_size0 + ((u64)*len << cluster_bits);
 
 	if (vcn != vcn0) {
+		if (vcn0 >= end) {
+			err = -ENOSPC;
+			goto undo1;
+		}
 		if (!run_lookup_entry(run, vcn0, lcn, len, NULL)) {
 			err = -EINVAL;
 			goto out;
-- 
2.53.0



