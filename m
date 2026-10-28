Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215850;
	b=zwpae5Ju5poWA7ni0YacKTWIzjk+bjgrMqOFLn/Wpy0I2e9Rhkb/jZR6Xy/QQuFEBzzT
	 RAXv3dUUE8FJjplOKm9aqefNhXkMGxpcI88frR5FS1WIZTXWDlApr5FN1zbABlcEZFsdG
	 jaN1iUR2Ni/HGrPhFA6I/nLIGkus0oHsxYeU6z4un73m8NMuNUFCfWp3pWscDHOftbEn+
	 dPOYcG+C8MELhr6Tfp9yDbdb6kzGdy4ZwMWPG3nSs8X7jK86XKQE8vvN+lBOP1slJyaR7
	 SPwHOhmuyIGtXJMoA+YLHhrjFFEVGBBEoQynL9sduHX7iCvONWL4hK5YUJeGS75XoVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jUYB7MmNKFbcc3BdlPXbGRlOPnGVmLeSMTaE91DngA0=;
	b=QqwhHvDGNHj6Lq+XR/3EKv7PcmwpjLMsr7Pm/QERWAY903bpwypREzho0pMOYgf0SRk3
	 uqAilBgnvla/71jzS2iGBEMitHVZoHrYv6PaL7HefIbGuiBe28uAP0USC4uVk+y9x+DsS
	 6DTC9cTkqPjoKy7mumOXmUGHkTXy4Xy4c1hQZyDaeLfvB1LH9XXhx99LczF4TChWcGVTi
	 kLyaaaAIBzg9uwS7CktpFYScvVSSYUElYNNoPHBJ3HsDI9Ix/kkI4deOeOWZqBhnir1NK
	 V2JsjHemPCp7PCrZMqGIgzAaL0Bjb+YFoKQbrb2qr5tmbk2wlJw9DGtTx7JasKsfQ1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xn6AWfJ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF5E606A31F;
	Wed, 28 Oct 2026 19:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xn6AWfJ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAB41F01825;
	Wed, 28 Oct 2026 19:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215850;
	bh=jUYB7MmNKFbcc3BdlPXbGRlOPnGVmLeSMTaE91DngA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xn6AWfJ9SN8RlFyuJpE9tJzgh0XD7N2FsMpnegOC81QoQ7WgBo/pMXvuHHy3D0ON0
	 ucfpdIBtiEXM8eLcDTwbOx7QOnt7G3HMPbaKpwYAxNh24nVZv7scch5Zi/Ds/UL4X4
	 q5DdGyrmMYxD9lyaBrd1x5K2l1scV2roruKqJrZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1353/1887] crypto: virtio - bound the akcipher result length
Date: Wed, 28 Oct 2026 17:57:29 +0100
Message-ID: <20261028170530.229414807@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit f77a956f6a19f9463ef1527c9d0cda50dded6b92 ]

virtio_crypto_dataq_akcipher_callback() sets the result length from the
device-reported response length without bounding it to the destination
buffer, which was allocated for the original request length.
sg_copy_from_buffer() then reads that many bytes from the destination
buffer; a backend reporting a larger length over-reads adjacent kernel
heap into the caller's scatterlist (an out-of-bounds read).

Clamp the reported length to the originally requested destination length.
A conforming device reports no more than that, so valid results are
unaffected.

Fixes: a36bd0ad9fbf ("virtio-crypto: adjust dst_len at ops callback")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Message-ID: <20260622-b4-disp-3a2c09a8-v2-1-d1a809281db4@proton.me>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index db3817f5ab46e..c19920d3397ba 100644
--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -89,7 +89,8 @@ static void virtio_crypto_dataq_akcipher_callback(struct virtio_crypto_request *
 	}
 
 	/* actual length may be less than dst buffer */
-	akcipher_req->dst_len = len - sizeof(vc_req->status);
+	akcipher_req->dst_len = min_t(unsigned int, len - sizeof(vc_req->status),
+				      akcipher_req->dst_len);
 	sg_copy_from_buffer(akcipher_req->dst, sg_nents(akcipher_req->dst),
 			    vc_akcipher_req->dst_buf, akcipher_req->dst_len);
 	virtio_crypto_akcipher_finalize_req(vc_akcipher_req, akcipher_req, error);
-- 
2.53.0



