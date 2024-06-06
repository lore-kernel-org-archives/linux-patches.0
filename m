Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A716196C9D;
	Thu,  6 Jun 2024 14:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683123; cv=none; b=tRvmtdAQERSAAHLmY0sINsVreyQe+ocbRl7aFaQY4rbXCtcHKyb18pI7J6+qoOPQ85Kw1+AREoFEkQoF0dcuveWMDWXkeCl10UXwAWdz2J3JQrafnSeBClXOVWUa0pWr4yFo4ebzmwapE80FNlZcboBRqk2HyQLJvqpMy2yWrJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683123; c=relaxed/simple;
	bh=nVjX+Y1BXqUL5pYj/8pHH1zzNTlGBTBbSiyKl1RWS28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmgygwghCnUlRDtc6UufV/MXR9V4VqL/YnBw3wJek7toWuhZ/5tr8rYsyjHGDIDPwdxijFC07BcRMVg94KVqfMndiqgANSNSSi1gio+dkbvVqJ6E/fZZZ2FkaCecayZow9h3fEGeRlu9rj2WhbaFyMzOIBdWBVor9LbDVT9Kwec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQ2KnqJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQ2KnqJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECE9C2BD10;
	Thu,  6 Jun 2024 14:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683122;
	bh=nVjX+Y1BXqUL5pYj/8pHH1zzNTlGBTBbSiyKl1RWS28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQ2KnqJnmBa7oqd6IIxdfgFE77WM1JKQOgCXTUsUijDxFcF3hOPIh/Ayj3l1DJZxQ
	 7T0P+tMOylIpiksz9dwa0NxarKOIPQlGhjIW8bcwOyOVmlzY1BlBnbYgeDOjzt4g6P
	 ax/826fJagA8m3iyvAxYRwDs0aYlOsII5hMw105Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/744] regulator: vqmmc-ipq4019: fix module autoloading
Date: Thu,  6 Jun 2024 15:55:35 +0200
Message-ID: <20240606131734.436353911@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 68adb581a39ae63a0ed082c47f01fbbe515efa0e ]

Add MODULE_DEVICE_TABLE(), so the module could be properly autoloaded
based on the alias from of_device_id table.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://msgid.link/r/20240410172615.255424-2-krzk@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/vqmmc-ipq4019-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/vqmmc-ipq4019-regulator.c b/drivers/regulator/vqmmc-ipq4019-regulator.c
index 086da36abc0b4..4955616517ce9 100644
--- a/drivers/regulator/vqmmc-ipq4019-regulator.c
+++ b/drivers/regulator/vqmmc-ipq4019-regulator.c
@@ -84,6 +84,7 @@ static const struct of_device_id regulator_ipq4019_of_match[] = {
 	{ .compatible = "qcom,vqmmc-ipq4019-regulator", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, regulator_ipq4019_of_match);
 
 static struct platform_driver ipq4019_regulator_driver = {
 	.probe = ipq4019_regulator_probe,
-- 
2.43.0



