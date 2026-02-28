Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9508E344D9A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301723; cv=none; b=fmmG+yyMwJM8HCjX3Miblh6Yjt+DznEOowHTCGpgHQgIkacUF77iUYTSz8QULmIaZYYXXJFF4CAjWuRsE+dwIdajSi2k8IvZAV4GiIIQyB1ObVaP0NtD675wdjFJzIDJZDV+YPJNF/ItafTSzEgaWQxlZCXMoynxDNA84bkseKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301723; c=relaxed/simple;
	bh=Z+zi8+gAW9l8IAbXzorCTQMxTXO/pbNuO4JwRjN6w10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejM5cvJujIIosxO/3SvV5sr8CbwqVPuaqlQMaeDQH7YCwvPTiz7lcn5UBVUfL90oIgnuVz7qK8Fmp59xrMV8VHSXsvjoSfkDNl8OFwfiybvjgSB7CYa98AK9h0HY7SaCly1r657PIVcvWSQTj6bpRZ3+VB9lRhmcuny+VvH4JCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XJX/JsmE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XJX/JsmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05845C19423;
	Sat, 28 Feb 2026 18:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301723;
	bh=Z+zi8+gAW9l8IAbXzorCTQMxTXO/pbNuO4JwRjN6w10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJX/JsmE3vwoR2tPlnNOT11BXLgQqdoRe+gCtYg9msEoUXyZ46RQnWnYT1XWIpaiF
	 UD+nlIS8ueucaBo/pgcuwwYzW8y/NqY6UQtuZbl4gkdDr0rtHgifLTBrgKrjD4y4BO
	 a7KFr4+60WeSYGwV598fsCNVrYN+kbdoJ+YVOOjw6NEl619/ViTMRbXi/jFUYpbWqm
	 t6hPVdDz3h11tuh9lRHvUowrkjk3K7TB/Q6lf8gaN/psoy9Q4pO4lFkXdfxlEpSXJT
	 bzQngyordTjkH78uQZQUtwlAe5VFfFbHlxb9CjZ+5FnJMUkXlQaVZQuI5am7oNTERi
	 1qNSVd21XcCfw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/385] arm64: dts: amlogic: g12: assign the MMC A signal clock
Date: Sat, 28 Feb 2026 12:55:43 -0500
Message-ID: <20260228180011.1568201-121-sashal@kernel.org>
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

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 3c941feaa363f1573a501452391ddf513394c84b ]

The amlogic MMC driver operate with the assumption that MMC clock
is configured to provide 24MHz. It uses this path for low
rates such as 400kHz.

Assign the clock to make sure it is properly configured

Fixes: 8a6b3ca2d361 ("arm64: dts: meson: g12a: add SDIO controller")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260114-amlogic-mmc-clocks-followup-v1-6-a999fafbe0aa@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index c3a718de85c6d..e0ddb28a34c29 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -2408,6 +2408,9 @@ sd_emmc_a: mmc@ffe03000 {
 				 <&clkc CLKID_FCLK_DIV2>;
 			clock-names = "core", "clkin0", "clkin1";
 			resets = <&reset RESET_SD_EMMC_A>;
+
+			assigned-clocks = <&clkc CLKID_SD_EMMC_A_CLK0>;
+			assigned-clock-rates = <24000000>;
 		};
 
 		sd_emmc_b: mmc@ffe05000 {
-- 
2.51.0

