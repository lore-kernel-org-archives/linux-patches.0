Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F3F46C4C2;
	Tue, 21 Jul 2026 15:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649431; cv=none; b=TDBZQkg752Wup76k2DfPlxAax5+MudeDicYlJaNXpnvkZyXNlY2rfqSVg7y8PybUDiZAizF5uojjEA6tn5LH6s+PJGXQ4K0+rDBK7mTeu3jHtUN900jrd6NLu8w2Lj+K1LqF+g8PFojPGF1sROM0/DMF9fAyH1HyAZuEgb7ygVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649431; c=relaxed/simple;
	bh=m5WNVWQwj9kpedDDJQ9ovoA7UtQURxe7NDF1P93D2mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVFjz8K9h9efFhCiXn/ahAPIrHqMJKdvlER/WSal/k3K3rkycxf6zQqJ4+MGNYWuHSwZi+XsZxj92J5yamOs7U8LK39KYGRx/XDKGZYro3/zE9Nj9YjkDZNoC65xnA8/AWGOnoVCmXyfypwooO2J5SW+u6Sd8ChIwWIUsINFHtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcBfYiKQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcBfYiKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019121F000E9;
	Tue, 21 Jul 2026 15:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649429;
	bh=IfOhwwHa+/g84hGLW/c0hxbWcsiZoi2CJ2JJ3yVDcpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vcBfYiKQc/BoQjSmbnWBzKgM4JDZDlV6iRXMEO8AO6OrTCA7JnPdYWlt6YeXvlhOn
	 T68PkUVYfFC9X4DWJuhu1LTqw6LLJu17DhNIEog8DeXK8l+Cou3Cc8gzq5JkSk4DiC
	 A/e3JE5usVLQzUdsWrd+gvMUBIPNyfDQlQr5kaD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0575/2077] hwspinlock: qcom: avoid uninitialized struct members
Date: Tue, 21 Jul 2026 17:04:08 +0200
Message-ID: <20260721152606.369936010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 8752c396ce3b2136b3d4c906fe103f6efb6782d9 ]

The reg_field is allocated on stack, so using the REG_FIELD macro will
ensure that unused members do not have uninitialized values.

Fixes: 19a0f61224d2 ("hwspinlock: qcom: Add support for Qualcomm HW Mutex block")
Link: https://sashiko.dev/#/patchset/20260319105947.6237-1-wsa%2Brenesas%40sang-engineering.com
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260512091339.31085-2-wsa+renesas@sang-engineering.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwspinlock/qcom_hwspinlock.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/hwspinlock/qcom_hwspinlock.c b/drivers/hwspinlock/qcom_hwspinlock.c
index 0390979fd765d0..712003a4640cc1 100644
--- a/drivers/hwspinlock/qcom_hwspinlock.c
+++ b/drivers/hwspinlock/qcom_hwspinlock.c
@@ -202,7 +202,6 @@ static struct regmap *qcom_hwspinlock_probe_mmio(struct platform_device *pdev,
 static int qcom_hwspinlock_probe(struct platform_device *pdev)
 {
 	struct hwspinlock_device *bank;
-	struct reg_field field;
 	struct regmap *regmap;
 	size_t array_size;
 	u32 stride;
@@ -224,9 +223,7 @@ static int qcom_hwspinlock_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, bank);
 
 	for (i = 0; i < QCOM_MUTEX_NUM_LOCKS; i++) {
-		field.reg = base + i * stride;
-		field.lsb = 0;
-		field.msb = 31;
+		struct reg_field field = REG_FIELD(base + i * stride, 0, 31);
 
 		bank->lock[i].priv = devm_regmap_field_alloc(&pdev->dev,
 							     regmap, field);
-- 
2.53.0



