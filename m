Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831646;
	b=3UZaFSiHqJL9BJVBsRYcKs17xwVS0SQSvdMmnV8lvbvtkA+x9kZFN4yNp8ChyAP9z4Fg
	 47vFBqpc7ZxrBqgultf929BV3C6LJp9+9gHxg9w+FUvpfM7I2qWKRJVKLhbcdAIdVnze0
	 3QVwq+hzKvanxEwYluFppYLGGPysxWg/O8W1Aq02CjsRfw/Tmt9CDhnNMi+lQ9ckEN38s
	 gM3LgHdTLWQ6af4q+YPSVNRuOuwVczu5y7I8P3oxed65sol9LPRWAj41yEfXpJCAx/iNc
	 yqHRsUyQc8cLO/+rt/uNMw6+GZo2QdxNP25kKGk12lN1gl/b/1DEzV2XKXeVfcysyxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xoqpp5M4RaWgmjW/b0l4XC3HBghH0dE9+M2d+9oGJZU=;
	b=uABsaHRIcZWia3NGwItFKLHi4IznYqcEsFgzk1GA2tA8xk9koIPYoIYUskYV+4N5dTb5
	 XmfAfveljfcNqYbKLtE7N512Il7GTOiLXvIX//+aOpR9yqUQeOlWtzz0gWW1bNzecAPf1
	 3vzXHvfUVlIcMZqPy8W5K2HbFTp/dPhN7t072WRIfZWv16t0L2DtKb+xppODe9SoaI0t7
	 N4YlMxWxhEzoClPlSs89z23/mw5mr8SPVcTpISdF9vIu1DsS6P0UXS6Mv7K5j68QM7qT9
	 4cB4waOVfFiWW+ost/1QTfQ8nN8ASWeTdijjzjxXwjUUPmIhRooIYQUZ0sYUcoYGoHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mr5r0v12;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243F7606B2E7;
	Wed,  4 Nov 2026 22:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mr5r0v12
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DE71F000C1;
	Wed,  4 Nov 2026 22:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831646;
	bh=Xoqpp5M4RaWgmjW/b0l4XC3HBghH0dE9+M2d+9oGJZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mr5r0v12ubWgbFyg2HcAu7GFWBMtRRsJOPC/FEo2LTYzdjjUv39L5e4SH3b8e5V3B
	 AoqW/6+6yr4ABld8opjfBRvorCJt+aId8zNhLRKIkJWrgNzqUEv5ADTdLsuYJFY9my
	 iHNYEVRC2PFsfQAU7e0qB9ETmdE6RSvCX35yBtdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0830/1005] xfs: reject remote xattr entries with an out-of-range value length
Date: Wed,  4 Nov 2026 16:09:23 -0500
Message-ID: <20261104211106.579376156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit 15ccd92a782a0253f4a17895f3d3f71e5c1d1973 upstream.

xfs_attr3_leaf_verify_entry() validates a remote attribute entry's name
but never bounds its on-disk value length (xfs_attr_leaf_name_remote.
valuelen, a __be32). A crafted leaf with valuelen = 0x80000000 passes
the verifier and the CRC.

That length is later assigned into the signed int args->rmtvaluelen
(xfs_attr3_leaf_getvalue), becoming negative, which slips past the signed
-ERANGE check in xfs_attr_copy_value(); a getxattr() with a small buffer
then memcpy()s a full remote block into the small kvalue buffer
(xfs_attr_rmtval_copyout) -- a heap out-of-bounds write with
attacker-controlled content, from an unprivileged getxattr(2) on a
mounted crafted image.

Reject remote entries whose value length exceeds XFS_XATTR_SIZE_MAX in
the leaf verifier, so the malicious block is rejected at read time.

Fixes: c84760659dcf ("xfs: check attribute leaf block structure")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -296,6 +296,8 @@ xfs_attr3_leaf_verify_entry(
 		if (!(ent->flags & XFS_ATTR_INCOMPLETE) &&
 		    rentry->valueblk == 0)
 			return __this_address;
+		if (be32_to_cpu(rentry->valuelen) > XFS_XATTR_SIZE_MAX)
+			return __this_address;
 	}
 
 	if (name_end > buf_end)


