Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8457E10B;
	Mon,  8 Apr 2024 13:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584036; cv=none; b=pcg1o0uuaT1Yy9TEl3Ye1mj/i2d7OWmEd+P8hahqySpao7sVz/jJrASw0efNaCj8GiLbM5p5Cg5eZSGXp0339G6ER2h+Uufjk4P8gHBoQ3khSNIGfe43stQaT0cV1ogKYemfqgE6k/FzVoFC48Wo83tYSRzgyrGE0/l7FSpVJW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584036; c=relaxed/simple;
	bh=NOScHutPeaM20eOCwsOOxkNdCKp2jiJefR2jcPn9sSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxoOTnh7ekO4duFdK9107taJib5ZeI3RDaryrK8t6/wqhTnEzKMaFatVL51WdJ2sEO2S2Zw0217phmpiJ0hXR07TzlVdN23CggeVR6i6j+PaqbNCplzAGvX29QuREqsnWr5DUkO9wB84QUOguj2B+UN+DlydP4BL9U+EROHlfSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXAxQVEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXAxQVEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4454DC433C7;
	Mon,  8 Apr 2024 13:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584036;
	bh=NOScHutPeaM20eOCwsOOxkNdCKp2jiJefR2jcPn9sSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXAxQVEb4Bg6sp/DP4zCSKhsis/cCOWfiXzPkPOUU6CMqnOv6RZ8SQ+UW9r7BdkAE
	 XtDVOJtk9jzIwLNAfBme0FEN4N/oE4s+5eWFAPW7dW5cdQ8f1gHcGZVXn/Hw1VuQBK
	 pvXjog+McrjHQl5zDuM8LGG8EwzKykRvDNbLJkkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 324/690] NFSD: Move documenting comment for nfsd4_process_open2()
Date: Mon,  8 Apr 2024 14:53:10 +0200
Message-ID: <20240408125411.355058318@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 7e2ce0cc15a509b859199235a2bad9cece00f67a ]

Clean up nfsd4_open() by converting a large comment at the only
call site for nfsd4_process_open2() to a kerneldoc comment in
front of that function.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c  |  6 +-----
 fs/nfsd/nfs4state.c | 12 ++++++++++++
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 6a9c7e6a23ba5..3ac2978c596ae 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -628,11 +628,7 @@ nfsd4_open(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		status = nfserr_inval;
 		goto out;
 	}
-	/*
-	 * nfsd4_process_open2() does the actual opening of the file.  If
-	 * successful, it (1) truncates the file if open->op_truncate was
-	 * set, (2) sets open->op_stateid, (3) sets open->op_delegation.
-	 */
+
 	status = nfsd4_process_open2(rqstp, resfh, open);
 	WARN(status && open->op_created,
 	     "nfsd4_process_open2 failed to open newly-created file! status=%u\n",
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index f9681a4d116ad..d79b736019d49 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5465,6 +5465,18 @@ static void nfsd4_deleg_xgrade_none_ext(struct nfsd4_open *open,
 	 */
 }
 
+/**
+ * nfsd4_process_open2 - finish open processing
+ * @rqstp: the RPC transaction being executed
+ * @current_fh: NFSv4 COMPOUND's current filehandle
+ * @open: OPEN arguments
+ *
+ * If successful, (1) truncate the file if open->op_truncate was
+ * set, (2) set open->op_stateid, (3) set open->op_delegation.
+ *
+ * Returns %nfs_ok on success; otherwise an nfs4stat value in
+ * network byte order is returned.
+ */
 __be32
 nfsd4_process_open2(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nfsd4_open *open)
 {
-- 
2.43.0



