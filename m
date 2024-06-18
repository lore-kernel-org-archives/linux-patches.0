Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B8B14F108;
	Tue, 18 Jun 2024 12:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715209; cv=none; b=puJzHWY+AyZdHe+ER2mPWDUrHL5Y2I/tLXybyfSrsbXja5/bmmpErlFfsovkn8+HM8EmHs8pzbo5Uh4Bcd/m+d2v9dFw2wv3xpQKGRqpuCFhAtGF4HZQ/YN8fl97Kw2DjfLrfQ32+38YbBdyYH5M+GWIUgVIwAR5w75aQOaIUEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715209; c=relaxed/simple;
	bh=T3ir/1HFGakZqeeZcqDHFT7UsoINoV9tnvMRySZUDAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBc/b6mYx2ifxQ2A4nFkGIC19OeRAZFP13OR2mSggki6q5hl/69ZWAhu6lVGlf8tV3zVuQ7rwkeWmNz9IDByZ2A+oL1R0g5P6ENUInde708cIHfeWJYyBqt4lulY3uXdBw1ZPzf0U8giLMfVs8I5RtpPCpyKDqdJa1B4mtTbeLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5LQij9v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5LQij9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAACC3277B;
	Tue, 18 Jun 2024 12:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715209;
	bh=T3ir/1HFGakZqeeZcqDHFT7UsoINoV9tnvMRySZUDAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5LQij9vzThMrYwFfbfZUFzWAVPzFC0/fZ55qg00EfWEREFr889YdT6085ZslYpnY
	 Sk4kXk4Ss6L7Zi/RrlFCb6u5vAnXEAEuIh55EsycaJc0OmmAZok1yE7jtjttQzKFRZ
	 2CtiAiOWMl7nQenrL+ppRjOSBOp5oa+ixhPHVecw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 231/770] NFSD: Update the NFSv2 SETACL result encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:31:24 +0200
Message-ID: <20240618123416.199677854@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 778f068fa0c0846b650ebdb8795fd51b5badc332 ]

The SETACL result encoder is exactly the same as the NFSv2
attrstatres decoder.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index 102f8a9a235cb..ef06a2a384bea 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -363,8 +363,8 @@ static const struct svc_procedure nfsd_acl_procedures2[5] = {
 	[ACLPROC2_SETACL] = {
 		.pc_func = nfsacld_proc_setacl,
 		.pc_decode = nfsaclsvc_decode_setaclargs,
-		.pc_encode = nfsaclsvc_encode_attrstatres,
-		.pc_release = nfsaclsvc_release_attrstat,
+		.pc_encode = nfssvc_encode_attrstatres,
+		.pc_release = nfssvc_release_attrstat,
 		.pc_argsize = sizeof(struct nfsd3_setaclargs),
 		.pc_ressize = sizeof(struct nfsd_attrstat),
 		.pc_cachetype = RC_NOCACHE,
-- 
2.43.0



