Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F0936C9E5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302346; cv=none; b=fcWyV0Ho4GP7J5tm+Jc+E9a2Dxoi8VSGCqmvJCnrm/QQhXczh00U0BJNa+QYsGMscDQQS9QJq/aW4K2GTnYXbIjVCMnYVtB+SwKmtwX6nxNtVrst6OlAAKe0rTlrKmgP+roDwTSjrzwUFpJKqs82cmd4kDCoVRUubqoz5j/9MWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302346; c=relaxed/simple;
	bh=o9qH4ssdLxdyxqskgJZZv0brbjOZZxIvW2u1KsBr1p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nB/nKOdWfmcam+mc6KO1wW7qsI2pkoyExDGgQm0vVXdko3FKRqO+nr5Gpq0SZaPdKSssmySv8qmOTzBMWEIq0H0sy5a3bhoFtFbNOzMRLQjH8X9EE26MgzXiZGiFAyGLH35+RUdkN0bdP1o8GcazLb/CCOn//h8PgxlyRLKZddk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WtbaaxK6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WtbaaxK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E11AC19423;
	Sat, 28 Feb 2026 18:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302346;
	bh=o9qH4ssdLxdyxqskgJZZv0brbjOZZxIvW2u1KsBr1p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtbaaxK6zOFjjRLkbBLT19jK6gWCvObblfrbh5BBun9IIRI7FrpKgWWvQgqqvZaXm
	 MC6veoZEyn1E+wrYB93+9cc87qmJhlpwZu/u4ktjufk3mj6KZkVAOJYpZJM53Jgpce
	 76PPCA9DLuZXSOAVnOT5Gn8l803x6AubpJLPQ/SL5CegD4i7j80E4+7oZmNGC1HTI+
	 y+mxOedLkE0Lp28MC8W/xb2Y0gDgxP9zRZMGzp9OhA6BXS7FiqhBjBYMhoFjtwNkML
	 U1J+rkp3kuceIW32SEn7S8KqYpj3vjJ0GeV9sLPXgKob9HQa/vRcm/0BzwGe41VY1i
	 URHyMNuPTTY4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/232] arm64: dts: amlogic: g12: assign the MMC A signal clock
Date: Sat, 28 Feb 2026 13:08:43 -0500
Message-ID: <20260228181127.1592657-70-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 041f1c1ec49ec..e930c49207dad 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -2324,6 +2324,9 @@ sd_emmc_a: sd@ffe03000 {
 				 <&clkc CLKID_FCLK_DIV2>;
 			clock-names = "core", "clkin0", "clkin1";
 			resets = <&reset RESET_SD_EMMC_A>;
+
+			assigned-clocks = <&clkc CLKID_SD_EMMC_A_CLK0>;
+			assigned-clock-rates = <24000000>;
 		};
 
 		sd_emmc_b: sd@ffe05000 {
-- 
2.51.0

