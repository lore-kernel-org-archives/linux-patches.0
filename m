Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAEA433BCE;
	Sat, 12 Sep 2026 12:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214662; cv=none; b=aonDH8ZH68B+PSxOmbpONUrIxeFrpnRWwuAeIerwG9IzgskBX+Fc2YRaEtC2VM1Sdgi8fwq7sg1kdHfcXZ1SXZWwY8ugd2BF45hzS0hZYl94grmOWSdZC+87DDpDqZ6Y8rC3KGi4IgkpYlHxm2/sN4eZOTv7AdNX9DK594y5khs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214662; c=relaxed/simple;
	bh=VPqVxtJmiaJ4fVYPLwi/D2/sYsAKfWBHj/G95RX2W+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jX5ilWQvZOMkVW0koGy/NvNLmtLtgN+oJ3rlN/7KbHFG11ejpC0D+9Jk033Nj1FKKzWskbrZLYvdPEG98PgfFTPQ70IOe1uQAZax36uDChts6nEjTDS53Ua8DHRddaPKZC9GVGhRVYllQUl66pIrnQoTQOpL18YHpFb72nbJ5bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQymMLGP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQymMLGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A9A1F000FF;
	Sat, 12 Sep 2026 12:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214660;
	bh=3FZ26+by0dOVsBGf+UMmBo2EaqR7ereZsxdlPDf9NZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lQymMLGPBaPpc+41T9Cu7dBgiKVzrqTBVTZmCmBEOOwu6JL5n3eolF8UXj+kKIWRb
	 HrwFjotdtCTSenlmFszOmh8pSZEhITZ3VTxdE9ap1rPhjf5m3/OVEwMe1X3pHHhWhf
	 N9CEbSNVFXy9Ayxx5WSXQW0iOlh7/gMRizbK4Tqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0370/1376] regulator: tps6594-regulator: remove hardcoded buck config
Date: Sat, 12 Sep 2026 08:46:36 +0200
Message-ID: <20260912065615.795240566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 180a135eafa9e05657559bb04cc9eb6a86ca45f3 ]

Commit 00c826525fba ("regulator: tps6594-regulator: Add TI TPS65224 PMIC
regulators") added support for the TPS65224 and made the description of
the multi-phase buck converter variable depending on the variant of the
PMIC. But this was just done for MUTLI_BUCK12 and MULTI_BUCK12_34
configs probably because this variant only supports a multi-phase
configuration on buck 1 and 2. Remove the hardcoded value for the
remaining two configs, too as future PMIC variants might also support
these.

This is a preparation patch to refactor the regulator description and
is compile-time only tested.

Signed-off-by: Michael Walle <mwalle@kernel.org>
Acked-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20250703113153.2447110-7-mwalle@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 7fd28093b3ef ("regulator: tps6594: Fix device node reference leaks in multiphase loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps6594-regulator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/tps6594-regulator.c b/drivers/regulator/tps6594-regulator.c
index 1284a702db8f2..5420c6eb3e1a8 100644
--- a/drivers/regulator/tps6594-regulator.c
+++ b/drivers/regulator/tps6594-regulator.c
@@ -695,14 +695,14 @@ static int tps6594_regulator_probe(struct platform_device *pdev)
 
 		if (i == MULTI_BUCK123 || i == MULTI_BUCK1234) {
 			error = tps6594_request_reg_irqs(pdev, rdev, irq_data,
-							 tps6594_bucks_irq_types[buck_idx + 2],
+							 bucks_irq_types[buck_idx + 2],
 							 nr_types, &irq_idx);
 			if (error)
 				return error;
 		}
 		if (i == MULTI_BUCK1234) {
 			error = tps6594_request_reg_irqs(pdev, rdev, irq_data,
-							 tps6594_bucks_irq_types[buck_idx + 3],
+							 bucks_irq_types[buck_idx + 3],
 							 nr_types, &irq_idx);
 			if (error)
 				return error;
-- 
2.53.0



