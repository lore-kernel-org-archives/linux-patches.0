Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621399;
	b=w7a6/tS2dTsIvyfrL/AG+CvWAkLT+lFJ33RR97JJNWH1a9Kp6HD+j3u4wcLzRYu+UuUP
	 29vriEv2EBlAcwxWmAv/bcbEKFFYvA7mtUAWp1ckfNEsOgUp5eBE0AwiRJmPxlLu4Dy3z
	 Lf/VmHLQoquW/XaqQ9Nu4mUoi36j5gstPA2eDNvZTcrsleLtuL7PnJofEAYzmpFZ1qgFN
	 oyn+XOD7U+eg31+6gzbii60NFKC9FqhKygHENkP3VRWezP82LCenkGHkDplan6TfJjdAl
	 bRJl4X79F+jA8fTnVrsMnAarai8P9FomrgOtr5sSwnzzfg50WpSGwI5WUgj2yd0W4lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LU11iUx3MjVFeClJBj/WKH1z2P/TcxSEsmauaLXNSiQ=;
	b=VxtkxcJpj9yLTFcNEOGc0HPj1Z7Sg2iDSJt3nBrq0cG9AlbGZpEdrb89OoofYqZZYqhz
	 pDxfltLts4LSCuyGphQLVMw7mVKJw6I5jJ84R0AlyEFZYDufG/ealr/8Q/ncL8VJx8n/s
	 epWLtZ0xae50eBpL3foONsNZEu3N7IsNZ5VZZu6zWaC+GbnD/O18bm2kka7rFB5bays/v
	 yKHXqWwy+Gx1BeSXF+HMPiaC+atxiVj2eNJQcumtjkN7g3uGbktuz4ZV7JrTd0yNTgdcO
	 UEgbX142XIdqUCfw+6vc7LKMudt/W5QOVY9aKwXAEEOy73ykYia5+zg9n8QFYRzxcqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oMWSTOPJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EDD606A31E;
	Wed, 25 Nov 2026 15:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oMWSTOPJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D531F000D1;
	Wed, 25 Nov 2026 15:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621399;
	bh=LU11iUx3MjVFeClJBj/WKH1z2P/TcxSEsmauaLXNSiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oMWSTOPJj5STlzKNNwstPjI/TbET6UorzojEQwsvQ/GtYgXD+Gz5o63mn3QdNjeCU
	 l6y4tcXPld5/cAI1Ybe21BdhixXrtksc4V8WrgXIXTnnYX8MfpMpxthbAyFqJXoW8B
	 JtyF2SGgRj4GxHy7gcIMwwF1B4PFeVpfYqbzrx40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 158/990] vhost: reject invalid IOTLB update permissions
Date: Wed, 25 Nov 2026 15:25:25 +0100
Message-ID: <20261125143825.793361946@linuxfoundation.org>
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

From: Linfeng Sun <linfeng.sun.dev@gmail.com>

[ Upstream commit b179f21d2d8a60ede29a00472bffdefb0284ef39 ]

vhost_chr_write_iter() validates the type and size of an IOTLB update, but
does not validate its permission field. An invalid permission can therefore
reach perm_to_iommu_flags() and trigger its warning in vhost_vdpa_map().

Reject IOTLB UPDATE messages whose permission field is empty or contains
bits outside VHOST_ACCESS_RW before dispatching them to a backend.

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260913-fix-vhost_chr_write_iter-v1-1-76bf1f436cfe@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 87079382c9714..f8fc0c1a10009 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1734,7 +1734,8 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 		goto done;
 	}
 
-	if (msg.type == VHOST_IOTLB_UPDATE && msg.size == 0) {
+	if (msg.type == VHOST_IOTLB_UPDATE &&
+	    (!msg.size || !msg.perm || (msg.perm & ~VHOST_ACCESS_RW))) {
 		ret = -EINVAL;
 		goto done;
 	}
-- 
2.53.0



