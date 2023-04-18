Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11BF2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C59C4339E;
	Tue, 18 Apr 2023 12:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822256;
	bh=DNHA9w31gGi6slqGhnDugKrUxRmBTEkUVrJjeSv3J8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kid/WU51ROyD/mApx2QL718HGjUQkPLDecbgRflMeJ79XF7HXNixzk59NkPxR/cJ5
	 wID1PsgIF0qM+c6MzyHnzFH3BKDWXAqRkw34ITusPvg5jgG5dXp3dIR0zH7ZOpAF72
	 uHeyb+9htJZC2sVroeCmWu3lRrn2BDxjbMgNXYkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <simon.horman@corigine.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 082/139] wifi: mwifiex: mark OF related data as maybe unused
Date: Tue, 18 Apr 2023 14:22:27 +0200
Message-Id: <20230418120316.912197574@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 139f6973bf140c65d4d1d4bde5485badb4454d7a ]

The driver can be compile tested with !CONFIG_OF making certain data
unused:

  drivers/net/wireless/marvell/mwifiex/sdio.c:498:34: error: ‘mwifiex_sdio_of_match_table’ defined but not used [-Werror=unused-const-variable=]
  drivers/net/wireless/marvell/mwifiex/pcie.c:175:34: error: ‘mwifiex_pcie_of_match_table’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230312132523.352182-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 2 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 5dcf61761a165..9a698a16a8f38 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -172,7 +172,7 @@ static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
 	.can_ext_scan = true,
 };
 
-static const struct of_device_id mwifiex_pcie_of_match_table[] = {
+static const struct of_device_id mwifiex_pcie_of_match_table[] __maybe_unused = {
 	{ .compatible = "pci11ab,2b42" },
 	{ .compatible = "pci1b4b,2b42" },
 	{ }
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 9f506efa53705..ea1c1c2412e72 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -479,7 +479,7 @@ static struct memory_type_mapping mem_type_mapping_tbl[] = {
 	{"EXTLAST", NULL, 0, 0xFE},
 };
 
-static const struct of_device_id mwifiex_sdio_of_match_table[] = {
+static const struct of_device_id mwifiex_sdio_of_match_table[] __maybe_unused = {
 	{ .compatible = "marvell,sd8787" },
 	{ .compatible = "marvell,sd8897" },
 	{ .compatible = "marvell,sd8997" },
-- 
2.39.2



