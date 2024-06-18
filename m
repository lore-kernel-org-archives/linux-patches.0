Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A721BE861;
	Tue, 18 Jun 2024 12:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714613; cv=none; b=HJdjg70D2JzjHQbM5EENF6A7Nax72M+QM19Y1GltfA8ziVqwaiFaLOarq42tk5SRRgybXbClUsNpEg5EYzP3Beawwi10rb4aRndyaZ/L2PK2zkyaZhp0FTR3scOHfuFD2AV4P+KIgEiEFTpxS80iwCzbxvvL3K+XYr6Tis6wHdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714613; c=relaxed/simple;
	bh=JksjS+1aq6GSG+56ARY3PSNeToWuLVBFBL5HrKKCVFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWUe8nVlnUA87Jdt5Sd21u/lvSt1z8kJklZGRz72wX8i8nDyZDncS6+cFPhDxsT1/OX9Qz3PZUVTi0oGQhuuxirOGK76IVuzA1NtbIs6iGxTz18sORO4vwHuRObvaQ6OAPB8nH1XW+6o6Nnreo/MZKF0aIgeM4UEHJSUfaCEaNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8t9kttx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8t9kttx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBE1C32786;
	Tue, 18 Jun 2024 12:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714613;
	bh=JksjS+1aq6GSG+56ARY3PSNeToWuLVBFBL5HrKKCVFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8t9kttxjdwkPNxSag/I8U76R08nVDAjjcvGUfMwwu3mkivO+2QTyksrFfzf3olYM
	 kRYW7IKYviI7VHVPtt3XYCUVfI47VWsMhhM7wXoZ6+lKDtve+0lD+DxLBhxwhp/d8C
	 3nK9J9kfytbu14f+Agq8btY6BDsswafcuRm+8DTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/770] NFSD: Replace READ* macros in nfsd4_decode_delegreturn()
Date: Tue, 18 Jun 2024 14:28:02 +0200
Message-ID: <20240618123408.419448351@linuxfoundation.org>
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

[ Upstream commit 95e6482cedfc0785b85db49b72a05323bbf41750 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 8f296f5568b11..234d500961230 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -766,7 +766,7 @@ nfsd4_decode_create(struct nfsd4_compoundargs *argp, struct nfsd4_create *create
 static inline __be32
 nfsd4_decode_delegreturn(struct nfsd4_compoundargs *argp, struct nfsd4_delegreturn *dr)
 {
-	return nfsd4_decode_stateid(argp, &dr->dr_stateid);
+	return nfsd4_decode_stateid4(argp, &dr->dr_stateid);
 }
 
 static inline __be32
-- 
2.43.0



