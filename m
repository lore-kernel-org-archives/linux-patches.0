Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054704;
	b=b1/4XhZaPmTKMo3+yl7BkLYsGmhhXwIEz8F8INsdIsK8xxftfJOYaA++UO2Wkd+mnyTj
	 cL8Y2lRwzNTbGW6kDsZHxq5m8WeB2I4HjelyxBO+gymzYpFak0NQvHfEzWpveKhG+AQ6z
	 qQNQX+Bx9nMbKqdkzLI1G6zvfyLmDBIwtqF64a3OlGAaKeBQLr2X//vNhSy95sU/FDijp
	 G8RRpo9hzV2BfEl8sJdO7ji2wymdHY3TCfH/iqOnX3Csa1u565eN9q6fXCPAFHHJBVWrE
	 9ZRgckTH+mN6j9XO4XEYEFsJq9gdQ1M5jpr8QUF8hAKowEPcEHd8J41cAyhl1PUvpOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ljXSeBo568LUY2Vwh4Ah7Kk3ArckRotKd1X9MFt4hCk=;
	b=L+OJe8LqJXHarZSUSat+L1KxC1K80/JyusyhxqxKctzEky9btCM3cfBpSTsUCD26nuzu
	 8yh374kXzcpKzIuCfrxhq1TANw1EO1349P7Jovqi9wcacOoOgsmrQ6D7Z0mMlHq76CuY7
	 8LVFVgVxOt06PmCRkZwwiUgzlKrBjKsjGq3GSKLTiJyMbtxidxL2g3U5h3kZotCEunndQ
	 CfeUZKSYKPjSHC3coZN8Ffz9YeImJwqktxv2aCiFii3TYhkw7j0u0P3+85PP+uwU0mdyu
	 onjvfWj8rXJIq02EwDQlEXoheRrIl0MRXFmE1djmcjYIHwWddraLvYYAbS9YvbuqfRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mv0FH8pk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8E2606A31C;
	Thu, 19 Nov 2026 02:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mv0FH8pk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F281F000C4;
	Thu, 19 Nov 2026 02:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054703;
	bh=ljXSeBo568LUY2Vwh4Ah7Kk3ArckRotKd1X9MFt4hCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mv0FH8pkO2RjONvzJn0QnKrKcvWV8vY2dHs9/HwNg9600c2GJ1KJL+OFh8d++VPxJ
	 A8yF7lXlneod5Hche6KP/xsESWPsk4onqR2eeD0/c7OPeivhKSwzDZn2qnQ15hmrXi
	 vrc5HPf9AhD5AHkw2t8Dvz8U9I78ptYw9gBfw0q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1368/2214] staging: rtl8723bs: disable SDIO function on block size failure
Date: Wed, 18 Nov 2026 15:50:44 +0100
Message-ID: <20261118150106.160086040@linuxfoundation.org>
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
index d346cca4a4396..daf0b88cd2c99 100644
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



