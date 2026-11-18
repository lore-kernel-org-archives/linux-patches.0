Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033496;
	b=DR+KSLz2/B/MNnqRUQClsz9Bvy/dEeILyHPH5QjLgUUCisCEL7T59COIfo5BTfs8QfSA
	 0OFKgESkuTnuZqV+iz3cY4yE+Tr+Kxc2WV7N8mRJXp1Li+iX5ROSSvsV5aLE7jxsRWfC3
	 wzStGuebfwMGeiXuhPd08fZAGDHp79c0eE15zTX9s7hlECYpVTRo50h7fTu42Ye1dJeLg
	 E3XjBMzWGctlREGDZbQC0XEmgLgYMnLffoURd6y9989Hpo5+1YLt7TwOie7VdbxKKnK+E
	 Y6xW1usYmefLcU5Tnb6E5GcxXrD+dB18tSe2hZu7f4rZb5KF/pEhXznQsdb+5FfoNZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VkOwHe7ON5ZJY7lto2BrEAekQDfThWo5orrrn42cY1k=;
	b=mTvn8fT/Ro67JucWjwgpcazI4mVOYa2KTvDv4MzTDJwO8Q5wkshmpwCx+eVemuut+kX6
	 ecPoMj9NSkzRQaVDut8DookTs1xwv1LAVeZFZU2W75/KjYKWu8un5feQI/vD6ncbAxK3D
	 PMK+mRn3p5icBu+vTrl+TSyZb+hVLbLisRYRGoKPfqePK1qLTak54i7zxTD6cMmR4Ega9
	 q+kvcaiJTip3H7pPFM1N79CpwMniZcLPBPGzT+mxgZpVDoyCX6UjcMsgUlgprCncksDmH
	 pmEVvdikKjkT7KaHPUWzgp3LchXQBs+0gS7SjBVdX11R9PJjL9V3trmV0W19iLcKuag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="e+/gHnYG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C46B606A320;
	Wed, 18 Nov 2026 20:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e+/gHnYG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA9C1F000C4;
	Wed, 18 Nov 2026 20:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033496;
	bh=VkOwHe7ON5ZJY7lto2BrEAekQDfThWo5orrrn42cY1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e+/gHnYGMl1+xDkzmxVuQpvbdSvn38MBZN6pPNhtq+zbDLxCj+0jsaIW7Od7qNtV2
	 JK0ALYKH24E9K3Ja6x7udY2P5mgdwmOvP2wEoxusG/p0ywRNV2pCMFTsYYiqDsQnqu
	 C2B549PFW+3oym3srNJ+GBkQZYqiwdsPNT2C9cP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0036/3318] fat: reject name longer than NAME_MAX in msdos_format_name()
Date: Wed, 18 Nov 2026 15:10:58 +0100
Message-ID: <20261118150314.916726546@linuxfoundation.org>
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
index e189fbf95fcac..25e1ace9d0c68 100644
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



