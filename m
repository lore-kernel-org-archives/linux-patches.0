Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C83EBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976EEC433D2;
	Tue,  7 Mar 2023 18:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215131;
	bh=BZiaj7JzprCIuqLSE6dAwEL/JcxKTNxtW28HQgC/nws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/9sjRFyApzPoKZgG1mdXOaNuZ3bo5ehls6PAHrxAWGpgbbSgUHzggAr0WXKCpRwK
	 Eg5471hLxFd85BXQTbBPvl7nxRaLLaK61EzN533TWCMGS+CqjL5u3zXWqIcL4eoyzq
	 3j9nj3uiXSHHIJOMckLkbwj65UY6sv6dz0FoA4t0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqin Liu <yongqin.liu@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/567] thermal/drivers/hisi: Drop second sensor hi3660
Date: Tue,  7 Mar 2023 17:58:10 +0100
Message-Id: <20230307165912.625031440@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yongqin Liu <yongqin.liu@linaro.org>

[ Upstream commit 15cc25829a97c3957e520e971868aacc84341317 ]

The commit 74c8e6bffbe1 ("driver core: Add __alloc_size hint to devm
allocators") exposes a panic "BRK handler: Fatal exception" on the
hi3660_thermal_probe funciton.
This is because the function allocates memory for only one
sensors array entry, but tries to fill up a second one.

Fix this by removing the unneeded second access.

Fixes: 7d3a2a2bbadb ("thermal/drivers/hisi: Fix number of sensors on hi3660")
Signed-off-by: Yongqin Liu <yongqin.liu@linaro.org>
Link: https://lore.kernel.org/linux-mm/20221101223321.1326815-5-keescook@chromium.org/
Link: https://lore.kernel.org/r/20230210141507.71014-1-yongqin.liu@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/hisi_thermal.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/thermal/hisi_thermal.c b/drivers/thermal/hisi_thermal.c
index 9a21ac0ceb112..29ff1e66dd6e9 100644
--- a/drivers/thermal/hisi_thermal.c
+++ b/drivers/thermal/hisi_thermal.c
@@ -435,10 +435,6 @@ static int hi3660_thermal_probe(struct hisi_thermal_data *data)
 	data->sensor[0].irq_name = "tsensor_a73";
 	data->sensor[0].data = data;
 
-	data->sensor[1].id = HI3660_LITTLE_SENSOR;
-	data->sensor[1].irq_name = "tsensor_a53";
-	data->sensor[1].data = data;
-
 	return 0;
 }
 
-- 
2.39.2



