Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044507;
	b=ZYBIU8c2P3KLty5rWzbpLMfpNT+ZVaEP/70w3SCA2FKpb11/+iY67V/nDE7c4Wyxk7r1
	 xE5skd+an2eHlqzcw58CNGhYi4qjohLleA18WwSIQmafqHBUGuEOEusrX0M+AsbEbypZZ
	 oUr8rigp0MmS/JEh4k4Gyf0L4HfXKoJ0F4fJtsMhi70lwPSXWKipDKf+tWHtvWDBL2Pzj
	 aNYbzGtAS35mm2tgWfxXFn1Mi13D2cq+U89BC62USPmKSRt9I+uk1tUMc+76IQAFEA1YY
	 9qJHg7Q3asLKRVvFCJLeYh9sncGuOiZn0ZoVR58kXI1ZFEGuMhaJul5Rw9l1YYJOlZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L0i0Anyk1bxMIIgK8Gk+1f8WRAibL7ig4IWKdFtz5Yw=;
	b=WfsdwNhY/vqiSGjzfqVpGx6U3VVN6R6ktOVrGcddnvH5++d8Hg8rFJ7Jn9swxX1eMyxb
	 /FAKxbhgeceL/ker0TT22VHjVRDq89/4GVhdU/bG/ZtqBFPGpMLMJ4kD07/F8wxnhPcjD
	 zub53CoUDxGeT5xvjQCUSp098PkIuzPfC5XnQL2+HQB0kws5U0AxMmt59F+0yCo2SgylR
	 n/uXgDOd3dxJbhGs2ECjGcKNZiTCNDvhsRKkd5dgH+8UM/93s8lNTwH0ixEenPk7BLjkR
	 im3ppsbnSMF4ssaBmsMJVCf3A9eHctCvxkSZRHAxNBFV8nFbZ9/BiPchNrmEPJ5gzWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TDCBUAez;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F6E606A320;
	Wed, 18 Nov 2026 23:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TDCBUAez
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCB41F000C4;
	Wed, 18 Nov 2026 23:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044507;
	bh=L0i0Anyk1bxMIIgK8Gk+1f8WRAibL7ig4IWKdFtz5Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TDCBUAezusWRbZVeNfSO64Jyq8+sbSvp20iAAflG70LhIdLl4KIyUU3bZzo81bb0b
	 EgqyYzsDQn7WixUpMTkVAN9MYi8ucyLm7n8Ky3Hq7iAl7oC1sq1Lnn9WstiEeIQg4E
	 dXII4GADyZxQjGdF+d7WSEWPPgjmk2b+YNWkYfng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 0592/2857] xfs: only written file data blocks can be shared
Date: Wed, 18 Nov 2026 15:27:06 +0100
Message-ID: <20261118150222.799948121@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 634b63baf05062988456a0bd5df2696c14ea2949 upstream.

LOLLM noticed that xchk_refcountbt_rmap_check (and its rt equivalent)
will count any rmap owner towards the shared count.  However, the only
blocks that can be shared between xfs files are written file data
blocks; and the only blocks that can have single-refcount entries are
COW staging extents.  Fix the checking code.

Cc: stable@vger.kernel.org # v4.16
Fixes: dbde19da963706 ("xfs: cross-reference the rmapbt data with the refcountbt")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/refcount.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -114,6 +114,18 @@ xchk_refcountbt_rmap_check(
 		return 0;
 	}
 
+	/*
+	 * The refcount btree should only have records for written file data
+	 * blocks or for COW staging blocks.
+	 */
+	if ((XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
+	     rec->rm_owner != XFS_RMAP_OWN_COW) ||
+	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+			      XFS_RMAP_UNWRITTEN))) {
+		xchk_btree_xref_set_corrupt(refchk->sc, cur, 0);
+		return 0;
+	}
+
 	if (rec->rm_startblock <= refchk->bno && rm_last >= rc_last) {
 		/*
 		 * The rmap overlaps the refcount record, so we can confirm


