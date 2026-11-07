Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062636;
	b=nrYV7o5TjRlNakO3S1ci4uyMpzIjwzHMA/AHytlGmxCVWnsDnfokFV76yaieXB7fKZjO
	 Ox9uikTyjSuWq3fB99Vr5e37o6CpVKOETB7Oo/5h5w8S/A3CVDjNBKfE/155uVYjdjOIA
	 ztcEYkioR8zx3C8wmqlaq7wNA3okKLuanvSRaiUegjEonQau9mEKQ4zJhB3MenY4sMF6c
	 djAduo6WrFFB+u3ysewP3Pqh3DsBocZ3nYhn3buXe6OeLe85hNwVD2RPbr9i2QfKpgKIL
	 NZUqvsCwViG2GtNQNnyefLJEZYSez86nP/w5If2heRU1fMKg8SYkoCgkzc+Uksnz58g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=geRgcworY6XTp9YXGv46twpKUT+VdE72MNj1A5T6i/0=;
	b=bCSA7Ao+o8A5bK5+nOyqsLw6prudeLS8X2hlNL+1BjwIZqvDN6iVhpUfq81fUC9zaHOJ
	 x8Xt4Jw0v8XCI0j9VydXu+xY1qwQaBWlkLsIWGoKhjL2+wVCac06BqEEExUDae7GZpCqm
	 0pm7m11i0zvWg9+pHN+exqGkSkTg9HeuRN84i4OR+HHucq8qdK7QbSQHBsYWuRLsF0Dnj
	 eP58nwcu1dgpWrCYqc2CSxielXvP+227mMGX3m1rW5Ps2LnLUaHJtUzp6G1x8SqIyixXQ
	 bztrIPrR4P5daTsYGlz62RtCArv8ueFezC+z9AGHHyOgazC4gBgVdI0+4ULvHxknTHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xc3dHBLA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FA8606A334;
	Sat,  7 Nov 2026 14:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xc3dHBLA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B3D1F0089F;
	Sat,  7 Nov 2026 14:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062635;
	bh=geRgcworY6XTp9YXGv46twpKUT+VdE72MNj1A5T6i/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xc3dHBLAiokc6kI1hW4JQjunBWXQXGkJ1cV+CEOY7B1fd3XnfZUjvS1O2/ytk3q3R
	 hmaeYgpsQOhBqv7Xm8RBuRpCl12oYt8gwVpk9B2KzLdkliP4MCDi1x7+r1IGMK3clF
	 BPjrAExLrGQ/p8r2dIPlDmSo0Z7Fw7iIf3XFhI1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyeontae Lee <wonju345@naver.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1504/1536] fs/ntfs3: bound DeleteAttribute asize against rec->used in do_action
Date: Sat,  7 Nov 2026 08:58:40 -0500
Message-ID: <20261107135040.105792438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyeontae Lee <wonju345@naver.com>

[ Upstream commit 408216b66afd9ddadaba2dce56fd4af6793e95a2 ]

In do_action()'s DeleteAttribute case (fslog.c:3316), attr is
Add2Ptr(rec, roff) with roff taken from the on-disk lrh->record_off, and
asize = le32_to_cpu(attr->size) is read straight out of the MFT record:

	asize = le32_to_cpu(attr->size);
	used  = le32_to_cpu(rec->used);

	if (!check_if_attr(rec, lrh))
		goto dirty_vol;
	...
	memmove(attr, Add2Ptr(attr, asize), used - asize - roff);

check_if_attr() (fslog.c:2869) walks the attribute chain from
rec->attr_off and returns o == ro.  Its loop breaks on ATTR_END, so ro may
legitimately equal the offset of the ATTR_END marker; that is exactly how
CreateAttribute appends to a record.  But check_file_record()'s walk
(fslog.c:2831) also stops at ATTR_END, so check_attr() never inspects the
bytes there.  When roff is the ATTR_END offset, those never-validated bytes
are what gets read as attr->size, and used - asize - roff underflows.

The read itself is also unbounded: roff is a u16 and attr->size is
dereferenced at fslog.c:3317, before check_if_attr() has constrained roff
at all, so it can be up to ~64K past a record_size-sized object.

Commit 0ca0485e4b2e ("fs/ntfs3: validate rec->used in journal-replay file
record check") added at fslog.c:2844

	if (used < PtrOffset(rec, attr) + sizeof(attr->type))
		return false;

and its changelog names this very memmove.  It bounds rec->used against the
ATTR_END offset; it does not bound asize.  With record_size 0x400,
attr_off 0x38, a valid three-attribute chain ending in ATTR_END at 0x158
and used 0x160, a record whose four bytes at 0x15c read 0x100 gives

	used - asize - roff = 0x160 - 0x100 - 0x158 = 0xffffff08

i.e. a ~4 GiB memmove whose source and destination both run off the end of
rec, a kmalloc(sbi->record_size) object (record.c:105).

The equivalent non-replay path already refuses this.  mi_remove_attr()
performs the same removal and starts with (record.c:548):

	if (aoff + asize > used)
		return false;

Apply the same bound, spelled as a subtraction to match the neighbouring
cases, and move the attr->size read after check_if_attr() so that the
header is known to lie inside the record before it is dereferenced.
Requiring roff + SIZEOF_RESIDENT <= used rejects the ATTR_END offset
without rejecting any real attribute: for an attribute the walk validated,
roff + asize <= off(ATTR_END) <= used - 4, and any attribute a
DeleteAttribute record can legitimately name carries a full resident
header, so roff + SIZEOF_RESIDENT <= roff + asize <= used - 4.
check_attr() itself imposes no lower bound on asize, so a crafted
sub-header asize can still pass the first test; the second test then
bounds it and the memmove stays inside the record.

Reproduced by mounting a crafted image on v7.2-rc5, which already contains
0ca0485e4b2e, under KASAN.  The image is an ordinary mkfs.ntfs volume with
four bytes of one MFT record changed and a crafted $LogFile:

  BUG: KASAN: slab-out-of-bounds in do_action.isra.0+0x3211/0x83c0
  Read of size 4294967048 at addr ffff888002423258 by task mount/66

  CPU: 1 UID: 0 PID: 66 Comm: mount Not tainted 7.2.0-rc5 #3
  Call Trace:
   kasan_report+0xce/0x100
   kasan_check_range+0x105/0x1b0
   __asan_memmove+0x23/0x60
   do_action.isra.0+0x3211/0x83c0
   log_replay+0x920a/0xd300
   ntfs_loadlog_and_replay+0x3ef/0x510
   ntfs_fill_super+0x1d23/0x4550
   get_tree_bdev_flags+0x2ef/0x550
   vfs_get_tree+0x82/0x2f0
   fc_mount+0x10/0x1b0
   path_mount+0x517/0x1df0
   __x64_sys_mount+0x20b/0x270
   do_syscall_64+0xf9/0x540
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

  Allocated by task 66:
   __kasan_kmalloc+0x8f/0xa0
   __kmalloc_noprof+0x1b4/0x460
   mi_init+0x81/0x110
   mi_get+0x6a/0x220
   do_action.isra.0+0x1dbf/0x83c0
   log_replay+0x920a/0xd300
   ntfs_loadlog_and_replay+0x3ef/0x510
   ntfs_fill_super+0x1d23/0x4550

  The buggy address belongs to the object at ffff888002423000
   which belongs to the cache kmalloc-1k of size 1024
  The buggy address is located 600 bytes inside of
   allocated 1024-byte region [ffff888002423000, ffff888002423400)

KASAN reports the source side because __asan_memmove()
(mm/kasan/shadow.c:94) validates src before dest and returns without
copying.  Both ends are out of bounds, and on a kernel built without
KASAN the copy is performed.

rec->used is also left at used - asize by fslog.c:3323 before the memmove,
so the record stays inconsistent even when the copy is suppressed; the same
mount goes on to report "ino=1a, mi_enum_attr" and marks the volume dirty.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Hyeontae Lee <wonju345@naver.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index e3d0a859c230b..5774fc1bd0683 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3342,10 +3342,21 @@ static int do_action(struct ntfs_log *log, struct OPEN_ATTR_ENRTY *oe,
 		break;
 
 	case DeleteAttribute:
-		asize = le32_to_cpu(attr->size);
 		used = le32_to_cpu(rec->used);
 
-		if (!check_if_attr(rec, lrh))
+		/*
+		 * check_if_attr() accepts a record_off that points at the
+		 * ATTR_END marker, which is how CreateAttribute appends.  The
+		 * bytes there are not an attribute and check_attr() never
+		 * validated them, so refuse an offset that cannot hold a
+		 * resident header before reading attr->size, and then bound it
+		 * as mi_remove_attr() does.
+		 */
+		if (!check_if_attr(rec, lrh) || roff + SIZEOF_RESIDENT > used)
+			goto dirty_vol;
+
+		asize = le32_to_cpu(attr->size);
+		if (asize > used - roff)
 			goto dirty_vol;
 
 		rec->used = cpu_to_le32(used - asize);
-- 
2.53.0



