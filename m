Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039239;
	b=IR1SxHjop8LMQv0X+mWMxunzfArSoK2aaMk396uA9rTzS5Mrtl3WijL23H6WoItZAQ3u
	 GDIyrdJOyfR2ibq//Wb9ewHF0DeIC3OnwXToFnG8hu3b0jPshMRVVCSP+dZj+TxpN8Gd7
	 T/akLM1/7agNmCiIw3hOOuuwusehiJU6T764JI3+fB1+yxa/NN5SsCSHYFkfjVQqktXDN
	 b22Si9l88x5KPEDaPntxyRPmjBgT4bUkQ4479Gevhcu1PWTV5NuOOrcCuDHv7TQugQ9l6
	 cbDpefj44Eld2KeNa8cMTWS2zBmMayaT/7LPq/BQKrtm8fgTND+t70jIRG31u8ecKTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ac4yGOYvoYrvy5nhRMQ3UupAYqPkAoL3eqS0MbjZVEY=;
	b=CiFYecGgtc6mc8eOpvszwdmnPfVChT0xX+cY8ASD2NHu+KSo7HK8vPQzPdn+HCHSHdYM
	 a1M9CcPIvBMHsSg5dE2cjv70TNGYfB9Ot3CzwWDtZGcvTJ1W8qjp9B6K+lIQHTc0rgtNt
	 Pd+9tT88KhTK7pNlnguVus5VPIZndd9+V3J3eUOVFUMkCvQreB02B6+m35OAyYX2Z4HDm
	 oM6AAwxrC2NRAoWHVRoMEBIq+TczuBAahJNHvfM7rT/mmm32Dc70XQo6lTD3P0xOkYlov
	 Un9ZtqtUJ1wLZ51RaEjWS9y5Gp+bhLTu4y0OhjDVyfH86jeSQCSW1GrkkwbN9KXRfrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zyyj1r7Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481C9606A31C;
	Wed, 18 Nov 2026 22:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zyyj1r7Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05211F000C4;
	Wed, 18 Nov 2026 22:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039239;
	bh=Ac4yGOYvoYrvy5nhRMQ3UupAYqPkAoL3eqS0MbjZVEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zyyj1r7Y7Gs2rZCaWKO3l+WJp/sItFAy57DNV8zpN4nA0w1IjNnsXkLxs1a5XMBuy
	 BjoPDR+yjJybgdOS40mVBSw1FRwzh/8MDxzLNoA5G1dGswXJq7YCxba7UIDMKYedm3
	 imZUTyO1nz/PfSYyHuIlin1vcy9JxVaj1x/EK8S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2029/3318] staging: rtl8723bs: disable SDIO function on block size failure
Date: Wed, 18 Nov 2026 15:44:11 +0100
Message-ID: <20261118150422.910877995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



