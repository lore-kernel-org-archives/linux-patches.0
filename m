Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591640;
	b=lg/h2SsLE+LZ8CeoRrKGLPFB8KrjTdvFWKl/kbI/ZAw4HTdgueg/E7A0DHn3PGYikuqW
	 7dw0N3WVI3V8kYwniamUjw8VeeMXI3so7mqYRrF4NOEJdnedkRolAxV2RSC30uBUkR3E6
	 9rdFmmg+SRP10/Bu+uLl9uy12dVsImxO3nDtEtZfXJ6pBV5nmzwSa4yohSddeTPw7Ucgm
	 2U9joIlgEt3R5uKLjmRRJxQfDuJ0rvzlA06i/9oo5d6W80kZhVMzU4T/0ygtNPYTtWtrY
	 JmMPSvWcikfk3weCj3UtNCiZInQ64bGqM65S8B4bS/ws9N8IMEBIQiyiuj2TLhu4SWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9vopsjK572yJORMK05oLiu3L/Tt/mV19bLQLilNpVeA=;
	b=c5LOIgjdqhrS9bwXG1OA8rxvy9fkSbvrQjwcrEvxWBtdefl4j7QhiJ1iYTYvVQ+a+AMP
	 4aYOeyDktpI36XyUmiYR/yrDxaJMj9NEV5+Yvn6deJLqzqoFAoYQXJHeKK3xKVjpD+9Sp
	 ZX+VbfUTGSd2uOqXuwCkmZME6Gv+htd2hRolAeQvHZW92d6qmrf8fz6ub4dSLcaE4CntC
	 YchKuJjbC6c/ut7M8teqXfK9IYPZ+6ogFrH1T4NzPQ3m/tUir5Tf35os0PgO3h3rczXBh
	 TKiyfQCbXXP0qHzgtf8/Fb2plrmo4J/lk5qM9zndzal1F5oVDLb46/w02cRlTo5g16A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="N5yTPW3/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4104D606F71D;
	Fri, 13 Nov 2026 17:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N5yTPW3/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D0F1F000C6;
	Fri, 13 Nov 2026 17:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591640;
	bh=9vopsjK572yJORMK05oLiu3L/Tt/mV19bLQLilNpVeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N5yTPW3/ptc6JqMShcFmikh8deXjoKdvfpg2/wqEsmTyx+MHHRXanlzjdJRltB3M1
	 S5bgNk3p+3FY4RCweAWO0qOjQ4Y+mGaz2GKhXppoHdXljpe9mcm/lVzyW2c5Nmewag
	 lKNrIa52iAmw6gCAo+pSEVBZ7hyVFq1sgZL2i9AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 658/670] power: supply: core: introduce power_supply_for_each_psy()
Date: Fri, 13 Nov 2026 10:53:42 -0500
Message-ID: <20261113153834.208889792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 9029409d1a250da19f1086ab1113752411c5163d ]

All existing callers of power_supply_for_each_device() want to iterate
over 'struct power_supply', not 'struct device'.
The power_supply_for_each_device() forces each caller to duplicate the
logic to go from one to the other.
Introduce power_supply_for_each_psy() to simplify the callers.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20241210-power-supply-dev_to_psy-v2-2-9d8c9d24cfe4@weissschuh.net
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 6bd80f22c764 ("power: supply: core: Honor supplied-from with CONFIG_OF=y")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 24 ++++++++++++++++++++++++
 include/linux/power_supply.h             |  1 +
 2 files changed, 25 insertions(+)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index e51ad6dadc165..34de2f39040c4 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -122,6 +122,30 @@ int power_supply_for_each_device(void *data, int (*fn)(struct device *dev, void
 }
 EXPORT_SYMBOL_GPL(power_supply_for_each_device);
 
+struct psy_for_each_psy_cb_data {
+	int (*fn)(struct power_supply *psy, void *data);
+	void *data;
+};
+
+static int psy_for_each_psy_cb(struct device *dev, void *data)
+{
+	struct psy_for_each_psy_cb_data *cb_data = data;
+	struct power_supply *psy = dev_get_drvdata(dev);
+
+	return cb_data->fn(psy, cb_data->data);
+}
+
+int power_supply_for_each_psy(void *data, int (*fn)(struct power_supply *psy, void *data))
+{
+	struct psy_for_each_psy_cb_data cb_data = {
+		.fn = fn,
+		.data = data,
+	};
+
+	return power_supply_for_each_device(&cb_data, psy_for_each_psy_cb);
+}
+EXPORT_SYMBOL_GPL(power_supply_for_each_psy);
+
 void power_supply_changed(struct power_supply *psy)
 {
 	unsigned long flags;
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 36275c37f1f2f..ee6e89c9c301a 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -892,6 +892,7 @@ extern int power_supply_powers(struct power_supply *psy, struct device *dev);
 
 extern void *power_supply_get_drvdata(struct power_supply *psy);
 extern int power_supply_for_each_device(void *data, int (*fn)(struct device *dev, void *data));
+extern int power_supply_for_each_psy(void *data, int (*fn)(struct power_supply *psy, void *data));
 
 static inline bool power_supply_is_amp_property(enum power_supply_property psp)
 {
-- 
2.53.0



