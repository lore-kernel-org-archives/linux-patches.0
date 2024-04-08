Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAA742046;
	Mon,  8 Apr 2024 13:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584304; cv=none; b=m7EtHrXY3qjpQKQGZIfVRDCdKSNYLle2ZrK2TMelbvetT7JenGyG6YglftmTVJBcjCoZlCTLICt78RMobtEfglriPd4F8OtohVE8kpUSDv7gSi7pH/xaAREKJH6s+GGKFBI+AKQic0CrUqcYek62rNSyxv3nP4fKxZs3xeDzIHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584304; c=relaxed/simple;
	bh=yLitQOxkqO1x06a0KVttf52XInpywJ4ix3C+xBO7aRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpluMg81O3WKRLgkG9lMseF0d8Bx899lThsVZaw8jJdFR6yZEi86uHAfcbEX0/ck7XjCnlxcnnqDHij9tJrLKZk0WpmVuRekneZvJV/yB3hl37WAtL5bEuTI1o5CASiotU2GEVfoPu8/E5nLh/nGbUt8ksKQHC9WQQd5hLzp8Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTN02tId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTN02tId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A8AC433C7;
	Mon,  8 Apr 2024 13:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584304;
	bh=yLitQOxkqO1x06a0KVttf52XInpywJ4ix3C+xBO7aRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTN02tIdHgXxjITf1vfsdQjnmBcq1umEVXH+hYJRzm+Dqrpgj/to/BpLZxbOnwmmo
	 2rvkr4QdORGMhXkkQzj/8LjoKhIcvusUU5k4Pk+nUvMfc/kYQ8/4pVYn/xS1RgVhHX
	 wYcHyfwXp9qDulwyOilImGVsPJVPQE1lqfUT5Dtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 393/690] NFSD: Make nfs4_put_copy() static
Date: Mon,  8 Apr 2024 14:54:19 +0200
Message-ID: <20240408125413.775847389@linuxfoundation.org>
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

[ Upstream commit 8ea6e2c90bb0eb74a595a12e23a1dff9abbc760a ]

Clean up: All call sites are in fs/nfsd/nfs4proc.c.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c | 2 +-
 fs/nfsd/state.h    | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index f0722d4ed0810..3e4b0fb44c7b7 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1287,7 +1287,7 @@ nfsd4_clone(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	return status;
 }
 
-void nfs4_put_copy(struct nfsd4_copy *copy)
+static void nfs4_put_copy(struct nfsd4_copy *copy)
 {
 	if (!refcount_dec_and_test(&copy->refcount))
 		return;
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index f3d6313914ed0..ae596dbf86675 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -703,7 +703,6 @@ extern struct nfs4_client_reclaim *nfs4_client_to_reclaim(struct xdr_netobj name
 extern bool nfs4_has_reclaimed_state(struct xdr_netobj name, struct nfsd_net *nn);
 
 void put_nfs4_file(struct nfs4_file *fi);
-extern void nfs4_put_copy(struct nfsd4_copy *copy);
 extern struct nfsd4_copy *
 find_async_copy(struct nfs4_client *clp, stateid_t *staetid);
 extern void nfs4_put_cpntf_state(struct nfsd_net *nn,
-- 
2.43.0



