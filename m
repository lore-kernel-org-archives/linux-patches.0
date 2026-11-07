Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064898;
	b=VJIxAbhns8A+ft3SZq6y6VcAP6+vhBxJRdXPmy07tfbMRyLE0gFIJD9jb7rrqRgSu9Vs
	 QjzSadbdwGJZvMHy6OOOSHNcjwhxrJUdTBUtyYDhsWIS4OtDYFCb4hA5LvmaJZ1lm6Wh9
	 jNXbLq0yom0avjXrLM51aSOBN9kxFOavGiRX5tytOotR+px7Z/2HqMl8eWpGQ5ykYEx+X
	 OYMIMBcy0lxF2der+9Gsj6KgE/fZhYk7qkbTRmcxqaOweA6dO9+j9uGhT9DoneH071RFD
	 Kt6VByKw6chie3Izgfqldipr2sfSkX3IEYf6ZJMsKHYhXnIrT35c+4JCVbuqjzIx0Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TwspIsmlcA00rjcO9LWjkN2v9Xa955kzGwbALFFRMm8=;
	b=o6Twik1hnY8hBuhDjNat4n74504rLT3bM8Xp6Ttsw3l600TudMNeour/fXwKaYpEGRsJ
	 qiwoaKONPkQE/vIrUpItrJ7tThfU6TxGsnIjqgrMmvnd1LyVNWmH6XpNZf+U5oEQhID+d
	 gRbtgRk3XSByhwQdJbZucN90Th83jP3e06icqE7qEm4iN+Nj+4pyEzyikenoAqZSsyFLQ
	 IOwLBuMQGaCr+m4wSIwoE4m9e9SQTvjoi1jQV8dWoTelebEZGBQL0dGcj/4atIR1InbXj
	 72FbOhItq2cj4P6ULxo+fG+v5ww06nks5wHqyMJ97iuVAaX10VTO+S7qZVDvxUrEUOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yUqBPvFM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C2A606A9E7;
	Sat,  7 Nov 2026 15:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yUqBPvFM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6776D1F0089F;
	Sat,  7 Nov 2026 15:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064897;
	bh=TwspIsmlcA00rjcO9LWjkN2v9Xa955kzGwbALFFRMm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yUqBPvFM+3u1HleabCm+3RsPHjKZHWRe7x/eYWAYxatIpihYLQrdet2IG/qn9skVy
	 5eJFwnrm5+ASk8VdUFOJrcjFMY1XA/1oPxJQBod6vbuxQFGQiiESD53g9K51y1r7EX
	 aFfZVwpxTw/kpIOZvRRfKZfw6szI/OSV8aU3yea8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Charkov <alchark@flipper.net>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0803/1257] mfd: bq257xx: Mark self-modifying BQ25792 registers volatile
Date: Sat,  7 Nov 2026 08:51:39 -0500
Message-ID: <20261107135001.513569584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Alexey Charkov <alchark@flipper.net>

[ Upstream commit 56d974f3ad074a60bf877d131eab8b1df5b4f069 ]

Some BQ25792 configuration registers change without being written: input
source detection sets VINDPM and IINDPM at plug-in, plug-in also clears
EN_HIZ, the FORCE_* bits clear once their operation starts or completes,
EN_ACDRV1/2 follow input path changes, and ADC_EN clears after a one-shot
conversion. Reading them from the cache returns stale values.

Mark these registers volatile, keeping the cache for the rest.

Cc: stable@vger.kernel.org
Fixes: 9adbe53e32cd ("mfd: bq257xx: Add BQ25792 support")
Signed-off-by: Alexey Charkov <alchark@flipper.net>
Link: https://patch.msgid.link/20261001-bq25792-volatile-v1-1-cb3d4ec8a414@flipper.net
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/bq257xx.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mfd/bq257xx.c b/drivers/mfd/bq257xx.c
index 054342c60b731..01f5fc97f5385 100644
--- a/drivers/mfd/bq257xx.c
+++ b/drivers/mfd/bq257xx.c
@@ -52,8 +52,18 @@ static const struct regmap_access_table bq25792_writeable_regs = {
 };
 
 static const struct regmap_range bq25792_volatile_reg_ranges[] = {
+	regmap_reg_range(BQ25792_REG05_INPUT_VOLTAGE_LIMIT,
+			 BQ25792_REG06_INPUT_CURRENT_LIMIT + 1),
+	regmap_reg_range(BQ25792_REG0F_CHARGER_CONTROL_0,
+			 BQ25792_REG0F_CHARGER_CONTROL_0),
+	regmap_reg_range(BQ25792_REG11_CHARGER_CONTROL_2,
+			 BQ25792_REG11_CHARGER_CONTROL_2),
+	regmap_reg_range(BQ25792_REG13_CHARGER_CONTROL_4,
+			 BQ25792_REG13_CHARGER_CONTROL_4),
 	regmap_reg_range(BQ25792_REG19_ICO_CURRENT_LIMIT,
 			 BQ25792_REG27_FAULT_FLAG_1),
+	regmap_reg_range(BQ25792_REG2E_ADC_CONTROL,
+			 BQ25792_REG2E_ADC_CONTROL),
 	regmap_reg_range(BQ25792_REG31_IBUS_ADC,
 			 BQ25792_REG47_DPDM_DRIVER),
 };
-- 
2.53.0



