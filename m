Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761D52185A8;
	Thu, 12 Dec 2024 15:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018153; cv=none; b=JIxX/YYGRMLH28C42H2g0qV4Hz3ZkSU5DIeRUO6e/m3Pd4KlVlRPBPT7GRwCg61VhL2TZRA0MyV8IBthd5F7TLT4Eu2dDmVUXto/fi7HmeF+GQGr1skW1bBeF3Y6i8c6UbwDpDbrjIQaLXoKQcwU4xvaRzjv2RoWKchGrVyBzc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018153; c=relaxed/simple;
	bh=Xvw6nD2I4FNCOeNfDbPjZKni9LF65y5JLjEgtHQngpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwQ1qe+3TJ2z+MVhYpR2YjllXali7nAPVIzqdl59V9oOBoEN1Tp6coBrwZaT/zTJhJrpjQItaEb/pux4a1oL0/au/vHlK/X/ixnaW6U9OHMsJYdjz30YdqTLmQB0xIIX297wq3dn++hmDZLZVqg1PlJLmSe5hs82oBszpKTGupk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOw71dhm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOw71dhm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B2EC4CECE;
	Thu, 12 Dec 2024 15:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018153;
	bh=Xvw6nD2I4FNCOeNfDbPjZKni9LF65y5JLjEgtHQngpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOw71dhmzE/3n4RwcOZQ4lSwHS12ASzPjN5+y+Vh6EqCHH0nJYMVJdaLOvmk/qD/6
	 N/e758tBkB2toUEahCOm0NQy5tVKXJKf6TylnupxfMX5vZwq/aVyGbG4yniV9DCnKk
	 M/vz+9IbAOudpcpDCrXpz+DtB2TiPYor+k8kNu70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 212/356] drm/mcde: Enable module autoloading
Date: Thu, 12 Dec 2024 15:58:51 +0100
Message-ID: <20241212144252.989960723@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Liao Chen <liaochen4@huawei.com>

[ Upstream commit 8a16b5cdae26207ff4c22834559384ad3d7bc970 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded based
on the alias from of_device_id table.

Signed-off-by: Liao Chen <liaochen4@huawei.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240902113320.903147-4-liaochen4@huawei.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mcde/mcde_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/mcde/mcde_drv.c b/drivers/gpu/drm/mcde/mcde_drv.c
index a2572fb311f08..753f261dad678 100644
--- a/drivers/gpu/drm/mcde/mcde_drv.c
+++ b/drivers/gpu/drm/mcde/mcde_drv.c
@@ -465,6 +465,7 @@ static const struct of_device_id mcde_of_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, mcde_of_match);
 
 static struct platform_driver mcde_driver = {
 	.driver = {
-- 
2.43.0



