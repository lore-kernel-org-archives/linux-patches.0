Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2156013B79B;
	Tue, 18 Jun 2024 12:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715331; cv=none; b=sYDggnmHfdLnn4KJ5ODNRDfjAogm2KlBgpA8cFUh6kmrYpadQw6VikySH2fKD/mF72sTFv6yVgTdk7ehFXD4uzkJX5j3Idm1MQ+1nOOubrSIdC3UOf93h2767w6RwJsi9h9clq4mXtWrWkxFZ9owXN1qmraMZTVeo8L2KoA7yow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715331; c=relaxed/simple;
	bh=RKA6k++QZpXbaW8ma+2M8uvP29/ugWwdaqp1qrF7i38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNJ8nyFwbm3VBy/Wc45QEs1j4pJPT2M3BNeII6ypjobBZu1DlQ6ltGo+tGGougLho0NhYf4Ciw4OjxVs9QJOSPK1IS735pLWt/JF53+mfkUR621N8/gz3gxKVAcw7yoEjsffcnwS7EeOPKBJQiYvd3Dh4EV6uoO6D6gHFPpOILc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xHAZWwWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xHAZWwWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3F6C32786;
	Tue, 18 Jun 2024 12:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715331;
	bh=RKA6k++QZpXbaW8ma+2M8uvP29/ugWwdaqp1qrF7i38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xHAZWwWNKoiwmkH1Xmsm40nSbaal+FxKtOf8lUPBbHiFt2JASRJi6gb6cMy6TztjM
	 wDWSY7+3xhnFmlWD5ZWBiJIUR6ViUjGOAo21V6Y7BfQ7EWFvYsSUTSv0740In26OKr
	 FCZxUv4LoPdAfQY1pWeouuNlZu2ECiPBKTz7itd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 271/770] NFSD: Remove trace_nfsd_clid_inuse_err
Date: Tue, 18 Jun 2024 14:32:04 +0200
Message-ID: <20240618123417.731823063@linuxfoundation.org>
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

[ Upstream commit 0bfaacac57e64aa342f865b8ddcab06ca59a6f83 ]

This tracepoint has been replaced by nfsd_clid_cred_mismatch and
nfsd_clid_verf_mismatch, and can simply be removed.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/trace.h | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 0ab46a0c911d2..2fac89e29f515 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -596,30 +596,6 @@ TRACE_EVENT(nfsd_clid_verf_mismatch,
 	)
 );
 
-TRACE_EVENT(nfsd_clid_inuse_err,
-	TP_PROTO(const struct nfs4_client *clp),
-	TP_ARGS(clp),
-	TP_STRUCT__entry(
-		__field(u32, cl_boot)
-		__field(u32, cl_id)
-		__array(unsigned char, addr, sizeof(struct sockaddr_in6))
-		__field(unsigned int, namelen)
-		__dynamic_array(unsigned char, name, clp->cl_name.len)
-	),
-	TP_fast_assign(
-		__entry->cl_boot = clp->cl_clientid.cl_boot;
-		__entry->cl_id = clp->cl_clientid.cl_id;
-		memcpy(__entry->addr, &clp->cl_addr,
-			sizeof(struct sockaddr_in6));
-		__entry->namelen = clp->cl_name.len;
-		memcpy(__get_dynamic_array(name), clp->cl_name.data,
-			clp->cl_name.len);
-	),
-	TP_printk("nfs4_clientid %.*s already in use by %pISpc, client %08x:%08x",
-		__entry->namelen, __get_str(name), __entry->addr,
-		__entry->cl_boot, __entry->cl_id)
-)
-
 /*
  * from fs/nfsd/filecache.h
  */
-- 
2.43.0



