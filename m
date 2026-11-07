Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060639;
	b=ntp2iTE9zIDgaBWnpOW2SeG0HBf+vYVgfPa7zsUriag/LRpUnJ4Nql1CKeomkcGk4Oz3
	 Nasnvxuus8VbZoroJaIkY7d4sTQEGGsnmQFuiBGaUPbfcyHGTPXGsrIuQG3oDIoN0oJIq
	 6MlEKRsQamIUhIFhIJui+Hoa5YS8z3Ase7lysaEFoelilBiEj72EIr1u4k8y5eiXxglUp
	 0wQ4oc7SotKdU0UiFA3atbp7dTPghNkjx1Ap1znfQ1nAAsFzuoBu5XvDBpftA8vyxqd1r
	 Jr3EHWUOnpIT5kyAmFlAx0Q44gjAcKhle78/dGYBW6M+21AYqSFXU60XfO1oD9rtehw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cgLNDiM1VcofbiHa8ppeZxta/meUL9M2PPePItYVEHs=;
	b=hkoKC7h9BvRsgJwH0PLwDxz2CIN4zWi35vIvZZdP36N6YKzwUMAKpnYGHxB9f7bJSXn+
	 dNvU/tPqzGu+oKXvoeMSpOygb14hdrLMZJbFND0eAJ+j0wGk8atYeR4in2VaiF0iG+11k
	 07hRP+5zk088248YQYf1G2ma6c+OqgEpQXNwjc5dzjyXvOo7wLh2U5I2Y++58Ic6bTt/U
	 qBLCvqSHxzDgchZjKfUQeS3nNX1OU/VaFXYh+P8a6bd5Bw1PZGwoSmWs8XYgI83SU5IZS
	 Iwnw43JnqjASPviqWh5xF7gup2XWg7Mjs73n86My8Gv6vUQ8a/5D3e5jIGRBaB3LsyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f4Aj7MUK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EF3606A32C;
	Sat,  7 Nov 2026 14:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f4Aj7MUK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2891F0089F;
	Sat,  7 Nov 2026 14:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060639;
	bh=cgLNDiM1VcofbiHa8ppeZxta/meUL9M2PPePItYVEHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4Aj7MUKQQjSJYQgpZyalntdJSNuvqDc3wmnsDMqdSn+ub0HC+37C5BKAZflGPe8d
	 qKKj+bVWKiICXhVAhFar5Z+e2zr9mHbBuICamwXX02+THyXUhPYfoV4F71QznMPbTF
	 1f+7iTK2Lp9UrDk2aUTUKKP7tSJj5k+KajSVqiog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0043/1536] fat: reject name longer than NAME_MAX in msdos_format_name()
Date: Sat,  7 Nov 2026 08:34:19 -0500
Message-ID: <20261107134958.869164029@linuxfoundation.org>
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
index c75e3791514a2..78d044b51f46a 100644
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



