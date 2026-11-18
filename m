Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030339;
	b=xZeJjyVEJIi4Y4CMYwCVE7el5AdXhyScJgpISdQlHY/AjrXvKqdkWd00Ikb1lG1ALwPS
	 UdyGmDHcyUeTrNGtKaZ5IKNSSUNzra3qnuR18XxmuKFQueeiYpi1eDbo1DbBn1Zv+8/Hg
	 XC25VHCA73b5xb8PZ/O1+xc0Ld677IcLdy1XWL+b1K75QjJlmQgNFBoIKzd0B9l3aEIy2
	 5GIDIbtXVbyHVF0btT+f3RNZQ60r8xy58vVOzVQgHYN/NrC0F7ClBrWEjkL8qQPzh/ydW
	 H0nQETy4Q78RRVOFTuMrXup6gOvJYanzIpfOXs8VjkYwAJHydE3UU4UeJ1lQs2HfVjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fEiMCmrmqTndTNXJIvWPOxzlvG7W6AK1nULVqJyhetc=;
	b=1eDN18PMeHN5lRLjuzamLvGc0LpKeF4MulzM1/YdtGp4X4icX3ig1uz8dGkMX8ZMoklz
	 XG+4L/HkLerWfy+RLNHB4KXBC6b0EDg54N8QPd92j9XWVohgWdHA/tDtkGMdPu8ou/iDH
	 weKlgrW3Dl8ZMAlzQA4uGoL8j9+OJ30cqEpTq3+1dZaI/haTY8xE6e1k7wkJKBldeEUrX
	 FwIOULYn9eB1lhrSuKqLtxAQaSh73lpMKmPvZgKQc6jlQyehJeYhjo2Krbsn0EAntQ0cQ
	 uBttJujOKjvprZdxwC1jACLXvvhl795vnaieqZl9EryUlFtptodZflyZ/dw4JhbSu1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nycqdHyM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B42606A933;
	Wed, 18 Nov 2026 19:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nycqdHyM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FCD1F000C7;
	Wed, 18 Nov 2026 19:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030339;
	bh=fEiMCmrmqTndTNXJIvWPOxzlvG7W6AK1nULVqJyhetc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nycqdHyM0buwNTA5JnnQvvTJO54Hsi8NHZcBtqX9WWqRSY2Fnz4H7p5WQBC1jI2Sb
	 i4uiJBOttuFJoYbEuXE7ujHJUN6+mVfw7cGob5h9XwKEBNaiNw0Pohuf6r9d/yFSG4
	 CUd5KxvRRYFbPMfTn+/PthM5ar7StUDDqW5nQMkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0669/1756] fs/ntfs3: fix slab-out-of-bounds write in attr_insert_range()
Date: Wed, 18 Nov 2026 15:46:36 +0100
Message-ID: <20261118150035.902823291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index bfb192ec29950..f7b42cc15f6d7 100644
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



