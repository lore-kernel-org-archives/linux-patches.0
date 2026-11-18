Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044523;
	b=PA+bPTLRiVB5NYylAxhF34pbdjXvpbEuF76YXNptnFk10wP4bNJPDAJXal+dB6shPgTm
	 VXbCngZPm9GwPeMSRS7UUsV9mCa/IgxD1vHtSqmdQqLeKVdrPX9kpl+LaFlNGtJY6vInf
	 5182wYiymsiqvszBeEbYaFXvvvG8pPD5zbfITy/cisQH3egpULDO7KPVLLCuucxvJeiH8
	 mOL7gfzZTp0AXa1IyDLwQmH7YmZMN7p5lOOd8Mj+oft4dRg/UL6nRuekkgY3JuLJMLiij
	 RLe/GpYWg9cGnJwcIdx/v8MOVDbO+ozsY1n8l4xNCE30KEqWIT7tjLLnGabAyd9fRzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AxKMEf12t+ggTbxc9Vv2QqG9qPT5akP7RVtJAuen0Aw=;
	b=Il+pMKbEo5aYfyHiEaZuA7BzGcSDhxoE9ebZHEeOdtPD+1ulOr9P5VGK/EmehYQpuDp1
	 MhjVhxA/PGSBhKzgogwG+oNQ5p/SFcL/+7vbxiyWRDzAQ4Ax8afEao3bRo6MaDApq1Dg2
	 EzLAamSNJbxPKrlYGeuZVf2Uh9gu8RpC5PO/fHzxNpKD3PvWWJ7TCGkqXQaB79aKUnA1d
	 pb3I6xGoXRX4cXwKAoVXmBvi6H//XdKADj/teCKp0/r/OLBqvWILj5XlFGFCWgBfip0AE
	 pIBjxwlKhdyBrIZv6TZA6PnfZ5mTXwHNsMgKIoEhD/ZapC5PXJXJ3ML9eb1Zkdc7ikA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sMGkSMcX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD188606A32A;
	Wed, 18 Nov 2026 23:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sMGkSMcX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AEE1F000C4;
	Wed, 18 Nov 2026 23:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044523;
	bh=AxKMEf12t+ggTbxc9Vv2QqG9qPT5akP7RVtJAuen0Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sMGkSMcXxe7h5F6+yiuE7/Xpc1k4RuOFu5WZ29H/YCTI5sI6BX3I7d4JoOM4a/TGV
	 Dxdfh4IAlUoVTttqJM5go86IpuLgd3BJDB1QWjyBpGJPw9m9jG9Iv0nTio/8KlyQXR
	 wyB/d5KYN37scUovFSahfdE5X22G3LqnfzQK9PgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.1 0598/2857] pNFS: Fix CB_NOTIFY_DEVICEID CHANGE to consume ndc_immediate
Date: Wed, 18 Nov 2026 15:27:12 +0100
Message-ID: <20261118150223.021574036@linuxfoundation.org>
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


