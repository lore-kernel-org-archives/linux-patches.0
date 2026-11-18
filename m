Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033887;
	b=Thvhld5ZLS1mTFTNdzo8YGTyXiz39RJHDK6urcd/M6lp4LPgFNgSnQKnu7CzkN4cQf3D
	 NFn8fw3Vos3SX+7iz1sdKuogzs2/7gHsm9bHRl3FWTTzg2DjUvOfbfmJ5qrD6JJs8pMID
	 wQPCLrbA4Zj66o5ns2wIvPSAZ4bSXa06qD/2V1vhuE9mWQ2O9nxuU9nsv+IP772d5MNkH
	 lNyZ9MT7/O+y9fxzpjUZu6DxDhyzJrrPM55ZUWGLWFZnP5Ach/O8tPRbi5+7Y0aa3FogO
	 A3xioNL3T5UNvy1+dwD3ap5YMhtjTExdtPnZtoCaoh4l1Gsni6mdPezd9coHhk1uGwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bXXAc6eOWzNWUuIFmz409hwwXcsLGzrWQ08cUdTtyEI=;
	b=I07oAQpWwbSo7kcXGXo+aOYYrhtwp8ARi0PWrbQhz9WM9UG9XdJLhVKsYUlrdMJWHrvL
	 W9QPuckwSaeNHUPP3iofRLoci0bKEj8+TCwILGDhoFJ6WwUrDaDxeoWR6beqnis9Wj6f5
	 wp/FBFuMC4VbARhwBWjaT2mw8KGE2jx1RW/dc597ry/+jEiZmRhdxib55dINDvooB283C
	 kgr6hC4Uk2/9F+tq03QeQPFNOANYqjVIK/Z0bFR9e66/b25ln15HvYQnKONWZDcvzFOWA
	 Z7//ZIpAb2+wsXeHqulDVD4szyugoMwyNRASwFm/L9HHus+jH9+gPZHZX5zIKNGPFJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xq6d4DLf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22801606A320;
	Wed, 18 Nov 2026 20:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xq6d4DLf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764B71F000C4;
	Wed, 18 Nov 2026 20:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033887;
	bh=bXXAc6eOWzNWUuIFmz409hwwXcsLGzrWQ08cUdTtyEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xq6d4DLfQUlbfWrJBaf2gllIsUk2LKH94jH5skhL1gQLF9ccInmjOFdikmiP11XJh
	 MiYdGRrT+HzpnJPH0xYeVlGTXHxwzY0m07xjzDRLEY0/GQRg8m3gzN60YEeoMFOaou
	 qbE0Y8YPULh6C6n2o/q6yp+bYZU0OoV5OlNFzktk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+905d785c4923bea2c1db@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0175/3318] ntfs3: fix info-leak in ntfs_rename()
Date: Wed, 18 Nov 2026 15:13:17 +0100
Message-ID: <20261118150319.935004099@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 2fa56613b25d0c983ef3ff6d3e865d4254280abe ]

Hard to say about copy_to_user_iter(), but at least the first splat
looks correct. At the end of fill_name_de(), data layout is:

struct NTFS_DE *e = buf;
...

    |<- data_size + sizeof(struct NTFS_DE) ->|<- XXX ->|
buf |-----------------------------------------------------------
    |<- ALIGN(data_size, 8) + sizeof(struct NTFS_DE) ->|   ;; e->size

If 'buf' was allocated with kmalloc(), XXX remains uninitialized and
passed as such to memcpy() called from hdr_insert_de().

So using kzalloc() for all buffers passed to fill_name_de() looks
the simplest and most safe solution. OTOH if someone would have
said that an overhead of PAGE_SIZE'd memset() is too large, more
fine-granted solution is to memset() XXX only.

Reported-by: syzbot+905d785c4923bea2c1db@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=905d785c4923bea2c1db
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/namei.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index dc41b80cfc584..d342814f4e7a0 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -22,7 +22,7 @@ int fill_name_de(struct ntfs_sb_info *sbi, void *buf, const struct qstr *name,
 {
 	int err;
 	struct NTFS_DE *e = buf;
-	u16 data_size;
+	u16 data_size, real_size, aligned_size;
 	struct ATTR_FILE_NAME *fname = (struct ATTR_FILE_NAME *)(e + 1);
 
 #ifndef CONFIG_NTFS3_64BIT_CLUSTER
@@ -53,7 +53,12 @@ int fill_name_de(struct ntfs_sb_info *sbi, void *buf, const struct qstr *name,
 	fname->type = FILE_NAME_POSIX;
 	data_size = fname_full_size(fname);
 
-	e->size = cpu_to_le16(ALIGN(data_size, 8) + sizeof(struct NTFS_DE));
+	real_size = data_size + sizeof(struct NTFS_DE);
+	aligned_size = ALIGN(data_size, 8) + sizeof(struct NTFS_DE);
+	if (aligned_size > real_size)
+		memset((char *)buf + real_size, 0, aligned_size - real_size);
+
+	e->size = cpu_to_le16(aligned_size);
 	e->key_size = cpu_to_le16(data_size);
 	e->flags = 0;
 	e->res = 0;
-- 
2.53.0



