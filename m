Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624444;
	b=XDFHXGMv74bqXt1R1ZVIbrcKMdQYiEWkUYu3muDeGLDDrchcb97nf4J34DXWdp4vqNR/
	 7gHeAOBvwvvaqCzxaP/apdM1clnF/iHvA08UMbmblNVHPNdX11+MLClV+/axRmShbMnhd
	 StUHAtkSGFdXT+9TY4OGL1DHrD7hWGN32XNgUoNpMKhkLeLhzCgdi4T809bN7UVXW6192
	 bVXP6RPXJuBT4s1QMMjWnycdLr255o48EIQXsNy9IZUgcAW72zcUbYdvrA1WKF49+lITP
	 CAU6XIvmQtN9clhLaNY5DehCqdqgWC8GhLOxuJXFF65si8iAn/2aZ/6ZDLwY1EUnrcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jzOAty4PMYEreFlOT/FD/07/F1n+7/2kg3iKGZwk54E=;
	b=EYAxBj9m2AkNGvOG6I9C8/WO2/qhoEti7E/sRJCQGZP6BrU55WasLuVmeGRVaYRh15T8
	 eEqrVPVMTDcHfPo6bG1n1cUC+SEp5U9VU4leE2s8XgUSVcTDJFjc5gRD267hGZNNZqIUP
	 cEs/EVulCoGsMQaM4bm8kF4kRwl2sY9/y8VPhiWDLLVZ6ndHOO86Q/oFBbDPa9vFWhuJP
	 xA9eoCYd8DXCIrkXEVqomkuy1Ts/D/6cfsV4qywrKuBE5aK7m665sj4jkWfAMstWv72lA
	 Bhkb94Uwlf85L/VcamZeOKMSO12ZEojetpWKUHk+ri9ijJujuoRZka16NCd/RBfW4xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MCuf0G3D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BCF606A33A;
	Wed, 25 Nov 2026 16:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MCuf0G3D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78C41F000C0;
	Wed, 25 Nov 2026 16:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624444;
	bh=jzOAty4PMYEreFlOT/FD/07/F1n+7/2kg3iKGZwk54E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MCuf0G3DVlA0zNWG33RKDSMMRaF1nkTrMhg7gcWS8wVh1JQcVnzeo9PR2/CljYIEd
	 lyc9c74OyMT1UL67y/9vooM32xKXNRHB6Iw32AKSEfLdLIqT8MHz2mP28Ncvjf2Rkl
	 OTOpyBEv1EIyzlev6J9Mdf6BZmqS2BXK6i6VFYCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 177/816] vhost: reject backend enable without a kick file
Date: Wed, 25 Nov 2026 15:28:45 +0100
Message-ID: <20261125143853.288782776@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 42c955a5b2111..997f869284377 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -281,6 +281,10 @@ static long vhost_test_set_backend(struct vhost_test *n, unsigned index, int fd)
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



