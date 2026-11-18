Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057866;
	b=xB9cErOj+qsS9wAyAtu+Mks6F8BaQyt9HZaYaCGd6/wVHMI/8/C+BTOoYmnnBt2yF+NX
	 Hh+rlGP4tS7oIUh2aMddE4SnLg9j7Fn6cMmTG8Lz0hHrAba6nRKk1lplQKVvr+OOrUKnR
	 D7CeveKxUjXEK6wAxEjIRZFJnSLvmvHqP6yfHF2jAmUFwzmNrRI777UGXRVrlrGbF7w7Z
	 slZzykxe2Wlc2nI19Hb8Ll54S/BQdO+bUmPvf5A47CHifGLhxlz5w9jQn3kCtytUFmu+N
	 oxn4XNGBUzIB3i5ldwbg0KWS1JSyrursOiv7jYDPcMp9SE3i736uhcQU9tfb1IpKTfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZB8po5+LbHfai7WNMvAJtRPDYVJQ1hx2Lj/TSJlgX2E=;
	b=4XeJHEw3eWOqTb9UTnNBxWuJ0F1RGp+pncoB3DnvY/9hm1SDHgWyRDnUloaGkx7b1bq8
	 kzQpAKpB6WDi6gDeDYuNZsFbY4naWIE7FLi/bdpWkT5QZI1o/PVZH/C29G56mGcI9DVR5
	 nJxbj5PDPVQSMNUB0eHMY4M5MH08OY9nXaGcp9EbBNp5hPSRCo9YtaVDWopXFaXJUmzjc
	 RRX/HP5jtakSLb6KoAKjCzGvg7bN7gRulXteFfTmSTji242HpbCnUyJNkclcYadsDkbOq
	 AsjujS7A6jkWV9UrZKYlSagUhbkUzT6dtulcKAkXdGxAHG4v5JjQVnrt19qNfUm5lNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ubdOLWjk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3467606A325;
	Thu, 19 Nov 2026 03:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ubdOLWjk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BE91F000C9;
	Thu, 19 Nov 2026 03:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057866;
	bh=ZB8po5+LbHfai7WNMvAJtRPDYVJQ1hx2Lj/TSJlgX2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ubdOLWjk1ynF4+nYL138qpWahxtnj98BtyDaqXbeRpuTOWO9WldiIVcc+qWlU5mTo
	 l2SIiEJPHvUn5Bok+x8M1OwdNFQMy5wcRb890kjLlxA5O3EIWGs8RqoHVPNyy074PQ
	 4OOiwZSo35Cc3J5NaBiR3+DoOlSmnXjAPQ0htYew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 5.10 0282/1848] pNFS: Fix CB_NOTIFY_DEVICEID CHANGE to consume ndc_immediate
Date: Wed, 18 Nov 2026 15:38:40 +0100
Message-ID: <20261118145924.002184746@linuxfoundation.org>
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


