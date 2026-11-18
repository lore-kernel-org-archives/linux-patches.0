Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040110;
	b=uM9zlYbmpyvfRFR+tm0aB5uaKzP9PAxPTz7Y/BcQirtyA6T4HjsHj6F6rE25W6pgiP9S
	 bDsz+UfS+MSRkakY+g8BI+9EthwDcF8wa4TyWA7H1r2CeiBKPYjX0cL24QxSu5M/GPbCA
	 /b6j2asX1NlKYNyI66qtyB45CLDNmrI4s+bo7c7w0suFq5xJpfuepfLaM1fi6frKsW4gx
	 /1tfinDhiPXHdrgnPYVQv4tlOECRYdk1rINq10CHoYlaM24Uz8Kk0bvPJUMdbYobYvHgE
	 esCYKg4jAHoFacCKPJBzDOGUdRVYgVFXJqJWARi0DQV7YqrEMEQL0DxU9a+IRg7Bs3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3MEbfGnzzZY7vBZIzSEhXCSX8rNkxEnJD6Yx/LMFoxo=;
	b=u2t36TXIMFHvykvWBqqeBP2gqXOo32WS7CmiMvkykbhIF2X8z7pZFJvF9vfHoDeTQGOl
	 +zJkgy8cdLdQGyNa6FhfWBMZjqHC4bjkcG2BPtaaSdsdIDNIY9ZWEsS32Vk2QE3yw17OL
	 Q8zmT9MmBWppK9KAJK92nW1F7xnJPMG3GxR3ugPp9LBgQ1WwNgGzLSN/cEkvluz0KiG1v
	 iDO7M1oJ9g3tsvTIkkUGxMJZFqy5nePr2Gfrr8OQf/5GFDshg5S9nAlis4q9/7pNC+kHV
	 YS6y3OWYVfDbcLzcQbXq/zSEJeD4ug3aR+95hpoqyYPbt8KHYM9eVjhEoWRcyzWGSKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oAwJYHIQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20108606A338;
	Wed, 18 Nov 2026 22:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oAwJYHIQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327F61F000C4;
	Wed, 18 Nov 2026 22:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040109;
	bh=3MEbfGnzzZY7vBZIzSEhXCSX8rNkxEnJD6Yx/LMFoxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oAwJYHIQdkqAx3Fgs3/lpYwXAYp232KWyg67PBcj4KDATcYh/B2+WEMjbMZu28m1G
	 OQeXp2zn2v4EKgznD43dnbxwc7brF+aUvY5+yB1pI3jCoOteC3zSqF9lak+1pf4nFJ
	 /LMskP3UJsnb9lME0tK1SpcBDHQiFxLkX9HV/eoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2340/3318] mfd: da9150: Balance IRQ wake on teardown
Date: Wed, 18 Nov 2026 15:49:22 +0100
Message-ID: <20261118150431.832034850@linuxfoundation.org>
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
index 94d621e20635d..6e7087f9cf467 100644
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



