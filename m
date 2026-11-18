Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042908;
	b=N+OtN0NEnUYjInCUeTSs35wtFc7OtXPICopruOUob8vLJ8fMcLknntRNtbvtnUf+jd/+
	 m8JzHhn8fZlmnsKccYmN8yx5kqanWMdwFEZqVdQtCD4VaDIJ31Io925AJf0yugv8JcOe0
	 rKqysJ1Dbhcdu+1XugYuxJwO/BAH3LVJuBah9T5379qB/wvRR3NPaWpSP7JL3TEaYC4DE
	 G3O4Syyu4+5LPPVI0NmYlpwm8StmpdZA56lkJmk9fDk8dnri18+dX237l8YwRQMucexxp
	 HjC05GAkfaTAiyVkxSu1hKEUvI4YSxwXhdcwJSq4+B2WHUAV/cbVV+ScST3m8UNY90w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=IW5fX8/rdP/qV3Tv5P2hF2lpBeWcWCkKUdrAYtV+RL0=;
	b=tdQNBNCfGI/vM93/9QIZAN/RzGuHhaduseZaK4Aqea1D3x17/Mr0CcuZ29DDUK55e3pT
	 wxyw1Sui8uaODtv/jA+g7WvIjMyqzRoZ2WgkUr8iW6qf9tgx/a5NwdfhkEgDO9irwlBdV
	 o/azBDXqJzDVmLGy0ms00xgAslbz5SZe7WwgPdGkV4pRb802r+3HObqlMvwV2Tf4kUGq2
	 zetHW+YDSxjBe/tFF4y1uA6aGeI2rOTGg82wPOJXOMbFFaNIbPPS2ZlduUvYMgEs7SQu/
	 0gLmh2YOlqVmdPlHQUDzg+rO+jgAmpG4+TtLVduqJnK+h72OQldXHI6MEljGDyPBEWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RUrlWzQ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C006606A31C;
	Wed, 18 Nov 2026 23:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RUrlWzQ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9AA1F000C4;
	Wed, 18 Nov 2026 23:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042908;
	bh=IW5fX8/rdP/qV3Tv5P2hF2lpBeWcWCkKUdrAYtV+RL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RUrlWzQ9yAOLGa7HBAUzICBLa3XaMB6ysURJuNqCdyTFbmQkG+wObqBK3M7CItnyz
	 nM4Pleh4F4K5/pEWR1HV81of8EM3pcp0eUGDbWLhQFC1Ct8XEA59oXd98K/xH91dIy
	 HixMXPKOMS3jkyFlPQQDQBt+QbGjNaCMbDP6G7GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kry=C5=A1tof=20=C4=8Cern=C3=BD?= <cleverline1mc@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0023/2857] w1: ds2482: add OF device match table
Date: Wed, 18 Nov 2026 15:17:37 +0100
Message-ID: <20261118150202.198333742@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kryštof Černý <cleverline1mc@gmail.com>

[ Upstream commit 53f33fd74d3993af0fbb5494b5be709f6ca6b712 ]

Add an of_device_id table and hook it into the i2c driver so the
ds2482/ds2484 can be matched and auto-probed from Device Tree.

This allows automatic module loading when instantiated via DT.

Signed-off-by: Kryštof Černý <cleverline1mc@gmail.com>
Link: https://patch.msgid.link/20260612-w1-of-autoload-v1-1-74e8a17626e6@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/w1/masters/ds2482.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/w1/masters/ds2482.c b/drivers/w1/masters/ds2482.c
index ffb1ebb1d2b0c..8f13b45904e70 100644
--- a/drivers/w1/masters/ds2482.c
+++ b/drivers/w1/masters/ds2482.c
@@ -553,9 +553,17 @@ static const struct i2c_device_id ds2482_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, ds2482_id);
 
+static const struct of_device_id ds2482_of_match[] = {
+	{ .compatible = "maxim,ds2482", },
+	{ .compatible = "maxim,ds2484", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ds2482_of_match);
+
 static struct i2c_driver ds2482_driver = {
 	.driver = {
 		.name	= "ds2482",
+		.of_match_table  = ds2482_of_match,
 	},
 	.probe		= ds2482_probe,
 	.remove		= ds2482_remove,
-- 
2.53.0



