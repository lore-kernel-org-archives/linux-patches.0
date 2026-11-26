Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704258;
	b=kSlxIH/bM66tBUekw/8a5X1bMzia8Jd+7iZZY7mM5EWsXKc3e2Y+ewaz1bpp71Gww6kH
	 W+1g3HlYsVUzl/O1XpUeE8/QACLTz+MRGJa/PCooJCfFdsCMedEKKXju6dWNMQgAnOLVR
	 KMchHIPoezDXTuwF2Qw8SpZ2nGkZMoygVAhXg/wtLL0kNnuX7CBaR/OT3pdPE30d1xtu1
	 XA6egmS66Nk8WkW1NyaCYkoNzWuEC7vnhCM6ykFm1/gEiDpHV5xvdSGnar7lSauUIASih
	 xxf10PHX4efbBwyHiJ+PhUqvKpu5U4X6R4gGttWSZIdRDCVD7s88/NO0yUO5hduom7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JedIdT+vcKNzs1/0WphvkI8aYgDR0E80NZVfXGHnoI8=;
	b=tUiNy+P7tddQiY4L+AIfq3of/QWcPLUJxXG79F/mVTlj7HkZ26kE9mBDJx893jalU4Bh
	 8Mt2MLyr4SbuNBbPKY+nwoRdrDXY5u+LoRt7p7HObO0jwj/WTdl9IKosX0odAI5ial9md
	 dGcG26Oavv6MUAkA0XMQtEg7EtSJbckDqmtoTUZRM5n3mcMARI1XgfTWQ+nB1xZRrCMKC
	 zIH+alLw+YdHCCQOz4jienrVQ3J67GWdKXisHxIN1Th6TdF3IL803hk23VXyl8a7pnjMN
	 oRnIq52ezwKt4uwg5xtoicbultrPpchHo0ZH2nT4jxdrjLXyhUYYOpAd50SPc4ZiqVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UuKfQqlU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249DA606A31C;
	Thu, 26 Nov 2026 14:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UuKfQqlU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D7D1F000CA;
	Thu, 26 Nov 2026 14:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704257;
	bh=JedIdT+vcKNzs1/0WphvkI8aYgDR0E80NZVfXGHnoI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UuKfQqlU6pbUFBKixyoXUJ/PU7WCsiu11n76kagFGFRJLtYgL+27AaEnSqV/GhFg1
	 u6qF9HKqI/ks0Qx1n7REwhJdPWnl05TpsRzGCnV/mN8BuD9KOAiV1fgOWmy5sVk7eB
	 E1L3MCQezwwis8JgQFyXFl+wVmKZcUfPCrwCbMqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/265] vhost: reject backend enable without a kick file
Date: Thu, 26 Nov 2026 15:36:32 +0100
Message-ID: <20261126143609.422980635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: Linfeng Sun <linfeng.sun.dev@gmail.com>

[ Upstream commit 509f6bd229e94fc39506e01be692c4aa22338b49 ]

Enabling a backend without VHOST_SET_VRING_KICK dereferences a NULL
vq->kick in vhost_poll_start(). Reject the request with -EINVAL.

Fixes: 264ee5aa81ec ("tools/virtio: Add --reset")
Assisted-by: OpenAI-Codex:GPT-5.6
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261011-fix-null-pointer-in-vhost_test_set_backend-v1-1-60b2f12d64c6@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index a09dedc79f682..e68611a566272 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -288,6 +288,10 @@ static long vhost_test_set_backend(struct vhost_test *n, unsigned index, int fd)
 		r = -EFAULT;
 		goto err_vq;
 	}
+	if (enable && !vq->kick) {
+		r = -EINVAL;
+		goto err_vq;
+	}
 	if (!enable) {
 		vhost_poll_stop(&vq->poll);
 		backend = vhost_vq_get_backend(vq);
-- 
2.53.0



