Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043915;
	b=VCIJJNmRgAXqyJKSzE6eOWHPaBRtjQVYwo3MzrfWhfP2hoQseM/pEcvEqdOLKyzi1QAH
	 vJRk91cwZbrlbA2hrhP/IN+KwTSgHSrEjfBEKtrXfRuAAEZkZhPjU3AhfSwSe9nZg4opQ
	 oGr39JNAaCuyiqvN7AloPOFCS11i7V9hBsX5Jy08HcXdKrhXmC9gFdGdGMnfPGUPpl7W0
	 Ra9hX3psvgpxfuqfK8Lmp51+4/GoJ1FtpV4ZxmoY2HH+8YsfnHsRnHd4rhd1AefpNwtl5
	 eWaVgtzk4yy8T7GH5D4OjYYi2dZGvCMkEI6qg10SVH+7kgqS8A68yW8hh7UhdfNbngw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1IP6oYefBkzeVEqzlA2yzy8TZRjjryj1SQAXpGZ9hVc=;
	b=Lt4QH8b4vNc50hxDc2urjPCa1agorYoQ3OMVqCE3/AplBJvShRROeikKSJcXA5kO0IHo
	 0/DVLVr9EENsTScG/qQhVeVSFAmUgGBcDHwe14qLluCXxTGKPPDif8vjLCJmtQJ1ostAs
	 VyvvFdJeSNekChtR+P5syS3XISeBElXeYoN/kBPxzDADZG5+Mp7ek/fhJPC2KCHfqjxW5
	 n8s56fsGpqHoVJOu3TLTFTlxPmAmJDJCSLdYjSsqM1V3B0yAf/mTA0K8Q5qWyJ5trDEjk
	 yUVIJl+L5O4jgMQW3dVrZqBnhnDVv1MHSsj7kFY0dQ242bFkyT6agfnT1rvyD5HLXrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U0NZ4ZJx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6070A606A32C;
	Wed, 18 Nov 2026 23:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U0NZ4ZJx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A997D1F000C4;
	Wed, 18 Nov 2026 23:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043915;
	bh=1IP6oYefBkzeVEqzlA2yzy8TZRjjryj1SQAXpGZ9hVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U0NZ4ZJxecnthcBFmhlbwZvJDtAqP3zOOxaion6huRb2JOC0s7gUUxbS+uxBJb7SG
	 bwt+1qHD9gg1ifAanrvKs/meKAowAkZ+yFh1AaHyeOK1P+xdT0Jrcqvib8CxeFSCiT
	 pC75mDSS5spYQKC4Ce7Qw/lSQwLfE40XwThhHnoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0382/2857] iio: admv1013: initialize callback mutex before registering notifier
Date: Wed, 18 Nov 2026 15:23:36 +0100
Message-ID: <20261118150215.161733391@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit baf7e43b7fb5afb777353bf265ddf9d909f72b9f ]

admv1013_probe() registers a clock notifier whose callback takes st->lock
on POST_RATE_CHANGE. Initialize the mutex before
devm_clk_notifier_register() so the callback cannot observe an
uninitialized lock during probe.

Use devm_mutex_init() so the lock lifetime is tied to the device and
cleanup stays paired with the rest of the managed probe resources.

Fixes: da35a7b526d9 ("iio: frequency: admv1013: add support for ADMV1013")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ sashal: Replaced dev with &spi->dev in the devm_mutex_init() and notifier calls, since this probe function has no local dev variable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/frequency/admv1013.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/frequency/admv1013.c b/drivers/iio/frequency/admv1013.c
index 9c147b9e89826..5238dfdb1de5d 100644
--- a/drivers/iio/frequency/admv1013.c
+++ b/drivers/iio/frequency/admv1013.c
@@ -613,11 +613,14 @@ static int admv1013_probe(struct spi_device *spi)
 		return ret;
 
 	st->nb.notifier_call = admv1013_freq_change;
-	ret = devm_clk_notifier_register(&spi->dev, st->clkin, &st->nb);
+
+	ret = devm_mutex_init(&spi->dev, &st->lock);
 	if (ret)
 		return ret;
 
-	mutex_init(&st->lock);
+	ret = devm_clk_notifier_register(&spi->dev, st->clkin, &st->nb);
+	if (ret)
+		return ret;
 
 	ret = admv1013_init(st);
 	if (ret) {
-- 
2.53.0



