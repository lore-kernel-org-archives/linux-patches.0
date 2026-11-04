Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827102;
	b=T6S38wRRISTKJRwYHLeuqqzXIWC7DKd/RiGuOC2+9d+WT3gxbOkUnPWvEHUiiMKKMJ6a
	 I2uN94J5BGKbJGcGTGIzoMt2P8QQtF41CSG0k1OtRny4jnmut/Bi9tmwxFW4LAFI+Lu3u
	 5dJgEGu02vc5wURu1a+q39g5UEZZdoF0MVoMbQ+E2HMnj+9nlkzYW/6FzHlqoY4CG2vAT
	 P0b4WB0olr1FZlBF8tlrZZ/MzIvVwLWh5sPT8Vnk1XtaUhiV+ZYltEzDlbyeoFByJYwSZ
	 Y+ipm5KRHh0yOLZFEKsfSrkgv64aGWx1TAQX9HqpIaYn13GBidNsEnJc75nLRafdGnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fxBAqDqxqdvRtsZFoiKYQb4acuQytmiJXwjIKrhG4r8=;
	b=zcDuhg02JN5hz4alqhuvbK77o4T2AKqILxAeO9GSZCV3HBHZ6pwc2rEGx5/kVJ7xgDoV
	 OhWEOBYiAQfIcGIHvfZBaV5jd/yVCwFHsGKukIasFwqg2HxH6WHTg4aSq0SXG+PWri+36
	 ZdgLBbQo0RNEy+3Yhxsb5piqxkvfsDMbtUmXZSsq6zFJxoFU/0HIDTk3a6YLD+OK2qHUl
	 1JXC2ixr/PKf+nKs0tgqGlZnvhdlXyly1FWG8pMFW2Lcqimg2xgEi+cct1T2i6zeC4tyR
	 D81mRF0o7/2T5vTINdD3iORzrXMjKbh0kZHSqHul5s5S5qopWfklVJoRys+5Gx+P1aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wKWvZwWM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1D6606A869;
	Wed,  4 Nov 2026 21:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wKWvZwWM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33ADD1F00919;
	Wed,  4 Nov 2026 21:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827102;
	bh=fxBAqDqxqdvRtsZFoiKYQb4acuQytmiJXwjIKrhG4r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wKWvZwWMiSGa/x7RjN08351unftJOido+2Dx/46VKMKU/4msx9q1gbdFv1RtEt4zf
	 31DP6lSCN8BJTQKidXM55X4X9V4cKVvWihNPvH4lPJhX/ZEztzplj2Z4HBdaDp9vrU
	 YWPOfPI2fIAb0YRX6u1TRLhYAMQ1/8WJZijZmKf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 7.3 179/547] s390/vmcp: Initialize full session info to zero
Date: Wed,  4 Nov 2026 16:06:03 -0500
Message-ID: <20261104211043.231223106@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit f63eb4ee4a30fc5d8de07a229d92310e3c8d560c upstream.

The cma_alloc bit as well as the response can contain old data.
cma_release will not free the kmalloced memory in that case and
the response code might leak kernel stack data to CAP_SYS_ADMIN
users.

Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/char/vmcp.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/s390/char/vmcp.c
+++ b/drivers/s390/char/vmcp.c
@@ -104,13 +104,11 @@ static int vmcp_open(struct inode *inode
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	session = kmalloc_obj(*session);
+	session = kzalloc_obj(*session);
 	if (!session)
 		return -ENOMEM;
 
 	session->bufsize = PAGE_SIZE;
-	session->response = NULL;
-	session->resp_size = 0;
 	mutex_init(&session->mutex);
 	file->private_data = session;
 	return nonseekable_open(inode, file);


