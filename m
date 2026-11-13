Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585519;
	b=0JTdutd8jHTocZw1LJJ4x7ENXTTxwc/la/hkrmAzhZphEaumt4JKDIn2YgwXhjTGDuqv
	 zrvwN6aFFFyLcT1D099HUvS1T9qt5YyMx7/Ltq52AZC2BBPFOH1GYO4OVf9GHUu+MKl8G
	 bj7AzDFQ7gTYCMYTSMDdV25IGmtCjApiFg2C5MFVnlX4Btl5UAvnbofAnuh+XNTjKXbTT
	 wvDhDn1uJOpkLx7Hr3ecXNs1U4VVAHhUyw2jx5d9DmzKlop0YVaGM5SNh7oxlSSM3beUA
	 97xVjLJzZtTeXHboMudJ2Z194Y1VZxbHP83DMDa2Jt/AetiuPhtX/BuMrW4Gv+8e7vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LCEpHRqKhNiNBwxdc0erX5rDPhcRj7xmMC77u4vW88E=;
	b=VQv67DrtEhFM0yXEPNYI3OEEhHKLQKiTpvLPQ0rK1xVEnQtWfXBol+1xNDvlc97jIPSj
	 F8A+Y5TJWohCp5szLkZwlDUjXwbd8uF1wpTF8ij0Y7V14LZYuoZWvmdMEvtd0Cy7vdtuR
	 0GR+2dW8EqPnNQe/TPG1p/8yS6Khip/7xoa4+q0ztpc4IZs+JdZtRLa7HNvhJQ/rOJ9ar
	 zbFHdHY/ivof0NsHVzCxFboUjmHMs+PlQi9kp3eBAklhNayXoT41Tkpi1TdhZNndlVy/O
	 xGj0873LzwhCDW/7YL4BMF+VafmTFRd975UBiOkhsxV13iR7VFWCl046hW5wW3MpmPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x0JFSdQm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2254606AE3F;
	Fri, 13 Nov 2026 15:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x0JFSdQm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7851F000C5;
	Fri, 13 Nov 2026 15:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585519;
	bh=LCEpHRqKhNiNBwxdc0erX5rDPhcRj7xmMC77u4vW88E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x0JFSdQmVzUDE0Mz3Cl1RipjhzB+xWfqvArELmBnKGgvDRpHFwOjFYj/5kMFZj97K
	 qwxhswATf/83UQMOBzAESl4iMTMJoRb8YvaoS9B3d55HPcg79Npt9FEc/8sM0+sRcM
	 4eQHVQTN7FsgDvpYJ42CLfjMzytD1XpO3fxR3yx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 163/507] ntfs: dont allow compression on volumes with clusters larger than 4K
Date: Fri, 13 Nov 2026 10:47:47 -0500
Message-ID: <20261113153800.020587542@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

[ Upstream commit c77ab4eeeb3ed471bcc99a94673f0e0142c4b84a ]

On a volume made with "mkntfs -c 8192", a user can set
FILE_ATTR_COMPRESSED on an empty file through system.ntfs_attrib.
Writing to the file and reading it back after dropping the page cache
then crashes:

  BUG: KASAN: slab-out-of-bounds in ntfs_read_compressed_block+0xa2c/0x2040
  Read of size 8192 at addr ffff88804355a000 by task dd/106

The read path only handles clusters up to 4K. It copies each cluster
out of a single page, and a compression block of 16 8K clusters does
not fit in the 64K ntfs_compression_buffer. Loading an inode already
rejects compressed data on such volumes.

Reject the flag change the same way.

Fixes: fc053f05ca28 ("ntfs: add reparse and ea operations")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/ea.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
index 6ac551fe8ea64..9e00588ff9b5c 100644
--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -699,6 +699,11 @@ static int ntfs_new_attr_flags(struct ntfs_inode *ni, __le32 fattr)
 		goto err_out;
 	}
 
+	if ((new_aflags & ATTR_IS_COMPRESSED) && ni->vol->cluster_size > 4096) {
+		err = -EOPNOTSUPP;
+		goto err_out;
+	}
+
 	if (!a->non_resident) {
 		if (!(new_aflags & (ATTR_IS_SPARSE | ATTR_IS_COMPRESSED))) {
 			err = 0;
-- 
2.53.0



