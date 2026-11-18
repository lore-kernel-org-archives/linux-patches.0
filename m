Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057850;
	b=G+n443OFHwczZ8EGA5YERvayDZ18G47/rnIYxBQYQuiFgI6C3Ao4gB8uzjVMAxCAqeS/
	 KWXkzEL8cTZXAA7jtJ+abHQJZr5AarfoNM44DmOVHLkg9VeS6Drfp7IWDDLqogOFttrNf
	 ouyVmu5s8MVa9gZrx+DkIkZPT8sQcS9GiQYBChNP9+2kHDRZ2n8qOGwX6VrRM/CFzNcO1
	 f0bMYEzrlvnDbaXkeXVQGEKPFLMoqoMPGkQX+lP3FQXS8IqEZqpxGEvIihkxk0lsEUgEr
	 oiPCcaf0eh0NLmYmGt9tWaYN7E9MkbMB98kKmFBGI22HgpOqGArFgzKyauq2PIh/sdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bwrlWSxwx3ypAZpfire23NxjrAHRCM0eA8jVvINb8NI=;
	b=3WpVQA+AraT1LsfnRPQ/vn5/enyonHvvf1P3i+c+BXYwQW+Uw9KbB8vxTv7mkbRipIYA
	 DROdRE/j798FrAI4UnJzZhedV09IOBu6SKSvgINMEE+0oddztNEL/lo1tPHqi+6FIlDqh
	 gMg5mBaNaCW+3IRu/Wctl+KFdWAPc3UIiLxSjjeKdu/+5LccrW57u/ZYZ4bMu1Z9Vo8xd
	 jKU91ThDWDqyYk7mJ17wWU6FiBgXRrChhGFJThi3OEztP96cLGJH+j33ri/iZ4HqDEY4L
	 D+coaIVsjPn9DujvcXwfc9wyhshd88u8J7TmOo42fiAHtBhboJB+yWTP2IKoryQi6Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="b2/QHh2l";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9CD60A261D;
	Thu, 19 Nov 2026 03:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b2/QHh2l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A72B1F000D0;
	Thu, 19 Nov 2026 03:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057849;
	bh=bwrlWSxwx3ypAZpfire23NxjrAHRCM0eA8jVvINb8NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b2/QHh2l3RsjbJCrNmjuz9xspcBlgXT1ulGqhDlmON4tOL1A5v4Cj9Mv8Y60ZvDyI
	 xWwN4WSrlms/5t8FKE5FJdi35LArgdOg0Iwe04ZVpcKwDeQygTyc1mckC3Sb1OBHcY
	 PJ7XKUC7cIAyljK86mJOhvpcE/7Y5UHoFyAry+3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.10 0277/1848] xfs: reject remote xattr entries with an out-of-range value length
Date: Wed, 18 Nov 2026 15:38:35 +0100
Message-ID: <20261118145923.819395918@linuxfoundation.org>
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
@@ -293,6 +293,8 @@ xfs_attr3_leaf_verify_entry(
 		if (!(ent->flags & XFS_ATTR_INCOMPLETE) &&
 		    rentry->valueblk == 0)
 			return __this_address;
+		if (be32_to_cpu(rentry->valuelen) > XFS_XATTR_SIZE_MAX)
+			return __this_address;
 	}
 
 	if (name_end > buf_end)


