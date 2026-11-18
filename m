Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045823;
	b=1xfACaW8aOk10EKQCbjv7fg/nC5V3H/SPcIy08lmvvDRGPxVT3Ilqz5wwVyUKkzXimQ2
	 xYyh2KU35rQUaMz0cJ/McHM/McwqeEy4vNh2uta9YDE/3FOQcMSyFRN0ES4XsY7kKbQ3N
	 MNqbn5OWWy5DbZaQfew4tl23p5Bvi+lyCKnOt5FwaQAQ0EXGt22qQBOXzAJ/Zhb6Rjw1Z
	 +hFiw0QcnkAyRY3IxbwwtmQBKUKRTAiEWKrxNRrLdzMDdlL4B8zuf29kR5Ig0EjMdbJ05
	 oQ9Xq1pSmZ1shjzXe2FPppsp/RZvMWalCA/VGjuIzv9qVUUr2Kuu2nCd3SZBuiDzYbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=raUjtr00sxTqeRAjBYxYbavqKnQZhoWbF+UO43ar5kk=;
	b=WMvc5yp3z4TNaToGZEtWyMX0ZSrxBMMVYGVvFi6+d3Aul+/4KqP8KsrKCrrFXP/D5Yp3
	 QP+z3zOEk6MacIoiC4G2aRGy3/fOxW826UYKtTZk1ylU5ZxC5sN2av40s0Dzt2k6LbWU3
	 91O3Y7o8CGnMkG40adB8k/jfCrwSH3FHJ2IXoJN5wCBJSfs5farbRAXqtsY2jmO4bUOB4
	 MQzu7MgBqTw1pleCOj4TIHFa7v9LtzslsWf6UkHjWdzRp4mdneLab8Tw2No36eAddFS0n
	 T23MvbliQVfd4926Gu/u4j0gP41e1TRnSGbgBRQGVUR/BjNWIcOh+vCa4hkEO5VXJ4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gTlNyFa2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AA0606A31C;
	Wed, 18 Nov 2026 23:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gTlNyFa2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8BB1F000C4;
	Wed, 18 Nov 2026 23:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045823;
	bh=raUjtr00sxTqeRAjBYxYbavqKnQZhoWbF+UO43ar5kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gTlNyFa2cQZCFafWZbdGyiSCImOApQUCSssbavFQb2YPkPLy6P5MH8NhA1M9yR5sq
	 2vIt2W/mXOOskN1ascF06OYO/BhQCjnOHDfuArEUPW8vR15utXKI1c4BqDJuyEk/k4
	 +tAY3OQkACyBdOaGKd7k1qNjXzSK5V7HtlRL6trw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1060/2857] ceph: validate encoded xattr name lengths
Date: Wed, 18 Nov 2026 15:34:54 +0100
Message-ID: <20261118150239.758791736@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9c5445eb671e8..cd4bcae1ab51f 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -11,6 +11,7 @@
 #include <linux/security.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/slab.h>
+#include <linux/overflow.h>
 
 #define XATTR_CEPH_PREFIX "ceph."
 #define XATTR_CEPH_PREFIX_LEN (sizeof (XATTR_CEPH_PREFIX) - 1)
@@ -806,14 +807,23 @@ static int __build_xattrs(struct inode *inode)
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



