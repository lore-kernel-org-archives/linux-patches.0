Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3130913FEC
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjZmjyK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1522C433C9;
	Mon, 23 Oct 2023 11:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059198;
	bh=nq5yN3K6q7NxWbpCeH5FkGik/q9K3WXpeRB2xsZ4U28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjZmjyK9iyjDapaaWObz6fraQ6ivLg72ptfzcyyzIWS+wJ4vrlaNVUghwyS3utGvd
	 R3oivnZghGAODARkTgbBOy/UhrXMDDNN04GQYvLZevqnQVXpn8aEFrzvpkLYM/vtzP
	 sOS5e7f8zvQbjjQDMQ5Z+ZxT0vWSfBG5ZEPX7Rgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 097/241] pwr-mlxbf: extend Kconfig to include gpio-mlxbf3 dependency
Date: Mon, 23 Oct 2023 12:54:43 +0200
Message-ID: <20231023104836.267508462@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit 82f07f1acf417b81e793145c167dd5e156024de4 ]

The BlueField power handling driver (pwr-mlxbf.c) provides
functionality for both BlueField-2 and BlueField-3 based
platforms.  This driver also depends on the SoC-specific
BlueField GPIO driver, whether gpio-mlxbf2 or gpio-mlxbf3.
This patch extends the Kconfig definition to include the
dependency on the gpio-mlxbf3 driver, if applicable.

Signed-off-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
Link: https://lore.kernel.org/r/20230823133743.31275-1-davthompson@nvidia.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index fff07b2bd77b9..62f592e617339 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -307,7 +307,7 @@ config NVMEM_REBOOT_MODE
 
 config POWER_MLXBF
 	tristate "Mellanox BlueField power handling driver"
-	depends on (GPIO_MLXBF2 && ACPI)
+	depends on (GPIO_MLXBF2 || GPIO_MLXBF3) && ACPI
 	help
 	  This driver supports reset or low power mode handling for Mellanox BlueField.
 
-- 
2.40.1



