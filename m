Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052381;
	b=2KMdm6IE1yIYzGEg/tlIxltVk2UdFvW3Tfo9CgK1JeHOGDRiEzENBA7iK8BMUtOUsUNQ
	 S1sc6zWnKbM5G4rLgFAGPKjifvGxA8hc3OdTTKfYWY9mQO7Baq0n9Ejlz2PJ0soPem9DS
	 ne+3TcdFcKvQ5+p7krAMRNQKPjEG3/HvX5M7dtRfKQDt5PtruUICfGe70I7cVujmXyAXq
	 wKTAr62n6M9YuLYJfm+XS+FgyMJikvDeTEqCXPZD8/Zpnr5lQyvmIdp0axDhoRwFR8j1H
	 MGjSIt1auRF544ThTg9FSCsBOMh/iul7WIUvd9VjmQVFEMb0Qmg0plKINKWkULsdeeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nQgKeE71bgKKiBOh4zXl6c8KNiappggBPgEHR/a9SvY=;
	b=DwpC0X7K2Tja0bvgI1ClirW5J5XgU3V7yoYUSyCizer3grXgWutVMsqqy0iwesM0ghlf
	 O+MYXCjPNU5aEBCGL4B9e0H+ENQefJRAQmLr3sH8XBPIJtc4rZNNIsl1bBiettC6Y66Gw
	 Fz3MSZsfnb37E0fw+a8UHzbOCKj9PpmGWM+RI+lp9GmtHi+Egt8yk/jNMw+BtllfVp7Sk
	 APRyLAC4YCFKYYZWMR7HfPPy2n3fHqjeJORasiuMsSoMZ4lEOxLsPPpDZdwrZerpBF0Yb
	 qUKeJneTK0CyEDCdog5H5DDz0pgJUwhJk4dJLvXAmRV/B/gyrs26yIf91NYjAxejSnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aj5WRuT6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFB6606A31C;
	Thu, 19 Nov 2026 01:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aj5WRuT6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6464B1F000C4;
	Thu, 19 Nov 2026 01:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052380;
	bh=nQgKeE71bgKKiBOh4zXl6c8KNiappggBPgEHR/a9SvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aj5WRuT6DMEgga834Sl5ei0Lra30hgaIsh1NJiabVS0vE/nieN2BII+4m9/KBdt2k
	 02LscyqYgQhtT7cC/2odqqjBXEDfdAm4dBHMNRYivrploDpcCZgWdwbOHzPE27amsV
	 3pkl3hErmBavaJchlsBH5KELJkaRP3fHLJa1cESs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0543/2214] ASoC: wcd9335: Fix device reference leak in wcd9335_slim_status()
Date: Wed, 18 Nov 2026 15:36:59 +0100
Message-ID: <20261118150032.741219975@linuxfoundation.org>
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

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit f0cc352be29ba616e0682f66f551d3f3029886fd ]

wcd9335_slim_status() obtains the SLIM interface device with
of_slim_get_device(), which uses device_find_child() internally and
returns the device with a reference held.  As the device_find_child()
documentation says: you will need to drop the reference with
put_device() after use. The reference is stored in wcd->slim_ifc_dev
and never dropped, so the SLIM interface device cannot be released.
Fix it by using devm_add_action_or_reset() or put_device() respectively.

Found by code review.

Fixes: 20aedafdf492 ("ASoC: wcd9335: add support to wcd9335 codec")
Cc: stable@vger.kernel.org
Signed-off-by: Ma Ke <make_ruc2021@163.com>
Link: https://patch.msgid.link/20260914095009.12049-1-make_ruc2021@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 075ed20e9fad8..4170d8dc3e89f 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -5172,6 +5172,13 @@ static int wcd9335_slim_probe(struct slim_device *slim)
 	return 0;
 }
 
+static void wcd9335_put_device_action(void *data)
+{
+	struct device *dev = data;
+
+	put_device(dev);
+}
+
 static int wcd9335_slim_status(struct slim_device *sdev,
 			       enum slim_device_status status)
 {
@@ -5196,6 +5203,11 @@ static int wcd9335_slim_status(struct slim_device *sdev,
 		return -EINVAL;
 	}
 
+	ret = devm_add_action_or_reset(dev, wcd9335_put_device_action,
+			&wcd->slim_ifc_dev->dev);
+	if (ret)
+		return ret;
+
 	slim_get_logical_addr(wcd->slim_ifc_dev);
 
 	wcd->regmap = regmap_init_slimbus(sdev, &wcd9335_regmap_config);
-- 
2.53.0



