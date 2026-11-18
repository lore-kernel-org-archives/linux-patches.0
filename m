Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057173;
	b=WXuTiUPpCB0/JnEuKsnG+Us15pFpmJJLGE4RIAF9gKwM2O3GtLwPjYgK/gwVnpiu/GcM
	 DISpYZvoCLICogN696RRjZVUVqSHL/chrIkFctlwpXRhQ66+Syo9AlbvTRYU96DQyW6Gc
	 DbxOugiNiEYSj1y/sv55qiapJhfVfm6Ec2Qz+6S90p62XOl4oHQAzkYKjSKd1BoiMdmlo
	 Z+dQLB/BkhG9/BMG0h8SMaHjdV/ALyqaCUSuTrvgXXZ6OQGuuAtwZHnOq/0/I4hRAciUH
	 IZktlQUb2hw7GOSR0XaY8HqNSxCzhLn4xE0QzL7pztRIM1A1XA9ZvLBzzyzNOIn+iWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YfiYv0Xv166F3b8QAGLXFM2Xg1uFOTTSvqywLQWaXEo=;
	b=IS/GtGkwkATfTlwZa5XUx/G5cgYMyJRIIzG7HC2nMaKHLOL5TqrK9XOQ8jFdh0pdpGbJ
	 1JqPkqjl0S+upyFEU5cwEW/QJYEBwtBMFZbdy1bHrTUBNEebZqcyFByQfym+U6SsNgGnW
	 r/4mejD//CTy1ouExT1D2h2bzBA/4AI5U6Cz2bc/MYdBCe0mX23oZw21xaZ02745bvJa9
	 n+2gztrQddQ5KF8L5PYr/JCUR1rti43eBusFbcQfy24DP53Mg++dAzv18lgMgXdmqBLRS
	 jPkiHrKbYvWQRRk4nniX7SEJwZVzwN+uAhZnfgxIsHT9lmkVATOPcOR+2aW1J5W6pWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HAuh56mP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE248606A31C;
	Thu, 19 Nov 2026 02:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HAuh56mP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F56A1F000C5;
	Thu, 19 Nov 2026 02:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057173;
	bh=YfiYv0Xv166F3b8QAGLXFM2Xg1uFOTTSvqywLQWaXEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HAuh56mPaAoY6mAl6BqM5aXHjJuqWy1MFuAKrJmU7mmHdeq0JFsHRWYCzRvXkJES8
	 q6nwfLE3E40834aEoho93f6ZSPSKcBV5LlLdI4JQ9aQkZq7YI1f3hdfwabtFR0dfKr
	 gmoVD0PQe3WnBay1w3rFVQ+bPR7JF7BILsO1cBHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0036/1848] fat: reject name longer than NAME_MAX in msdos_format_name()
Date: Wed, 18 Nov 2026 15:34:34 +0100
Message-ID: <20261118145912.647090190@linuxfoundation.org>
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
index 63a323be9179d..966386b01da15 100644
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



