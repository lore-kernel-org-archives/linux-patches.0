Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9262C333434
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301864; cv=none; b=tLzh4nxk+GuRGMZdw67VZUEo/+4Y7d1E9SGCEO423+TEj5O71B7iBpW/NlME/tc6nCG7cpOMgbgNfA5zRDxrfXsax+Dy9W6Bi6b00OyccadrIG5cadTrVgxLjFLRDzHoFY0ihUkN/0OLRMZscWHnp6OA/HPNU4KiAjBswPvJhXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301864; c=relaxed/simple;
	bh=18DrQD38hn44o/0AYfhOcv2VP1+mi4X01NSbLxfMI64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGp14aCnr0aK7zpF8JhNAGP5of9wXt6gNdBOt/J7hj1YqBt1VsD7UZScdsRCuYB2VwZZMuz4xMpicYrp67ZpuqDteXlPqnI8Hec9ublL0qZqHcEYjAMAFl9bEWWnQ4UnN7XRU5l4MmTWztnn+wwHGOrWgf/aeCFW2x/iUAS80BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l6tawvp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l6tawvp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCBDC116D0;
	Sat, 28 Feb 2026 18:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301864;
	bh=18DrQD38hn44o/0AYfhOcv2VP1+mi4X01NSbLxfMI64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6tawvp6muIYonuc105gzG7zeaG6jttYja8eHA6Mu4zi3WwgWFSuNTXkmKKhcABnS
	 s1PoEROMrUw9il/vsHcas6n9e2OauQV+CSeGmWcZnIK+XGcOR+FG21iAuB5v9bU/1w
	 mQ35X5k2+/iXrn2AGMiWldgQzWdniYoVwh9ygHbf5j8oU4JM1byI2hM2ew7Yu04pOs
	 4hoAYmKn0RGmCFJAk9MGR8dwXAhmyNXj9N+4ErtOtBgqUyy5PiH9+cxKm1JmekGOQy
	 zhSl5vZWe0VpBYoX3JmqiSvYQjbute+ycZEfpiCkOf536PIhmlnJJ1Be6TvM52X9KT
	 W1xgi0C4CfLnA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Val Packett <val@packett.cool>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 287/385] power: supply: qcom_battmgr: Recognize "LiP" as lithium-polymer
Date: Sat, 28 Feb 2026 12:58:29 -0500
Message-ID: <20260228180011.1568201-287-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Val Packett <val@packett.cool>

[ Upstream commit c655f45480637aee326b5bd96488d35ab90db2b0 ]

On the Dell Latitude 7455, the firmware uses "LiP" with a lowercase 'i'
for the battery chemistry type, but only all-uppercase "LIP" was being
recognized. Add the CamelCase variant to the check to fix the "Unknown
battery technology" warning.

Fixes: 202ac22b8e2e ("power: supply: qcom_battmgr: Add lithium-polymer entry")
Signed-off-by: Val Packett <val@packett.cool>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20260120235831.479038-1-val@packett.cool
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_battmgr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/qcom_battmgr.c b/drivers/power/supply/qcom_battmgr.c
index f8bea732ba7f2..a6576248e761e 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -984,7 +984,8 @@ static unsigned int qcom_battmgr_sc8280xp_parse_technology(const char *chemistry
 	if ((!strncmp(chemistry, "LIO", BATTMGR_CHEMISTRY_LEN)) ||
 	    (!strncmp(chemistry, "OOI", BATTMGR_CHEMISTRY_LEN)))
 		return POWER_SUPPLY_TECHNOLOGY_LION;
-	if (!strncmp(chemistry, "LIP", BATTMGR_CHEMISTRY_LEN))
+	if (!strncmp(chemistry, "LIP", BATTMGR_CHEMISTRY_LEN) ||
+	    !strncmp(chemistry, "LiP", BATTMGR_CHEMISTRY_LEN))
 		return POWER_SUPPLY_TECHNOLOGY_LIPO;
 
 	pr_err("Unknown battery technology '%s'\n", chemistry);
-- 
2.51.0

