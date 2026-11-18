Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038696;
	b=nD8z/OZ4jCe5NuDkgMD5l0hOBrZP/lO78pVhqA+TsMfz5Wgn/SXyDdbIz1JUJU9PiMAS
	 mAlX6I58tLvJyIYIIcjoRP1TuUOi5xMmFdeNl6QC8dmsyVl2KDEJHqz+OK8US1jT45GWb
	 y2RzNErwCFluM1vE0KttVvtnPBKDvhff7i2CbCb97yLJqRoGz2IeS/vXWJ6qPsd0o5gqo
	 qg0xFTeHlNFY4uLhVc0F0qPl9aLmsRA+7v0enns9F6T2fPfPUpE8BP54kAl/sGH6Ff582
	 1eQjGWQ2I4/Yv3GvYKhMUJ8ibIckuWbTSJ1ZREG+Fyaet9IxE41Iy05DmcRsLnk7VlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7tjwfwP72orCvajaUu5JvwAGQTOpo1dP3rwifiuQAoE=;
	b=rYsfcxs3ANurdVuKwn2NNuLUORQPIIL5jAXv1459pagNAQQFmM4aTeGuONpCxI3EnCCH
	 duLzPWFZprhZ+RByP4eU1CBl7dUMnSeFphwHlO4t6aXuBS6FDygGLZDlU042DKr3Qja1R
	 qaYnjS0CzIphes8PorW1gNsl7epLsuyqR2o+OvFS7lMcEPVaySYOtC2AOk9qOGbyK1Krs
	 qX2FWKNwlqSf3/TYJQ2CDTYTa0PcBCzeRKTFGZECcBZCQfmRToyul614qkPpQ60ipIIK+
	 BA0zoJJZ0AlO0/ELPlLzXlYkVwB+mlpx7VRBYglXlxGkbE529GNG9Uo3je4Tyz5Ol5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JcS+bnuu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED21606A320;
	Wed, 18 Nov 2026 21:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JcS+bnuu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D851F000C4;
	Wed, 18 Nov 2026 21:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038696;
	bh=7tjwfwP72orCvajaUu5JvwAGQTOpo1dP3rwifiuQAoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JcS+bnuuRCjm+4TYzK/Jce98t6arewk4hWulKLQZ35p9MhCNHNrJE9vFdm/B3fftL
	 uzEodZvO6pd8NPkEJPbVp5tEIKl+Q8Tonsn2s9D8N1ZnTHz/uiuG9+W0Pwr14+5Ivi
	 mojXpw7peioxY79oiJa0VrkfE2jc4HCP5WjAzBw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1836/3318] power: supply: core: introduce power_supply_for_each_psy()
Date: Wed, 18 Nov 2026 15:40:58 +0100
Message-ID: <20261118150416.940352103@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index df5e21ec01638..260de00996bc1 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -119,6 +119,30 @@ int power_supply_for_each_device(void *data, int (*fn)(struct device *dev, void
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
index b08e00368f9de..4b231468c3f1d 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -896,6 +896,7 @@ extern int power_supply_powers(struct power_supply *psy, struct device *dev);
 
 extern void *power_supply_get_drvdata(struct power_supply *psy);
 extern int power_supply_for_each_device(void *data, int (*fn)(struct device *dev, void *data));
+extern int power_supply_for_each_psy(void *data, int (*fn)(struct power_supply *psy, void *data));
 
 static inline bool power_supply_is_amp_property(enum power_supply_property psp)
 {
-- 
2.53.0



