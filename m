Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062597;
	b=CJigas4FuNrwl4KW7eUbaiF6BChsZvekYkmAIPB4GBbPtrQPNFL0KMFSTy6bb5H3T2/W
	 cSersFqRq/rgmFPuZuhvhmbt76mOTo9R7DfMGtXlXdpVrfiyv2kkzmDBNzf7XcVRgt8sc
	 ZKkbeDPWGirB9aUD9wZfK0OD8pvDtYfMnLX4RUN15laOKJcL+yb30BL/atsZIdI1RlqNo
	 fi88WJhZiEBcZ4evi8AMJC6JNJezS7Do7vXWONniw4dJDy63bh7EoUQXNKqupHhVwxFW4
	 sQjZJMEAIFqHPclrBwI6n9bOIeq64BrWQDAisdM945vjCJ50vNryCMkFTyjq1U2XOtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kRAGwKXzm29apSHO4vC5RSYddwhoAYUO+qbI40cizSo=;
	b=bD9pKxlzfQEF6GD4GBoECBbQAxz2wx40C3msCbSHl3bih+TxXc7TloSoHEDD2KEaVEz2
	 p/A/LJlpvTnfZ6azRisokVBHifNbjpNdDzFK06LYgcu0Kby9e3LpQXgleEFmSg2Y+IDkO
	 2Tv3u1QsOkp7Y5Di4uVb/h4GA8H8I6vX4MM/0HbeN340EWWrpjSEBYhau6FL9QzYX44BV
	 1a0NGVwkKaFpsrSiUgkQ8dvQJtm74SptciHSkN7oypTMo4y2w6VW6QmTpevAgdIm3F7QK
	 W8Xt3PKqUTLztyopLmf2u3n0NS4d8MghM3SOHhxAyj3NjqXeD2YEHrrIM5iHE82GT5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q3GuwPZW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B21606A330;
	Sat,  7 Nov 2026 14:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q3GuwPZW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD051F0089F;
	Sat,  7 Nov 2026 14:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062597;
	bh=kRAGwKXzm29apSHO4vC5RSYddwhoAYUO+qbI40cizSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q3GuwPZWdrzunRK4rVqFeJy8lGmxfvqW6IW+r9tRM+1Wx9MtIkxDuu/iIkz91aCUr
	 quZ2Itf4kal4lXhyS8gn45naLfo3LBe95Skdj9BlyLa+mOz6eiPtA/GbYu5+oEzj3H
	 uFDtrtpzWlnBkaNVIzSGhiOLjD3m+uR2LrKoEV2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1472/1536] ceph: validate encoded xattr name lengths
Date: Sat,  7 Nov 2026 08:58:08 -0500
Message-ID: <20261107135039.190178691@linuxfoundation.org>
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
index defea882812d3..a1e3aed5c277d 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -11,6 +11,7 @@
 #include <linux/security.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/slab.h>
+#include <linux/overflow.h>
 
 #define XATTR_CEPH_PREFIX "ceph."
 #define XATTR_CEPH_PREFIX_LEN (sizeof (XATTR_CEPH_PREFIX) - 1)
@@ -845,14 +846,23 @@ static int __build_xattrs(struct inode *inode)
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



