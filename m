Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043228;
	b=1z0HwxG/tFMSZ0hdMjKGD69W5dXYSeJOYwGeZhLW8hnxIuqgAmqSFk+rcX9raiZSs49y
	 mkLGM2D3tXRmsXCA7CnJHJdu3Sd9snT8wHjcn0q/WVvALNhy8HB8VfJcfh65I9HXkH/1p
	 2gcPTVlayIHnPh1ZOtTsqQKmHLyiWEj4qNfcAQi/UhL9fe/0eyM1I5xH84g7wUce4o6D8
	 pM75Mf8KWNlgOD/jNceh4bZQwgwy/CyRufnjHGBkxEhELI02fFsE1pvEcHTiRKoQYuWfo
	 qCfLDxmVdZ3uNVECvVEzLEmLHp+qAkm4JWK/EH0lCpIj+NbwO6ZNq26nvgcgWvLTYrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rmAOQl87GXLRDu/3cxiD4empTi35aDcA0AXFi2ulXUA=;
	b=KTpjD+xAEv+H2gkLN3dcsoxLep+4F8BnVufoCUTriFzQOuf2OX0aLJBtn9kLaAimENq/
	 8127lmxLu9EJ9QuXFfZvd8L0cbqyxvDvlx3Ei0jbXxIKaAqGpbzjpMzXrfa+rm+q9PVNe
	 bWApVb60ka1ONc0CF2yt45FjjwkJJNH0XCo6PHE+ozDchog6OSHx3CDaClUTqXpfJ59zz
	 gyO21kB8EnDs0cISGzIv0+oKgeAntzDGgonZjxvbW58g0KaFe6PTjLSZEpeKhWddqb5hx
	 EeJf/8JJgtpWy1by8uk8wAvLAMhinsBC5hqChBJA1I73vGWVTYUo/22KCrsbE2SmsTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MvGL5i2a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF76606A325;
	Wed, 18 Nov 2026 23:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MvGL5i2a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19511F000C4;
	Wed, 18 Nov 2026 23:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043228;
	bh=rmAOQl87GXLRDu/3cxiD4empTi35aDcA0AXFi2ulXUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MvGL5i2akigu6LUXTNeLE5sXAOAQW6D4BUtjyffp1uFrm+g+NQbdkDseS6PGba99i
	 fiUo1SDl/Rm6vBhSG0gQrJDkCqmJsxYlFyHQha6AD1o2n9EANVp4X8/QfhdsHJ23yW
	 fWEjzasCQAVHMnEhXvkXiSkQCY8EZIA3mxsk9r0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0135/2857] power: supply: cros_pchg: unregister EC notifier
Date: Wed, 18 Nov 2026 15:19:29 +0100
Message-ID: <20261118150206.217892334@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 631adfa03595c63b2a621cdc62db60bb1ce5f91c ]

cros_pchg_probe() registers an EC event notifier whose callback uses the
devm-allocated charger_data via container_of().  The driver has no
remove callback and does not unregister the notifier, so the notifier
chain can retain a pointer to freed driver state after unbind or probe
cleanup.

Register a devm cleanup action immediately after the notifier is
installed so the notifier is unregistered before the driver state is
released.  Also fail probe if the notifier cannot be registered, instead
of leaving a charger device that cannot receive EC events.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260615063105.39152-1-pengpeng@iscas.ac.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cros_peripheral_charger.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/cros_peripheral_charger.c b/drivers/power/supply/cros_peripheral_charger.c
index 1379afd9698df..6ac5871c6d291 100644
--- a/drivers/power/supply/cros_peripheral_charger.c
+++ b/drivers/power/supply/cros_peripheral_charger.c
@@ -259,6 +259,14 @@ static int cros_ec_notify(struct notifier_block *nb,
 	return cros_pchg_event(charger, host_event);
 }
 
+static void cros_pchg_unregister_notifier(void *data)
+{
+	struct charger_data *charger = data;
+
+	blocking_notifier_chain_unregister(&charger->ec_device->event_notifier,
+					   &charger->notifier);
+}
+
 static int cros_pchg_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -344,9 +352,10 @@ static int cros_pchg_probe(struct platform_device *pdev)
 	ret = blocking_notifier_chain_register(&ec_dev->ec_dev->event_notifier,
 					       nb);
 	if (ret < 0)
-		dev_err(dev, "Failed to register notifier (err:%d)\n", ret);
+		return dev_err_probe(dev, ret, "Failed to register notifier\n");
 
-	return 0;
+	return devm_add_action_or_reset(dev, cros_pchg_unregister_notifier,
+					charger);
 }
 
 static struct platform_driver cros_pchg_driver = {
-- 
2.53.0



