Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B607B33A6F2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302197; cv=none; b=Nx3ynuKY79WIzdVL/JOyF3e4raVi+FNClpJzWGaxVU9MTaTOlYH1MUDqUeLVdnzhj4W4fhIbSsrMeC78CN9Hi+HqUwcyrmjn+EORmWgYLnByDqSkBbt6KwrkyOr951tw2VT43sxwQjyzczTzL5dNSc/UC1ahM3jZiysVHDRgqgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302197; c=relaxed/simple;
	bh=F/6T4w/4sHNqTjaOZNHlmov56MjUZELfLxVS/rNpgk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2qi7e0Ahi50SEIDMO0dMwxycX6HzBfpAaY4qc74Ogq+PhuQBxPgIN8u3rWoCG4rv4S9e+U/hQl+XttMu17ATPxtbgxJ5f2mAEU4El/VMWMjlNKU7O0lW2Zm1v4C6Q7QEQeVi3XSF9aJwZ0dp6FkzhUpgnote3shCgTursCf75Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HGSG+9Ww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HGSG+9Ww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5EEC116D0;
	Sat, 28 Feb 2026 18:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302197;
	bh=F/6T4w/4sHNqTjaOZNHlmov56MjUZELfLxVS/rNpgk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HGSG+9Wwe9x2saYO/tB7EARLaRDDK9WODzz6smq8OudkqW0198qXIkwBJnuqjZYZn
	 nNEVbQ46+ZW/6sSagnWRi0CYjrSf+uIO/Wt1a7dLZmxJQdred7ymmlb1GYywzFEVrc
	 SSEjxCBjA2SBaN/Zh5H6QSEBZgq24BztSWbSISefYXO31MUk4N3FuSseWrlKX7BZKi
	 lU72Pwc2k83AlbC//OfskSVs2Bi+7TLt840kdt/XYDxEjWkcozI3c9ZYmHy8+bbu4I
	 fclmQ9lUTGhD/qg9iVkl94z2n8UoiCQpcjqfFgg8IEYuS0rZ9c7a/mMTVF6SGYelXI
	 RJQi4IXefUELA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Val Packett <val@packett.cool>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 201/283] power: supply: qcom_battmgr: Recognize "LiP" as lithium-polymer
Date: Sat, 28 Feb 2026 13:05:43 -0500
Message-ID: <20260228180709.1583486-201-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 0c993780d3ef2..e5eade1328163 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -981,7 +981,8 @@ static unsigned int qcom_battmgr_sc8280xp_parse_technology(const char *chemistry
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

