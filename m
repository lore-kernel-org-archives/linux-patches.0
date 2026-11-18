Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015864;
	b=ONitvm0jX430W5JN9jLXRP5iC1J5qfXCqrK189yVhLBzyJOnr9Xhu5+782F6M02GTebB
	 Kx+eLKQ+Vc1XdVAJEvcSoAhZ0heL5O84EP3C19y6v268dQ04Xs8E7eda5aXxN8Oz4G1rE
	 vo0an4v4UzkV7qlKVOR37AyGkOFvYPHlsXqaY1YZ8JPYptNRHT9dTt6cJdGPueX4dJpO0
	 v3X8r7X6SdNNxgB50mpSz7VS9FH2xPAgZFkj0qF/M2VToXqkzd5jR/LqndtH8GxOZn2mW
	 RRZvDwb3BZ3MGfGbl9jq8jDGNgzVSODASqOmgJlAie5ROgggvPUv6J5f89oUiVKtijQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WKw04XY2eijIx0yVGNQ30P0o+wDBeO66Yf4A53QnXnw=;
	b=NkoQsAsmFW4LyuHua0gbKP2ZNvoYAQ5vyyfNk6bBoUWeosuJ2kD1dyy6R+TuhWGQvwUu
	 EAyKeEZziIZ5CyEroqK9K9rEVHfo+aFmUxNvcfzvsOYn2hbBbWO9kDU0zU0qrCjLZ59Mm
	 uDiY53zcxZrV+HiUtPpQwg1iQbqOsw/IgCT5ldhifrgWbBHv0+hJg5ISrC1Lh33MkD9nE
	 oseSu89Sp0JiEjaBTolu44nN8gwXj7BKDfunjIPwlX39kjLc2Bmiz5dWpbqZuodNqVF77
	 ppcGGLUd+ztmJpaUr2QNggeQUfb9swhTnN0HqsmJa6NZCHlK9tSbYkj79NAONjqW+pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oITEbadS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CE7606A320;
	Wed, 18 Nov 2026 15:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oITEbadS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFCD1F000C8;
	Wed, 18 Nov 2026 15:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015864;
	bh=WKw04XY2eijIx0yVGNQ30P0o+wDBeO66Yf4A53QnXnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oITEbadSy1UiSxLfaSr6sIVYC7BkPVap/4pacZ0rIFVbUhVrsBlWxkEevnIa0q5ob
	 yi+/qbvDiw21CL6X/2VAokjHIQWP2NNkUWAj/IVDGNaCm6RtcYwtUki/GjSQWpzvXZ
	 JOtBTvgXzTgiXAfAan9/M0ifsRwKk49nIDhti9mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yassine Oudjana <y.oudjana@protonmail.com>,
	Kaustabh Chakraborty <kauschluss@disroot.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0324/2651] power: supply: s2mu005-battery: return errors from dev_err_probe() in probe
Date: Wed, 18 Nov 2026 15:26:04 +0100
Message-ID: <20261118150259.532375500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

[ Upstream commit 38c8b37600b63db724c9c21d18d9989359353cc4 ]

s2mu005_fg_i2c_probe() calls dev_err_probe() when devm_mutex_init() or
devm_request_threaded_irq() fails, but drops the return value and
carries on, finally returning 0. A failed probe is then reported as a
success: the device stays registered with an uninitialized mutex and
without its IRQ handler installed.

Return the error from dev_err_probe() in both places so that the probe
fails and the driver core logs the error state properly.

Fixes: aa2132799817 ("power: supply: add support for S2MU005 battery fuel gauge device")
Cc: Yassine Oudjana <y.oudjana@protonmail.com>
Cc: Kaustabh Chakraborty <kauschluss@disroot.org>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Zongmin Zhou <zhouzongmin@kylinos.cn>
Link: https://patch.msgid.link/20260827020539.22837-1-min_halo@163.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/s2mu005-battery.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/s2mu005-battery.c b/drivers/power/supply/s2mu005-battery.c
index 53de6605b4922..a76154e5a0917 100644
--- a/drivers/power/supply/s2mu005-battery.c
+++ b/drivers/power/supply/s2mu005-battery.c
@@ -262,7 +262,7 @@ static int s2mu005_fg_i2c_probe(struct i2c_client *client)
 
 	ret = devm_mutex_init(dev, &priv->monout_mutex);
 	if (ret)
-		dev_err_probe(dev, ret, "failed to initialize MONOUT mutex\n");
+		return dev_err_probe(dev, ret, "failed to initialize MONOUT mutex\n");
 
 	psy_desc = device_get_match_data(dev);
 
@@ -277,7 +277,7 @@ static int s2mu005_fg_i2c_probe(struct i2c_client *client)
 					s2mu005_handle_irq, IRQF_ONESHOT,
 					psy_desc->name, priv);
 	if (ret)
-		dev_err_probe(dev, ret, "failed to request IRQ\n");
+		return dev_err_probe(dev, ret, "failed to request IRQ\n");
 
 	return 0;
 }
-- 
2.53.0



