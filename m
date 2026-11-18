Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021199;
	b=vBzLljCbpPUS7Wg+R/1gpBPNZgmS5+vI62f+C9+xZo/HQ0KUyrCGnBSFtqUQgseKIAd9
	 OAjrzK/1U4HPt1FmqNCJUYMuCF5AvFq6pNCWCR42bYp4KSe5PKhCORQvfyFYM+J1BA5A+
	 gXM5eJEg/+6UkX4xmuDgeMizvZzbBpG3NrzrDPYVKg6Chw/98x1l2ZbtKx5a/xBKK0jSh
	 U/GhLqO2B4A6LoYZ/2lL66E3uUJ6R4q84monDqRDDlZ3U1kYi0E+uy2LT4utBmUsvOP54
	 /sacjOBPu6s7tXXGEVZRdxX77jgUYp0FGnnmDtcbTguB5EEcAl+Kqb6WEiwfQW5SUUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sxu8TVrV8rp9ucGwoC1H7cDlmIIAhwoMKORjzukC+Ss=;
	b=wAoB0uxonB1QNC0xz2lAL84Wi8RW8uW4uk60koLP/5ecyMl+2pb4rBKP9kYL5sC8ay/Q
	 uVfhmt1kCl1EfW8CUxBBTzw6YaVHsxvtwQKECgP1nXUzPGi87MWnAO5cKqA5WS/iOj8nU
	 ACBbmuNVW1Y0Yqvo90SDXhOIAwn7Wn+hqQvY5GK0bUMBlfqh3Xu+ZZpmVCnZS2UAegMT1
	 B+1gY910GQdWCoyf0lJadpRzatwEo8UbxTvffREgZjU/L5+sit1a42cxQf0CWW8uVsSzb
	 NVF60mJoNuLQFUtzXirNz+EE1ctIsiIz7jjvO0dfSUE736xbF7v1xCYbfTsf6K2gmfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SjjGcWTE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8C0606A334;
	Wed, 18 Nov 2026 16:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SjjGcWTE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3101F000C4;
	Wed, 18 Nov 2026 16:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021199;
	bh=Sxu8TVrV8rp9ucGwoC1H7cDlmIIAhwoMKORjzukC+Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SjjGcWTE3BamxQv8QH7xD2l2BPlLUKW8PaJjt4kmK423yLd1869r/8v9GXHbzRl3h
	 vrQhYJ4uQy81ebqIiGBTOy2DXUKwnQnk+woghS+RoNLsSmhwzgN9JuT0QbUBz8HZSO
	 Vi6PRVtQYvuPTdu61S/siFrutOGwifLA1wbl4Sew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2221/2651] ntfs: sync attribute inode size after resize
Date: Wed, 18 Nov 2026 15:57:41 +0100
Message-ID: <20261118150405.541498412@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 3e38885ff66c797fc90cf90ab94c372bb4386e84 ]

Internal attribute truncation bypasses truncate_setsize(), so successful
resizes must update the attribute inode's i_size. Restrict the update to
attribute inodes to keep KEEP_SIZE fallocate from changing a file's i_size.

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 22afc03cbf6fc..ee54ebdeb7c71 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -5187,6 +5187,8 @@ int ntfs_attr_truncate_i_locked(struct ntfs_inode *ni, const s64 newsize,
 					ni, newsize, locked_ni, false);
 	} else
 		err = ntfs_resident_attr_resize(ni, newsize, 0, holes);
+	if (!err && NInoAttr(ni))
+		i_size_write(VFS_I(ni), newsize);
 	ntfs_debug("Return status %d\n", err);
 	return err;
 }
-- 
2.53.0



