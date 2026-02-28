Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B22344044;
	Sat, 28 Feb 2026 17:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301546; cv=none; b=QZM0mKXY2w7MIyqhfgAphoVnI0EtDmenbaQAKTBxmdRWUnBfGeq3X8fsFqSwUcdGXHDAQ1d9VLJMHCMPUSDo7dTcnJTvRfy8hfzDIPpQh3WlZNKmyvsktRQJe5UXLy7bc4Opfjr3DtsQAu+bfuMXvMhVWH8dOYCOiMBs1isbt7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301546; c=relaxed/simple;
	bh=/PlTOHnxU+YtZ/oVw0B8iKFTALZYB8xaIPwatim10WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChglwZspZT2xtAjcZu3RTt5B0NKBkJJJjU6+J3UAqgJXkKCbcEDBN+lwcTsHvdmCq+Tga5YAPX/l7fOGNAZaZDWofRYAeyTWl0J0ho9VaRArXCy8V3RJsmbOSP8QJUurbqOqilYWWamsqSRFmu+RPVykMBVqNBlEW5Xlwz7wgD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S6WW+pL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S6WW+pL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D8EC19424;
	Sat, 28 Feb 2026 17:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301546;
	bh=/PlTOHnxU+YtZ/oVw0B8iKFTALZYB8xaIPwatim10WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6WW+pL4tqiQUvr9WHUKxkrzXf7ADCjfOT4L6bySdi844GKoxs30Gf8JynONP0ZtP
	 /txePBcYog+V03QbylcBB6kEXE5j/dWqphAcspDyrDTqouwn7tZTnVJB8S9bp12n0v
	 +srKhFlBwuMPIxMZoSMFTKV+F2hbvJ83Ue6YE+vPzh85USWnEKJYKGGxU+rLOpXvAV
	 J3FcexHHppiBl1aHeuFkkXWJhTMOUbjDM6dj620iG8Ja2yQsxPSurFUO44qhB6PNuv
	 y/85FZb8Ulq3MOGgRew0UOV+2P29uekNFM915xxJDbKC9i+NSiABmtgXZiKWVbr18Z
	 HaBko8wb8RSgw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Gustavo Salvini <guspatagonico@gmail.com>,
	stable@vger.kernel.org,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 729/752] ASoC: amd: yc: Add DMI quirk for ASUS Vivobook Pro 15X M6501RR
Date: Sat, 28 Feb 2026 12:47:20 -0500
Message-ID: <20260228174750.1542406-729-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Gustavo Salvini <guspatagonico@gmail.com>

[ Upstream commit ff9cadd1a2c0b2665b7377ac79540d66f212e7e3 ]

The ASUS Vivobook Pro 15X (M6501RR) with AMD Ryzen 9 6900HX has an
internal DMIC that is not detected without a DMI quirk entry, as the
BIOS does not set the AcpDmicConnected ACPI _DSD property.

Adding the DMI entry enables the ACP6x DMIC machine driver to probe
successfully.

Cc: stable@vger.kernel.org

Signed-off-by: Gustavo Salvini <guspatagonico@gmail.com>
Link: https://patch.msgid.link/20260210155156.29079-1-guspatagonico@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 67f2fee193980..f1a63475100d1 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -696,7 +696,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "XyloD5_RBU"),
 		}
 	},
-
+	{
+			.driver_data = &acp6x_card,
+			.matches = {
+				DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+				DMI_MATCH(DMI_PRODUCT_NAME, "Vivobook_ASUSLaptop M6501RR_M6501RR"),
+			}
+		},
 	{}
 };
 
-- 
2.51.0

