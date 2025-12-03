Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEEF34A3BC;
	Wed,  3 Dec 2025 16:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778451; cv=none; b=QcHCNpRUSxnRNQ6mYSHbtBHHoxhTSWAn8Hv0vYqSzbHmJBPOqSvmek811cjKAWumt/s7+TMIFLmGzoSJ5MzVWvuMKi6kxyV3blQMM8kZssj14cj2nT/CkUVxm0ez4qS1GbdvBBEizwdsSY6fnRjyFhUWLvzlaeVAP/5a5BSy9sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778451; c=relaxed/simple;
	bh=lcBh9Vcpq5qMBGIXsQz/SxXjgLC97Sn6pIjsDCHByF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNZGMerRWMQSMify+SVF+jufB/i+GDON8BWkaRCxBmspaxkIJXh/AenNVdAw+YE8mbiRri5Gh17Op1CUgQkV8A1vtzSLnESHnxUqXacS9+DD3LDyXlqV1fC2j73LOMMDBs0Nr1WiL4YTL9KRYFXbyjauPB0djmAb0pet0UOlhDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCgJJivT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCgJJivT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3149C4CEF5;
	Wed,  3 Dec 2025 16:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778451;
	bh=lcBh9Vcpq5qMBGIXsQz/SxXjgLC97Sn6pIjsDCHByF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WCgJJivTGqX9K37nfg0kh1hLD6m4//58gSHk5zu61UEisnhwZhOzINKM42tow83nl
	 nGyzZcH4fgNSjjkAcUOqE2HKbKFkRXuqGnMwn6Xd6LPzjpYCF8YtD3aQwjxAcIqGCZ
	 XTtl9rsSkWZJ96I9nrlmq6XY0EjaHCPonbArG4GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Alexey Charkov <alchark@gmail.com>,
	Hugh Cole-Baker <sigmaris@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 317/392] mmc: sdhci-of-dwcmshc: Change DLL_STRBIN_TAPNUM_DEFAULT to 0x4
Date: Wed,  3 Dec 2025 16:27:47 +0100
Message-ID: <20251203152425.825121868@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit a28352cf2d2f8380e7aca8cb61682396dca7a991 ]

strbin signal delay under 0x8 configuration is not stable after massive
test. The recommandation of it should be 0x4.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Tested-by: Alexey Charkov <alchark@gmail.com>
Tested-by: Hugh Cole-Baker <sigmaris@gmail.com>
Fixes: 08f3dff799d4 ("mmc: sdhci-of-dwcmshc: add rockchip platform support")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -49,7 +49,7 @@
 #define DWCMSHC_EMMC_DLL_INC		8
 #define DWCMSHC_EMMC_DLL_DLYENA		BIT(27)
 #define DLL_TXCLK_TAPNUM_DEFAULT	0x8
-#define DLL_STRBIN_TAPNUM_DEFAULT	0x8
+#define DLL_STRBIN_TAPNUM_DEFAULT	0x4
 #define DLL_TXCLK_TAPNUM_FROM_SW	BIT(24)
 #define DLL_RXCLK_NO_INVERTER		1
 #define DLL_RXCLK_INVERTER		0


