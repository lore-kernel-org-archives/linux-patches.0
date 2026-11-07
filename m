Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062940;
	b=4VSRSV9QQA29EVU4oOVGx5tiAvrLu6giJCvxpbaGdjrkZ/pHaGx5nQaBD+/N3jjGDfqK
	 tqhjgEBeGccBg1GnpAwMzV3ZKFrjrZD+3hnAtpxYG13r+zL5eVAe8+pA2snScQprcAJfC
	 1jCU91V1TwNPeBXHQN5GrtH5c1+jKPFsHB43IKoU25AjYGC3QA/YdzhN10/cof0I68iJ1
	 Lsn/w3FSQXWTHMKptVbTSLIFl4KGc1j0Hgzg7CAEqAt4+dQk1l0bYLY/EJ6S+O+IXVGyo
	 DN9u2xRK87neBsC/z6cedoJWDMxxjgEHDbMMx0SDCuFMdvrGtCfdkl6oyqJPFYo5AOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yIQ6qtXT6+utuKG2nxErFY+3fomT0wKrKl1Ze0WVAcI=;
	b=r1WBKIUIef/4CZScKY58ndcVVn267HMqKmt1t8xm6vrgakWcW0qXhQkK5aqL7JYlxLuh
	 ih18kgz3wQrwhulYxt+OyJqTQeAkAl+Mc3/uPZC3HeukjK460k0t+BAb8ce3XhC5fdCIj
	 pi9TbtXQOQ6ec3bW1G8rhMDRIzxJDtvH2z/D1XPAbg+jZSgD/27sjkDQW4Jul52VHwE9F
	 dkK+jE3yx12wG3uP8dvK0EffG8XvQDYRjPxjRXRLdKq/ubWfv9n+BF3FVqLxT9LujTfKn
	 WjsnDyKy8ZAheeBTkwD0R1ri/eKsIZqx0Ef93AVaYFR+yBNl2Gamh+rDcPnOqo+3Fig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2eII3x5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FACF606A326;
	Sat,  7 Nov 2026 14:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2eII3x5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7A91F0089F;
	Sat,  7 Nov 2026 14:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062940;
	bh=yIQ6qtXT6+utuKG2nxErFY+3fomT0wKrKl1Ze0WVAcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O2eII3x5G252stLdBs7QajOZQeKaE0pVsdKJJfI420hktOZ/bMCqC1mPnLZ2etwE8
	 ou1v5PGMFnJc1e62//Y7C+VWKxkpQmLT3YjqKormbJXYgZzadzKa9A2F7xMTNepyUJ
	 KffUrFSQwf2g8WI+kLICY+PcsoHuDvzsuier7nQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 208/869] media: cec: extron: clear response tail before dispatch
Date: Sat,  7 Nov 2026 08:48:10 -0500
Message-ID: <20261107134859.030958529@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit a601427f03e015e3d4d2ba44cfa6e0de144983b9 ]

The serial receive buffer is reused between responses. Terminating a
short response with one NUL leaves bytes from the previous response
behind it, while the dispatcher also checks fixed offsets beyond some
prefixes. Those checks can consume stale tail bytes.

Clear up to ten bytes at the end of each completed response, limited by
the remaining array capacity. This includes the terminator and covers
the dispatcher's fixed-offset tests without adding a separate length
condition to every prefix branch.

The issue was found by our static-analysis tool.

Fixes: 056f2821b631 ("media: cec: extron-da-hd-4k-plus: add the Extron DA HD 4K Plus CEC driver")
Cc: stable@vger.kernel.org
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c b/drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c
index 48410ce33490c..638def4cb5691 100644
--- a/drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c
+++ b/drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c
@@ -846,7 +846,9 @@ static irqreturn_t extron_interrupt(struct serio *serio, unsigned char data,
 			return IRQ_HANDLED;
 		memcpy(extron->data, extron->buf, extron->idx);
 		extron->len = extron->idx;
-		extron->data[extron->len] = 0;
+		/* Keep fixed-offset response tests from using stale tail bytes. */
+		memset(extron->data + extron->len, 0,
+		       min_t(size_t, 10, sizeof(extron->data) - extron->len));
 		if (debug)
 			dev_info(extron->dev, "received %s\n", extron->data);
 		extron->idx = 0;
-- 
2.53.0



