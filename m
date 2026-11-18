Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037163;
	b=tZ6XVHo67V/GNdGjC3ebbz3HlvtFKMCjHvtKfSAvJM9R7DXZcjLSWpUeYNFoVsB7d6tX
	 mt7jXCbapoA7aZXLxXkXFzo/bUsGyVZQOgrd2nyC0nFZnGGNvCC8+zY1OaUhXxWkfhppJ
	 FVXK0zhk5mHPdc6Z69jExy2O6dHE6zGdsEnooIkkP429pT44miCRQn8uD7j+oPIIzd+x6
	 /LzNySIN19EdtqMQYlHzYIZJlGx4xFyUgU9PEDk8Kh210DAOmrwZdlC3lBpvjdah+5veD
	 akxEBJHQ2aquSKg66LnQ2jZBys1TjP9c+PIu9BhLFwAaOR3eBhFtIVRS9/ZLV3g5aMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tp4SaUcKCs05kYSazHd3coClw8cVKYg3uCW6065j+Lw=;
	b=05D6G42kSYpxum7cj0THVbGJhky0bd+3Tk0PEX7MpLQrtiVElV99JwWqvNGi8t9upILX
	 J57PjwAA5MIyHNPSPTGoka4eKyxFBvmg/OmqbloKtFeGZYzNy120ofnh21Lm2deO9jICn
	 n/sr2XcLRe2BfiVyWHJYJ0ljzzY47qTu552nvYPRU4Giv4EvOprH0Cvl9s0sVqBqkFNyh
	 +b/UTJsi6jzrZ3xxjIRMIM3Is+5jNGztErqaXhsyJGwAYjfbXwNxL6E9o5qzMTGxsHtce
	 K01Va5nHge9MJu4/wugVD33rN+rUGjpFSe10jUy5bd9j6zIPfpxGlnjzLqS9H9kImlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r4tdiR5l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54206606A32A;
	Wed, 18 Nov 2026 21:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r4tdiR5l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BE51F000C4;
	Wed, 18 Nov 2026 21:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037163;
	bh=Tp4SaUcKCs05kYSazHd3coClw8cVKYg3uCW6065j+Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r4tdiR5lIqvE14qImYTmpMy0Is0cSZzouyNLl5utSRd5cZYTsLbt3pampRS1/llI+
	 6jTzpuzugWf2pnWJGCe0kHzV6U6RtVuqAkTYR6UMeFpKTNZ3wxIvH2Qy5ojXUsiFEt
	 aG0FAsUAP9SjLN0/C+SP/uCA51S4Nm2ce2axn+Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1316/3318] NFSv4/pnfs: bound the CB_NOTIFY_DEVICEID array count before allocating
Date: Wed, 18 Nov 2026 15:32:18 +0100
Message-ID: <20261118150359.787370984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9e6176ae9ca54..9e78f73474224 100644
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



