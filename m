Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8DA4437B;
	Mon, 11 Dec 2023 18:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lIhTX6xY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF49EC433C8;
	Mon, 11 Dec 2023 18:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320355;
	bh=D28Nkyfl66WbNmJDnnyWB/7NyEgjlXWCbhO7xJb8Wjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lIhTX6xYF1+7hJRioMeXApfNugvs2v193uw6U6dXh3CoklipOOTGmInn07pIRIfj5
	 Ux1lqaz/ATrUzkKw/y0wOn81E26tnFc8BUHiLCS7dtqIK9Y9x9cMyPAMaOy6GEGoDb
	 3kOeyB5iRZcQV/bRY9mmoK1nxBeWLPs1NYx31Il8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Vadim Pasternak <vadimp@nvidia.com>,
	Kunwu Chan <chentao@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/194] platform/mellanox: Check devm_hwmon_device_register_with_groups() return value
Date: Mon, 11 Dec 2023 19:20:21 +0100
Message-ID: <20231211182037.982336609@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 3494a594315b56516988afb6854d75dee5b501db ]

devm_hwmon_device_register_with_groups() returns an error pointer upon
failure. Check its return value for errors.

Compile-tested only.

Fixes: 1a218d312e65 ("platform/mellanox: mlxbf-pmc: Add Mellanox BlueField PMC driver")
Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Suggested-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20231201055447.2356001-1-chentao@kylinos.cn
[ij: split the change into two]
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-pmc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/mellanox/mlxbf-pmc.c b/drivers/platform/mellanox/mlxbf-pmc.c
index 925bfc4aef8ce..db7a1d360cd2c 100644
--- a/drivers/platform/mellanox/mlxbf-pmc.c
+++ b/drivers/platform/mellanox/mlxbf-pmc.c
@@ -1454,6 +1454,8 @@ static int mlxbf_pmc_probe(struct platform_device *pdev)
 
 	pmc->hwmon_dev = devm_hwmon_device_register_with_groups(
 		dev, "bfperf", pmc, pmc->groups);
+	if (IS_ERR(pmc->hwmon_dev))
+		return PTR_ERR(pmc->hwmon_dev);
 	platform_set_drvdata(pdev, pmc);
 
 	return 0;
-- 
2.42.0



