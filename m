Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BB8248F6A;
	Tue, 11 Nov 2025 01:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823071; cv=none; b=EdBT6Kb0lw7xGpxanyaZnnk2OJvoTJ114gYAqcVSv4W7MBj9jWdlznwV31s6stshbCcq662GR5moEUsycjZmLN/AJ2/Ywb1g+2DhQgqnSC8yqS7pKE9Y9nH3xWM6yCjnuCrVq9VjuD/wOyMJwu5HtLQ1RVKPcBFvwxAYF7p0Cqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823071; c=relaxed/simple;
	bh=HOcXWopndfJpQap5verJu69ovCf7uEh9Lk1gZVJuXno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpIBMlAapmt+xkLvNphO6ImfoKhbuWCznWtq3m91j/mwDktTA62J6Y2CbmyWVQ7nogB90dX+QOofZdAbi5Sk99sP9tLKuvKzqppBbs8HV+LcoFEw5caQx4TzBk+CDhqx0aXlGVwE1FfSg/NcK8UcEoztbm4iUNQyLBBywKeEBhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmjJwLvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmjJwLvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE8AC16AAE;
	Tue, 11 Nov 2025 01:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823070;
	bh=HOcXWopndfJpQap5verJu69ovCf7uEh9Lk1gZVJuXno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UmjJwLvYLXbMjx2o/1kGMo7T3cY5/a0RckBGTCbbuLe1rIswzzFgBv2ArpzciU6+t
	 kpywOb1cnNQzrCd3gdxT9gzHXoQ5wk06NmpseH6bmZGq7ijcZwJnaqqFpKvsuIttv6
	 rvgTaAYrwwiZI5zvsnaym78ZSo8zBopW0TPZku3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 225/849] mfd: macsmc: Add "apple,t8103-smc" compatible
Date: Tue, 11 Nov 2025 09:36:35 +0900
Message-ID: <20251111004541.883755040@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janne Grunau <j@jannau.net>

[ Upstream commit 9b959e525fa7e8518e57554b6e17849942938dfc ]

After discussion with the devicetree maintainers we agreed to not extend
lists with the generic compatible "apple,smc" anymore [1]. Use
"apple,t8103-smc" as base compatible as it is the SoC the driver and
bindings were written for.

[1]: https://lore.kernel.org/asahi/12ab93b7-1fc2-4ce0-926e-c8141cfe81bf@kernel.org/

Signed-off-by: Janne Grunau <j@jannau.net>
Link: https://lore.kernel.org/r/20250828-dt-apple-t6020-v1-18-507ba4c4b98e@jannau.net
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/macsmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/macsmc.c b/drivers/mfd/macsmc.c
index 870c8b2028a8f..a5e0b99484830 100644
--- a/drivers/mfd/macsmc.c
+++ b/drivers/mfd/macsmc.c
@@ -478,6 +478,7 @@ static int apple_smc_probe(struct platform_device *pdev)
 }
 
 static const struct of_device_id apple_smc_of_match[] = {
+	{ .compatible = "apple,t8103-smc" },
 	{ .compatible = "apple,smc" },
 	{},
 };
-- 
2.51.0



