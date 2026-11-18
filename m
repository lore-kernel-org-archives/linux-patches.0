Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022975;
	b=pOzaraaHh2X95hzeAH1LnujMUuOet14q109yEq8Z6qfDTvZCQnmqxvgbYP6hlcskCihI
	 Lg37/rF/rvwoAIPTe6W4sdyTUBZGEjj0xUXVLLcrr8Lo5frDFralSTwTSUWsTsxShqr9n
	 vVc1T9ARYgKO0AuY9JZPxbauIqGNf/ci7ndK188bITzFl3/oe088zd/X+dp/VJrC6z/Bz
	 6KVgpWAJfwyXLU7pkhHJpC6hVYW5uDW8nAILUKzQMhidIgIOCuY2nogR077CJHGOm7jXC
	 e+OfQoHlaoz063aqbggPUcfTDGsPiQxuQT1DhBEA57CZmeNRBQJID5nKvR2sgoXZ/gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EbR+qHDq8Wep230URe9NWVLkyS9M2UMPzld1riiNvPY=;
	b=04lIByJqQDPBwTsgIY9K5s7RxDVH3lgi0E9hERg/6ysNMk6y4cLiSGZcuxhQTBvcZ8nq
	 Gq7kS/Fq/XUkbYCDNQN8YXsbCtyWC/C1IQhukc+X7JZs49JadvRgcgej/S+N5eF0VzUQa
	 XVEhKszBrpyaWtSapwPxJ9m2KRDaUrx4VsfWsXD+qaXInaFjprdwCB0R/Q3cSDkJRFEDT
	 7uZklpq7l2YT43qr2frkCRBPpfMyG3koMyvgkNBYLgO6efH/UZksZPs805gTg+ztRKBcS
	 /NKZNaIFojFqMcp9B3vS4O3hidnrhq8yQ6tzwp2vbBysKrWFWnM5v0FzVLfAePqp7Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qf6y6DPH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5487606A31C;
	Wed, 18 Nov 2026 17:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qf6y6DPH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1099F1F000C5;
	Wed, 18 Nov 2026 17:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022975;
	bh=EbR+qHDq8Wep230URe9NWVLkyS9M2UMPzld1riiNvPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qf6y6DPHA0imt32Dz4KqDqx/WyX7d+ACCc/WPNOruzn/S5vtewMoNwpD4EPiorwMr
	 UuW4QLpq6CuL/UfUeG1XLl5WhYbxTGTkJTw0BMRAEpg1TkKh9Thfp6bvdr7784P74l
	 73qX2hSUKf7DzgdIepKP4Qe28t4f+fZHsPQ5FkjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0187/2151] staging: rtl8723bs: disable SDIO function on block size failure
Date: Wed, 18 Nov 2026 15:32:02 +0100
Message-ID: <20261118150128.598522042@linuxfoundation.org>
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
index 32ee0f8f4bb99..ed5f8ee3de2f2 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -121,8 +121,10 @@ static u32 sdio_init(struct dvobj_priv *dvobj)
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



