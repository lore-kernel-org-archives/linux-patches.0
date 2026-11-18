Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050954;
	b=rkXrlKr1exiIBSOx68s38mDsuz6PajTVLLr1sWNYuEByEX3hGt+uq0aVz8V+qmH3mJIa
	 CjdGInof7elaAK0959mO8+OvC9sYhHTbg8WF76yUv+5fU5HWoJDLkx5wk7NDh6O9+Nw36
	 9BNfsXDXHPNXWgEKftiOp60WYP88nAlWOKIkgSR10EIW7FjOaf5xj3mRuzK11UfCeJ1Td
	 pLSyKLGGtjnq1ZsicS1G65D+k1wHaGi3Ui/smLBjWvSmbKiILzqgKbnxwkxvwQNySpWBS
	 O/0tQT3nFuuPzevu+PUmCr6su03Q8N9CATfxm/hJT3ECt0wrsyIP3cNYVwhYkaVh77A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m6xrQHCkCKEL/hdtGKgHlno/p5IguVZ3KLsg3GeLftc=;
	b=FaBAQRrPr5Ue98huWStqyt2t5itwpMvI4EVgCpkCD5q0WybzqHx0E9AEkU2SKTNmD475
	 Y3aslqSd0uZ7bnhcqqqMTQY/awSWE38haParUVQOVx6OxcTLHgcAP6Xut7AyHfQNmEaR7
	 mXeT3mD/gPkiV7JW0klMYS0XQu0MH65ZDQ9oQS/gEuDwCNR3nmbXE6WE0Y7+s1lMex62T
	 9fp6AGDSzoV+IpUe+v+z6QS2rkr45/yPQu3TMzaWCFLv86wQJ29AD18cGIBZ2SGGkJD6g
	 YYIu0ybUOEpRrBDNHi/mLlV6riSNnDenIBwZLCxJWll1faB3pS8H84EAz2Ma2bwm0GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQ6gvROP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1729606A31C;
	Thu, 19 Nov 2026 01:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQ6gvROP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A631F000C4;
	Thu, 19 Nov 2026 01:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050953;
	bh=m6xrQHCkCKEL/hdtGKgHlno/p5IguVZ3KLsg3GeLftc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MQ6gvROPRWy0Qe+Qw5S9Dblc0bOad9xNpFF7ZrVDu4mnnf6/NhO6UIu+GtTn8hCDW
	 MeZJCujfsmOSiPm50T/yHh+p4AMOWvLHAetbObH2ScfEVpGs2WHusBK7yCnUEeVd6O
	 Zg5xI49Rr2dvSgcNivSLYY16ZMqrAIlgD1qMymyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0036/2214] fat: reject name longer than NAME_MAX in msdos_format_name()
Date: Wed, 18 Nov 2026 15:28:32 +0100
Message-ID: <20261118150011.522714640@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 9d7ed813ee5ff0d469bd99630828ed6fdef4e8da ]

msdos_format_name() performs no upper-bound check on the input name length.
It silently truncates an arbitrarily long name into the 8.3 form (11 bytes)
and returns success. The subsequent fat_scan() then matches only against
these 11 truncated bytes, so it returns an inode as long as any entry with
the same 8.3 name exists on disk.

For example, passing a 300-byte name of all 'A's returns 0 with res set to
"AAAAAAAA" (8 'A's + 3 padding spaces), reporting success for a name far
longer than NAME_MAX.

As a result, when a user calls open() on a path component longer than
NAME_MAX (255) bytes, the VFS only enforces PATH_MAX, not the length of an
individual component. The dentry keeps the original long name but gets an
inode attached and becomes positive. Later in vfs_open() -> fsnotify_open()
-> fanotify_info_copy_name() triggers WARN_ON_ONCE(), and the event is
reported to userspace with an empty name.

vfat is not affected, as create goes through xlate_to_uni() which refuses
names longer than FAT_LFN_LEN.

Fix this by checking 'len > NAME_MAX' at the entry of msdos_format_name(),
the single entry point for all msdos name handling, aligning with the
NAME_MAX check that xfs/9p/ceph/simple_lookup() perform at lookup.

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Link: https://patch.msgid.link/20260629130943.3671939-1-wozizhi@huaweicloud.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fat/namei_msdos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index fba3a07d39478..ea6ff97d3aea6 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -29,6 +29,9 @@ static int msdos_format_name(const unsigned char *name, int len,
 	unsigned char c;
 	int space;
 
+	if (len > NAME_MAX)
+		return -ENAMETOOLONG;
+
 	if (name[0] == '.') {	/* dotfile because . and .. already done */
 		if (opts->dotsOK) {
 			/* Get rid of dot - test for it elsewhere */
-- 
2.53.0



