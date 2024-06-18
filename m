Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B686C13B780;
	Tue, 18 Jun 2024 12:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715286; cv=none; b=SSpTK+NXpjKW7LML3ezgsJ44uz5Uk3F2xyqYKXFVQqwv1wXRCOJ4+QVoIr/vrRxXQZF8CM+TNHRjhaZeaRLeYPK9pWScoJUY6SFucGhRlCZ947c5mNz68aFjL3FbEc1KwXRgao1s0GYSNMGETp91xCwiy+50wqqV1eZ7J8JPf6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715286; c=relaxed/simple;
	bh=005fpCm0TRzd9zsXYh2t6oUudCdD6hrKO8SN9qmcKwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcmQtPVTDFaHq0lPlzPHyuFMlWD0gPji3Wdli6P//tdRu01q0OXPvGWEuxZH6BB+JdS/HTgjMbF1XZxkiVEpzPCNhZ4moXj0py2p/sAtP1qXheyVOoCh3MN9ywzC95efz1KThRzexms2QgkX7KUIzWL7m6c9RddGfYQRCtrYcnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+FnQncx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+FnQncx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAFAC3277B;
	Tue, 18 Jun 2024 12:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715286;
	bh=005fpCm0TRzd9zsXYh2t6oUudCdD6hrKO8SN9qmcKwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+FnQncxaEAUoEo+sHcSEydzEJN8r4UKe3uOwrSLbFerulnOmDqf+zPSmewAoI+wM
	 CJOknHF7sZFlbYbsjyF1kltUmKxV6yLa/vddaqOWm+LGT7Yy2XoYjc+C8zuJSPUY+V
	 EU+V7+HEZPtk3d3BTXKEbDI+48g1vq4eshQkvs2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 258/770] nfsd: remove unused function
Date: Tue, 18 Jun 2024 14:31:51 +0200
Message-ID: <20240618123417.233715086@linuxfoundation.org>
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

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 363f8dd5eecd6c67fe9840ef6065440f0ee7df3a ]

Fix the following clang warning:

fs/nfsd/nfs4state.c:6276:1: warning: unused function 'end_offset'
[-Wunused-function].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 104d563636540..a42a505b3e417 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6336,15 +6336,6 @@ nfsd4_delegreturn(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	return status;
 }
 
-static inline u64
-end_offset(u64 start, u64 len)
-{
-	u64 end;
-
-	end = start + len;
-	return end >= start ? end: NFS4_MAX_UINT64;
-}
-
 /* last octet in a range */
 static inline u64
 last_byte_offset(u64 start, u64 len)
-- 
2.43.0



