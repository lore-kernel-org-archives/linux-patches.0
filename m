Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618039;
	b=gvAkEUYe1IDXUWMrWV3IB5pHdgBZiZu8drHu2y+G+h1G7cxSp5wzP34tKC6ycfTC6/MH
	 aGeVcJuMbzmvKZAKiHKMX7UfDodgGvpfJwWxIhNrlEdR06wdyelgE2DgKK6tjf3utgGMW
	 ZTIExGYzieNVJug/0zLQda77A9TSt5hyjC/qszFZaiU89x53gNI7efj0QaUV0iMdzJrxl
	 3piEyOy6j9p00Yy5k/FmoVbhLdJJOx1JHfomlpuBAT7vTzM60/Zptju/TDPBKcRRvm8Ia
	 Z1b2BwWx09YAiEXkd5ANacdYeADEjv81giPa840z3h9CT1weG0MbmmHXBbzY0XQa91g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vgRmdtJgqbMraIVSxm3SO6AqGloA+IeH1Hbp3ewLnqs=;
	b=gn2JKGOpcBGTomQsDBp6s8f3hWmqaB+jFCeqwEpQTUkq7C1T0mOBxes0K1cofv1zz4hw
	 37BUEojHdNmOfilEpz6JxU1tR2HBAXCCcaGE2PetN5ZF/5KGP1zwfI1TOThRNI1TQyeGg
	 bcBQpsP+hz/abESW9f3QJ98lU4e5tZal0nq6oqGKJNPX3m0m0v6YS9vXB4amKLMqc/KTj
	 hhXs4Ww0X3BsgpCXYVbh+XdgYr/2uUVQQredWOwzGZCBq9JTTzWLliRKt4T7kUSfKJvrN
	 9j8X3YIkh8hlS7pWSAn7iGN3eV78LuJxy3DaiGeUj27cOdLLl+ySO61oSA61mwPvopw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="R/EcXNCz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260B8606A321;
	Wed, 25 Nov 2026 14:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R/EcXNCz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E981F000D0;
	Wed, 25 Nov 2026 14:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618038;
	bh=vgRmdtJgqbMraIVSxm3SO6AqGloA+IeH1Hbp3ewLnqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/EcXNCz+2PcP17qtBzMDf/HZKDiGAL7gTGfMG8DZizCQ2YlV+lYxAZfgpzk7yAOj
	 NcvdUoQ8vdXPkRFbzqYMlUOP3wdhTgQ1gmCa/cT4bNJMXNs0IIHvf028MFseTcx2Kx
	 0fbzBjyhc+wlKNhmAmkuiravnCGDZq81Ug4OjtR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0152/1005] virtio_ring: reset IN_ORDER state in virtqueue_init()
Date: Wed, 25 Nov 2026 15:24:50 +0100
Message-ID: <20261125143825.293875489@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit d7825623a9d4452f97da7ea0d84b2967d507ccf9 ]

The IN_ORDER feature uses additional software state to track the next
available descriptor and in-flight descriptor batches.

virtqueue_init() resets the common virtqueue state, but free_head and
batch_last.id are initialized only when the virtqueue is created. When
an IN_ORDER virtqueue is reset, these fields can retain state from the
previous queue instance.

Reset free_head and invalidate batch_last when initializing an IN_ORDER
virtqueue. Keep this in virtqueue_init() so the state is initialized
consistently for both newly created and reset virtqueues.

Fixes: f6a15d854986 ("virtio_ring: add in order support")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260910123903.1717-1-lirongqing@baidu.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index db678f5a80e03..d0dc4645b5b37 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -559,6 +559,11 @@ static void virtqueue_init(struct vring_virtqueue *vq, u32 num)
 	vq->in_use = false;
 	vq->last_add_time_valid = false;
 #endif
+
+	if (virtqueue_is_in_order(vq)) {
+		vq->free_head = 0;
+		vq->batch_last.id = UINT_MAX;
+	}
 }
 
 
-- 
2.53.0



