Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016810;
	b=YIJ4oIiRdZcMvAVa/pBzJtWoj86tTUGKw1TtXQbJMsbGghzxzL5Gy7fJJlPeIZMAwp++
	 0/2MzdtBjF5yiJvNTaxLZvvuICAg8WT/USmm/tNidUPA1PROeGiIuP5mVO3aIsGopUk87
	 XdMLcDab7Eh+4PufS3Wu5MZn1IluzZ+OfosB14XhSnZ7jkK0cXBhJtcJYQ0Fc1KEuJtWS
	 UYFN1Z9oeLB1PN7rxaQ4QFCVHlHRDBwAJwNUhvGCsZRGU2ULJiJ3STk8pl1Lg1WDxVM+R
	 nXzy8eHanPATByVFxOzXvsWRyPhcLhUrgNBwJu5kVbMg3AcZrG/ru2XJ6c83LVDK/MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016810;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N7n2miZ7IPOSQQWVYFqmhqaeRG9ZeiYSnbfXgfrQNEw=;
	b=ru+wl11XIacpJY9VUUV7Q8CFE+ym+a4gBb/ZR6E4ab/7PIWjRdgmmhZm71qIZCBTlPZE
	 MoqIRf5mVXhmA5qUfMucrlZLrIm9uxHRpd5KM4SdYm8vCOnSxqpC1g1/wqohpst99iy4D
	 21W7YogzwRHpVxF/lxx5bJDyxgikEZKyWFup1spVFN6zbWWk5DrZ2igPQWtsEGVkQx4VP
	 FZzMsjcXuRw6Zrr3R29ScfwIiHpIQwdp8W+W7w16dSv1exGUAAHUv7rcWM3ae896A2M3u
	 4+05w3vNqNPV1CE+Rtw6wGyHXZEJ0xrrk/sZ5SwMfoXM4c3WeTUBjwIsghNNVj+tgQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iUxnZVD7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDE4606A32A;
	Wed, 18 Nov 2026 15:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iUxnZVD7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374691F000C4;
	Wed, 18 Nov 2026 15:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016810;
	bh=N7n2miZ7IPOSQQWVYFqmhqaeRG9ZeiYSnbfXgfrQNEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iUxnZVD7a4VaaMm/Zu1S3ovScXHglE8ee1czStlDpm2mAPCGqZstGAXHwDfGb1qSn
	 6qkiappFRrHbyiAY36kzF1cPgmCG9fR+yog+ql6ysOztM88y1kPzSbfBCQOuwPKZQg
	 veSXM1kEtYqZqkdxbKN4TuFr1CqbqQ7zux7TY1gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0662/2651] regulator: mp886x: check get_voltage_sel() return value
Date: Wed, 18 Nov 2026 15:31:42 +0100
Message-ID: <20261118150311.707236487@linuxfoundation.org>
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
index a10f3a20d413f..5efb8585fb330 100644
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



