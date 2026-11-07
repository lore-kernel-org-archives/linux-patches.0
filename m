Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064097;
	b=zSRANbBBCb3c9dSGj91vd7GLZIckyxtOymXgGX72bXfmrSlUFqXWmb08RYDeJCZNkQtF
	 Up1hsYtUv1XmVRbNVKsB4eAjDwKXlpELyP5MghPQFjf0+Mo9tqfsf0Sqjw7qsmlO5YnWr
	 UKJc2q+MhO4CLsxbJXmViP7AU4QvIka85qRLa2d1+tPTos+jdcu61n3IJHCONOfRL5bzr
	 uBl1/hfPtYoK6Ucct/dyAzLWrcXB8li3ucZ+8aF03o9Wb3P/ePqKi3fMKVlPbgwIVhcDH
	 VeK+gf8w4AsygmTHk6hWQQwQ1k+8jbWHOsbDCUijCpXnZx8qfNY6O9Ns2zX60gmrdQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064097;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w3RuHhJIpmoxJK9yfggTTqDfKYKWI7N6G2nJBYPkKcI=;
	b=zG19BWEmG6jxqBlR0IcD6macYxlbc4RQ7ZBeoaL2UkN3Lw7mdNpo0ArM4ZNIFMP5iMls
	 HU6F133B+PtdCElThaEu075Q3qZrZAgobCLyp5r3kFhQ9doLD5dmOCpaeKcUaqcvMBdu4
	 FWE6lUHnMKlGpj5c4DLYD+pzsxGYyk6mF3LRWQFUbB/Sjly95rZizvFM8dBk0kNFzMTq4
	 RsRvYJ5ONivTzRxp00Tcl5zSFBWHIPshEtgLFOhUoL+deWylCTvHgDh+/eqSznJj5zKAw
	 wDhWXczPJv/eD1rmD/Z5ZDNCCZwQLXXLyRaAktPTQ28OV1noknTpuPk62BRcaJqXBPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a/oKS/8n";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA63606A9EE;
	Sat,  7 Nov 2026 15:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a/oKS/8n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C0E1F0089F;
	Sat,  7 Nov 2026 15:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064096;
	bh=w3RuHhJIpmoxJK9yfggTTqDfKYKWI7N6G2nJBYPkKcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/oKS/8nvbz6qFyoV433vNdXy72orJXZp7enUIjTRmAvhObFIUYZRb3bLofuc51au
	 5BJkD3Dfw+1qKCdo8X86xnKLYAHNQeCPeHCuP8cNN73Gb0R7uNwzGBeT/TqodBPWiy
	 oXN6HNzrkxeQHOh/Vn1n429USYQmNGNjPuU8O9ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0258/1257] media: cec: extron: clear response tail before dispatch
Date: Sat,  7 Nov 2026 08:42:34 -0500
Message-ID: <20261107134946.626924100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 3c6ce6f3d93e7..1f8ed7ff31e52 100644
--- a/drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c
+++ b/drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c
@@ -847,7 +847,9 @@ static irqreturn_t extron_interrupt(struct serio *serio, unsigned char data,
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



