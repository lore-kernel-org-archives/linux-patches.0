Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA799443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9DCC433C8;
	Sun, 13 Aug 2023 21:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962344;
	bh=jKRxpdxrUXrRrMojvF0wPez7cvRCO3GbA2weQDooMAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J65AgibbGcAOSg12HZwyPxrb/QlcU7lDCodNIK/lZ4Vg25Fo2gMH8+lDpZXmRlng6
	 vVsYfYcPnbdZb0UeX6nLY8bYNBYTudmBhYXuB1r6uqU99pKIsk+h7qoDjZdv9Yi6Ig
	 /aL6ErAq2jgNXe2V//MzyZMXZ/PSa11XmaFxLLE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Pasternak <vadimp@nvidia.com>,
	Michael Shych <michaelsh@nvidia.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.4 202/206] platform: mellanox: mlx-platform: Modify graceful shutdown callback and power down mask
Date: Sun, 13 Aug 2023 23:19:32 +0200
Message-ID: <20230813211730.787186556@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vadim Pasternak <vadimp@nvidia.com>

commit 9f8ccdb5088bd03062d9ad9c0f6abf600cbed8e8 upstream.

Use kernel_power_off() instead of kernel_halt() to pass through
machine_power_off() -> pm_power_off(), otherwise axillary power does
not go off.

Change "power down" bitmask.

Fixes: dd635e33b5c9 ("platform: mellanox: Introduce support of new Nvidia L1 switch")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Michael Shych <michaelsh@nvidia.com>
Link: https://lore.kernel.org/r/20230813083735.39090-4-vadimp@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/mlx-platform.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/mlx-platform.c
+++ b/drivers/platform/x86/mlx-platform.c
@@ -222,7 +222,7 @@
 					 MLXPLAT_CPLD_AGGR_MASK_LC_SDWN)
 #define MLXPLAT_CPLD_LOW_AGGR_MASK_LOW	0xc1
 #define MLXPLAT_CPLD_LOW_AGGR_MASK_ASIC2	BIT(2)
-#define MLXPLAT_CPLD_LOW_AGGR_MASK_PWR_BUT	BIT(4)
+#define MLXPLAT_CPLD_LOW_AGGR_MASK_PWR_BUT	GENMASK(5, 4)
 #define MLXPLAT_CPLD_LOW_AGGR_MASK_I2C	BIT(6)
 #define MLXPLAT_CPLD_PSU_MASK		GENMASK(1, 0)
 #define MLXPLAT_CPLD_PWR_MASK		GENMASK(1, 0)
@@ -2356,7 +2356,7 @@ mlxplat_mlxcpld_l1_switch_pwr_events_han
 					     u8 action)
 {
 	dev_info(&mlxplat_dev->dev, "System shutdown due to short press of power button");
-	kernel_halt();
+	kernel_power_off();
 	return 0;
 }
 


