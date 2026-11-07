Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064529;
	b=qqe/IZXoLx4vTtYFw01hscTUncXWXLMVEbyrr4ezc7fzxixnRtzWa/kpm5yqhc/Mw143
	 MQ3wnXyq3DFIJfWU/zddZjY/4R4448PJ3A0HsL3v7PdQwpTi+XfPT5JGcqcs/uaUQjefj
	 rM22hM8s9gwnVEQzWX0QDY3+uABYFih+ZnakUa1Uupx4Kyo1Ra8RO1FDdEH7WgHDN6pLT
	 o3D52Q14CoRZlRHal1H3ZPLijF/MmBPQLDUkeAikIm7DgBaSsC4X8IoLr0QSd4f5JpFDU
	 Qa4eGRh4lcY/D8tkrGe6fo5xSk1aTj05szKxcUPKAljR4/xabttRNZnHyM4uox5IXQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kFkOriMbDwIwurVnWMBw24aDfGaWEL4apmnpl2HM0Wg=;
	b=eOx8E9NnolmdqUrvmZqDKQ74IWlYS4WPpZ8vQ30M+qO/a1LSY/fj08Mm82gtsHgeeprr
	 m3YCI1sDrRRXz8+OyuhQ8mnr5I6UJTZJS66IsjFzXmy0NRSGLNLAT8i3WkA8J4Ru7xc25
	 HX3yuLZlHlDhCDkgdv3o+5JcGRk8Y5TS54CA/94DuOLChpyI1h17zQWz4nxq45+ngGHeS
	 6QD5T/WMMIjARbyZXT/KUd/QnhRUbbpG4NQBPjh3gviJJ1MHa1xthsLTGB+scJ5OYQCKZ
	 HhUXK2TjTq1VuQqhsOsEjLjoScTmRj5hh0OESS+JRyi7sViqGbj3ry5FV7lzRuSAK4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CuNeiEea;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A840606B89A;
	Sat,  7 Nov 2026 15:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CuNeiEea
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF341F0089F;
	Sat,  7 Nov 2026 15:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064529;
	bh=kFkOriMbDwIwurVnWMBw24aDfGaWEL4apmnpl2HM0Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CuNeiEeaZdUbyGxkaFvgfwuSHI9jrtfNoNBCUXJlsj/giqR3ZqVpMPW9B9Hs+Jjqg
	 UBgZHp15nlEJY72NNa6snTEf/ZAnqG1nICVa++ktVY2FBfeK18YuZgxhRsidTZnsgT
	 A+novQjQdjPzDxFdIMDszTjL82JZzJkdEHm9WmgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	guzebing <guzebing1612@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0559/1257] ext4: only update tune mount options when requested
Date: Sat,  7 Nov 2026 08:47:35 -0500
Message-ID: <20261107134954.814992343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: guzebing <guzebing1612@gmail.com>

[ Upstream commit 981eec6c300bd4e84ffac8f3c28b762d00f13e9c ]

EXT4_IOC_SET_TUNE_SB_PARAM uses set_flags to indicate which superblock
fields the caller wants to update. ext4_sb_setparams() checks set_flags
before updating the other supported fields, but always copied mount_opts
into the on-disk s_mount_opts field.

As a result, callers that do not set EXT4_TUNE_FL_MOUNT_OPTS can still
clear or alter the on-disk default mount options through their unused
mount_opts buffer. This can affect subsequent mounts by changing the
filesystem's stored default mount options.

Only copy mount_opts into s_mount_opts when EXT4_TUNE_FL_MOUNT_OPTS is set,
matching the set_flags semantics used by the other tuneable superblock
fields.

Cc: stable@kernel.org
Fixes: 04a91570ac67 ("ext4: implemet new ioctls to set and get superblock parameters")
Signed-off-by: guzebing <guzebing1612@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Link: https://patch.msgid.link/20260810151200.1405562-1-guzebing1612@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index c8387e6a2c6e9..1f6d7afb62ec7 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1362,7 +1362,8 @@ static void ext4_sb_setparams(struct ext4_sb_info *sbi,
 		es->s_encoding = cpu_to_le16(params->encoding);
 	if (params->set_flags & EXT4_TUNE_FL_ENCODING_FLAGS)
 		es->s_encoding_flags = cpu_to_le16(params->encoding_flags);
-	strscpy_pad(es->s_mount_opts, params->mount_opts);
+	if (params->set_flags & EXT4_TUNE_FL_MOUNT_OPTS)
+		strscpy_pad(es->s_mount_opts, params->mount_opts);
 	if (params->set_flags & EXT4_TUNE_FL_EDIT_FEATURES) {
 		es->s_feature_compat |=
 			cpu_to_le32(params->set_feature_compat_mask);
-- 
2.53.0



