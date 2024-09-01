Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCC6184530;
	Sun,  1 Sep 2024 16:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208399; cv=none; b=IbbwWt/U1KVHA/UXwqwzWwhHd3TY2zTy+dLTVQiEYoi7EUMLDqZ8DXWAVw9Lotyy527nxMXroXnMAeEHtmsUrIsZXw3dVIavZEMvmMxFJvz8epgSVzRShojEVdw5mgw5D0KAE11fKxHDnZ+9L5cdHXcd9rm/76ExpTWy2KYli2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208399; c=relaxed/simple;
	bh=Tlh4OJXMRH8HpRbgaRcd1tx5MJYujpDnn5LwH9I+E/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5qSzRqV1BeSYFPwLi3Fk/nTMpmby8sUpaID306CbXAFFs4FdJxRaZZ9Q1pAhoWKjU58NZV/MvbdrqIVP8mdC8jRgxKt2LDS8TEe+7awVdc49crdhje7xhxrwHO7r5OwnXMuLLOf3Uz9zjYxViiKS5J04HRjdHBzyQW1UevxKyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxLEEenR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxLEEenR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C6BC4CEC3;
	Sun,  1 Sep 2024 16:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208399;
	bh=Tlh4OJXMRH8HpRbgaRcd1tx5MJYujpDnn5LwH9I+E/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kxLEEenROlM9xowrn26ROTWAKv0BcS7yNLUFHaHqWlkmFbDdQGL2zja04FtgV3BHJ
	 xAKejjtH7xrMKEgnvnGMlrgn/SHNVXG4ZSpZA3aUOnZ7hpFGQkcEkB/KIuFWz+Lfo4
	 9aB1n2oibdl+qbgQB8FgoBg3Ch2vQOijivZWIsqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 071/149] smb/client: remove unused rq_iter_size from struct smb_rqst
Date: Sun,  1 Sep 2024 18:16:22 +0200
Message-ID: <20240901160820.135682111@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit b608e2c318789aeba49055747166e13bee57df4a ]

Reviewed-by: David Howells <dhowells@redhat.com>
Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h | 1 -
 fs/smb/client/cifssmb.c  | 1 -
 fs/smb/client/smb2ops.c  | 2 --
 fs/smb/client/smb2pdu.c  | 2 --
 4 files changed, 6 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 0a271b9fbc622..1e4da268de3b4 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -254,7 +254,6 @@ struct cifs_open_info_data {
 struct smb_rqst {
 	struct kvec	*rq_iov;	/* array of kvecs */
 	unsigned int	rq_nvec;	/* number of kvecs in array */
-	size_t		rq_iter_size;	/* Amount of data in ->rq_iter */
 	struct iov_iter	rq_iter;	/* Data iterator */
 	struct xarray	rq_buffer;	/* Page buffer for encryption */
 };
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 595c4b673707e..6dce70f172082 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1713,7 +1713,6 @@ cifs_async_writev(struct cifs_io_subrequest *wdata)
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = 2;
 	rqst.rq_iter = wdata->subreq.io_iter;
-	rqst.rq_iter_size = iov_iter_count(&wdata->subreq.io_iter);
 
 	cifs_dbg(FYI, "async write at %llu %zu bytes\n",
 		 wdata->subreq.start, wdata->subreq.len);
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7fe59235f0901..cfbca3489ece1 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4428,7 +4428,6 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
 			}
 			iov_iter_xarray(&new->rq_iter, ITER_SOURCE,
 					buffer, 0, size);
-			new->rq_iter_size = size;
 		}
 	}
 
@@ -4474,7 +4473,6 @@ decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
 	rqst.rq_nvec = 2;
 	if (iter) {
 		rqst.rq_iter = *iter;
-		rqst.rq_iter_size = iov_iter_count(iter);
 		iter_size = iov_iter_count(iter);
 	}
 
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 52b95f33db57d..d262e70100c9c 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4517,7 +4517,6 @@ smb2_readv_callback(struct mid_q_entry *mid)
 
 	if (rdata->got_bytes) {
 		rqst.rq_iter	  = rdata->subreq.io_iter;
-		rqst.rq_iter_size = iov_iter_count(&rdata->subreq.io_iter);
 	}
 
 	WARN_ONCE(rdata->server != mid->server,
@@ -4969,7 +4968,6 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = 1;
 	rqst.rq_iter = wdata->subreq.io_iter;
-	rqst.rq_iter_size = iov_iter_count(&rqst.rq_iter);
 	if (test_bit(NETFS_SREQ_RETRYING, &wdata->subreq.flags))
 		smb2_set_replay(server, &rqst);
 #ifdef CONFIG_CIFS_SMB_DIRECT
-- 
2.43.0



