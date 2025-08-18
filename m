Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75056350858;
	Mon, 18 Aug 2025 14:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525903; cv=none; b=TLoaq4fIortfcxXPxHWi+/3gYbga6piAZ0TDNLp9EebZyPp4mVMN0TriChJOWsu3AL/ALSDR+4hjMMkDzNYeQm+rlesRduoMR1EjoNtl2pfsS6h2xFGTfQrN2zbTYL0b67YuabmAUSm1yXEe0qRlI2tY4Do6F0rbR94RNpG3DvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525903; c=relaxed/simple;
	bh=INqeDQ1WpMyBNt5bWcb2GAcX3/4juesNboTuoPz63ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NptFVP2uGe6N+Dfseq1/sGzz9gxt3us9LgarzWMflfw6o4nBwDgOiW7E9sDXXL/xsxYNPDwoKvUEKjf7SmX43X9fIk4/KL82+2qANq9tSIARpMyeQffFmyBaUmVQBoYUcw64gepdKT94r2QIm3tCalIbtIePOaPojrEkVHituIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mg3F1iG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mg3F1iG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AC7C4CEEB;
	Mon, 18 Aug 2025 14:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525903;
	bh=INqeDQ1WpMyBNt5bWcb2GAcX3/4juesNboTuoPz63ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mg3F1iG7vTJHXmJYupq3+cxZdmQWKLzQy9B/uGQ8DKuqGbJgkc7z3f5DPKZMtB1Bt
	 Q2lCvUNlRaf0uhD9IsMIUH39E6NNwExyEkg57Nd/Ic/vVo9+ElQRIjV4esyd0PkN3H
	 rgGz3TbYuOWNHj80fZ2JVa+L9d14nTTQ1PlHGjnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 400/570] power: supply: qcom_battmgr: Add lithium-polymer entry
Date: Mon, 18 Aug 2025 14:46:27 +0200
Message-ID: <20250818124521.263585290@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



