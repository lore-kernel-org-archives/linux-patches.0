Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052935;
	b=qcMA2lMZccS1D2v8S4YeQywHHv9lGq2Csd+RXJwNSKz945ifgpwtaYqv2HdKHjbtLfiU
	 Or6YFj5cVkS+aoFbW8WDyfCASQSf6tHTLNGw9hJrB5Po2atAlrqT2jPRtjA+wWjt8g/17
	 +m5ITNEUQnZtCWSnBvLpdZ8RTgbw1+HjmN4e5MLmd9wBBSGHS4rn1C2DcVWuN5+YJcwzm
	 5yJR5KbG+YHbs4TmFuKM3yB+3fesWNdTKtnxRjnTZZ1bLYWK07tuHPk5bOOqZJshN/n5c
	 uZ/MfNxP94rzk7RSAzBoThAKI5W6emmtG/wiiSa/Y6ky4/H0BlzJYGh/16D3q0CtfuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fX5yGolRBEjSoXBtq8ATxKUiqVlPLc3fjW/5REhS2kE=;
	b=aRP6k/SnSAgj9iQ90m2RhEoMTJ9u/iHwiJmBNfGdafQVXw/iPvvDJTxyqP69x1pyBJf7
	 L1XzmzapAV4GSZwnWm5GRT1DthjEzvMDyTabCcLzQZLFygUmo7d6kpaFevWWZlme2b0y1
	 fmCgDKnkDnCr0vwEoRJX52BDNOrvHp0Vr6z4IEVg1l6P0ibdi01Vf5ytbfnYGJ59/M69K
	 PFUJIcMaRP+e59ei5iUrON5VSKLQEG3WFR5Vjr1i3qXovssLHTG6HadPTBjyysnCOfnnw
	 9mjs9dMhCH02QCXI5+VCaXsVM3+sfatSk9QNDEBJ3HKgUmVOCmCm1M9w7G4AZGF4xmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V2x+j+8t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1E3606A32C;
	Thu, 19 Nov 2026 01:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V2x+j+8t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594B61F000C4;
	Thu, 19 Nov 2026 01:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052934;
	bh=fX5yGolRBEjSoXBtq8ATxKUiqVlPLc3fjW/5REhS2kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V2x+j+8tsLson894F8rcd2XwxThuiNiD2uVAxO+UYoAcM3fLqfZdP3oitBDI0lM3/
	 RDDxXW+BcPZ4XhXQLms15AovFpmco/T022i2VdKoraVWclmehcM8RdSGHL0na+ZAJT
	 0X8ngVyvdEWBuNi2DJqJmkKD49b8oVbjp0Th5pkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0733/2214] net: hisilicon: hisi_femac: Stop the receiver before releasing the RX ring
Date: Wed, 18 Nov 2026 15:40:09 +0100
Message-ID: <20261118150041.154420218@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit d54b21d824302af52d06574870817fbe14774dab ]

hisi_femac_net_close() frees the receive ring while the RX address queue
still holds every address that was pushed to IQ_ADDR.

A port that keeps receiving then DMAs arrived frames into buffers that
other slab caches have already taken back; on an EC6108V9C (hi3798mv100)
the queue still held all 52 armed addresses right after the interface
was closed, and had dropped to 43 after 15 s of broadcast traffic.

Reset the port before the buffers are released, so that the receiver no
longer holds any of their addresses.

Fixes: 542ae60af24f ("net: hisilicon: Add Fast Ethernet MAC driver")
Cc: stable@vger.kernel.org
Signed-off-by: David Yang <mmyangfl@gmail.com>
Link: https://patch.msgid.link/20261025182022.2959333-1-mmyangfl@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hisi_femac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index d881f8de74fc3..f89faa435c10f 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -491,6 +491,7 @@ static int hisi_femac_net_close(struct net_device *dev)
 	netif_stop_queue(dev);
 	napi_disable(&priv->napi);
 
+	hisi_femac_port_reset(priv);
 	hisi_femac_free_skb_rings(priv);
 
 	return 0;
-- 
2.53.0



