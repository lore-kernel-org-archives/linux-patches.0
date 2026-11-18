Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058714;
	b=i4GN8GSWoWjMTEiVTqgXc+G4ALqQKU8wY20G5a1JdgKXQpGQ6sqtki5iJbD9ggS3Zy+m
	 TS99IOjJ16YKkqvEmaQULqYp7NS/AEIWMSgwXG0NRbddthuhiS2cCbClv5PmulNj3t/B5
	 nQDhetpRkPYzQQP17ISL1Mt6/qAV7Hg0JXR5DFEbWB6MGRLXjH9SDu/XNaLiZzO40kVvN
	 iJQcTin2EJ2ZONIrFsh/P6IFQO1P3BCM+1VXkoCzCDw2sXggqr5O872aJTSUANWcdEkCw
	 5eEBd8uHyeOSw240qfh7WWcKARG6fAP6yY7v8prjmB/YhAHV4fhNw05dXlq+0n2UeJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lW/4PyUi4zsDC/GSIwJh3EREUlQMuzGmWOjyO/JBr78=;
	b=pSF0nI0FuaL+eyhv8XDcyyaU1MnvwHKefCzxj+jvW8+dM2fukOvgp8bFaFxeYfQRGag/
	 oYxMBm+O0p5TSINm74fPPUYmzl+0b/SXSkCB5b0FGteeTmsuCO+7o6IVN59bHiUVsZOLV
	 EWMj9SUYPfL4kTUXW/jACHg1HEnz6qcyWK+891bfjCzcAhLBvwx3nZBkM3a9fv7dwT6tR
	 1J4oLwKwwBkr4VgyuVgT/A1vfcGpTLrU3jDQ4/m+FlTC3ssP/YHJ1QsykWXAJ4wUA0PHh
	 0nj6TCYbcsyMnMPLKbdd4LRAWd2CFjwYAh0rh4e/WqLUDKo+z+o6/G3DRAt8ZL1HumQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUEdaWof;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F13A606A320;
	Thu, 19 Nov 2026 03:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUEdaWof
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70E11F000C4;
	Thu, 19 Nov 2026 03:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058714;
	bh=lW/4PyUi4zsDC/GSIwJh3EREUlQMuzGmWOjyO/JBr78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUEdaWofzoiDrYIkTo+nvIs/FL9g0FvBy+nzfbXYOR9D1j2GzjAsquOehGR2Bvd+u
	 TvqU3N419nutTRxUwp3q2QJWudKFuHiWOmo5ONkew9W2bqhtQqjQzcEozJB7l/zv05
	 Ujbisql71vJAwHAmeD43t6DQO/u/wnQgc8LqE/mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0585/1848] ceph: validate encoded xattr name lengths
Date: Wed, 18 Nov 2026 15:43:43 +0100
Message-ID: <20261118145939.901948840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8bb9d670af101..4045fd0bd6dd0 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -11,6 +11,7 @@
 #include <linux/security.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/slab.h>
+#include <linux/overflow.h>
 
 #define XATTR_CEPH_PREFIX "ceph."
 #define XATTR_CEPH_PREFIX_LEN (sizeof (XATTR_CEPH_PREFIX) - 1)
@@ -710,14 +711,23 @@ static int __build_xattrs(struct inode *inode)
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



