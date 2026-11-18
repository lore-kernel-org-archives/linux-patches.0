Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043835;
	b=C6ny2l9wsHqo5grCGjQO5xTh2wwTRWn57V95HHM7gx+gYSoeYNLrRv37lULqETGSr1h4
	 iCOCamFVJ56mX6gsrnrdBliGLUlJ4xKFddWXJ8cYY0nf91Xeoar80vV6vU83AJC8Wr6f/
	 X9na0VsXFYLx0f/eruvGyJO+ilrRoSg5ECot+gkLh5WYhwlVkka7b5uEFUqlblJpw8lpM
	 J396APl9kkGFiWEa/d8Bapp4+KN+7whPBdCKIE+W+kuLYNK7wOs9cBSq1yCG8MrW8Fmx4
	 J3qsYxmUbWuT2KuDOiY5zVjhiDyaIeUJ45O0BHf55Z3c309h3YuZoNZKyNTe1vQoQGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rw2W0LJKfslKsAjs+3SNLiuztv0sOfb+6txhOEUFKyI=;
	b=JLUrGJ3bU2rGN0Up3AbsZfLU7af9Bctr3+vhbsxRu4kjEn2NZOIJHkpGQiVmOAWZ6YOT
	 9awsXmEj/CjSMz013uTSUe5uXLKTK/de7bPp0nvieJTP0I9NnznZBWM/YzPYq9PEZ115d
	 M+24mZqmA95qN+p176EGwIF0w9MZ1uJtf6etwpsgI6Gfh99w9A4dSVEIMFDx1uZuYx2ca
	 7b0O0cGdCvi6PBcewJAAJ6f7uLukPnhcvSyWVM74Xa5UwCTgcpt3KVMNfB9AyoNahjiqS
	 K5TuxGzmc5GaFI+5JC7UI6gVP1qjGZowuiJZ/MXQ6ow+mHLILPMEVv4cC4nzuVLcxeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rudl+dcG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FAD606A320;
	Wed, 18 Nov 2026 23:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rudl+dcG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D011F000C6;
	Wed, 18 Nov 2026 23:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043834;
	bh=Rw2W0LJKfslKsAjs+3SNLiuztv0sOfb+6txhOEUFKyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rudl+dcGXo1+epFrEVe7At/BljBCbkqAbZcmh8p0RTVA/eDguiS9+TRPoVVoGWh1Z
	 M7pI+4V7/+mdUOvzoc4xX7lQ7FeN+5SKTli3uujlDCg+pHgg5faEjd6XS7TkN0F2hi
	 RfeSv3dbP3I21ZC6mke08qPZuQiTb7IJXuQIA99M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0351/2857] svcrdma: Clear sc_cm_id when ADDR_CHANGE replacement fails
Date: Wed, 18 Nov 2026 15:23:05 +0100
Message-ID: <20261118150214.073761119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 01500306e1d50de7ca7a2cdcdfa28ac0523eb747 ]

When svc_rdma_listen_handler() handles RDMA_CM_EVENT_ADDR_CHANGE,
it creates a replacement listener cm_id and returns 1, telling
the CM core to destroy the old one. If the replacement allocation
fails, sc_cm_id still points at the old cm_id that the CM core is
about to destroy. Any subsequent dereference of sc_cm_id --
such as svc_rdma_detach()'s rdma_disconnect() call -- is a
use-after-free.

NULL sc_cm_id on the failure path and guard svc_rdma_detach()'s
rdma_disconnect() call against NULL so that the listener can
be torn down safely when the server shuts down.

Fixes: d1b586e75ec6 ("svcrdma: Handle ADDR_CHANGE CM event properly")
Cc: stable@vger.kernel.org
Acked-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260527-rdma-follow-on-v1-5-1b09bd87b6cd@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
[ sashal: Added a NULL check around rdma_destroy_id() in __svc_rdma_free(), since this tree's older teardown code lacks the NULL early-exit that upstream relies on. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index c84e80ae374ea..1da190fa25265 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -305,6 +305,7 @@ static int svc_rdma_listen_handler(struct rdma_cm_id *cma_id,
 		if (IS_ERR(listen_id)) {
 			pr_err("Listener dead, address change failed for device %s\n",
 				cma_id->device->name);
+			cma_xprt->sc_cm_id = NULL;
 		} else
 			cma_xprt->sc_cm_id = listen_id;
 		return 1;
@@ -584,7 +585,8 @@ static void svc_rdma_detach(struct svc_xprt *xprt)
 	struct svcxprt_rdma *rdma =
 		container_of(xprt, struct svcxprt_rdma, sc_xprt);
 
-	rdma_disconnect(rdma->sc_cm_id);
+	if (rdma->sc_cm_id)
+		rdma_disconnect(rdma->sc_cm_id);
 }
 
 static void __svc_rdma_free(struct work_struct *work)
@@ -616,7 +618,8 @@ static void __svc_rdma_free(struct work_struct *work)
 		ib_dealloc_pd(rdma->sc_pd);
 
 	/* Destroy the CM ID */
-	rdma_destroy_id(rdma->sc_cm_id);
+	if (rdma->sc_cm_id)
+		rdma_destroy_id(rdma->sc_cm_id);
 
 	kfree(rdma);
 }
-- 
2.53.0



