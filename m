Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052887;
	b=a9m3+V2fQ3gcgxhNyDwW/noRHLK6lDjntgtZNCe4aiOUs68tdB0M97sT/ChBeVsGp5z0
	 e2qgJcdtOyslmx2TLBZl7cHobMt0Oy3qeEGl1H2opL75PVc4+0UChzC5HnZouQQBt4l+B
	 7L9HuSB8BlPU/dHHGEc2GO+vTyKzbxIRhGYWPxx2/zXRD25w3gv5M7TUcSK5b8TJSKQlJ
	 YL0OF3zJucNw1z96AviX+FxYkH/rSyUtZL7Z4BCewiHYRfG8Wv1AGIbppc/yziHniel8e
	 euzOg8Bb6AelYiMK+WEq/lqzAEHgxHP7HNLq4f6dF6QD/Iq9M/Ye7A98RGeqZC3xUkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SNkqcPylSy+pGlwPXo+iTX5xEynaHfEpg2PJxqlsODc=;
	b=4UPVEfiojCHOmPRqyS8htSwSRSJTZVztgqRMaYAKt53oHGYg1hYisaqGQ1k0H27ZoOHn
	 WYe64dwwvWGNXB86j3r0e/msvXtpueOudaTUlGvF6+w/bB3hRVEAdgODCfLDDmxwb/r1f
	 h6kaofdyO7bfkQpfiqtzf9tKzJmczjKWRi3Q+ZWgQep8jOnoKpHmZpOGNSOL3SKzibRu9
	 Qnb8EtabrW7gWYSikT2Eyt9uLyMAkprQb9/cj5n+/NHgz/BfqKd1yHd0K9HryTSUoHTyF
	 PXKXPBgUaSsTL44S4NSpOKgxeZdka70ZPC+/H7P75PpRpEidQ7Vb73Bks7bP2AJ3fGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yi+3ag0h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC402606A320;
	Thu, 19 Nov 2026 01:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yi+3ag0h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0A51F000C4;
	Thu, 19 Nov 2026 01:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052887;
	bh=SNkqcPylSy+pGlwPXo+iTX5xEynaHfEpg2PJxqlsODc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yi+3ag0hqZeu6PGUeBMlHb/Oto0G/YypH1S7P+aDyjMVZzocYH+2ycluXSLmjNRu5
	 coVYTVndYUbpg8YKTHJ/sRFFa+m+Tzk9XeQUiQXGLoNnV6Bw0uZnAd2bAJdUStXyHK
	 hkRys1iDKJCw6N+8J7biDAxsEmrz9kDNz0mPMg4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0721/2214] ceph: validate encoded xattr name lengths
Date: Wed, 18 Nov 2026 15:39:57 +0100
Message-ID: <20261118150040.620675396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 058bcbc79aa65..6faef163b2df7 100644
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



