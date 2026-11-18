Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023957;
	b=IpoT2SHLLkHyVb4+yplsXKfLt6LM2gsVpyIsAJKrz/KBe9HXMXAkZeOkHfLWqNDi8uL2
	 a4HoT/CRhPqLrcihG+M+m6mTGrX/qsVP1OkL1mZicR7It9XyaMXTpemjbcaRRAWy8nlG2
	 MzfBixruu0EMZ3scWgLwrUdfQvVEUA5MqWdrRztWX7Fttmg89+Pf15Xwmb5tPkTVf3vKZ
	 m4NURAF+8Rs8Zaco5rvX3srkKDrSCGJxrFn0vxTRa96p6sNES5QUvTboIErmKHRatZnef
	 /GsQdcEVYF46u6IwZl49+VnlEofa6jgCWxff3ytIl7a9no0OLgukEQM8eZli1EotYhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SQTd13rPBRtWf7nYQUWKOlNMFcGxckFLoeT3yGGkM9w=;
	b=CEX7ntsJ8bepUR/oqiHzgyv5fIr/XPxjkGJfDDDOh/Uxn884sG5FPw0sCuBdi+1/uVSh
	 qm47Y4ocpem0q2w/JqGEbVgDA+IWZm8mDPYxUX3Z+bEhc70lSdlAcFk7jpb8GbdJY26NG
	 XWQwIDEAjjA+YtmjzylGdj2mUD/50Mo9x9uHkOooaXXQSsFtmKw1rK6JWPDLMbP47KeBh
	 uzOvXdnlo8HpYAyFRrvzigfHZDp7Azy/PCOJJDFr60PSbSJteCjXRGEpElQgUdJdzdBR6
	 Xo+VReOyScXZQ5KYp86wF8p9LkgMgNDRH5YAHBahfgg+siAetDzU11tWKbpTr9ppMMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hP6VIdvu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B209C606A31C;
	Wed, 18 Nov 2026 17:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hP6VIdvu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148731F000C4;
	Wed, 18 Nov 2026 17:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023957;
	bh=SQTd13rPBRtWf7nYQUWKOlNMFcGxckFLoeT3yGGkM9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hP6VIdvuy3sZEmHtpHUd2My0j4s0xWzxQBqxfeKFQr831KtoWhG8E64bTPCzfdT99
	 n0FdsUkOua/VRrbKCRuy0tYD3qd3BPOFKCt6wN8x58oWdBRih+DTjYJjQIZNgBYKVS
	 w0+eJ60jWr4q8dPEJVz+Mbt/twF0QdvdGP8ZzGlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0553/2151] fs/ntfs3: validate $SDH entry size in ntfs_insert_security
Date: Wed, 18 Nov 2026 15:38:08 +0100
Message-ID: <20261118150142.106931319@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 5b76487f94dacc2884135ce9a7bda61ce7ffa209 ]

ntfs_insert_security() walks the $Secure::$SDH index and reads
e->sec_hdr.size for every entry returned by indx_find()/indx_find_sort().
Those only guarantee the NTFS_DE envelope (e->size), so a crafted $SDH
entry shorter than a full NTFS_DE_SDH at the tail of an index buffer makes
the read of e->sec_hdr.size run past the allocation. Triggerable by an
unprivileged setxattr(2) on a crafted NTFS image.

  BUG: KASAN: slab-out-of-bounds in ntfs_insert_security (fs/ntfs3/fsntfs.c:2148)
  Read of size 4 at addr ffff88800fa1de00 by task exploit/142
   ntfs_insert_security (fs/ntfs3/fsntfs.c:2148)
   ntfs_setxattr (fs/ntfs3/xattr.c:947)
   __vfs_setxattr (fs/xattr.c:223)
   __vfs_setxattr_noperm (fs/xattr.c:257)
   vfs_setxattr (fs/xattr.c:344)
   filename_setxattr (fs/xattr.c:690)
   path_setxattrat (fs/xattr.c:734)
   __x64_sys_setxattr (fs/xattr.c:764)
   [...]
  The buggy address is located 0 bytes to the right of
   allocated 512-byte region [ffff88800fa1dc00, ffff88800fa1de00)

Stop the scan when an entry is too small to hold a SECURITY_HDR.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fsntfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 5e3506815c279..5bb66ad2513ad 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -2136,6 +2136,9 @@ int ntfs_insert_security(struct ntfs_sb_info *sbi,
 		goto out;
 
 	while (e) {
+		if (le16_to_cpu(e->de.size) < SIZEOF_SDH_DIRENTRY)
+			break;
+
 		if (le32_to_cpu(e->sec_hdr.size) == new_sec_size) {
 			err = ntfs_read_run_nb(sbi, &ni->file.run,
 					       le64_to_cpu(e->sec_hdr.off),
-- 
2.53.0



