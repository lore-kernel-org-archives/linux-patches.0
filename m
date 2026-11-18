Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053643;
	b=NNcxMYSTxceJYbZzGlGjOPCL5uc4U2cEKWyoSFrXGOE0evEIuWNzt57WX7d1iKcPm/nX
	 JgKJuI2RG5/ynv2TFOeT6nAPdQlRLViTiLBbN+FAUM4nFk4UuYv8kqiYFGinCalSEvWg8
	 qTW9ob0pdzollXEPCbenraeEg4SecutjjBjuPh43Obd92Ghg3vBGFSKULxWYwfTF+5xHX
	 0P0y4y26XX9KqjNTD3R4k8rQo4GoAonLtKFmajnyD9G798kUqO70S+1HMhEXAXVp4GmEY
	 d+TauOtEldNnygZFeId+lG2Zg9O3bNHhCtQgv00FRsuGOXY8Z/iY8UU1gzbyZhwoTuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p0tAEOvQHdb/9KxrTwcj2Lu2Exajn2LX+eQvWDpkbF0=;
	b=BhNQ5EVGpDuCjBjHT3643JvyhnV9Yd8CkHgrjw8TsHIcfuTppHktaILk75l+yJidvioG
	 1st3EhR3BOr1dCpApnLg+O0cDSKf9bulRvjTyRqBiYkO0NbSi6Lz+7k0C1VoXiS5oEIj4
	 t/nhGpKMhKRzPew3BF29ANawOwfwckocz6XK3u7iEFSSova/8BbGMpjSYU/8PU0nfFxJE
	 1qRqAoHfS2UYRijG3/bEgVf8AJl0dLytzATUGTtZLs4L9w2rL16MZx9R47AWdx101Fz0e
	 uCWKm/P6pUB06pWiAFdDApenpjq4Nh+uNhPXFQn25h6NB74Rq8sMILlJO97i7TSdC2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ymMQMtOj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE79E606A330;
	Thu, 19 Nov 2026 02:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ymMQMtOj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4A61F000C5;
	Thu, 19 Nov 2026 02:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053643;
	bh=p0tAEOvQHdb/9KxrTwcj2Lu2Exajn2LX+eQvWDpkbF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ymMQMtOjY/xsIS7CB1LxhRK5VoY/2ykDjJ3N+fb3JQshXGKpXtty+gyWZX9spr0QQ
	 0w6nQIVU3Y+09INSd5bNRi/gVp9KlXTFSK+tDxW0MtQfVQVL+aSzxFSKrQiNqhMhIU
	 Hbr3mbxHLyTafQ0Wy9MwTrTaWOKuQXdh1GZKWmpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0993/2214] media: redrat3: Error path leaves device in transmitting state
Date: Wed, 18 Nov 2026 15:44:29 +0100
Message-ID: <20261118150052.094502641@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit 8024d5e84531d828535365718278f1cf0ce67db0 ]

In the allocation failure error path, the transmitting boolean is not
cleared. If this error path is followed the transmitter cannot be
used again until the device is replugged or the module reloaded.

Fix the error path by moving the assignment statement.

Remove the check for the transmitting state in transmit, since rc-core
ensures there is never a reentrant call to the driver transmit function;
the transmit function is always called with dev->lock held.

The transmitting boolean is only used for interpretting firmware errors.

Fixes: fac59136bc22 ("[media] RedRat3: Return directly after a failed kcalloc() in redrat3_transmit_ir()")"
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: Adjusted allocation context for kcalloc() instead of kzalloc_objs(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/redrat3.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index e0a59a2b0f995..f095ad8d74370 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -773,17 +773,9 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 	u8 curlencheck = 0;
 	unsigned i, sendbuf_len;
 
-	if (rr3->transmitting) {
-		dev_warn(dev, "%s: transmitter already in use\n", __func__);
-		return -EAGAIN;
-	}
-
 	if (count > RR3_MAX_SIG_SIZE - RR3_TX_TRAILER_LEN)
 		return -EINVAL;
 
-	/* rr3 will disable rc detector on transmit */
-	rr3->transmitting = true;
-
 	sample_lens = kcalloc(RR3_DRIVER_MAXLENS,
 			      sizeof(*sample_lens),
 			      GFP_KERNEL);
@@ -796,6 +788,9 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 		goto out;
 	}
 
+	/* rr3 will disable rc detector on transmit */
+	rr3->transmitting = true;
+
 	for (i = 0; i < count; i++) {
 		cur_sample_len = redrat3_us_to_len(txbuf[i]);
 		if (cur_sample_len > 0xffff) {
-- 
2.53.0



