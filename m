Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036123;
	b=Xc1tqVVk5hAuCGB0IPM2eWQoMNmqqBIU8gUe4qpyDYwRCe4E8LdI37NhpvpM4KV/ZxMt
	 N97/Bfgt+WbvWeVsbu94+pOFP8ta7MJ0NTnWhwImybr7Wk9z1hzsPbTHFO9OaouwDnLNg
	 sAEw+AKi5HMf/jrD8w4yHB6yKi1JxQwanYhnVqh7pALeR9s6W+othW9THJ/4ccptblh5B
	 rI0SPgq+XDq1+wIIOK/f8jul+5S1hCroANCPqYS9dTk3EBYaPEjQpNlAU+Z1zswsTwOj5
	 gh5a+1c5DvEG6GKtL+AZsWQDicqYOqkS+/ZlNjnGupCDaw3WYMMPFaBBKbBm0eGDbfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036123;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KPER8iEhy956xHmtR0116tVENwk332IkIaK3OAeszUw=;
	b=mmv6wYnQJs4s7Q5VptI0t7aZHh9LDlY8+CbXNL3KxlGyZufWx/P60dnKqhoROYtdmL55
	 Rn5ESeQfuRrx+8XnBUsZuSEPt3U3Flce8oKRznlf9ZnTCAaBQ7b0dVF4GEFT+OAxiiIt/
	 g9DIAAyCQhwR7OAXWngp6ubAdu2Ibt+9Ej9Sf9qpnlPPwql45ImMcT1IaVW13mOIcL0u7
	 7fWJu8gziJOnLfwsY7VPi8hjJpbXvfU8ma2SNzgnXRsqcLE4oJwKcG0SzJSvVbhPXUaSk
	 9FbsrWNnuox7aQM8MYZCL8krvCWR/C6+A1DHAxKdYUWI6SyfMqN5zGPGHOTVPJ/vXig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ArEoSVay;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558D3606A31C;
	Wed, 18 Nov 2026 21:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ArEoSVay
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7B71F000C4;
	Wed, 18 Nov 2026 21:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036123;
	bh=KPER8iEhy956xHmtR0116tVENwk332IkIaK3OAeszUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ArEoSVayuNUZw9GJ3u+pMW3uHesmqubUBqkpiF1t+DZiZIKRILKyg/C5Xt/lg7vug
	 +oAOFlYigJTdMYh7e0T1hrRUrxkW/BZWZmSk+fto6CIZTg7hhKdCanRSCrn/bbBt3R
	 RD2ccUBi/q+8zKkcnxZ1wflIahs7l6hKdLkRmttI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0947/3318] ASoC: wcd9335: Fix device reference leak in wcd9335_slim_status()
Date: Wed, 18 Nov 2026 15:26:09 +0100
Message-ID: <20261118150348.011304980@linuxfoundation.org>
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
index 8d5d186fd5802..d805d971979e3 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -5155,6 +5155,13 @@ static int wcd9335_slim_probe(struct slim_device *slim)
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
@@ -5179,6 +5186,11 @@ static int wcd9335_slim_status(struct slim_device *sdev,
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



