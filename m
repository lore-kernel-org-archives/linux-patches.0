Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA84154C02;
	Tue, 18 Jun 2024 12:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715337; cv=none; b=I7QBJXnn5itaBaaMX9XUPt2WVU2+Iyjh7tx2uA0w0mNey3ed2wVHNUUUqiwfq38la5rmyPbR2rH++Tqcpvbg7r+c4ntPbSVuylRu6eyqp0EQ5t2tQ/Zqrq9hZM7IPvJOKoz0Izoa4tC2V9Gn/eL774/PGZBCxLdm6TEvzTeF8pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715337; c=relaxed/simple;
	bh=psZrKiboh4XGozPN58WUuDKUboAvr/4yfRRQzeZYICM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjYEk4snXTM1bQ7CaPEQO8LqxfTmlFBPuf+nyIxqKbqoSyiDs5Vqm5YT3rLEp1/l60A7b6rXXKiLu2nxxCoeHuT8utR8zcdO+8mVnAgXDLC83oI/45LmJIS/lgvt/h80tkjQXs0r4W4+fzaXnd3hmv8cH9BpIxeBB7KOZP53Sdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAUo7Srf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAUo7Srf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845F4C3277B;
	Tue, 18 Jun 2024 12:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715336;
	bh=psZrKiboh4XGozPN58WUuDKUboAvr/4yfRRQzeZYICM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAUo7SrfXpxLt+DhUpdVl96Q/v4oRFAk3M2nR3mII/kAqNTwKM6oYMPPNOK/uDhVU
	 3XelBZn9Q/xwp9ZbtxBCWa9TPfoqLrYlpORTk7oCJ9ERwGJ6Jvpd29wBM+drtWU32i
	 9+xGDAyZSFwG5j52f3dYrX6GTd81JH8i0kHt9iGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/770] NFSD: Add nfsd_clid_reclaim_complete tracepoint
Date: Tue, 18 Jun 2024 14:32:06 +0200
Message-ID: <20240618123417.807518768@linuxfoundation.org>
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

[ Upstream commit cee8aa074281e5269d8404be2b6388bb29ea8efc ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 1 +
 fs/nfsd/trace.h     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index b10593079e380..da5b9b88b0cd4 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3981,6 +3981,7 @@ nfsd4_reclaim_complete(struct svc_rqst *rqstp,
 		goto out;
 
 	status = nfs_ok;
+	trace_nfsd_clid_reclaim_complete(&clp->cl_clientid);
 	nfsd4_client_record_create(clp);
 	inc_reclaim_complete(clp);
 out:
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 2c0f0057f60c9..6c787f4ef5633 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -511,6 +511,7 @@ DEFINE_EVENT(nfsd_clientid_class, nfsd_clid_##name, \
 	TP_PROTO(const clientid_t *clid), \
 	TP_ARGS(clid))
 
+DEFINE_CLIENTID_EVENT(reclaim_complete);
 DEFINE_CLIENTID_EVENT(confirmed);
 DEFINE_CLIENTID_EVENT(expired);
 DEFINE_CLIENTID_EVENT(purged);
-- 
2.43.0



