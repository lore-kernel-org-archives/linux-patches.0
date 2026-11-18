Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051817;
	b=GBZmrmaR6i3IVYrCpse9CRB7cAUYE8xAAlzszoMfaWLjq3Dx1WbucubyifXSlI8CZtdd
	 sPPFMFA5d6bYQCQwLXzct9KfzepXCtaxYp4gtfLn92Gmv3qvcBE9aMHfggsyxwYvBIZqB
	 dn28CJUvLalHdFwlixQ7n0nxG4o/TONf5sDR6MSo1sQRhr0mNFDprSCQmSYGOQ1OgdHbi
	 +ThmUYiHbeRMJQLdQGBySMgcqep2bxfSM8X3nKOZI5EBDTX47VHuRftyjQ/EKVQrn0Z/A
	 GCTofUfhHCKfU8UAXV4yoYKZgYKA7xKg0iGik5NBlRkudyE1EPc/7SOsoPPfLZ4Cy0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V6Xwf8QM6PNaMlgM+EQc48g5sLpO++DAHAYBDc6GbwQ=;
	b=hOXNu3qyMDr2884ySHXHoBcR98COhvDmG0MAFPWJ9dd2/PRFFKor8VmBFi6wzg6rrJx7
	 e7WB3qrzYWEcFN1QE6LEOp1FORhKiMEzrYDmxKHxkGHJK2OXAMrdtvavNBh8bnnat1xVn
	 oLn2hYpcNyKZgnnCa9noXpaUw4vGZRZsh4qUl6PZCbX07SM/lvuaWrX1FncoUGGoW///t
	 2xyTW/UJmxKdB2/QwtY8rHiFjsJnlyuihTIuI1mwAVnaWX61K7SLI3u4BssraxIoE0uE1
	 y9LkFvxRdBpxezcsTWzfiM2p3xKcjSIS/ThmO8/W0tGEYZz7XwkpiPuONzgxsh3W3gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QEi+mkSq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1785F606A335;
	Thu, 19 Nov 2026 01:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QEi+mkSq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8501F000C4;
	Thu, 19 Nov 2026 01:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051816;
	bh=V6Xwf8QM6PNaMlgM+EQc48g5sLpO++DAHAYBDc6GbwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QEi+mkSquX3NeRuYKijT6bCBmK0vVyHHFM+2TAAQvQ8kPf14Z0F2ae7+mev7PLq4x
	 4RUOShI5rl7cq+Pe2IMDnCfgoR5zz7gpEmX6sEtGDGtFYKUG0nNuhtJAWgAxIjeHf3
	 KNRndTCgR0Tnv8h69NhgCTYy6jrEsietJ+fTGER4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 5.15 0342/2214] pNFS: Fix CB_NOTIFY_DEVICEID CHANGE to consume ndc_immediate
Date: Wed, 18 Nov 2026 15:33:38 +0100
Message-ID: <20261118150024.360923489@linuxfoundation.org>
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
@@ -313,7 +313,7 @@ __be32 decode_devicenotify_args(struct s
 		memcpy(dev->cbd_dev_id.data, p, NFS4_DEVICEID4_SIZE);
 		p += XDR_QUADLEN(NFS4_DEVICEID4_SIZE);
 
-		if (dev->cbd_layout_type == NOTIFY_DEVICEID4_CHANGE) {
+		if (dev->cbd_notify_type == NOTIFY_DEVICEID4_CHANGE) {
 			p = xdr_inline_decode(xdr, sizeof(uint32_t));
 			if (unlikely(p == NULL)) {
 				status = htonl(NFS4ERR_BADXDR);


