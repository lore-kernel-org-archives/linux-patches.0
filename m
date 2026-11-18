Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055332;
	b=L2s3Hx8YoQfQEd1emnrximb/UQkae643ES052lr9UEaUq0TQ8BG8ZS15D4aLl11/6rCy
	 WoFJ/2lBbqK0z1EmjIKurW7CD2Ly2YgKWr4CdC8ziZtuFLHLLPUBMk7uIk2KobvxTRqAI
	 0bA9mTVLFKCOCdT9Qo+iSDKTZVVTnJktA9i3eg1N8dXVR0ZKtshPMJvL6Dn836OrZrNJY
	 gty06kC+8hvJ/YEiSkDx7HCmqTpRoGclhqwyPhHikGNjxCrg2df6+a5G6NggaUvFGQD0b
	 GqAkfzi6azSz5DRgGz/vob4IT8Vm+uV0z8dX2vaUoZldfRP0lwrkFJ20b0OcKgj1iug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7KhAe8Yh67HWRJKh+EZPe86w9MAMQyasNoN5n7RlbnY=;
	b=gE55ZQdSBR36w0NGfJ3ydAXk9G+k9BOOmzElTZjLOFmJ8SJQvmmDwgBSd37J7VKx/qMV
	 WPmqdlXXSxJebiMndf23Grud83Ha6UH31/VFzTM/ga+3YgXr98au2CDQnxpb/omkt0mmz
	 RIvQGBc7g5NV01OXOgcEEwR8i+smxjorjixfd/9LWMSVmXx3eBru8OW7Mov/avDRWPTzq
	 DsbAUgD9sKtMfrLZHcaFA3d0Qllke9oy6DiGTYwjbU1+QBQFo/pYIkoBSrgB7Ar+LKHW6
	 L+t2NhLnzfIjoiZMe9n2tat2qr1BfbQijgvA/8rsBOPMsLlMoZmFRTVULrZ+9IBlrJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="n8x/rMKw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50412606A33B;
	Thu, 19 Nov 2026 02:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n8x/rMKw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61001F000C7;
	Thu, 19 Nov 2026 02:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055332;
	bh=7KhAe8Yh67HWRJKh+EZPe86w9MAMQyasNoN5n7RlbnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8x/rMKwEBWNwFg/Cr/1O3Nk9z5txc+4G8b9O7unCOFNV9Uv8ueZmAzZD2ffVbjRC
	 rnU0MbGjoxojYdJVqJEt9Lyh+ojwtlETBhiugAVqzPUinFT9REn+kUstCSZWFDV2jf
	 +eb9L1o+Zw92By++VhXC3NTTTzo1JBGkf9ltITuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1591/2214] mfd: da9150: Balance IRQ wake on teardown
Date: Wed, 18 Nov 2026 15:54:27 +0100
Message-ID: <20261118150115.630924501@linuxfoundation.org>
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

[ Upstream commit ef464f82f3aecad4071af71074b2ceb77ffbb609 ]

DA9150 enables IRQ wake after registering its regmap IRQ chip, but does not
disable it on a later probe failure or driver removal. This leaves the wake
depth elevated after the handler is removed, and repeated bind attempts can
accumulate the imbalance.

Remember whether enabling IRQ wake succeeded and balance only a successful
call. Remove MFD children first so their nested IRQ users are gone, then
disable wake before removing the regmap IRQ chip. Preserve the existing
non-fatal behavior when IRQ wake cannot be enabled.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: b8fce55c09d3 ("mfd: Add support for DA9150 combined charger & fuel-gauge device")
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260923021936.957065-1-mhun512@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da9150-core.c       | 8 ++++++--
 include/linux/mfd/da9150/core.h | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/da9150-core.c b/drivers/mfd/da9150-core.c
index 58009c8cb8705..b05ac49dbd6c5 100644
--- a/drivers/mfd/da9150-core.c
+++ b/drivers/mfd/da9150-core.c
@@ -451,7 +451,7 @@ static int da9150_probe(struct i2c_client *client,
 
 	da9150->irq_base = regmap_irq_chip_get_base(da9150->regmap_irq_data);
 
-	enable_irq_wake(da9150->irq);
+	da9150->irq_wake_enabled = !enable_irq_wake(da9150->irq);
 
 	ret = mfd_add_devices(da9150->dev, -1, da9150_devs,
 			      ARRAY_SIZE(da9150_devs), NULL,
@@ -464,6 +464,8 @@ static int da9150_probe(struct i2c_client *client,
 	return 0;
 
 mfd_fail:
+	if (da9150->irq_wake_enabled)
+		disable_irq_wake(da9150->irq);
 	regmap_del_irq_chip(da9150->irq, da9150->regmap_irq_data);
 regmap_irq_fail:
 	i2c_unregister_device(da9150->core_qif);
@@ -475,8 +477,10 @@ static int da9150_remove(struct i2c_client *client)
 {
 	struct da9150 *da9150 = i2c_get_clientdata(client);
 
-	regmap_del_irq_chip(da9150->irq, da9150->regmap_irq_data);
 	mfd_remove_devices(da9150->dev);
+	if (da9150->irq_wake_enabled)
+		disable_irq_wake(da9150->irq);
+	regmap_del_irq_chip(da9150->irq, da9150->regmap_irq_data);
 	i2c_unregister_device(da9150->core_qif);
 
 	return 0;
diff --git a/include/linux/mfd/da9150/core.h b/include/linux/mfd/da9150/core.h
index d116d5f3ef561..369698036d1aa 100644
--- a/include/linux/mfd/da9150/core.h
+++ b/include/linux/mfd/da9150/core.h
@@ -65,6 +65,7 @@ struct da9150 {
 	struct regmap_irq_chip_data *regmap_irq_data;
 	int irq;
 	int irq_base;
+	bool irq_wake_enabled;
 };
 
 /* Device I/O - Query Interface for FG and standard register access */
-- 
2.53.0



