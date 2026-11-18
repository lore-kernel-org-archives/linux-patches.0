Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016878;
	b=1kg8bFeCKs8JbvUagGIMEzjMlG6/RzsPvN+KCOsvt4PTLFGcTNVRPZZtEG5XwqUuWX/q
	 ooXqJTrBBvQKX4pCV4oMJ5baVgPSdQgx0WAXTU9CjUt4YmJYrxFMgU+Wjyt2qn1dIeOkO
	 rrHkhoQeqg7+o6t8RkeH3+Dxeu93DxYHuufenozngoqG1asuVx9JsC2vZKU/62Bs3NK6X
	 yHSrYv8IBDwt51SytxFGDGVixJKjfHzjuCYFb71C6yR5TQh1/IQAiCnyoT9kRMA+Y42Kf
	 Rmt/MPq//feEcKHUghwxfJogXwyrF8UfMjnQ3VRHD4JRC66WRgloQSVwwH0CFcMXMCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fcj6Srgjl+WuHo29QU+IN3wPAkaP3t5PboVoPRiduZQ=;
	b=z9c740JjRv9y5VOmSPs1yeUd1xKn1mDFBdK2e8lWiPEk6jcL2tvW0lnw5Mxkgof0LiXD
	 Ux7q+xc2v65i+OeU3F75mhd46GvDKUDvqDv4DCbDPLBhwGDsRpCvstazJ5j9ulim1+gcH
	 aYerJkmi94ri6SONryiTrJTw9eLDSY2ycW9xRmeBgVO2eJshXvTTuq/uxkQ572bznn9z2
	 hjB0FA58UpgfhkCztvFvJnSOvPTKdp4p7eMUci7lH5okJdUL0w2TI5nyItIBtVGj9ygdZ
	 t2dUy75CagOi1UY8nuT3YDmLjvhWW8U2RhWdiKyetS4x2+QeIZVtHBj/rigjSzwmZwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NPFYfb4y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B11606A325;
	Wed, 18 Nov 2026 15:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NPFYfb4y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260361F000C4;
	Wed, 18 Nov 2026 15:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016878;
	bh=fcj6Srgjl+WuHo29QU+IN3wPAkaP3t5PboVoPRiduZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NPFYfb4yBpnBmW6Z6nuLvKiINfJmLX4YbezvbSiLx3+4IDtQIulxQZteWFmR2MpYs
	 4JaE9FDrGuGjH0GP5zf1NgxSAlfQy2j2LXXAYNQhkuRGZ3ByCk9ebwhc4S20LomJB8
	 CNS755odeKxN2oxjVIey3PADkYZgJWk1UhQItvWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0684/2651] RDMA/cxgb4: Fix neigh reference leak in rx_pkt()
Date: Wed, 18 Nov 2026 15:32:04 +0100
Message-ID: <20261118150312.484177503@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 5fb3051aa4611ae18e304814fb1b74a30065fd85 ]

If ip_dev_find() fails on the loopback path the code jumps to
free_dst without releasing the neighbour reference taken by
dst_neigh_lookup_skb(), leaking one neigh reference.

Release the neighbour before jumping to free_dst.

Fixes: ef42520240aa ("RDMA/cxgb4: add null-ptr-check after ip_dev_find()")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260916183530.2092534-1-vulab@iscas.ac.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index b3b45c49077d5..f57a31cf4fc78 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -4156,6 +4156,7 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 		pdev = ip_dev_find(&init_net, iph->daddr);
 		if (!pdev) {
 			pr_err("%s - failed to find device!\n", __func__);
+			neigh_release(neigh);
 			goto free_dst;
 		}
 		e = cxgb4_l2t_get(dev->rdev.lldi.l2t, neigh,
-- 
2.53.0



