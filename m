Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4201F76A9;
	Tue, 17 Dec 2024 17:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456481; cv=none; b=CwU0Ijcz2O8pGVDuOqHi3Ji0y6GOkpy7Z/QnkHFrBMOcoyZ1GrqMgqKD0/0pCtyMQ7V9F1Daz4ff6U+I1+uyWWq+v1xcBrCSFmp5wZ4OTN09OSqom759hC/VCXiVBZ5hABBO50wNDPj6I4gr1RCXGpG9X5P9oCfpQJVzKwhxdi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456481; c=relaxed/simple;
	bh=gBtHpZBqNwiJIfHknBkzaFLu1Qm7UTKRssRJiIDoGyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UoUyksY+0Q63z7rkDjZ2stgkSlEv2LuNhYpXmqPUwTV1U7WnFVbtlYmbtrZQRaEVc4tsW+63jo4Q57JYZ2V7WftTCzBW7xETIzD5DDn2W/rUIYS2c2HZmlHAcaVKlL5l49hJjv/affvDQnW/ttBncOHaXlgkl6vfvBlT3Li/0Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tp+0gqd1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tp+0gqd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDB1C4CED3;
	Tue, 17 Dec 2024 17:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456480;
	bh=gBtHpZBqNwiJIfHknBkzaFLu1Qm7UTKRssRJiIDoGyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tp+0gqd1oMEvTEGx6+ECgvlwTnuJx8HQkNbDav7mW676qMVktXqZd9u2e/vEFvLEa
	 weVMOuswVBcwts3Cyi7mT3OuaT5pqmoPhD5+NEJ138c7tZTZZP2YBSvdoAG769J4DQ
	 Kuw6QVUqma+M73ZaO62e+ezwqYwkLhQNi6IP0g0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.12 073/172] xfs: fix scrub tracepoints when inode-rooted btrees are involved
Date: Tue, 17 Dec 2024 18:07:09 +0100
Message-ID: <20241217170549.312780230@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit ffc3ea4f3c1cc83a86b7497b0c4b0aee7de5480d upstream.

Fix a minor mistakes in the scrub tracepoints that can manifest when
inode-rooted btrees are enabled.  The existing code worked fine for bmap
btrees, but we should tighten the code up to be less sloppy.

Cc: <stable@vger.kernel.org> # v5.7
Fixes: 92219c292af8dd ("xfs: convert btree cursor inode-private member names")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -601,7 +601,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 	TP_fast_assign(
 		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
 		__entry->dev = sc->mp->m_super->s_dev;
-		__entry->ino = sc->ip->i_ino;
+		__entry->ino = cur->bc_ino.ip->i_ino;
 		__entry->whichfork = cur->bc_ino.whichfork;
 		__entry->type = sc->sm->sm_type;
 		__assign_str(name);


