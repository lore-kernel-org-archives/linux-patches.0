Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035374;
	b=OB6bwMtYrg0IGhv+KXGSWf2Ok40/682PPqdqIPPv0XAYD7ria26lp2J+0JceTMc8tHVw
	 YUZMX7bYZOPitITwdjkDcOLBp7JZoAG5q52UNe1MRG86FzgtpvQdX/UpS6T+pOrOOSQP4
	 h9i61WHhFwmDE5pSHc2XtjQk2xPJhcL78qQ/6q1DBEeqOVu+BETsvAj0ncQFfqDrM3A+V
	 0JKMpmGbHA0eObxCQqwbHAbTAzGrSDQCkFKb/TVwU1WZb8ax6KQqNI9umVnCkDZvad7Tm
	 F6Zx+ctyFakG3cye8lvgV4aM6eJbVZaQWwDu/Pm39bAE5u1JY0P/rj1+qkKeNeOw8Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0jT2pHrEVFihbOdSLTbTrt/r/pzfvqJcexDA72smHZk=;
	b=1R+RYdf5RjVs/pD6QBUR4vusKMTiAg7gOOYYJHcXyeKDMiApOW6nQ4CXbt1agDMFDBes
	 jb61pR4ABcchSTHEEirzBtzRLscbFhNWbD8uQFU6ViZ3EXZUUPcdjTWjY9AHZkwLCubVq
	 m0X8jRPOh6RHzkP5XAt/IA5/2FVqsCgKMt5slzuTbYrYMLA9sZ9O6uvhqE+zHpct9gVHU
	 np8dLFDEBbygwnjWDWoz7HUbyJJznAPXNETi4N3ShXesH6I+/MlxO0/ZW1gYjyTs25lD0
	 bWB7xIeIWQTvsRQ7IFROPCc5VR252PjNIHpQ5HxLZAA5xYBi9yoRxWoeptV0PO8xDZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SpDkUBy9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5955606A31C;
	Wed, 18 Nov 2026 20:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SpDkUBy9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9AF1F000C4;
	Wed, 18 Nov 2026 20:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035373;
	bh=0jT2pHrEVFihbOdSLTbTrt/r/pzfvqJcexDA72smHZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SpDkUBy9E5qj3ECLeELDoTsTakjX2g+LvFIJlnzbxkYfQAIdCmfS0nKJwdD6344wf
	 hsPKe6ey25KRTWkYzxlY9rWU5yQmrK/XJKPKSNflO39FDVr0UtLgwQXmNXV0hoyXV9
	 MMgX0GZbvovavY2nM5zTwj57XGh8u/d0Uhzob3fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.6 0680/3318] pNFS: Fix CB_NOTIFY_DEVICEID CHANGE to consume ndc_immediate
Date: Wed, 18 Nov 2026 15:21:42 +0100
Message-ID: <20261118150338.589416154@linuxfoundation.org>
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


