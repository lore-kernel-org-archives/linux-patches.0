Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030042;
	b=CE/Wih1bg17kyUc+YoUW7y0rjS/DvKgSAj25XTEKJ3WJ/xJtfczVCY1RpEgNtEv7HER2
	 qm/6Q/pY3kovEMQVlMZk/hVbVqKZnKKbf2JQzyqzOMgCo42PMPzXIBRPhWdd2f/n+3aAu
	 WDE+OvcQueouU2FyQ+v5K3ftprRgrLXibbqTdOgKiu+NQQUP+Q9+fW2T86+S5+AK2TgBH
	 p3RftBG734X2zA2K+pOEhoW+hiVjmAoP+QPuTWH8Vusu5P8lN7YoJnG0Zih2UgwuCZUlM
	 FIPTjuV610OpWm1zUwKEnQ0pK2AZ9BxS8iKdhSP2T1MXLxkNzph+FxMeW2l/56QaGrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gzlf5sPXIMlKFXKZFcOqymE9Tw8M0jRDYEywsJGHR4M=;
	b=0cm2SG9JrFWu6rsfBuoV8RLcRMT1VeR5t9NGSrUnH5xHp2DpoCOCjLs2I3NUtpNFKhoc
	 TSZ9ABEM3WDIQQyUhT6cTJ0SjNmZnRRsF4bw+0xaOpoh/QpnEzRXVUjjra+yud59SdZ/U
	 KF4CfIoXHtA4Nzok66zWcjiiFu5Zm7vsiEjakl+CI3kA/StmxsEHoDDDpORTEnhkQZgF9
	 Ny4ZAlRrIozL3Gz1WtJyNB6KsGQAOBPKV/Q6/DN0oFV2Yb9Vebnni7H+Zpo+kZYDPilM+
	 DnHj6MKHbOv8qO6oOeoRMmQ0LVjnAvm5Z8/4JDgQEJUKLOqb3SX44/TnkuztlBXIT1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KuEpu8Ay;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8178860A2600;
	Wed, 18 Nov 2026 19:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KuEpu8Ay
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8F81F000D4;
	Wed, 18 Nov 2026 19:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030042;
	bh=Gzlf5sPXIMlKFXKZFcOqymE9Tw8M0jRDYEywsJGHR4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KuEpu8AyyJebjr2DSdF6Dh7sl4p00xsxzz/PEwURaYjz/zR4xD8A45FBOGS+r+JaZ
	 HfdjSVWh5tpSkG4+qCgPaxfYfVWdsLnAHEJsfj5BcFyIzuYWjhim8FmHQKGYGRHYdp
	 lpjCz0uHjeYrKnS4DxPTvsY2Fe3KhfTI+CQkl0IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0557/1756] mfd: da9150: Balance IRQ wake on teardown
Date: Wed, 18 Nov 2026 15:44:44 +0100
Message-ID: <20261118150031.273807368@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5c59cc869fb3e..19325d72a27e7 100644
--- a/drivers/mfd/da9150-core.c
+++ b/drivers/mfd/da9150-core.c
@@ -450,7 +450,7 @@ static int da9150_probe(struct i2c_client *client)
 
 	da9150->irq_base = regmap_irq_chip_get_base(da9150->regmap_irq_data);
 
-	enable_irq_wake(da9150->irq);
+	da9150->irq_wake_enabled = !enable_irq_wake(da9150->irq);
 
 	ret = mfd_add_devices(da9150->dev, -1, da9150_devs,
 			      ARRAY_SIZE(da9150_devs), NULL,
@@ -463,6 +463,8 @@ static int da9150_probe(struct i2c_client *client)
 	return 0;
 
 mfd_fail:
+	if (da9150->irq_wake_enabled)
+		disable_irq_wake(da9150->irq);
 	regmap_del_irq_chip(da9150->irq, da9150->regmap_irq_data);
 regmap_irq_fail:
 	i2c_unregister_device(da9150->core_qif);
@@ -474,8 +476,10 @@ static void da9150_remove(struct i2c_client *client)
 {
 	struct da9150 *da9150 = i2c_get_clientdata(client);
 
-	regmap_del_irq_chip(da9150->irq, da9150->regmap_irq_data);
 	mfd_remove_devices(da9150->dev);
+	if (da9150->irq_wake_enabled)
+		disable_irq_wake(da9150->irq);
+	regmap_del_irq_chip(da9150->irq, da9150->regmap_irq_data);
 	i2c_unregister_device(da9150->core_qif);
 }
 
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



