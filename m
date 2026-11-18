Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036980;
	b=rjht834qOw+bN8J3Iu28lcPnlK+glRUjU4XNpc9m7AdFgHOaXN7Fm9bgOSwvdgH4nuDH
	 B1rLgl27AHRajOpqBR/R2Eon3eaNbyWEczqXcFP6wbcsvCDsz9hNRTeW+pmwYjsFK1eTn
	 SN7pTwAw+O/elPCMzY0lhwV4JIBXWV7rq7D6p6hlswdNVC+C+Ygcu9trkr3/12hGYn7sP
	 lkvG1aPadyb175zq2lkvY49r3lGaoCeQVvzJLCc9ZuNWuFz88X5QBC1S+K1NeTDhPZm+i
	 IOeFUZf0GBRa/5JjfZRNdQa2j2ojD0U84P85LanTpkAC/cgdYrqwmdhfO5ts1oiNsNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ycKkH0bIgG64JFEGTfkBr8P/quLuEzwmmepbfYoE7LY=;
	b=NylMc4ONYsihkGGM4AxZFczrvGljz3ueMd8dtixEuE1l2aHhXAS36XrYa4d5b+NmOhMD
	 7H9qUceLDp9JhRGcIfqUv0Fb4JCPLQ2SXNfetFop3EklpCHsksgTCQJjIqxM5DItkM8ZV
	 CheC8vMvTDrAm5Rf6auBeUbsQRBIoa6qFhggxhYT1cw5IgeEpUCSAnkInZwSigOoO9Fyt
	 N5MnOfIMyvRgtKHjPSIuQKrQ+1YtJggAf5gPvyrJb/QyC3besrphAla/TUybjJXxcJUK4
	 FO4S4GfV6EQ7yiK0/q/7jQ9TMny1a4mepF+B8weOiAY3H5o3m6Be4jaxGHVDczHQ8tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4vN5yDo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BAB606A32C;
	Wed, 18 Nov 2026 21:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4vN5yDo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD701F000C5;
	Wed, 18 Nov 2026 21:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036979;
	bh=ycKkH0bIgG64JFEGTfkBr8P/quLuEzwmmepbfYoE7LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4vN5yDoiYVtFNgoJNoaMcoDPcTCAkWz+bTZ4nWRKKeTra8Ocy5h3KzrmbbWvIEHh
	 NjSQhrlB6lG7XCXDX3H8UDWAoUA6OC6HzDAUXexCLdThL5VC5OGTcWKFEr9mqkSw8O
	 SVikQX3nZdiBsqDYrJJBT5CZZF5E7769dFM/456E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1244/3318] ceph: validate encoded xattr name lengths
Date: Wed, 18 Nov 2026 15:31:06 +0100
Message-ID: <20261118150357.510753013@linuxfoundation.org>
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
index 17da8be8423fe..bdffadfa62387 100644
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



