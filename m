Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621197;
	b=hU38hAaoCjs6rfm0GTtKsr4oLh8ORbUO7w6s7m0GxLjT0LRL6zpYJFY/LNLXY8FBeGL7
	 eNZWf75GCrpq7xG96GlR+FC33ZF4EL1Buu7N/EWfHrn7Hc4eE+hlCRhlDvGYiZZQj1YT+
	 Eg0TirNLiRwQBZfkFBxHwfZQ5q3+hJ8BdCjsbKctQu/yqtt1k/GJWR+r8FzmTcuHo+px8
	 c9GXkFvg6QjeOZoQ54ZbrpMEvnro86zrEhU+Nr9RYzp70Pfo7FvvLuJul+bxnQYR0bqcd
	 TnZAKQX875QXbT6CkvN/TX93Xg0OCXtH36aakUM2lG6O0EJTQHRps7tgF2umc5T3UJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8h2n8HMgcVC0Mq1kDOd0JAo/vN5NB3OAhyAS72Dy1As=;
	b=SlF5yFuqCQmr/HJTL4z5z9BtHjcRShi4UjRkiuzcfWXBhsaeW8bR2kj6QrVkaniRqDGv
	 ckH03Ooviu80fvRtCw6wGFgO+e9EUQrsUpp0S4E9e2EHslyEVpWDbIF7XhV+dIhkgtyp6
	 pbEzDuE5Plfx9kQtT1i2oDnVhexBvW7owFTLxFqlZXByFXTUdHRWPrLUtWJKSbbpY3RG3
	 lRbqBmZL8VXHKyOaEYjrySeCXjYraWuBGw/Ru8Z7gexMsF48lKJAJeYCww9U12TLtnQv+
	 qcO38Xrs//RFiXYykgGd4ebcQYoiC0/vIXw7tBDYoHYF4uthuy1MspzsnyKBJ5ocfEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SJvBUV4m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA74360A3809;
	Wed, 25 Nov 2026 15:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SJvBUV4m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4471F0093E;
	Wed, 25 Nov 2026 15:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621197;
	bh=8h2n8HMgcVC0Mq1kDOd0JAo/vN5NB3OAhyAS72Dy1As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SJvBUV4mw3qGOlVhlrNKqSsO9BojUtZFdd2xXbzieOp3WUMGhG7hRzCYIt2epmGt/
	 h6ZInqHGmOt/20M8ISOnQMvhvm01pagtB8HGjYi8kbDCb2X8wrWI4w3D0OA6d+lF9S
	 7ddYdsHtRCIfpChtNQCN+1eLBKZnwAZK353V4VoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 150/990] virtio-spi: Fix virtio_spi_config kernel-doc
Date: Wed, 25 Nov 2026 15:25:17 +0100
Message-ID: <20261125143825.605525046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 62b0a9b11e94a4bc7f67c89348d0619cba82b54b ]

struct virtio_spi_config contains max_cs_inactive_ns, but its
kernel-doc describes max_cs_incative_ns. This leaves the real member
undescribed and adds a nonexistent member to the generated
documentation.

Correct the spelling.

Fixes: 6a1f3390fafe ("virtio-spi: Add virtio-spi.h")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260909064938.90995-1-kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/virtio_spi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_spi.h b/include/uapi/linux/virtio_spi.h
index 8ab3c970cdd31..459c2276c938c 100644
--- a/include/uapi/linux/virtio_spi.h
+++ b/include/uapi/linux/virtio_spi.h
@@ -73,7 +73,7 @@
  * @max_cs_hold_ns: the maximum delay supported before chipselect is deasserted,
  *   in ns unit, 0 means delay is not supported to introduce before chipselect
  *   is deasserted.
- * @max_cs_incative_ns: maximum delay supported after chipselect is deasserted,
+ * @max_cs_inactive_ns: maximum delay supported after chipselect is deasserted,
  *   in ns unit, 0 means delay is not supported to introduce after chipselect is
  *   deasserted.
  */
-- 
2.53.0



