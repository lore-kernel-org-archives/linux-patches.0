Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618950;
	b=X2RaLcDD1iMVX7VYmcj5dNcXoozKaP6EciGo0Y10tDbBEcwPA3A1TBn6+WcSHJgGcgio
	 EUJ4y7GZLgD3dMAxc4ZyIIywbPeJcYw+bC83EB8afTQyuIEYvXLUea0ABnfqV+TVFLpSe
	 ywu2C7rocSy2bXaOtMTOONdDxI1FJZGqsvTTFBIfiEmryUhpAI2R47Lzoif92kdBmsK24
	 Vx617bJe25Yt+AJEOiP20E9tbF2iv189Fl0UYtMNXaNzAeGqRt1dXXZFsOjNepj+kC/8f
	 v9P9ArIp8bhC5aCLNivPDlzOVnEM6oGzFFg6JfiCvTEnKSdW7lgj1QtLJ0qshklynjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FMyY2pJDZyxVYAgAY9K5bMws9+7pWOoKzQ2x6S7KkUY=;
	b=ViDug/f4kGZ3QxAqOYAxopH98+P1rN9JNRPcNxbdDmUM1fs7vaVezW/zLWLXsHBUYzIB
	 whzV2eNnga0n462hElZbkFmGWxWRkHUsi5rS49fvgZ1y0Oyu77YrTlNBHhkbq4Ck4IO3N
	 YpH41WnBCO7sdxWAlRrJ6hCXajMAYV7DQYMPhFI5uMBLFKezLJ2ifJIxTyJ20n8/Dnxxl
	 mcrF6kSr86Ddh2OquJu7pyzxjHPtazgFt4vz3duf7ryed1EMwOmsjYp3hbajk1cWe8ppb
	 WXRBWFAd3cKMH/BL9Z+mG5eD/Eo+orGxZRyEzqNN2xCuIqbPwKQwiTChyZxiPqoUjRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m0iYP+fL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B983606A321;
	Wed, 25 Nov 2026 15:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m0iYP+fL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C3B1F000C0;
	Wed, 25 Nov 2026 15:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618949;
	bh=FMyY2pJDZyxVYAgAY9K5bMws9+7pWOoKzQ2x6S7KkUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0iYP+fLxTjma2rdJFdaQysEa5jM9l0xlcyC3xoo3VjxSH+VaW6dCo/LrUGmQtM5m
	 FmC8uqtYOF/O2a5KysX4Rks0b5vE/yCYtmuYcTLDbERSZMpIuvJGpX82Exx8pp4FbL
	 KfUPMEdjJwwDM23GcPciLiNAPFiu1Xv+dGYyoNOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0439/1005] NFS/localio: hold the client across an asynchronous LOCALIO probe
Date: Wed, 25 Nov 2026 15:29:37 +0100
Message-ID: <20261125143832.034046434@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 000a87910213562ff09f5bc38cd366ce34fccf71 ]

nfs_local_probe_async() queues the client's own cl_local_probe_work
without a reference on the client, and nfs_free_client() does not cancel
it.  The work takes a reference only once it runs.  If the last
nfs_put_client() comes first, for example at umount after an NFSv3 I/O
queued a throttled probe, the client is freed with its work queued, and
the work then runs on freed memory.

Take the reference when the work is queued, and drop it when the work
has run.  If the work is already queued, it already holds a reference,
and the one just taken is dropped.

Fixes: 76d4cb6345da ("nfs: probe for LOCALIO when v4 client reconnects to server")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index cdada6cbb13bf..d5859e8c2a2a8 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -203,15 +203,22 @@ void nfs_local_probe_async_work(struct work_struct *work)
 	struct nfs_client *clp =
 		container_of(work, struct nfs_client, cl_local_probe_work);
 
-	if (!refcount_inc_not_zero(&clp->cl_count))
-		return;
 	nfs_local_probe(clp);
+	/* The reference nfs_local_probe_async() took for this work */
 	nfs_put_client(clp);
 }
 
+/*
+ * The work is part of the client, so it holds a reference on the client
+ * from when it is queued until it has run: the last nfs_put_client()
+ * cannot free the client under a queued probe.
+ */
 void nfs_local_probe_async(struct nfs_client *clp)
 {
-	queue_work(nfsiod_workqueue, &clp->cl_local_probe_work);
+	if (!refcount_inc_not_zero(&clp->cl_count))
+		return;
+	if (!queue_work(nfsiod_workqueue, &clp->cl_local_probe_work))
+		nfs_put_client(clp);	/* already queued, with its reference */
 }
 EXPORT_SYMBOL_GPL(nfs_local_probe_async);
 
-- 
2.53.0



