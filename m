Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029123;
	b=uLeQf0VXf2p8AOafzozoAiZOiLlKVJ8QNxH0R3Bu9vmvlJGpfVb6X+82DsJ2jvmVuONA
	 AiAkhR6x2XdaKrUPZUWuxtCkkURbE5PYABoomZlIFvZQBoOemT7M0NL2Dsx1ISajNiAIB
	 4Wu5XHgjdfdiy3rOmV2xMjGicdafORYlAsEdEI+VY/2reEB7+h6Ds4MpjMWtzBzjy1dwj
	 kAy4b8aXWGELtV5sd0SOMDHBffMoGeXxe/Y47XNb0wXKx/ZukrwCJLBvtpUMrEax9opZG
	 tfpVYv8hrluBI8typtOWfEXyMlvH8ETPhXkIbOu2mfrFokWFN1j1CdLpF6cLtptu6RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029123;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HmOETWd/wzMY5KqDFEOpxgf+ajXjLVNNVXccsJQ5064=;
	b=qt/+/cERZHD50qyLoMllu+1v2hfTlaVjzmJvZJG9YCImyrkzds19KYCTfGXv0jTMt84H
	 N2lw+Mf8OLZ4XLqsVKCPJ+xKqXbNv3zVqwsyO+qsuTy+hun5QePKDrSgTNgW7GyT3F/lp
	 /P6RJ0pWqlOyffCrFxvTq1a6CxyMLGUVQ9qFwehSNR/zi6fG+kx5tjRp9ZZmWkAfK7jnB
	 c6xHuBbMsSoLun5iNkyK1L378Rp/CaAlYRFsrvRE54257B9eER2s2SO10F7bndDfx1pkT
	 tJzIMhcfFWcfeO7MTpYQm1vTKQL6Pxr6XPsDwvo6cUaUKjslRGF0kcGKagn7wHbE9ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zbo2YIdq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59363606A31C;
	Wed, 18 Nov 2026 19:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zbo2YIdq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FB81F000C4;
	Wed, 18 Nov 2026 19:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029123;
	bh=HmOETWd/wzMY5KqDFEOpxgf+ajXjLVNNVXccsJQ5064=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zbo2YIdq93mQL0WSPLfejhDriMB4MIp2SsEHvQ/5YhJ7+GS3GmV+emNOZYI9+a1tg
	 CSSPWpO3FKlMgP8MZJISw83JwJFQVoq9Ox3u9AZzYfi0Qu3ka0Mqc/inJT8dq+hn21
	 SCHR2STl+xpEjCUzoDGIrV1MAkhytmVGN/yBfbY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0238/1756] regulator: mp886x: fix vsel_mask
Date: Wed, 18 Nov 2026 15:39:25 +0100
Message-ID: <20261118150017.755473062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 24fa0eadc2e3c7e9397924197dca7777ec08b8d7 ]

The MP886X vsel is 7bits, fix the vsel_mask.

Fixes: 97be82880b61 ("regulator: add support for MP8869 regulator")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://patch.msgid.link/20260901043123.5401-2-jszhang@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mp886x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/mp886x.c b/drivers/regulator/mp886x.c
index 48dcee5287f3d..451bd7c0abe24 100644
--- a/drivers/regulator/mp886x.c
+++ b/drivers/regulator/mp886x.c
@@ -267,7 +267,7 @@ static int mp886x_regulator_register(struct mp886x_device_info *di,
 	rdesc->min_uV = 600000;
 	rdesc->uV_step = 10000;
 	rdesc->vsel_reg = MP886X_VSEL;
-	rdesc->vsel_mask = 0x3f;
+	rdesc->vsel_mask = 0x7f;
 	rdesc->ramp_reg = MP886X_SYSCNTLREG1;
 	rdesc->ramp_mask = MP886X_SLEW_MASK;
 	rdesc->ramp_delay_table = di->ci->slew_rates;
-- 
2.53.0



