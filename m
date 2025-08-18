Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154D632255F;
	Mon, 18 Aug 2025 13:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524207; cv=none; b=tUvOBgbmSESgaxqniZzx8eSKhpwtf3ciRYv19oO4dpVWpYeIgtgbqyaxOeK0pXgmDEug1coFafEkXKREulVkpzs17ykk7pIHDSj+Phcr8B0owZPLWn5pxgVgHuOSufEQIr3fWJhpp1UF2+pAzIU5LVoEYqsnnr1CGVcLHlhstlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524207; c=relaxed/simple;
	bh=vVQwxcDLyko1d0q+IrDGSdXI4mcgyKCXxj7ugz/bUBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1XK60+dXLNWCRdBbJz79BSEHpnsyG2Q0D1DQS+BiKdxjQ3JEBnybrRpcWcpF5xYoH7qjjM6UiX9jcOCGviGMZgo3ez1WpY5v9q5QGgeD80CuPKJunQSoZipSS8jgR/ixEn/yqsf5zqz1d8Jmzwc70SNxbJSrQKtaucgXPma9Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jUS5tYX+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jUS5tYX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943ECC4CEEB;
	Mon, 18 Aug 2025 13:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524207;
	bh=vVQwxcDLyko1d0q+IrDGSdXI4mcgyKCXxj7ugz/bUBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUS5tYX+tbBCnofrtYdSpYoxLMojm7kTAknj4SrXFznD8hsks1h2y0v6HzaiMClxS
	 F0tvWgADjrH7aYOxasafNqg5LrOnajcJNbXqW/rzJwQoAr83/SejGHm7O4TVbhviSE
	 2TcQuEJhK1OSQuhbdYO11FUbbb5bmqwEmjunBiZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 368/515] power: supply: qcom_battmgr: Add lithium-polymer entry
Date: Mon, 18 Aug 2025 14:45:54 +0200
Message-ID: <20250818124512.575239499@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index fe27676fbc7c..2d50830610e9 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -981,6 +981,8 @@ static unsigned int qcom_battmgr_sc8280xp_parse_technology(const char *chemistry
 {
 	if (!strncmp(chemistry, "LIO", BATTMGR_CHEMISTRY_LEN))
 		return POWER_SUPPLY_TECHNOLOGY_LION;
+	if (!strncmp(chemistry, "LIP", BATTMGR_CHEMISTRY_LEN))
+		return POWER_SUPPLY_TECHNOLOGY_LIPO;
 
 	pr_err("Unknown battery technology '%s'\n", chemistry);
 	return POWER_SUPPLY_TECHNOLOGY_UNKNOWN;
-- 
2.39.5



