Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD554322746;
	Mon, 18 Aug 2025 13:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522414; cv=none; b=H5CuYjn64mcwG5HR3hAoWFRYF22bFIj2JA/X8q2SAWxGxvv5bpLiXE7jL/mjcM2XwAmz4fPerhNWHiXfQ04nz+xvw9TC3xZqWc+3kHUuCHZjInPigCl37ZKQEM6R/AgeC8yGxmzglnW79mFB/f3aZxuEpjdFJQGFziVu6zDhUBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522414; c=relaxed/simple;
	bh=u28pbMEeVseTvunkxDEnF5uHqqVQI4XJ4J3c8HHkupg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unicTnWhW0x7e9cgDues27mUKKsRGdLM4f8+5K2aB98mkwX3rWkRvruTNiHHYeNsUVbnHVFgJ+/xMTxeL86uVP2BkX9KwGwQiuzkb6eayJSriEpjP+tN2pobmuQivZkabXP1OquOAAE3XgEHDO/0AMn0SSZi9Obsz6rDOVQt9T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fthDjQtx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fthDjQtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1D9C4CEF1;
	Mon, 18 Aug 2025 13:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522414;
	bh=u28pbMEeVseTvunkxDEnF5uHqqVQI4XJ4J3c8HHkupg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fthDjQtxR0ZVzjd/8EplAJtVt2yrRWNQe0szrVZfLp0Nu4xvXb0tgY0huYSpq8TfQ
	 KU8s4szE42OSLQJiqv1qrR2N1UwlXHE9CPL0Z7WPkz3jw8ol5sOPodiEKWCGMoMdXe
	 BZHyG5rUit1ykvgxy6hK2PnYOVPqkMLTQYLUJ1AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 309/444] power: supply: qcom_battmgr: Add lithium-polymer entry
Date: Mon, 18 Aug 2025 14:45:35 +0200
Message-ID: <20250818124500.537149218@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 202ac22b8e2e015e6c196fd8113f3d2a62dd1afc ]

On some Dell XPS 13 (9345) variants, the battery used is lithium-polymer
based. Currently, this is reported as unknown technology due to the entry
missing.

[ 4083.135325] Unknown battery technology 'LIP'

Add another check for lithium-polymer in the technology parsing callback
and return that instead of unknown.

Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250523-psy-qcom-battmgr-add-lipo-entry-v1-1-938c20a43a25@linaro.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_battmgr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/power/supply/qcom_battmgr.c b/drivers/power/supply/qcom_battmgr.c
index f0a64c00ddaa..c2037b58fbcd 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -980,6 +980,8 @@ static unsigned int qcom_battmgr_sc8280xp_parse_technology(const char *chemistry
 {
 	if (!strncmp(chemistry, "LIO", BATTMGR_CHEMISTRY_LEN))
 		return POWER_SUPPLY_TECHNOLOGY_LION;
+	if (!strncmp(chemistry, "LIP", BATTMGR_CHEMISTRY_LEN))
+		return POWER_SUPPLY_TECHNOLOGY_LIPO;
 
 	pr_err("Unknown battery technology '%s'\n", chemistry);
 	return POWER_SUPPLY_TECHNOLOGY_UNKNOWN;
-- 
2.39.5



