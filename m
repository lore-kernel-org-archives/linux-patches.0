Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047826;
	b=ph0enT5WMYWcYmwTwlb43EgtQqSS0LqkukEqVM97lUH+2xkoFLXL2jsPx0IBTg2S/Je/
	 8+df/HW4TEID3mvQcuXTgcGNPN0PaTU2r9wPQxv9F8PT6vlBEBmZNZqz0nodn/E5hwRXX
	 rdchc2QRTpCeRsmpKKX0AdvkPSbGnkLFcm9TlPeN2n7AHdGj1xc+gHsgkJWYVSQrdEnQn
	 pa35P45slCMjMM25J/NZEnC0acQV0+hRduMdHbIWN2PhWmxFaXcz1X8ZqtJWSnS2lAmnS
	 lVD9sFsK60cWKXytAlfpYgW2udrWHTcODz5K92dkzZfSOKCej7mOP5AF1Wujz3nx4HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DuS7QpvoETJ5RBhFM72GxtqAaX3sH7ttm3CqZzXXrXs=;
	b=tOdRuWY49vtIh4fqGDiI5tnMX9H3+NTZQ0CdE4CWEdHKnaGOgskcPJp9KoIlnoFYOliM
	 ojZKEH6sJ8ddRDz0X0221g+c+/YYWkASVL9MCMABN+aSF6G8MsYLU+1x9Ks96FhYKLteC
	 qJMTsNXqT3Tm5GC98rggmJHT4H5hMz6GrH1RCexbSgJ662VnWbmH+RLa4/Z5lG1uxnJQW
	 U3NCfxT42SEcQsXAawogEasTFwOwhYuSakC5n1wPrUHShfvtyhzW+JRewZ4AyP0oLGXkZ
	 xhqFqJREMmRZuj7sDk/kSkeI1+HkAtLZwQ3nb52yxM+7DMsi6GYjrskk8FvKVcaQUtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qNDlu39j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178E8606A32C;
	Thu, 19 Nov 2026 00:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qNDlu39j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2099D1F000C4;
	Thu, 19 Nov 2026 00:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047825;
	bh=DuS7QpvoETJ5RBhFM72GxtqAaX3sH7ttm3CqZzXXrXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qNDlu39jqWUPL5uR0sVroH2w4J6dY6h7WQ/+CmUEzQ2X5Cjgfjj5MvTMRza+ckjT9
	 hUG89DrP6y+C5rrrL/7MHIRbf+EOVF+UV2guOBh7jp19OfER3fXqTxW/c7tnMc1px+
	 x9V7YV7nZTeHBtlZrFNTqCuNdbURTBSMM7CmxsAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1770/2857] staging: rtl8723bs: disable SDIO function on block size failure
Date: Wed, 18 Nov 2026 15:46:44 +0100
Message-ID: <20261118150305.011764066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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



