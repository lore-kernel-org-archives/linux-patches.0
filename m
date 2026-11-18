Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024758;
	b=0BFwOFUIqrEWj9CCaqdFPsxAlHBm8ZK43dD2CWL6XzCu098fF7XBcgrAnHHL0dzVTsmX
	 6H/dm3jHyIFC+1glYx+g924m+aTZMr8T5AYzn2VsfBQE2ALo1Iq1W+4Y6IEz7j2Z99phn
	 d78iYOELK6TW3gAh3f2lmxNs9CrqVtUZykNwVHOOP+gPUrpEa+bLDyIptBNxGqSqLndyT
	 J1lA/Gxx6g/aQv91zzieenodNeGrK45cbSHiDuQHtNKyt7lkbqwi7n/pqGVSCa1X56u6S
	 NAPa7nMUDRzoiIsb5A25sUDQl2pfCkClwGhbNIdrrDECUw/2T8hWAGCrYzS1w1Ywyvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FpJ9FU3DSrzqiwT/zRS0FcNn8ivgnYxJ0aW7ZhGunMg=;
	b=3OlkhJ9wrAWph7nymChCRl79L2c/UIea6y3I2PM/4kQ6mQ3MYry4a0Jsty2Iiiks7ngq
	 4ZUSXNLqNuo7hArbk1y7XPn4fgwjEKFNmtFTe2H31DSC/+zwlKh54vMaO+XEPRO4s7m5d
	 CPjzXXdqaO8zyCGg1YIW+X19sCE2R9wZV2ybfUc9lzNCHMD37a3pJ88ucPH8/A9iQ4TM3
	 m6n+gV3Vtl1hqb1Vy/D2gPAkpULDieJm4ydS0IBnJ/o2hlQ1u67kY+ZdF1dZmnWvngBsV
	 e0Hi6ivYNVEJN8DXpY8fdVAWRY9NfEuQAHwUVc5iigF0LvnoC4/tmp86xcIhwTnsWPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Gvk0/2aa";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE1E606A31C;
	Wed, 18 Nov 2026 17:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gvk0/2aa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EC51F000C4;
	Wed, 18 Nov 2026 17:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024758;
	bh=FpJ9FU3DSrzqiwT/zRS0FcNn8ivgnYxJ0aW7ZhGunMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gvk0/2aaHE19nqR/VfQHu4SVhEZnFkqoQiy/TMSmRKSqCO8xCSCUfcJQ8FmYUY3P8
	 kQU3isRwRdou1eqhGE9N+UaAVm+rUE6VeNUcvjsHsso47s9U3ljI15eH47C1tAEzqZ
	 7CEZj3AiZjGioijpqmCQG9+JmwJAROJxAA8RezQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0840/2151] fs/ntfs3: fix slab-out-of-bounds write in attr_insert_range()
Date: Wed, 18 Nov 2026 15:42:55 +0100
Message-ID: <20261118150152.847813252@linuxfoundation.org>
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

From: Xiang Mei (Microsoft) <xmei5@asu.edu>

[ Upstream commit bf9a6578e03b065335836e025356b4b9170b9449 ]

When fallocate(FALLOC_FL_INSERT_RANGE) grows a still-resident ntfs3
attribute, attr_insert_range() shifts the inline data using the insert
length 'bytes' as both the destination offset and the copy size:

  memmove(data + bytes, data, bytes);

Both are wrong: the shift must start at the insertion point 'vbo' and
move only the data past it (data_size - vbo). When bytes > data_size the
memmove runs off the end of the data_size + bytes buffer and overflows
the adjacent slab object.

Since vbo < data_size is already enforced above, the reworked offsets stay
within the data_size + bytes buffer and cannot under/overflow.

  BUG: KASAN: slab-out-of-bounds in attr_insert_range (fs/ntfs3/attrib.c:2581)
  Write of size 512 at addr ffff8880135e8b10 by task exploit/142
   ...
   __asan_memmove (mm/kasan/shadow.c:95)
   attr_insert_range (fs/ntfs3/attrib.c:2581)
   ntfs_fallocate (fs/ntfs3/file.c:618)
   vfs_fallocate (fs/open.c:338)
   __x64_sys_fallocate (fs/open.c:362)
   ...

Fixes: 9256ec35359f ("fs/ntfs3: Refactoring attr_insert_range to restore after errors")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 4e348c0f813e1..1feef22cc67e3 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -2438,8 +2438,8 @@ int attr_insert_range(struct ntfs_inode *ni, u64 vbo, u64 bytes)
 			char *data = Add2Ptr(attr_b,
 					     le16_to_cpu(attr_b->res.data_off));
 
-			memmove(data + bytes, data, bytes);
-			memset(data, 0, bytes);
+			memmove(data + vbo + bytes, data + vbo, data_size - vbo);
+			memset(data + vbo, 0, bytes);
 			goto done;
 		}
 
-- 
2.53.0



