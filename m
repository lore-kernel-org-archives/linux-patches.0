Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DCC435532;
	Tue, 21 Jul 2026 22:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671639; cv=none; b=dQeg0WmuHApAbqYsTrIPd0ABftU6FO2lFz4R99hL+a5Nz6yyyBiGsjlySIS3rzPm7I6QsIHgftJv408Hjglxr4ex49Y9jyMCfo846AdohZ0B4R8g9N/ShQtwddAVQVRUXbb1LU2YgGnt16tERXgWxPXcK5CXAsL9MURszGylm0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671639; c=relaxed/simple;
	bh=WsdNRuzl0IdPXwY3ICIrtpvnJ59aygE1a6ofzBpkC9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YK096DF7L/jMREp4+rPfsD3KJKyBhRjyoYROZ65dyltAk0jOeW6sT6UmEzqfA0NOkXCfFMe+zvZ8UBDl8Xlh5y0ad07GvIOKCFoPWQq7cCuGsECJDfftjw3jjaeVdUczeYna5k6UKDUTb1npuVz68Ni3cvNOL+z02ddvFANLKVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12ONMys8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12ONMys8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42861F000E9;
	Tue, 21 Jul 2026 22:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671638;
	bh=BDFSobXXD0wzh5L8iE2kFq5GcinFjMQC4+GbP5FZYOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=12ONMys8cWKp0IklasYEJbg5PG7Cs8mbwfpo3OHbjZQKOxaoFMeYdz1oind87o4Lr
	 eNFMhkUIBgVTGS4gknTSyaCn1zz3WjcFfWhcz0x0/YRxmgMLwd6x3oOIhkQ9OjK9E1
	 SDCXt7v1y3Q1Oe4vsKU2VyvEFBx0YB12Ri4oJ8Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 323/843] hwspinlock: qcom: avoid uninitialized struct members
Date: Tue, 21 Jul 2026 17:19:18 +0200
Message-ID: <20260721152413.286136236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e4991466486397..6a2a2f3e618554 100644
--- a/drivers/hwspinlock/qcom_hwspinlock.c
+++ b/drivers/hwspinlock/qcom_hwspinlock.c
@@ -129,7 +129,6 @@ static struct regmap *qcom_hwspinlock_probe_mmio(struct platform_device *pdev,
 static int qcom_hwspinlock_probe(struct platform_device *pdev)
 {
 	struct hwspinlock_device *bank;
-	struct reg_field field;
 	struct regmap *regmap;
 	size_t array_size;
 	u32 stride;
@@ -151,9 +150,7 @@ static int qcom_hwspinlock_probe(struct platform_device *pdev)
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



