Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B4915443A;
	Tue, 18 Jun 2024 12:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715310; cv=none; b=X2YEuvmzA8okt5kwqlN9pX8KuKP3MfcnpclhwiRybs7UWTluuSJRylfCF4ghJ7lp89I97xN8WJXWkYHZR0ggvNjRHvUUEKaCajyX04GyG87qQA6ANbNAd81zsBmNPhnWb6+L8vIjdYxpduW82QjGvOD+GY7Eb+oUSnZiiMjQNR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715310; c=relaxed/simple;
	bh=aCtPCCuYvUwYVUVXwsciQ/2f4abGN9PzS7/m0q8rYxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XaB9XIIGozjqebQ8frfx8mJpnfn949Pbtz57FxVuXMMwMIFG2RQFVhGRddddKjFR9ogZPe69xCHPPCSz89MRT3t9Y5JyDzY11SMbyJydMzbE1cmrTPyQOcZeyDzWSjsB8x/zPBcsio9OS9rrsFt3bfOy/cR1nBExZV70zlfKM3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzxjUR44; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzxjUR44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC09C3277B;
	Tue, 18 Jun 2024 12:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715310;
	bh=aCtPCCuYvUwYVUVXwsciQ/2f4abGN9PzS7/m0q8rYxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzxjUR44Ji8tNofleb533M0obQcwutigg8D88SLBNSFu9bJo86537dW8tbXlqk+Zt
	 i7SYaw4726oIYIQgy+e0M41YrkT1y47A2PIUuMmdWfwBo3M0rXwKnkiPUfnSutxeLG
	 42o2Af1OAnz3dIMc0jhxEofVaeIvyjhji0eTuuew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 265/770] NFSv4.2: Remove ifdef CONFIG_NFSD from NFSv4.2 client SSC code.
Date: Tue, 18 Jun 2024 14:31:58 +0200
Message-ID: <20240618123417.501990621@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit d9092b4bb2109502eb8972021a3f74febc931a63 ]

The client SSC code should not depend on any of the CONFIG_NFSD config.
This patch removes all CONFIG_NFSD from NFSv4.2 client SSC code and
simplifies the config of CONFIG_NFS_V4_2_SSC_HELPER, NFSD_V4_2_INTER_SSC.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/Kconfig        | 4 ++--
 fs/nfs/nfs4file.c | 4 ----
 fs/nfs/super.c    | 4 ----
 fs/nfsd/Kconfig   | 2 +-
 4 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 462253ae483a3..eaff422877c39 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -334,8 +334,8 @@ config NFS_COMMON
 	default y
 
 config NFS_V4_2_SSC_HELPER
-	tristate
-	default y if NFS_V4=y || NFS_FS=y
+	bool
+	default y if NFS_V4_2
 
 source "net/sunrpc/Kconfig"
 source "fs/ceph/Kconfig"
diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 5ad57ad89fb1e..70cd0d764c447 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -430,9 +430,7 @@ static const struct nfs4_ssc_client_ops nfs4_ssc_clnt_ops_tbl = {
  */
 void nfs42_ssc_register_ops(void)
 {
-#ifdef CONFIG_NFSD_V4
 	nfs42_ssc_register(&nfs4_ssc_clnt_ops_tbl);
-#endif
 }
 
 /**
@@ -443,9 +441,7 @@ void nfs42_ssc_register_ops(void)
  */
 void nfs42_ssc_unregister_ops(void)
 {
-#ifdef CONFIG_NFSD_V4
 	nfs42_ssc_unregister(&nfs4_ssc_clnt_ops_tbl);
-#endif
 }
 #endif /* CONFIG_NFS_V4_2 */
 
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 7179d59d73ca4..1ffce90760606 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -116,16 +116,12 @@ static void unregister_nfs4_fs(void)
 #ifdef CONFIG_NFS_V4_2
 static void nfs_ssc_register_ops(void)
 {
-#ifdef CONFIG_NFSD_V4
 	nfs_ssc_register(&nfs_ssc_clnt_ops_tbl);
-#endif
 }
 
 static void nfs_ssc_unregister_ops(void)
 {
-#ifdef CONFIG_NFSD_V4
 	nfs_ssc_unregister(&nfs_ssc_clnt_ops_tbl);
-#endif
 }
 #endif /* CONFIG_NFS_V4_2 */
 
diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index 5fa38ad9e7e3f..f229172652be0 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -138,7 +138,7 @@ config NFSD_FLEXFILELAYOUT
 
 config NFSD_V4_2_INTER_SSC
 	bool "NFSv4.2 inter server to server COPY"
-	depends on NFSD_V4 && NFS_V4_1 && NFS_V4_2
+	depends on NFSD_V4 && NFS_V4_2
 	help
 	  This option enables support for NFSv4.2 inter server to
 	  server copy where the destination server calls the NFSv4.2
-- 
2.43.0



