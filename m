Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E6C3B2D1D;
	Tue, 21 Jul 2026 20:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666012; cv=none; b=Hs4K9ffBuc8ABvjmKf656MoA74bPAVoE8ORkdQ7hxLL2/eK4C81OXrPokxQ0+ml1FEvDa+vgsk7maofGfHeQ3MHEno6FEIow4nnJE+1OkLB9l1gPwTDqoAKaYvGHrABIhv0v7Fjky1HCTFSytedlCtKYTDKbRkQEUGcB/jZ5qCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666012; c=relaxed/simple;
	bh=5yyUlieudDHL8hxfbuBLMIqfT2h7Hu7cuVmplt1AK3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqD31lC7luwj6GctaCVSjtlR3peOQ8/PYgRVs4mjIwZEOS6emwZ5sI6fYS2yoP1mArhtct4J9sy93t3FFNOvmCneqR18BRgETLfH7oxo2NgCVhYuZTcug2fbpdApkld8IZ0gdMAYg4tLYQFZaVBtfGLFNXkFrcihOZmaurAiJTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Re819oLI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Re819oLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CCB1F000E9;
	Tue, 21 Jul 2026 20:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666011;
	bh=7QQaBUqjC9pHNX5QjdpvUYCHDD7Ht8j7iIdyovRuKo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Re819oLIdKToIHPynN3razFmG7YdYIoyhSoDBGwozpZC6Zl5lRC1U/6dyOTfJCWG2
	 TgE26XeADQ9gG/7dKb7eNEWtf3OJqzGC2LBUgtsVq081/VwByiJuDX0kR4qhaA0zM+
	 ApU147/nQoGNTgTKORvYPj9/x6S0zDMMqHawTzjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0522/1266] hwspinlock: qcom: avoid uninitialized struct members
Date: Tue, 21 Jul 2026 17:15:59 +0200
Message-ID: <20260721152453.533960535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a0fd67fd293444..1daba80c6d6bd7 100644
--- a/drivers/hwspinlock/qcom_hwspinlock.c
+++ b/drivers/hwspinlock/qcom_hwspinlock.c
@@ -178,7 +178,6 @@ static struct regmap *qcom_hwspinlock_probe_mmio(struct platform_device *pdev,
 static int qcom_hwspinlock_probe(struct platform_device *pdev)
 {
 	struct hwspinlock_device *bank;
-	struct reg_field field;
 	struct regmap *regmap;
 	size_t array_size;
 	u32 stride;
@@ -200,9 +199,7 @@ static int qcom_hwspinlock_probe(struct platform_device *pdev)
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



