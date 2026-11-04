Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831515;
	b=uBzjcFdsEEbey6fFe5fZ3huC4Q7rosnvUnBk7Ibv+/0GN0MLwRuMgawzsYfbtBNuWw8x
	 lt4CBVPtELxRxQLsbb7MFPgwTfuPG7aX/Wrx2EcSw6LBvq8dmrRD8I8vV4VGOyeo2/TkW
	 5EV3DDNkgC8svU4mNsmjFxPITH8Lwpk4UQwpjERu8OOotiVzHN/iYpXyovk3LscuEVQ38
	 TS5/+/inw0GNVyqIDeTAGmX1Gn4kkXbCFjHC9oW+S+k3pqHyAjIH50C3nDVgMABvrRncK
	 PrvyCZzl7Iqxgh2U8PQ0UeeOj/Bp+UMgF7I3XGBc7fklmxot+kH6tekjQl3gRzkt6iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NoScHT0Q22WEE43M4cI71LbUIrfpSBPmTRtdYaS6E8A=;
	b=y4BLNa1GYKX9BZ3L63ZDQZBUVX7lUg2p20wOX+JSlt8kSpDFfWLgKK8cszvKRE2Zb26i
	 qp9oBLyJX65B5GHGQ2gY8oc4IpPzIg7Y8N4iiY5VlOusrlyu7nqZZeLg2dIYPngToepM1
	 hxCQO4kwOqrdFGzq3DUMr2zPb+fQCSP0E+tJAfetEPoFb8LaZzgdnGTbpGLaaIW1drmkW
	 eubj6GGlA61nunwXvWnt6LO2mogNn2eNuE0XacnxjUmiquE41DXfHxZSSMo6gYzTJ9Ech
	 hOJcvioLRA0P33d3ZgGy58LP5JKWMQ6+NR4FObZTn6DdVlnZcSJtXcru3RuJWvm8KCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SS5Pn16h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B870F606A33A;
	Wed,  4 Nov 2026 22:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SS5Pn16h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BAF1F0093A;
	Wed,  4 Nov 2026 22:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831514;
	bh=NoScHT0Q22WEE43M4cI71LbUIrfpSBPmTRtdYaS6E8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SS5Pn16hoxcNdCeIMu7/zkoxhAlgTgzwmkV3/vlJrvSOdrp34AuEWcb6EAodeyvDJ
	 VnpCwBZmFMcf9KVPHvEkl5HCfZC4CtCqCorJf/Jdfkxh2yscOK4BHzqE8QFu43XAzZ
	 Enj7zNpMDigyz5pECMxmw1qLsxxiGqU5ITinmdcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0749/1005] media: rc: After rc_unregister_device() timers can be re-armed
Date: Wed,  4 Nov 2026 16:08:02 -0500
Message-ID: <20261104211104.437997778@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

commit ef41a67979aed4d7d4f393c56c1e25b6754e2b78 upstream.

If rc_keydown() is called after rc_register_device(), then the timers
can be re-armed. Delete them again for a final time.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/rc-main.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1742,6 +1742,11 @@ void rc_free_device(struct rc_dev *dev)
 	if (!dev)
 		return;
 
+	if (dev->input_dev) {
+		timer_delete_sync(&dev->timer_keyup);
+		timer_delete_sync(&dev->timer_repeat);
+	}
+
 	input_put_device(dev->input_dev);
 
 	put_device(&dev->dev);


