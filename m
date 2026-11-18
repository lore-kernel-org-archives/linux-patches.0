Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024235;
	b=IFgcdWCdKRb70aiNa4hVLQq1wn9WziQVewv5Pq7DoLSmqg9JPxG94yr6mA65ICFfsWCa
	 l5uFllz1gK+eSz/VcUVIQb5SJLd7r2QeGEdQ9NHhnqi0mQVhbIKUzARvfURnK+4l1WZs7
	 FfUCs1LLi3z+DC/qO9oHLIjpMyxBYwpRs/GmoJFshTcKfOH0zo0XBYsdFipsSIv4WWL8t
	 7aHL72yqVZLpVhNIDbekxMgCfERo0eglXk14zVFanV2I64dSkFH8So8pP/F5nesGngJJa
	 342u65Y0RDbwSuoVCqJ+QTERVEFmXtCz0BHTZDrBadaWpE2VerEwk8IcEpszUgoJdJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DNEg/2D2xH0JAR/qtyo8UngHRKbGC0Vg39cEhlniUao=;
	b=Up9Csd7Vx4V/nf/rd/7bI8BnTo3zRRhiVwGZfxkeaen5OZaJ0ryzmkfPh/sOwYuHmFzU
	 pc5Rl5tkr64ZhEPpbFBv5nAJpLs6EaroPVRQETx38ifjyioB3DoYkFgD86/KEIOshwHdy
	 MlXzDVxrswUYF5GmpjfDKlLGlRQpEq316aDsFnu9mIkfPKMOLpWpuQkLLaVlu1KQZS2qR
	 rHfvcI0RRYSdXj6obdS2gY1t9am/f9BoOeKaUOJ6xt5phexMEIBRmKcSsS8iavdOpJ5Tl
	 AYLVJHGefajUd6+h+p57fGmAQ4FlTdrqghCv7zU9ZSY7mcd8mYNo5f+33wlEkqXq+JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ybaPSVqY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A6E606A320;
	Wed, 18 Nov 2026 17:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ybaPSVqY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D101F000C4;
	Wed, 18 Nov 2026 17:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024235;
	bh=DNEg/2D2xH0JAR/qtyo8UngHRKbGC0Vg39cEhlniUao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ybaPSVqYv5zx5rAxbjqA0vIIkkG4/mjTPzhpjUcm2tsXRzIPkoOjMp+oLu/7pNc4z
	 KXKI2tyeNEoV0uaNbEpJWxEuywaNCuo/N1uqGkk20klQcFyw0OI9ni4/dMuMYreCss
	 ldEPJE4OVmPLLLyUI1XiOK2MiWwKr3c7a3d0DLYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0602/2151] regulator: mp886x: check get_voltage_sel() return value
Date: Wed, 18 Nov 2026 15:38:57 +0100
Message-ID: <20261118150143.872352348@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 87121c42fadc7683469aee96ad833bc560197a55 ]

The get_voltage_sel() can fail, resulting in negative error codes
stored in unsigned integers and corrupted state logic.

Fixes: 97be82880b61 ("regulator: add support for MP8869 regulator")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260901043123.5401-1-jszhang@kernel.org?part=1
Link: https://patch.msgid.link/20260909143957.9284-2-jszhang@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mp886x.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/mp886x.c b/drivers/regulator/mp886x.c
index bbad6207ad7bd..6bad7ff40aa9d 100644
--- a/drivers/regulator/mp886x.c
+++ b/drivers/regulator/mp886x.c
@@ -256,6 +256,7 @@ static int mp886x_regulator_register(struct mp886x_device_info *di,
 {
 	struct regulator_desc *rdesc = &di->desc;
 	struct regulator_dev *rdev;
+	int sel;
 
 	rdesc->name = "mp886x-reg";
 	rdesc->supply_name = "vin";
@@ -277,7 +278,12 @@ static int mp886x_regulator_register(struct mp886x_device_info *di,
 	rdev = devm_regulator_register(di->dev, &di->desc, config);
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
-	di->sel = rdesc->ops->get_voltage_sel(rdev);
+
+	sel = rdesc->ops->get_voltage_sel(rdev);
+	if (sel < 0)
+		return sel;
+	di->sel = sel;
+
 	return 0;
 }
 
-- 
2.53.0



