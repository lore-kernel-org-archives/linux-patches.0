Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045179;
	b=otcmnFjXcR+e4S6ro/QmcE01IGx7b21lQdCepp3jGkSffZ0HWTszB1wCpz209w0VSLbT
	 Tl6ycyd/UVhAqpRhbeh42VmkubClFdtOBzl8JH2082rUIsz8BY8/MTa+NUEtIvHO/PmME
	 wkKiZCLyhL2l53MbeWTOHHn8Lxmt0nuOOJcepJJ832zfAq02A65SWaMzexBpBg37ae4JF
	 Vt33Ys7LiJJsx1B0W8kAHk8PSWXet34Q9QrgrHFflRkU0Tlhu1qHqFcQ24NMqtkl0XjJ7
	 ZnPw34fXlBBv7KaMU3Mts3gDOAmm1/nl5WrkCltmaeD4+ZzfUgJCkvIFUzEJjR+pmkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K1NdzN5PfxXrxs1t9asMn9Kmb1m5GpXbJpujt2uP7Sk=;
	b=A1jrN6QHOlEeYTW0T3o5XecEoI3aY0MWTkVDWEzDDw1qdV3b85SIbKAGE3Trgtxb9qqV
	 l5oj6cPKA1dYsI0x2YGYIzed8oweEhLtBZb5VWL9rkTFUrHNSssyakwJodscvs6LQTdCu
	 rBsLR1cRNY7ktkaWgq+E/wqJHVtyAC6OruTtWYcYWaFrkdP0XE71lCayKIo0jlMfBra5T
	 e63LWqXYO5DeDmf7CNYP1FmnAmFh+Jwt99TgoRl1jPKvlJE/qC96btyDz7JJx+U07bNV+
	 pIr9ii3XqmN1+zzPL/IKvQWdvJehDnOsh9BxMRzQ9EcU9cI0vLkTcOvbFi/m9wD0b6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CCwDhna/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF056606A32C;
	Wed, 18 Nov 2026 23:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CCwDhna/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0867C1F000C4;
	Wed, 18 Nov 2026 23:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045179;
	bh=K1NdzN5PfxXrxs1t9asMn9Kmb1m5GpXbJpujt2uP7Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CCwDhna/VIf3mFRbO5hKZ5MxKnpNaPM5UZiIvDxtvzHImqIMz2qFYPEk6puEe8RPW
	 zR+f9Ca+LglmgisEKZnISRdyVCT5rzduinviyRJ+PwC/FevEmPOGSevru/hk942m/0
	 g5LXT8oV+TiclcrXQwna9nirCeo8fArobulTBZtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0829/2857] ASoC: wcd9335: Fix device reference leak in wcd9335_slim_status()
Date: Wed, 18 Nov 2026 15:31:03 +0100
Message-ID: <20261118150231.420207180@linuxfoundation.org>
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
index 99de81c489681..e810951f78600 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -5158,6 +5158,13 @@ static int wcd9335_slim_probe(struct slim_device *slim)
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
@@ -5182,6 +5189,11 @@ static int wcd9335_slim_status(struct slim_device *sdev,
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



