Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054206;
	b=TBtP8LjOmVq46WssqhFp6SZ2aMsuNPB/wk+KaTZhHpYUifB4U0R616Txjnyij7eYNVcc
	 PSaEzCY+x06oJhCigF6cC/LwjJpwPrZNcbI0Zs6ghWGHQNpmO+9qT59roMKRQi6nQrrOR
	 S9bNyGvssObT5cULyBNENW4CvkRpvPfPyKUVhAeRuUDUR0LIJuI9y/+8p/ILbjrynJf0P
	 cZ32HrhqNxlkiAZfMMEytdDlPq511SI/kh64uvUNrnIbZt7KvJiGC1uYqf8Nb5n5me7Va
	 59cvSUcMiuKHpLw3i2TkGxblzuODfWkqr4pxEGwJcUvSIPUNBsqTFDvDIbUWQ15HfKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7DIb3buLMXDqMHvVgCNBuHIeEY/MOFs9wjKZBURnKC8=;
	b=MUe1Yn2aCrztNzwa7TRjabR9feDll9GLozrMhlr4gVx2CRwgzE4nuVqHFXIjwycebQV2
	 BP92jNlawjDkUJnaxjEx5vXIHwXZ6rITA318NCBmRQjs5vL8y+PdDdbpxAByxwS3d/WST
	 yyHu+Fq5s+NJpAvJ7fKp+cgn378LbiQ7E4akwkMIQUNw/meS/oRcZsOiHPGhDkw6Im72I
	 Og0buxSeuqXuKaUtenp30qrb4uMKfIUwmSSOkC21nAGQeiGPoVyE3D+eZTNMgKhIVdV+q
	 sPC76qiXBejbFuGD50tJZFu4yho0BUon0SY8cVp+a69BmVcDSbyIIDWz/P3Ldvuuvqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=skVMO5dO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC25606A31C;
	Thu, 19 Nov 2026 02:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=skVMO5dO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EC61F000C4;
	Thu, 19 Nov 2026 02:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054205;
	bh=7DIb3buLMXDqMHvVgCNBuHIeEY/MOFs9wjKZBURnKC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=skVMO5dOmnc5hzLd2kn7/+HfvdArzPoHk1z+PurGxJWYfmRmEbRrBBxsi5VaoHIPI
	 C67uVR9NpCjSopPJwzG6FmF/K4FzhXnGh3wVN5xFb/iKamdIdQk4EA/CMiyKbR+RUo
	 +kJSlXZInFJycZxhPqcs7WSeZczGXeHTPEiaur+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1191/2214] power: supply: generic-adc-battery: fix status with no supplier
Date: Wed, 18 Nov 2026 15:47:47 +0100
Message-ID: <20261118150059.545419727@linuxfoundation.org>
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

From: Tim Douglas <me@timdoug.com>

[ Upstream commit 8ae5a3f40045ff486826ed6b6a83e39a0f380073 ]

power_supply_am_i_supplied() returns -ENODEV when no registered power
supply supplies the battery. generic-adc-battery's gab_work() tests this
return value as a boolean, so -ENODEV takes the supplied branch and
reports CHARGING, or NOT_CHARGING if the charge-finished GPIO is asserted,
instead of DISCHARGING.

This was noticed while bringing up an out-of-tree Linux port to the
WikiReader: the driver reported CHARGING on a device powered by two AAA
batteries with no charging hardware.

Only a positive return value indicates an online supplier, so treat zero
and negative returns as discharging.

Fixes: 46cecd130d55 ("power: supply: Fix power_supply_am_i_supplied to return -ENODEV when apropriate")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Douglas <me@timdoug.com>
Link: https://patch.msgid.link/20261013022153.6707-1-me@timdoug.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
[ sashal: Adapted the direct supplier check to a > 0 comparison in the existing is_plugged assignment. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/generic-adc-battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/generic-adc-battery.c b/drivers/power/supply/generic-adc-battery.c
index 0af536f4932f1..33e151422d946 100644
--- a/drivers/power/supply/generic-adc-battery.c
+++ b/drivers/power/supply/generic-adc-battery.c
@@ -209,7 +209,7 @@ static void gab_work(struct work_struct *work)
 	adc_bat = container_of(delayed_work, struct gab, bat_work);
 	status = adc_bat->status;
 
-	is_plugged = power_supply_am_i_supplied(adc_bat->psy);
+	is_plugged = power_supply_am_i_supplied(adc_bat->psy) > 0;
 	adc_bat->cable_plugged = is_plugged;
 
 	if (!is_plugged)
-- 
2.53.0



