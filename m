Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620334;
	b=0lANN53SnY4wPFEfpCNA6THnuuRcgmD+n5PxbJq+kxUxAXZr0zZfi7j5p4KTo2aZ+RM2
	 g2uWyYnLDg8qoOQl9fRw1RyMy8syqRgOilHUsXg8VHWf4sOO24knXRfz6rWBRkeDrGuqP
	 E2FFYGYqr3bXbvAhEYz4lUM21upZuylXbqYbf2lzOnCZJprDgCmrDOZBrLEpnadqYv355
	 vSvnpu6XBQn72R/5U9Scr7BtT7GGdDtTFUlnok4W4MTinH/yFokk9me2XepIEcxyg69Bg
	 Lwm1cFwwt+FDf8eILpsCLygAw1sgXffSiiuRntaqFdqqdPErvbEKgqLpSyiQQ8TQjXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xiikKLt2GP+Gb5L/Py95SW7c58Nc3ZpmECKydFG5Oiw=;
	b=fhakKHO3QWwcxf0Sc+iU1IMxVap9SRPmCbePrq1inMYfBNoUXfRuVKYpTucTC+uf0y8F
	 7eAcJJRu82WoaXS/7QF+t8++ZqrB5fF7shbWIgUKdGcWk3ADMMYUdI1DXjImnKfZprwTP
	 lzQST4AJpIzdrIN+YxeE/aeKIx5EpCi7ZPqslPtLHCifXlumHzS61AjmGRd4Y1Am35lDQ
	 8nGqSMemCbB7IPksZCOap9yIi2na/EqS97d81U5ebFwndcOhpyr7iWZ6wATJC7vHcNBZM
	 ovtf104vpQGs01i/8BWN1ixiBZn8YuF7kp4VlpuhNzy8Bzh8H+LmgFG9SPRRHUR1YUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UYw/V0EM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F912606A339;
	Wed, 25 Nov 2026 15:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UYw/V0EM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E373F1F00AD4;
	Wed, 25 Nov 2026 15:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620334;
	bh=xiikKLt2GP+Gb5L/Py95SW7c58Nc3ZpmECKydFG5Oiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UYw/V0EM0GtwKZZpM6pFHtK7ziILjdVguXrYe3xDvj8KRp/9Jn1aFmjcazGBtwPgW
	 u+61GiOARRH+u0gSv3yI+2hEtRjQFvv/7PrMXDgDpvN8kW6ncDF43d06CzE+eGW2yf
	 UhtGUQpAoH8Lcwtqox7VE4jEXo4nPlaspZk2SqDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Vadayath <jay@artiphishell.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0881/1005] dm-raid: bound array_position before indexing failed_devices
Date: Wed, 25 Nov 2026 15:36:59 +0100
Message-ID: <20261125143842.340416947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Jay Vadayath <jay@artiphishell.com>

commit 11b5cd14c0eecae458cecbe53d21a3dbc10190f5 upstream.

super_init_validation() reads role = le32_to_cpu(sb2->array_position)
out of an on-disk dm_raid_superblock and then uses it as a bit index into
the failed_devices bitmap via test_bit(role, (void *)failed_devices).
failed_devices is a uint64_t[DISKS_ARRAY_ELEMS] (DISKS_ARRAY_ELEMS == 4,
i.e. 256 bits) living on the stack. The only guard is role < 0, so any
on-disk array_position >= 256 makes test_bit() read past the end of the
stack array (array_position == 256 reads failed_devices[4], 8 bytes past
the object). For a raid1 set the role != raid_disk reorder branch falls
through to the same test_bit().

A crafted dm-raid superblock therefore causes a stack out-of-bounds read
during table load. Reachable by anyone able to issue a dmsetup create
with attacker-controlled metadata (CAP_SYS_ADMIN in the target
namespace); the crash fires in the constructor / analyse_superblocks
path, before any md_run or array sizing.

  BUG: KASAN: stack-out-of-bounds in super_validate+0x1cd0/0x3390
  Read of size 8 at addr ffff888007b17828 by task poc/152
  Call Trace:
   dump_stack_lvl+0x64/0x80
   print_report+0xd0/0x630
   kasan_report+0xe5/0x120
   kasan_check_range+0x105/0x1b0
   super_validate+0x1cd0/0x3390        (super_init_validation, inlined)
   raid_ctr+0x2c4b/0xa0f0
   dm_table_add_target+0x66f/0xf80
   table_load+0x2ee/0x780
   ctl_ioctl+0x362/0x9f0
   dm_ctl_ioctl+0x9/0x10
   __x64_sys_ioctl+0x134/0x1c0
   do_syscall_64+0xe2/0x4b0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

role is a device position that must refer to an actual member of the
array, so reject anything outside [0, rs->raid_disks) instead of only the
negative case. rs->raid_disks is always <= the 256-bit capacity of
failed_devices, so this both closes the out-of-bounds access and matches
the intended semantics.

This bug was discovered by Artiphishell's vTriage pipeline, which
generated a crafted raid1 superblock (magic "DmRd", compat_features=1,
num_devices=2, array_position=256, level=1) and a dmsetup-create
reproducer that reliably triggers the KASAN report on an unpatched kernel
(the precursor DMINFO "raid device #256 now at position #0" is visible in
the serial log just before the splat). The fix below was drafted with the
Claude coding assistant; a userspace reproducer is available on request.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jay Vadayath <jay@artiphishell.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-raid.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2420,7 +2420,8 @@ static int super_init_validation(struct
 		 */
 		if (!test_bit(FirstUse, &r->flags) && (r->raid_disk >= 0)) {
 			role = le32_to_cpu(sb2->array_position);
-			if (role < 0)
+			/* Bound @role before it indexes the failed_devices stack bitmap. */
+			if (role < 0 || role >= rs->raid_disks)
 				continue;
 
 			if (role != r->raid_disk) {


