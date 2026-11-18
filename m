Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058365;
	b=t7jWmNNo/o8OeSzq4HnxVPHNJqoNZ35l/PjfLxn9naOG7M+IlUqBrQ5aPHD+6WpQo/yb
	 aZ6aaPg2hxDGT+Rezs7T74xC0O9KM+J1SQXy9uc2hYflJE9+YVF0BjQV9yMpnlsIwdShu
	 q8BgeKoPoqQbevqcEpzQKs/733Mmg7GAIxKymNDEUm33vKDKPbIdchxphsLkoO+5vzG8K
	 fpBWN0EDwQ+vBf3PDQC9nHU/xWmFUfYVAAcFS5c4bgQ9RCTgwF/oOxWx8GKPWyxtU5AwN
	 QFztcbSUYdhL/cmAqdHdbnmTJH74Fw2qgw7uOiYi3bj+VjpH/kY1zyW8xh35baKvoIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M5ri02OtaLWoraLGcfVNrva3BcUB6Wuee+FMj7602xU=;
	b=sdwysDw/+AxxZg8k7xs47GqZylrg++Qu4LSF/KmqaV8/VoD+fWo8L7ZJhTolbQUJ8HfC
	 QmoBNGr9vvLajv2W9VBHdWT3N1JWAAF07FHRLHMIuqSohRJTTBrjYAI+czS/sEC+7ZlDp
	 T7jahp5J+kCfzpzI05VAGuLoQvTTWAn5y+c6bXp9xf29O2/W1NzFyETTUnnpvPAqioMvl
	 Lpl0RFmpJ9g6iBMWqTo19J65mC7lcTByn2UDhWNox+0ZQtcCOtTJhx04ny8E5AzWSQDMg
	 hT0AKXx3DwzsB76ggQQhRurVxrLW2ZNnQKPwEUZMO9cl2UY8JDphaTutWSMYg+4CzTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mEpfdFQj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DD0606A320;
	Thu, 19 Nov 2026 03:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mEpfdFQj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E82E1F000C5;
	Thu, 19 Nov 2026 03:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058365;
	bh=M5ri02OtaLWoraLGcfVNrva3BcUB6Wuee+FMj7602xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mEpfdFQj/Ch2rqkn1dNt8+oNv/EmpBae8Irz9OJaMzEFsqkuRLFTd/2jF6LSWAD2A
	 gAo4WIHpUZWAOL60GTbsr5xUwqVKLdzsPz1U9SEyvG7H17c7U1c9s/AMXAhFDpOsHT
	 JmQSxuaWcN+KxOLUhvkro7jbA1KfZjtjc0EjjM6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0442/1848] ASoC: wcd9335: Fix device reference leak in wcd9335_slim_status()
Date: Wed, 18 Nov 2026 15:41:20 +0100
Message-ID: <20261118145932.737994483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 33c29a1f52d00..003b9086a6173 100644
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



