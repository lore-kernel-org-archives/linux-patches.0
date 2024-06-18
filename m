Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D02C12B143;
	Tue, 18 Jun 2024 12:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714817; cv=none; b=NHyBFsyJUXPgRAm6qCCXsAn+RcMk2fD7Jwb5cjNIAoToj26Ae79bqUj2Dpy1VXxJStCnm3salmDUXUA6YLgXKBLlDuZ45MNe3lQYlKqehRzEvjp1msHThCNEZ90xVItkGbJMmpO4unBIjUjpqoHebAtlKAC9NTrmsCxfw4/0KZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714817; c=relaxed/simple;
	bh=8NL3HoHgjensC2fBi0q4NgIl9kCzk1pfReruhY36Xv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkOoyriHGeXqSmpij81cw34eN5axCCh25eF/E+LFdUiY1feRDMc1eosSYVR2dcbwxIQM1uP4BgM61ydiwCdP5GAjvyV3Nacxrl9QVQzde+tlruOmhMg456TdKRx11Z/DJLAn6J+l2yBg0KqdLDya7eX7AYXugt+WCzVS0GgQBXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gEvXfAwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gEvXfAwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60E3C3277B;
	Tue, 18 Jun 2024 12:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714816;
	bh=8NL3HoHgjensC2fBi0q4NgIl9kCzk1pfReruhY36Xv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gEvXfAwcWlz4y8QBrIa5bE6GVCtwsxrpshI0E2FVBuH/JXQ+/Xet8AJR2svebS4I4
	 j+PAPlf6KOEsKMkyIqzEH+jcx28IP80fqUrzCMNrxxlNLihjE2rvDqLbm1F5mU0gfc
	 vo6Bsj9y2WlTXAZkMPKu/qRSS8V80azOG+RZZx8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/770] NFSD: Replace READ* macros in nfsd4_decode_free_stateid()
Date: Tue, 18 Jun 2024 14:28:44 +0200
Message-ID: <20240618123410.024076624@linuxfoundation.org>
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

[ Upstream commit aec387d5909304810d899f7d90ae57df33f3a75c ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 7a0730688b2f0..92988926d9540 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1685,13 +1685,7 @@ static __be32
 nfsd4_decode_free_stateid(struct nfsd4_compoundargs *argp,
 			  struct nfsd4_free_stateid *free_stateid)
 {
-	DECODE_HEAD;
-
-	READ_BUF(sizeof(stateid_t));
-	free_stateid->fr_stateid.si_generation = be32_to_cpup(p++);
-	COPYMEM(&free_stateid->fr_stateid.si_opaque, sizeof(stateid_opaque_t));
-
-	DECODE_TAIL;
+	return nfsd4_decode_stateid4(argp, &free_stateid->fr_stateid);
 }
 
 static __be32
-- 
2.43.0



