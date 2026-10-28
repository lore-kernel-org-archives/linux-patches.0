Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215592;
	b=cpGrIIFj90NQIR+p6NkRoe0PRcyctBBxPEhUUipXYW6+JZ0GnDAENbRM5A+jzc6MSz4d
	 DcrM2NQ7jqzsZIZCR0MQp55ewTusa0ht41faETU4lmgb9Q9WOFI2NOeChxaD1PNquFWjL
	 bIv6NOUPJe0ltL1HDoSMHwXKbRHSZKTOVXWMZT5rGcY0VDAolOcB/o7FgslAtaztl5LT2
	 6QOBH72CJJzs6jJZyf/MEoeM8S1X9L1OhRFkR+3h+HeFlLHXmgkhj9093iWvtnm5iCPit
	 nfjsXiNtI6x/7oYiCRQotMx9XIT2jfdJIzJ590SKeG2RxtI/Mk+EJQzqs1hUqs1o9VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6PdOZaIzJgLMg4gETB9Mwo2JFgBGBOsUDUasL2kYJ8E=;
	b=Q0qXGB6jsSfr21dsQRo1O7stzhwDw8nei8ZjiUejT4WZhkzkgaD/JNBgKeAw7rAtKFNm
	 5MLAN8n/PhEcH4bCG6WXQtzj1hwKPpE7IgZn+Nn6LDb+hPv3LrFafUWkuvS9zWQgI/riH
	 w53bh8fe8E33Z+sDgPHtsDn2/hbZBlOBD3KX/3s8OA6+umDHh1EoJ42mrQTaAZ1PlyfMz
	 YOZKEpYoNsKTbTSY1cEyFCvHxdeqNsj1xx+/lhgDYbO3idd8WHzgLz0qhO9vxJeQ+nN2Q
	 QNkwcRJfu5Qtcv3CYn84StSGXuYGRiQP1ArW5s02AZseL1q8o55bYAWF6XAwLVc6lPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TABG0aUp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40202606A31C;
	Wed, 28 Oct 2026 19:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TABG0aUp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D321F031E1;
	Wed, 28 Oct 2026 19:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215592;
	bh=6PdOZaIzJgLMg4gETB9Mwo2JFgBGBOsUDUasL2kYJ8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TABG0aUpG5Vq5s53JF/cg6fBSnoJx+1ouGrfOvpQ4WA90UywhRRMYmZBR/OpVpIxi
	 gAZyNGOSUc9zybXxerqtrfMLxd7q+ebqcjmkR4AlLEI4FiTmJYdSVIfPyOfVkuj6I8
	 Mls6XMXg4/wQceIHF1XA2fC7WJg9eU5wc05WuMWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianting Tian <xianting.tian@linux.alibaba.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1263/1887] vhost: correct misleading printing information
Date: Wed, 28 Oct 2026 17:55:59 +0100
Message-ID: <20261028170528.165884459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Xianting Tian <xianting.tian@linux.alibaba.com>

[ Upstream commit 76f408535aab39c33e0a1dcada9fba5631c65595 ]

Guest moved avail idx not used idx when we need to print log if
'(vq->avail_idx - last_avail_idx) > vq->num', so fix it.

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
Message-Id: <20240311082109.46773-1-xianting.tian@linux.alibaba.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: 09861858a683 ("vhost: fix vhost_get_avail_idx for a non empty ring")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 3cd58e9ae99b9..30d5969d9f547 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2247,7 +2247,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 		vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
 
 		if (unlikely((u16)(vq->avail_idx - last_avail_idx) > vq->num)) {
-			vq_err(vq, "Guest moved used index from %u to %u",
+			vq_err(vq, "Guest moved avail index from %u to %u",
 				last_avail_idx, vq->avail_idx);
 			return -EFAULT;
 		}
-- 
2.53.0



