Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024125;
	b=Mpy7lzdOz5tlTsSfz3FznOV0AZDuAxsSot6zxMag5Sf7XRm8L57IzWjJ3F9xleJD/zvd
	 4v+UtkaKOryd9DLCWJW+/IBRNvd4Y/Xw1PReRHMwgAa9kS/zYBY+HyrklOLZrHQhnCzcs
	 TkuhUl0MFDKixCn1KWYndK7gpoYgiOz054hwgm9aXqWI3fVeZQpkc7n0Ggya+iY8t9K11
	 WqRlgxohg7WQhirwCn9ULz3basrQ21PBEthrHMdliGOles7NVmYQHqmV6dIIxYxfdRD51
	 ai5kPDzTbQanLHkb2A37g1VLJpjFzG9q2JsM2GNlb6ysIdEYyWZuNe14kJy3MZ5mP1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SmYOG2C7ou/Eoc0oczXJFUbmJYkM2cZsFg6QpFGA8hI=;
	b=oocWrHyOWxfmSg61Ry+AA9d6d1hjcGGns0UBmG7E80D0Wl5cylmsK5HsVcCIayQGP4x6
	 G97lZFOKgsveuDeQE6OUASYa1V+RuaJNcBd/zClqFF4XUCRuV5Jp81XzC0+emzTOwD2oI
	 TzRtoa/0kdcdRZxAVjvNf2u9QlRmwm9M7rZzkRkXHCN9JVsyzDIUMQFfBTgBoZTd9ZpTn
	 o15HuGmXv0Fxnavj7RVc91jprizHLe35WXV0RdxCpTCKUUOLKISERao5FQX3bcM2JL79y
	 WcFErLe5Q7+BvBuor4Q/zeTRr6wo+LAN7gE5K3MbtPLCmwK7XdoEnIebvAv5T/ji/0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gQ9jmmkx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B43606A325;
	Wed, 18 Nov 2026 17:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gQ9jmmkx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9D41F000C4;
	Wed, 18 Nov 2026 17:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024124;
	bh=SmYOG2C7ou/Eoc0oczXJFUbmJYkM2cZsFg6QpFGA8hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQ9jmmkxXf3u3KMYaHmIk5nCKRLMb2LM2UUToDYLSzSr63b41DB1akOYEcZz7LUB/
	 DtcBsT1mOVvwhnBext48ik18JJjzioG17BGrIWxKKTOzeKZCmqK0Ze/xdUTzhJlEiN
	 hJryy4pvu87+pGFNGOm6xzHoIgYVxVfJBRmwlWMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0615/2151] RDMA/irdma: check vport device allocation
Date: Wed, 18 Nov 2026 15:39:10 +0100
Message-ID: <20261118150144.324855313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Slavin Liu <bolin.liu@seu.edu.cn>

[ Upstream commit 2a770e6a64d66fc3a7317669ecca9773d8339ead ]

An existing RDMA function does not guarantee allocation of the new
vport device. Return -ENOMEM before initializing a NULL iwdev.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 2ad49ae7330b ("RDMA/irdma: Introduce GEN3 vPort driver support")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Link: https://patch.msgid.link/20260911060909.94219-1-bolin.liu@seu.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/irdma/main.c b/drivers/infiniband/hw/irdma/main.c
index 95957d52883dd..106915b51e7cb 100644
--- a/drivers/infiniband/hw/irdma/main.c
+++ b/drivers/infiniband/hw/irdma/main.c
@@ -80,6 +80,8 @@ static int ig3rdma_vport_probe(struct auxiliary_device *aux_dev,
 		return -ENOMEM;
 	}
 	iwdev = ib_alloc_device(irdma_device, ibdev);
+	if (!iwdev)
+		return -ENOMEM;
 	/* Fill iwdev info */
 	iwdev->is_vport = true;
 	iwdev->rf = rf;
-- 
2.53.0



