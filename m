Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F47C1F55FA;
	Tue, 26 Aug 2025 12:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213171; cv=none; b=S7epHCstkGBjFG95veBGyEQlkMxb3+AAIetpFUgdK+n7+2R4wWuaIjuiZjmqLHzAvb1dXCk6o8KaLRXG9jqY2mQj2P3ss2TKFhdlrdw9FDlb9SydnE3wBNGxvU639neQNA4XkK6gSVdoBiISQdrc6uk2fLdQcrYD8rVgvWZ4LAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213171; c=relaxed/simple;
	bh=kIcnEmmjngSN2pmntEUKXSEV10kT0VRlOwQduI9WD2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqs/Luwo3GDz8Nl2j1pDDXxpyifndF4kQQNAaGBL3QjVPlkiCFRrxnwVA/MdJ5gaakxWkBjvt5HmRgOgRO34qXxUTNpSdNgM4cjJzHh+ELCYWdGYtPkwcriySGjet2c9GI3Z4GlfNFcRGtjuIemoyGY2TXSFsRyLJLJbBHZ1748=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOjJGcmK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOjJGcmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2195BC4CEF1;
	Tue, 26 Aug 2025 12:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213171;
	bh=kIcnEmmjngSN2pmntEUKXSEV10kT0VRlOwQduI9WD2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOjJGcmK/GIShHPz0o0RizXrnghVbiWDwWz26FteY1MgPbvZbEGX0l8qdBXoQqMxw
	 /WlDLv/wqtX7M0edNYGDo8Rf5poXh//xS6EGyU6WCGNn2bzNTrLhRrPwY/wA3vBMvv
	 AQI49qd86wtW3SjshxsmFUKADqUHg2jf8C/UCh60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 247/587] power: supply: qcom_battmgr: Add lithium-polymer entry
Date: Tue, 26 Aug 2025 13:06:36 +0200
Message-ID: <20250826110959.213703461@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5b3681b9100c..190e8a4cfa97 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -977,6 +977,8 @@ static unsigned int qcom_battmgr_sc8280xp_parse_technology(const char *chemistry
 {
 	if (!strncmp(chemistry, "LIO", BATTMGR_CHEMISTRY_LEN))
 		return POWER_SUPPLY_TECHNOLOGY_LION;
+	if (!strncmp(chemistry, "LIP", BATTMGR_CHEMISTRY_LEN))
+		return POWER_SUPPLY_TECHNOLOGY_LIPO;
 
 	pr_err("Unknown battery technology '%s'\n", chemistry);
 	return POWER_SUPPLY_TECHNOLOGY_UNKNOWN;
-- 
2.39.5



