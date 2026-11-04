Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831720;
	b=1+uSnFiQcYEPavGo+oSucL//kBKQFasPJPNbEiUvh9/sb6xfxXZAuqSOqBysl9J4PB89
	 Dk/KbPYY3fTFhZoTFF/4VgTmMy7U3Ta5vHmKqhuPk9HU+uzQT4oXkjptoqALXdltR6+np
	 Syz6q35dqBjayRYycLT2k5Oaao1Po15iiQ2LL9vY1qbiI+fFTKoBWNhJVy4nF0pnIdwo6
	 Sc1Ti867mhPxz7kGp5vOroQVOD97WzRI/9pTCl0PTZ9hMjG4S9fxES+XOzZpy1Hf0++s0
	 hIT0zWi3DiwOqOP4HRJuE1FgcEvzoB3ax9eo1I2lwNU62iIiUAjIP5Dn0RUF8CyFuNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/WYQXUusDEJy9DVm5jnCHrUtEW2Fa/TpOLZRKmqyPJc=;
	b=eo+r04nt3g4FlTQmP5dhRjz6QJ0SrJlFlf/PU2vWl8dWcTlik8KMLStTIkxcYBKWycby
	 TKedyHDEl7II/UT768L8pk1iDVctQe1QbmIaC/MdZlE9KNOxMAvcn/MXrxO5RZloVZ7kD
	 Yl1ZAXE79MtBl3LoqmgLk6galDmcjeP6g1aZFqQlSaZMGO7C1pfIEHgB7LBWXhfjlxdNa
	 puNbC0PZFDMQwcODgHIhYodtv8u7pSWPiup+d7D/Y+7VL21Sxh+ymxxyUH02bC0Ncblk2
	 3emGdLpmM2bCxuZ+MgnvTCP9iFtbDMkeDmRkqyPXvLCjoDIshJsh/Dvt6c4ztCC4c/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kcLTH6Z5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EEC606A846;
	Wed,  4 Nov 2026 22:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kcLTH6Z5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CA11F000C1;
	Wed,  4 Nov 2026 22:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831720;
	bh=/WYQXUusDEJy9DVm5jnCHrUtEW2Fa/TpOLZRKmqyPJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kcLTH6Z5NSQkTxz1JunMkckhXQA0GlS2S/zlL1LYZHfHqUOmtYJm4q+CAvKUAfh49
	 pulbmgjVe+oGFCY3+rVmhJ5pclSh9PFkPSZMxJJwY9HbGSGIEt7EYIDECLLm+Kahc7
	 utCbVgtE+DO82xTE8iwU0FOActRhmYGz63/ECZGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.18 0872/1005] pNFS: Fix CB_NOTIFY_DEVICEID CHANGE to consume ndc_immediate
Date: Wed,  4 Nov 2026 16:10:05 -0500
Message-ID: <20261104211107.687507259@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <ben.coddington@hammerspace.com>

commit a0cb76dc3b2919af8257fc08b4f9a79a35442483 upstream.

decode_devicenotify_args() gated the trailing ndc_immediate on
cbd_layout_type rather than cbd_notify_type, so the flag was never
consumed and a multi-item cnda_changes<> misaligned after the first
entry.

Fixes: 1be5683b03a7 ("pnfs: CB_NOTIFY_DEVICEID")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/callback_xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -316,7 +316,7 @@ __be32 decode_devicenotify_args(struct s
 		memcpy(dev->cbd_dev_id.data, p, NFS4_DEVICEID4_SIZE);
 		p += XDR_QUADLEN(NFS4_DEVICEID4_SIZE);
 
-		if (dev->cbd_layout_type == NOTIFY_DEVICEID4_CHANGE) {
+		if (dev->cbd_notify_type == NOTIFY_DEVICEID4_CHANGE) {
 			p = xdr_inline_decode(xdr, sizeof(uint32_t));
 			if (unlikely(p == NULL)) {
 				status = htonl(NFS4ERR_BADXDR);


