Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063675;
	b=F9eHrPMKooo+hNETLN8g1WgdWvXm+OTXsweWtJTvYTUr+NRMuBPZZSkFgcSMJqkqzLg/
	 wjbS9cMkZGVQdrFw2ezJgPwX6S7BE/91uBMRmifdtTf7uUrZ4D7rnqTC5lkd/0TE+9GYw
	 g+QiONTk+DwIpfHCVknKBODKzgcEXZu7Y3nadTznQJet7GJRCzDo2wxW4o5mJGZ1q9+zA
	 FZrqi9D2UK3lF1zdDPqZx5EMmgiYCGynWTUav6hws2pUbrjVUrSP3SYJihGzGxfIIR96A
	 JDcfT1Zj4tNiXmUJwLaEYbRqVokbeoPgmbPimEiqsBPtEY4/6gjUExdWqiQS5W6gmaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u6FBRkkulHH0SS8Z2VHvkrqOTEkjaAHweJ9EXjynrx4=;
	b=oRGGMwAx871osoJSU7ZA86eDLNDId4GbAN6ZkJjQn9M3b5vFfDXaH/1m1aBTI5i/tEvJ
	 x8/CwdSzx1DZuOa03GmkWIF8HOpfeAjxPrlgeu0XkfL7tvkifdbYHcyJCMD6TCmq0vXpR
	 9TCKZq3FIp4MSiTK4l08oMvRGFy0vrktFNLR3NrGhsHwCbNWVgQfUM+QCE54r5DqWqRUg
	 jMPbC5bMg4InSO2nnN5qx2DyPdYTzHlr18pjcO9bfqhKe5rt3JmiNDev0mNQrq4PSCqdd
	 XlhsYNYznPVsTA4nxEwqOaSF78VT0ufgK6EK9XP/anrA0h6uyvLOLKuFr6fnu13eFVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jUdZ/AD1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D062606A9EF;
	Sat,  7 Nov 2026 15:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jUdZ/AD1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9981F0089F;
	Sat,  7 Nov 2026 15:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063675;
	bh=u6FBRkkulHH0SS8Z2VHvkrqOTEkjaAHweJ9EXjynrx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jUdZ/AD1Kgkc0rEhbato3a9HP8AgiBXAxwYuaJ05oAm+G5nNTBERzxzrTVNhNzHG3
	 YLJu7SbR4cpIBoudEY42bWNxhPanu9fube2PXqF6zsMEYtzWnkyqoM1qQV5GX8GZ7/
	 lZZ06HfVsAkzMnKLTUUN3qYPXOwivZc7pEXeIw+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 785/869] ceph: validate encoded xattr name lengths
Date: Sat,  7 Nov 2026 08:57:47 -0500
Message-ID: <20261107134919.338049074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index cc73b0874ce40..90a9e7de8fea0 100644
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



