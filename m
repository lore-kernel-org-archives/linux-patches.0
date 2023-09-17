Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC6F7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3D2C433CA;
	Sun, 17 Sep 2023 19:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980708;
	bh=DjJl4CfeI8YE6KrH6Kgc7TVzsj0b83tt8FA7QZelLCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aL2lUncUMJ1B+4gxKW/rFg0C75A+NfXFqme02HLXFghZz//zm+EgqPVU3r7G9Xbld
	 kWjD4ILivk9qVn9QgDKrTFRiDYNbWY5LkCjSKv6SkOcwKxH5L75Bn5pE7s7+Rrm5wp
	 PZ68+zuqNOKfpyuqipDcCBC98GAJDYjue4uS4OQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Vadim Pasternak <vadimp@nvidia.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 271/285] platform/mellanox: NVSW_SN2201 should depend on ACPI
Date: Sun, 17 Sep 2023 21:14:31 +0200
Message-ID: <20230917191100.557016452@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 0a138f1670bd1af13ba6949c48ea86ddd4bf557e ]

The only probing method supported by the Nvidia SN2201 platform driver
is probing through an ACPI match table.  Hence add a dependency on
ACPI, to prevent asking the user about this driver when configuring a
kernel without ACPI support.

Fixes: 662f24826f95 ("platform/mellanox: Add support for new SN2201 system")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Vadim Pasternak <vadimp@nvidia.com>
Acked-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/ec5a4071691ab08d58771b7732a9988e89779268.1693828363.git.geert+renesas@glider.be
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/mellanox/Kconfig b/drivers/platform/mellanox/Kconfig
index 382793e73a60a..30b50920b278c 100644
--- a/drivers/platform/mellanox/Kconfig
+++ b/drivers/platform/mellanox/Kconfig
@@ -80,8 +80,8 @@ config MLXBF_PMC
 
 config NVSW_SN2201
 	tristate "Nvidia SN2201 platform driver support"
-	depends on HWMON
-	depends on I2C
+	depends on HWMON && I2C
+	depends on ACPI || COMPILE_TEST
 	select REGMAP_I2C
 	help
 	  This driver provides support for the Nvidia SN2201 platform.
-- 
2.40.1



