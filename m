Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8589443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB154C433C9;
	Sun, 13 Aug 2023 21:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962339;
	bh=BW8zYnyIK6f1YjLz3AKGpHFzxJ/qs5zX7Js9MRK86Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vudFhZbj89CnTmGyMlnKyUPRRrqt7GoZZaJ3yU1zkdVLjDbCDLdGg6JZIyqTJXqR1
	 ZEfx24iSdXd1bZv/AkK8KBHJq3lb3BrGymicW8gSNNoYkUv5B5ZEcxS9smwkwSphcy
	 UWEihr53veuS/VaiEE8VaBGBhyvOLEwaNzUXa3eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Pasternak <vadimp@nvidia.com>,
	Michael Shych <michaelsh@nvidia.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.4 200/206] platform: mellanox: Change register offset addresses
Date: Sun, 13 Aug 2023 23:19:30 +0200
Message-ID: <20230813211730.733938316@linuxfoundation.org>
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

commit d66a8aab7dc36c975bbaa6aa74cf7445878e7c69 upstream.

Move debug register offsets to different location due to hardware changes.

Fixes: dd635e33b5c9 ("platform: mellanox: Introduce support of new Nvidia L1 switch")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Michael Shych <michaelsh@nvidia.com>
Link: https://lore.kernel.org/r/20230813083735.39090-5-vadimp@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/mlx-platform.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/mlx-platform.c b/drivers/platform/x86/mlx-platform.c
index 240bc3174caf..7d33977d9c60 100644
--- a/drivers/platform/x86/mlx-platform.c
+++ b/drivers/platform/x86/mlx-platform.c
@@ -62,10 +62,6 @@
 #define MLXPLAT_CPLD_LPC_REG_PWM_CONTROL_OFFSET	0x37
 #define MLXPLAT_CPLD_LPC_REG_AGGR_OFFSET	0x3a
 #define MLXPLAT_CPLD_LPC_REG_AGGR_MASK_OFFSET	0x3b
-#define MLXPLAT_CPLD_LPC_REG_DBG1_OFFSET	0x3c
-#define MLXPLAT_CPLD_LPC_REG_DBG2_OFFSET	0x3d
-#define MLXPLAT_CPLD_LPC_REG_DBG3_OFFSET	0x3e
-#define MLXPLAT_CPLD_LPC_REG_DBG4_OFFSET	0x3f
 #define MLXPLAT_CPLD_LPC_REG_AGGRLO_OFFSET	0x40
 #define MLXPLAT_CPLD_LPC_REG_AGGRLO_MASK_OFFSET	0x41
 #define MLXPLAT_CPLD_LPC_REG_AGGRCO_OFFSET	0x42
@@ -126,6 +122,10 @@
 #define MLXPLAT_CPLD_LPC_REG_LC_SD_EVENT_OFFSET	0xaa
 #define MLXPLAT_CPLD_LPC_REG_LC_SD_MASK_OFFSET	0xab
 #define MLXPLAT_CPLD_LPC_REG_LC_PWR_ON		0xb2
+#define MLXPLAT_CPLD_LPC_REG_DBG1_OFFSET	0xb6
+#define MLXPLAT_CPLD_LPC_REG_DBG2_OFFSET	0xb7
+#define MLXPLAT_CPLD_LPC_REG_DBG3_OFFSET	0xb8
+#define MLXPLAT_CPLD_LPC_REG_DBG4_OFFSET	0xb9
 #define MLXPLAT_CPLD_LPC_REG_GP4_RO_OFFSET	0xc2
 #define MLXPLAT_CPLD_LPC_REG_SPI_CHNL_SELECT	0xc3
 #define MLXPLAT_CPLD_LPC_REG_WD_CLEAR_OFFSET	0xc7
-- 
2.41.0



