Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065422;
	b=2SAWIbdp7t87U1lSONJuZ/UQdEgm8FLKpLPA7SYbmvmTAQOUmsE/SRX/AuKOwYaM4lDn
	 Kvs/DivNVjTdvxy2vX62nhMO6xeUhRojUGvoBftGfxBSjkpBTFrSt5pVehPmJCTHaexrJ
	 r0/yXrVqcTbXQBFqVrpof1PkYp3xLFRj4vKqKSwXZSC/s+ONgvOUuJ0bvAgmOABR6P98l
	 l6dQLBy4VgfRLNehwwPLEG7OCZh/zoJKa9wjDaygSrhxTXTui/AFwLAoRDAOPjRLQ1J7a
	 fpSo7LvkwMt8utJ4vgVyPrZEw7WQpfGnbYG1Cewkl2mJ1tOBxomDyhN1LHCiX2tLCSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iYUboRX4lpuJGp74VIWAPKgoQCDxCgKW6ivZPYWnkrE=;
	b=ELLADhHmuViWORBZ0zvsxZJyfh5G/fntZSlWHc37jvtD7BcP+RYzwvyRAP3SSn4A2GPk
	 /eDnzDm6+mPh2Iym0nKsO6P/tmqd9KIS34F0rUp4O/f7iXSG4Oba/MkO0KNasr1LTvqSt
	 irrQgaRbZSA+54NFv5gBgjSGjVTwTtmZIV8lj5xRb2v71iE3uJRFbl0HYDUTm78YxLj6I
	 /4Q1mpjtrKNjHj7g3aGiaYGH6xioUdaK56u8Wb9rSeDivYkhjscRSsrdiiFy0jeAAARdx
	 TZuz7mMrJQS63lnlV505YDyDmOsdHKqBz+Wv4cVCIf9kIooZKj8hQeIlyRqZZ7iXhig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ctG1/GYp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B810B606D80C;
	Sat,  7 Nov 2026 15:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ctG1/GYp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE511F0089F;
	Sat,  7 Nov 2026 15:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065421;
	bh=iYUboRX4lpuJGp74VIWAPKgoQCDxCgKW6ivZPYWnkrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ctG1/GYpOPP+AlSIoJmBJ3z/XzPfC9jszTGiERZxAFHxhx8vKyKIsw/bsf7PuRrgn
	 cj5iRSy1PNt/YYVk7mREqoCFujANSYMnmokhvvtQDWxDRXn/nr7hzZEpgCLZ0V7xDf
	 xY4Jehjl7DSdsaErSdVJuD+mumfSLLz4ytK5kOcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1135/1257] ceph: validate encoded xattr name lengths
Date: Sat,  7 Nov 2026 08:57:11 -0500
Message-ID: <20261107135010.573893441@linuxfoundation.org>
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

From: sung byeongchan <tjdqudcks0424@naver.com>

[ Upstream commit 166375898d29fea050a9abec855da6075050d5c9 ]

__build_xattrs() advances over an MDS-provided name length before checking
that the name remains in the encoded xattr blob.  On 32-bit clients,
UINT_MAX wraps the cursor and is stored as a negative internal name
length.  A later ordinary listxattr() converts it back to a UINT_MAX memcpy
size and corrupts kernel memory.

Check the name range before advancing and reject name, value, or aggregate
sizes that overflow the signed internal accounting.

The malformed blob corrupted kernel state in two baseline boots.  It was
rejected cleanly twice with this change, while normal and length-only
controls remained safe.

Cc: stable@vger.kernel.org
Fixes: 355da1eb7a1f ("ceph: inode operations")
Assisted-by: LLM
Signed-off-by: sung byeongchan <tjdqudcks0424@naver.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/xattr.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index cc4ffbbcb719a..ff70e4df9331c 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -11,6 +11,7 @@
 #include <linux/security.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/slab.h>
+#include <linux/overflow.h>
 
 #define XATTR_CEPH_PREFIX "ceph."
 #define XATTR_CEPH_PREFIX_LEN (sizeof (XATTR_CEPH_PREFIX) - 1)
@@ -843,14 +844,23 @@ static int __build_xattrs(struct inode *inode)
 		}
 		err = -EIO;
 		while (numattr--) {
+			int names_size, vals_size;
+
 			ceph_decode_32_safe(&p, end, len, bad);
 			namelen = len;
 			name = p;
+			ceph_decode_need(&p, end, namelen, bad);
 			p += len;
 			ceph_decode_32_safe(&p, end, len, bad);
 			ceph_decode_need(&p, end, len, bad);
 			val = p;
 			p += len;
+			if (namelen > INT_MAX || len > INT_MAX ||
+			    check_add_overflow(ci->i_xattrs.names_size,
+					       (int)namelen, &names_size) ||
+			    check_add_overflow(ci->i_xattrs.vals_size,
+					       (int)len, &vals_size))
+				goto bad;
 
 			err = __set_xattr(ci, name, namelen, val, len,
 					  0, 0, &xattrs[numattr]);
-- 
2.53.0



