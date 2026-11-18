Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015350;
	b=bkss8H7QOfc0LBxzK+OtjtkGDrt5X3MqV+42Qzvvf1ZRqvPBDfeSGhp/+jxta/GAKwrB
	 rMxP7IWRcAGiBRlecZnJ7I7+zaTcWz/acLqjn6ibLKsVEMqR4NpzWp4M6OgKWgxE8JMKt
	 QmxSRwFujlT7APRRbobEflbkZ2Z4Ewm1AvE1/1wA1nuT/3tNdR1XfUm0Dq5+Sc9aWHU7N
	 SSY9+Zrra9FQ2njnuBfCNmv7jO6dzrjm4Nyx2uSbfxLAAzbBVXJxDeXA3HQaq0jjJuysA
	 tqESmlZAkzsY5ya7StCwHLYga0mcTdXutW9ix7Bd3QOUh0PJuMZWkZSxlacSNbzo1ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/YrAGKFyfeBPMEW9X0/CZ3o9mYzDCKCiJ23kOqwT7nY=;
	b=hmQB+kA/wge2oaEuJrm/dsZTw7TombqUzh6R7yLm5Pt+3vnFE/x26nBUCwShaR/kwOJZ
	 ZYD9Hm+ncqc1fFf2iRVa4zjRI1w1f0PLZ4SU4vZLAsAxm0MhzJUwTQAgcIa/Y6t4VChZj
	 4AU+gqBc7DYnD+Js4NI79tTPb2quYro9O+Le6+icsUxnivjsmlgPWP30Q9Cto5PRPRqlS
	 YjO2J3/fX7X9anIgct+CXY5BuOqlTC/OFsiLJGkBpp0+jBu3EA4Ph7ELw0Ukcl5D0OZhz
	 MdXsk5YUu1ZvjWSd+KKEB6FDznNeJNBfwGYW2EfDlC8A6QCBh2JPmm7eq/qynXqovjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TYxhRbN1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900B4606A325;
	Wed, 18 Nov 2026 15:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TYxhRbN1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58531F000C7;
	Wed, 18 Nov 2026 15:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015350;
	bh=/YrAGKFyfeBPMEW9X0/CZ3o9mYzDCKCiJ23kOqwT7nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TYxhRbN1rdpNTsTk7WBNJC/NA3kAPwf71oRPzy8sOcH4iYeO3gFBsVaWmuPHZ87mY
	 lMDyVBgKTVcHYbZlGHtHqnzjHsGN8krFg/eNOJhn25zE/Jo3A7DGki6KCN0AVDhehv
	 gIrOHT+gWRVnLu2ymnDWgMj+e8Go/VPXil819q2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0142/2651] staging: rtl8723bs: disable SDIO function on block size failure
Date: Wed, 18 Nov 2026 15:23:02 +0100
Message-ID: <20261118150252.959122004@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit baa84b1bb1648506333fde3e66b6540f9d7d73cc ]

sdio_init() enables the SDIO function before configuring the block
size. If sdio_set_block_size() fails, the function jumps to the release
path and returns the error without disabling the SDIO function. The
caller then frees the dvobj directly, so the enabled SDIO function is
left active on that probe failure path.

Disable the SDIO function before releasing the host when block size
configuration fails.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/20260731161710.44828-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
index c61d3d12df7fc..6ef3a71985338 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -122,8 +122,10 @@ static u32 sdio_init(struct dvobj_priv *dvobj)
 		goto release;
 
 	err = sdio_set_block_size(func, 512);
-	if (err)
+	if (err) {
+		sdio_disable_func(func);
 		goto release;
+	}
 
 	psdio_data->block_transfer_len = 512;
 	psdio_data->tx_block_mode = 1;
-- 
2.53.0



