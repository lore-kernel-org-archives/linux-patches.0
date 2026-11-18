Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058830;
	b=QWZToiRBs6sXOlpMNYS6kA3h+wys+LdOGjw6Jq09CQZDamceUlnRE5oJyKbCuSuTU/By
	 Cam6OGfp7KSqTksDaaqBZVu/7M1RAjQ8qHkr7ha2f6HyVe2vKtMoHVaY5aPpUO0fpc3It
	 R/vIQbLZLpcq5FbYwwwP6Wxa30iS2eHctZ67Urrxsr8fQKQLxO5U0k9z1HLFCSdEeG5qw
	 8QEIwiPVS0S+Vi/mAUDn54lqSFtuZ36OONar3Jb88W8dhnqGOQabW6HGa0BwCkPQ0ZVcn
	 8lH+fbOiz3CU/ykZwMVMtF+kTNfb8wJ3RXYwOiDQtvemrlYaYhYJXH01lpm2uqXYyFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b69MHbB/ZCAMJPT0cYQ+c2K/Wgd3PrPGT8uNFpcXRo4=;
	b=4HTC3t1W8txIUMrvzKQnPG7sOmSxp/moR8Q3HQe5oHtHj6/T7jMBrQByZmjjVt85xO4U
	 /yOGlwhVry+V7htLkKvpHuvA0cAzbCZdGYNY6urhP7SjJLtwDn+a89T39xgWkM9i1HKUf
	 kkdwUQy6d8Dcnol17cU8a5svWETRrejV+UssROuF0slbZqMYITcgsXH8mah10V2vt98WT
	 npiR9JesppMMsR0us9keMCGJtnPX6Obyl3FkkdOieImh35dnbtGXOCLovDwM6ckw5y+vN
	 XRsX4gASWgGDcp/e1fwePslqLsK0YXYM/xDmVagM47gD6j3Kpp661PZP7+GSX3QMiLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sSo6jzxF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73313606A326;
	Thu, 19 Nov 2026 03:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sSo6jzxF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C401C1F000C4;
	Thu, 19 Nov 2026 03:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058830;
	bh=b69MHbB/ZCAMJPT0cYQ+c2K/Wgd3PrPGT8uNFpcXRo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sSo6jzxFaYBsYhqgYv3nO+TBBkkpQWCx41/vKWuCCkPsAYvbu6bPIV4KFY3vdGit7
	 0oOGKKFRmuuUBKQ3tNI39QgMdarIX3wn4UgA+9nLaKRmvg5ebblJ3Z0g8xRyO4WPfO
	 ZHdd3KiHTFULymSq+ByK1DdQzty4Xx4OPv7fYDzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0627/1848] NFSv4/pnfs: bound the CB_NOTIFY_DEVICEID array count before allocating
Date: Wed, 18 Nov 2026 15:44:25 +0100
Message-ID: <20261118145941.783012532@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <ben.coddington@hammerspace.com>

[ Upstream commit 32f0967ea296d447925465c98e7eec71d4e2f755 ]

decode_devicenotify_args() hands the server's notification count
straight to kmalloc_objs() as the array length, without checking it
against the message that carried it.  Bound it the way nfs4xdr.c bounds
an attribute length, against xdr_stream_remaining().

Fixes: 1be5683b03a7 ("pnfs: CB_NOTIFY_DEVICEID")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
[ sashal: adjusted allocation context to use kmalloc_array() instead of kmalloc_objs() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_xdr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index 505d195ed61dd..ff73aee4f72f1 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -272,6 +272,13 @@ __be32 decode_devicenotify_args(struct svc_rqst *rqstp,
 	if (n == 0)
 		goto out;
 
+	/* sanity check the count against the remaining stream */
+	if (n > xdr_stream_remaining(xdr) /
+		((4 * sizeof(uint32_t)) + NFS4_DEVICEID4_SIZE)) {
+		status = htonl(NFS4ERR_BADXDR);
+		goto out;
+	}
+
 	args->devs = kmalloc_array(n, sizeof(*args->devs), GFP_KERNEL);
 	if (!args->devs) {
 		status = htonl(NFS4ERR_DELAY);
-- 
2.53.0



