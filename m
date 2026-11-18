Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034534;
	b=T+W5cgEugKcvG8y5ZKvu6rUq227s3zT55RvRuaA/kGLRut/c5wxUf90drz6mbFCDwyyV
	 sVCrNatnBEW6WfVXJbAvJoqK6pGwNm2CVv0n9b9QcIks+oIunLN91KtVBUvFoQL0JuBWi
	 egad3W+2mtV2JqXNcKzmlT1GIKtH+lKOL/UNo0ZTkg5GPlqoYUe+d+iiXp0dw8Zi274F1
	 jgUmfSXcVX+6j4Ye41qOSEGCdnsWXMmF0TI+OEGnkIgZVrsk2GzXZvC8IEHpkXo0FHYLn
	 ZJh8pK0n5S2qcNX4VZ5WV3OSO2B32o/6VM9UID1n5Fqc2CaPyPPXf++WVzkjCHvlGXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NcQZ8dC1ggqWfSkqcozjkMUyyO5ADJnHvbRrWCvJ7Og=;
	b=gooAbgA9mCzHDWZWBb+5V8Sr3zGewqCG7fxKIBuZWem9G4P7e7Icgx1kNQB4AwwutR5V
	 d05eXA14QRlEOZ7IuWKTqlDX6XPv2AvPCAauuGPQzqO/EEpWbHFjasaZuIZF/2SsFYI3J
	 7LLLJDTVQXfLvj7Yp9kNt2nBWmgJyeoPF0+ypzLGaUJQR9NqpQPTctjT8yIl9AfJTZAIG
	 ix3Vi/1gTVYzVShL9q412KvIbg5P2LGl+Cn1RWeAb500IHIxcFa4wkH98luYspgjoDdDz
	 dqhLB6aY0sI6cVMm8OQ1sCrAXaCw239v0fbG3PAXmj8OPpzR/el1Iy5o7Sz0Rzhu2TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="le/EV11F";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24B3606A31C;
	Wed, 18 Nov 2026 20:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=le/EV11F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2651C1F000C6;
	Wed, 18 Nov 2026 20:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034534;
	bh=NcQZ8dC1ggqWfSkqcozjkMUyyO5ADJnHvbRrWCvJ7Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=le/EV11FeFAZFZga2TtbFA4pRSgAXU7tHh1Cz5lOMWBEe9RC7ul6pNH4uyL4y2qUd
	 ssY7D05onrB29QN+C2k2ord2Y6iH1NQYCXBHMEPvqT2cpZEZTAsOcpekGK2FT6e0nQ
	 3u+E1J/V9R6jEFZvt9IuXG0GWNjBqINF6dITapsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0404/3318] btrfs: do not overwrite NODATASUM flag when removing NODATACOW flag
Date: Wed, 18 Nov 2026 15:17:06 +0100
Message-ID: <20261118150328.559732592@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 15f7c86215e8d5f14b24127fa88af6c79363d50e ]

[TEST FAILURE]
The test case generic/628 will fail if MOUNT_OPTIONS is set to
"-o nodatasum":

  FSTYP         -- btrfs
  PLATFORM      -- Linux/x86_64 btrfs-vm 7.1.0-rc4-custom+ #383 SMP PREEMPT_DYNAMIC Sat May 30 07:35:42 ACST 2026
  MKFS_OPTIONS  -- -O bgt -K /dev/mapper/test-scratch1
  MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch

#  generic/628  1s ... - output mismatch (see /home/adam/xfstests/results//generic/628.out.bad)
#     --- tests/generic/628.out	2022-05-11 11:25:30.816666664 +0930
#     +++ /home/adam/xfstests/results//generic/628.out.bad	2026-06-08 18:56:49.878542927 +0930
#     @@ -8,8 +8,9 @@
#      310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
#      310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/d
#      test reflink flag not set iflag
#     +XFS_IOC_CLONE: Invalid argument
#      310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
#     -310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/b
#     +d41d8cd98f00b204e9800998ecf8427e  SCRATCH_MNT/b
#     ...

[CAUSE]
The direct cause is that after "chattr +S", the btrfs inode will lose its
NODATASUM flag inherited from the mount option. E.g.:

  # mkfs.btrfs -f $dev
  # mount $dev $mnt -o nodatasum
  # touch $mnt/foobar
  # sync
  # btrfs ins dump-tree -t 5 $dev | grep "(257 INODE_ITEM 0) itemoff" -A 3
         item 4 key (257 INODE_ITEM 0) itemoff 15879 itemsize 160
         	generation 9 transid 9 size 0 nbytes 0
         	block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
         	sequence 1 flags 0x1(NODATASUM)
         	                     ^^^^^^^^^ Proper NODATASUM flag

  # chattr +S $mnt/foobar
  # sync
  # btrfs ins dump-tree -t 5 $dev | grep "(257 INODE_ITEM 0) itemoff" -A 3
  	item 4 key (257 INODE_ITEM 0) itemoff 15879 itemsize 160
         	generation 9 transid 10 size 0 nbytes 0
         	block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
         	sequence 2 flags 0x20(SYNC)
         	                      ^^^^ Only the new SYNC flag

This makes the inode drop the old NODATASUM flag, while the new reflink
destination will still inherit the NODATASUM flag.  The mismatching
NODATASUM flags will cause the reflink to fail.

The root cause is that, inside btrfs_fileattr_set() if no FS_NOCOW_FL is
set, we remove both NODATASUM and NODATACOW flag.

However we should not touch NODATASUM flag, as data COW doesn't require
checksum.  Only NODATACOW implies NODATASUM, but DATACOW doesn't imply
DATASUM.

The deeper problems are:

- Fileattr API is too binary
  It either clears or sets a flag, there is no "do not change" option.
  So that why "chattr +S" implies "chattr -C", and is forcing us to
  change NODATACOW along with NODATASUM flag.

- No way to change NODATASUM through fileattr API
  In fact NODATASUM can only be modified through mount option.

The deeper problems are much harder to attack.

[FIX]
Remove NODATACOW flag when FS_NOCOW_FL is not set, but only remove
NODATASUM if "nodatasum" mount option is not set.

This allows the existing "chattr +C" then "chattr -C" to remove
both NODATACOW and NODATASUM flags on a default mount.

But for a mount with "nodatasum" option, the NODATASUM inode flag will
persist through either "chattr +C" and "chattr -C".

Fixes: 7e97b8daf634 ("btrfs: allow setting NOCOW for a zero sized file via ioctl")
Cc: stable@vger.kernel.org
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ sashal: Renamed inode_flags to binode_flags and inode->vfs_inode.i_mode/i_size to inode->i_mode/i_size, because this tree's older code uses the VFS inode directly. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e4df4f5daefd7..54e3ec0685834 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -321,14 +321,21 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 			binode_flags |= BTRFS_INODE_NODATACOW;
 		}
 	} else {
-		/*
-		 * Revert back under same assumptions as above
-		 */
-		if (S_ISREG(inode->i_mode)) {
-			if (inode->i_size == 0)
-				binode_flags &= ~(BTRFS_INODE_NODATACOW |
-						  BTRFS_INODE_NODATASUM);
-		} else {
+		/* We can only change NODATACOW for zero-sized regular file. */
+		if (S_ISREG(inode->i_mode) && (inode->i_size == 0)) {
+			binode_flags &= ~BTRFS_INODE_NODATACOW;
+			/*
+			 * There is currently no way to change NODATASUM flag
+			 * through fileattr API.  If we unconditionally keep the
+			 * current NODATASUM flag, chattr +C then chattr -C will
+			 * keep the NODATASUM flag, and no way to remove that
+			 * flag.
+			 *
+			 * So respect the current mount option for NODATASUM flag.
+			 */
+			if (!btrfs_test_opt(fs_info, NODATASUM))
+				binode_flags &= ~BTRFS_INODE_NODATASUM;
+		} else if (!S_ISREG(inode->i_mode)) {
 			binode_flags &= ~BTRFS_INODE_NODATACOW;
 		}
 	}
-- 
2.53.0



