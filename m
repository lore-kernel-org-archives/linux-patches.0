Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828940;
	b=VPgzbgn7qhRlvdDkIFhriBl3Te9T3geXAvq83Y2pjfUkgDJUATFLou8F6+d+4deyplu3
	 jKoJvlbJIPEHI6z2VwyF5Awb1p9s8c5bvBhQfEbToEqaC2S1MpvwlW762MOOyNIPCD1r5
	 xQCq0QJZ8qMOXNzgXZ12teDkVEjrjOIHV9QjQ/WScnkCyNWoppK9e1qIEfL9yHEICjA2k
	 919Dd6GrV+LxOUqga2TK3XJF7qWfeAiloy7ushsYexkQUhi56FrpmpMs1dnxcah552Xu3
	 c6E12oePsxDEx+b/KH0JW8iNyDg0715GsQDDkzegim/O+20ZOJ3sdPyF8pAQ6fKxt8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3CxN3YOkTbpGD6fbdwBfWb3CqPFMe3iEHjE091/cMBw=;
	b=zmD51M5+jDczgbrO9dMMsxI3IcrtAtD/U9A6O+QOJ5E6IOfMP6nGYjw+DLKoPIQOaIJe
	 RqjkuqI0rN/EN+pGlpKBIlEGu87GNuTI3wiOmKLJPy23OLIOc2OWoTl4juVchZ8DpUR8N
	 cEnMgHAiIW5aadbGEavHry/IcCckBwJEJeNo16SmjqaPiFtOKHbnRDyOjkOtKq0aWbYmW
	 XrN0PKWfqBPtV5A0TTKMhuEsWmrqsg9BLZ1UM4Qox88BlzZ9TxRf6eCeA4Z0NhIMtDF51
	 HHZ/sIsUzZ8+bNgIlHusEARIMmOW3pAxdL3FiCCFu7XurtXopV/F+3ARr5vY+rNl2aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vAbc33kE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555C0607E486;
	Wed,  4 Nov 2026 21:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vAbc33kE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4AB91F00919;
	Wed,  4 Nov 2026 21:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828940;
	bh=3CxN3YOkTbpGD6fbdwBfWb3CqPFMe3iEHjE091/cMBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vAbc33kEg3s/L/9h+qtzyNdvnN/3oiEF7yYyOTuKA65ZLm83z3/VYWQt33pF82amQ
	 06E7hSCaJ9N62T4mJB34ijNMiVz9goxIOF5ZZlg4VWiRTJErPsSJyPEwrnIZEjRjiE
	 /NyTJexmXUPTWJ5D0WpmIIooBQtfaiYepssB1o1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 339/547] xfs: reject remote xattr entries with an out-of-range value length
Date: Wed,  4 Nov 2026 16:08:43 -0500
Message-ID: <20261104211047.861662562@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
@@ -353,6 +353,8 @@ xfs_attr3_leaf_verify_entry(
 		if (!(ent->flags & XFS_ATTR_INCOMPLETE) &&
 		    rentry->valueblk == 0)
 			return __this_address;
+		if (be32_to_cpu(rentry->valuelen) > XFS_XATTR_SIZE_MAX)
+			return __this_address;
 	}
 
 	if (name_end > buf_end)


