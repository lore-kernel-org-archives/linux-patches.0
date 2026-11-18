Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048558;
	b=st7TawMhTUouw0s8aIt4wCMsh5TQz1jghLXJ5gVB5ijCSDMwf477qFL6AnY/hhnta9B2
	 nLOJvg8x4iQrJg3uCp2xTCrBtsAGeq1xG0haEjNrvvDcxiIsKSEebNX/Wb9zl0rna8aVp
	 bUCNXvUHosUXEqkJQMrSmpqhVWYm+syecuU06oEAdxEGB9WoYwVoUb/2zzHBvDeuxmBtR
	 AXlmPRdBPD9CpaQxbD2+H3xfyZ3JwKLcrbq5doyFDMiIGXNMt18kmLkqUDrjDjLFu2rMF
	 6VnlDg5Li0h7XtNybHSTGZCUM4Sr/idk96Pzd5V4vCSC9OFLE4Bowq16wY8diOHWVLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BzPxXuymIHvJ8Qh+me5hHJxhBOmWya9l4hs0v5FKtHo=;
	b=5amWZrwCTO1KYgmHoRmOL0d6r/nOeEKD1R6aphJsQCREZlg329Popzu+1CfNebAvHPzj
	 7imMwV8a6z5qZK9yJCm729dx122seQ4Z2m1pAvsRJQEIb+L3CcMofb8uKpgMWzMig/fNP
	 s/Xsoq35xbWjFRofZsctFpIBwe8SLoHtd7pFTuwJDu+Y5BsaF2YLhOh/33ebiCp1DjC6E
	 uVzneS4W6lCM68l9bYMg2nljHeYVtxD9SyI2CxmEnU+ACSYhwJwQjrT3RdTsDnoYp59DY
	 rIu4AL2zdoHfeBSjOHWlz1o3gyIvxVzDOlzQiZhf5Dv749kbZIqq3Eq/rDhbtFV8MLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0R45JqAL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84226606A31C;
	Thu, 19 Nov 2026 00:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0R45JqAL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E161F000C4;
	Thu, 19 Nov 2026 00:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048558;
	bh=BzPxXuymIHvJ8Qh+me5hHJxhBOmWya9l4hs0v5FKtHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0R45JqALk4mDd1icWOvGlrKu61doCtxHcQEn6PLLjP8STvl3uC5wBatNkbG8+LST2
	 Iw2l9ZbrhqQkM5ZujfJCBsGchGlMOPWC0AdIwCpk6RlTHTFsCV3PjHKOJ7MMPQJ+9F
	 F5aD/6LPlF9M033eWJaouuGnz9aZDg3ywirN40ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1996/2857] regulator: mp886x: check get_voltage_sel() return value
Date: Wed, 18 Nov 2026 15:50:30 +0100
Message-ID: <20261118150313.239038735@linuxfoundation.org>
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
index 7910896df51a5..f42572d0f94e5 100644
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



