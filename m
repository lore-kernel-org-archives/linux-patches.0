Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053049;
	b=G3qkR+2Cnp/cexzT1n6pB+i+Nv0qCYcZlZzU0PjDb1zD+yqpMv0oM5KgqzYMxxqkxVTq
	 WHtUhNKB5kKTHGGZHOcecG0Bf4z2Wc/IxF1AOcxc8ouT9z/CdB/c/IODh0Om03Iwykhz6
	 NDgpFnTgaqN62ORU7juh4LFrQ+fjer/wEgQbaeVa/1qD4OlL9OzteZSnQEjdo3ISi+VIQ
	 kUP5G6aMs/UUjZvPjRC0EW4Jvq4yqMBJNgxLL0+C8imiT2V7dgQS+i+PNMESA+Zwblfap
	 bW51fOyh37CvBvKDVcqB4IYwWfbA7EgAbjAmQE2hdJWtZY8HjoWvD66ramP2h4TbsAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MTBYkE1juwS8PM2krRA5uaRPwPLdk3jGYUCqKVZWrZ8=;
	b=pX6YvMN/5eFt/zq/Lb23Y8Qu1vO9BxguQk0ntxQ89ygcvMAJ9cztH2CwDIdODwh9n77a
	 IF37RFKkxuArsiaTy/grMCrz346ZFDdMxUfkp96wheGVSFn+Bh6wKlPGq9Qwass4BgbsQ
	 4pKmB0OPsmPwYp3YA01iTy3E5fhmtsCJqA/Vjgy9F9vSLq9B6ihHnuXCoAOhhoOLzFQO3
	 kKvqduVaKz+kNuD2Oq6Tx35WXAjzQ8Xz+cb1Nr/1Ndk7ZAJ/cdaWpenthrV3Vkx2pbGc1
	 WXACW6K6SDyNa6vj250BgXLusl9EOx4wi6cLy+Mwh8MUMejjeIxlO7l20+4xIgk4QtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FoZhhfC1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA53606A31C;
	Thu, 19 Nov 2026 01:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FoZhhfC1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BE01F000C4;
	Thu, 19 Nov 2026 01:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053049;
	bh=MTBYkE1juwS8PM2krRA5uaRPwPLdk3jGYUCqKVZWrZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FoZhhfC1wSURcjJpbin5Es31F26VB8iiEbBDToveoMW4UDm6xDtizBhS+WiCLrPPj
	 jaLYVLWj0WD7v5PwDs53TjPh9hlMk4Mm5P5oW83cOepkz9jdetlhaAr6jf9tY9rDD3
	 +wuQDUOi+jZwNNEJAZe2pL70v8E1+IhlVq2L54qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0779/2214] NFSv4/pnfs: bound the CB_NOTIFY_DEVICEID array count before allocating
Date: Wed, 18 Nov 2026 15:40:55 +0100
Message-ID: <20261118150042.797077255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for kmalloc_array() instead of kmalloc_objs() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_xdr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index 6501459af0e57..29e43101b7158 100644
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



