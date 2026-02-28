Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A013133A702
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302082; cv=none; b=UGw57MsMZ3CorSP8CaNzPqOHSEJZet5Q41TiqmW3rofaZaASt+sDbJeDIIjBexHYssvEJIdlTl6qzGcadXwm9FduOmhCR2lJ51LZex11U2aponiHvzyNGjdyRd2UEagm+OplkCnaKoPK+FljC4g+P9d4iNSp61jKiWiY/r5DH7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302082; c=relaxed/simple;
	bh=EGB2OUkpkeLHpdQAAIv6VsAni3JRLiOoHq0sm3y8vaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+7ZpeVxgF7rvnwvfG3LrVLzIMPYk89IO9mJ+KtsL6K9nYGNmezcGr901nohM6tltgsnMoN3H1J6tauo7iOWH1zYp4rndyy5pJdGbE8IXI/MMVny56Op7eHO7tVnSTnyFF9pSgx9pNwVkcRwpNeGTyZyqd4B0hjkC44tAntfsYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EaFOTR7g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EaFOTR7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8B8C19424;
	Sat, 28 Feb 2026 18:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302082;
	bh=EGB2OUkpkeLHpdQAAIv6VsAni3JRLiOoHq0sm3y8vaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EaFOTR7goMoatH6b131wHtdG+9ayEJb718MSsBS7gxm1Fe4x04FGbD6JOzTfXHQ9a
	 O36qS61Oj4u9YjKCgx3HihJSt7zPX8hqoozMtfYCwS+w2JGY5e+1oDsq+f8xh9cyUT
	 WwM5CDlwf71/OLnr21MO0Cc6L7EBouCTZ/QPsz710acZH4pJmGFdsmUhOQ+gPB6QjO
	 a/Ju2OoZUxbKXkQOpcsPzYW/WbLpEn8tL6YTWhvKUt1CMY/1WKJLC5MDoMWcLG1KrL
	 YqLEDhCSEZzGh8OHcsEck+zj1uT1i/btVE9UCSXOYrY5M7QjjnLsfulXQTfWDJXPzP
	 vnSkEeG6UD6Fw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/283] arm64: dts: qcom: sdm845-oneplus: Don't mark ts supply boot-on
Date: Sat, 28 Feb 2026 13:03:26 -0500
Message-ID: <20260228180709.1583486-64-sashal@kernel.org>
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

From: Casey Connolly <casey.connolly@linaro.org>

[ Upstream commit c9b98b9dad9749bf2eb7336a6fca31a6af1039d7 ]

The touchscreen isn't enabled by bootloader and doesn't need to be
enabled at boot, only when the driver probes, thus remove the
regulator-boot-on property.

Fixes: 288ef8a42612 ("arm64: dts: sdm845: add oneplus6/6t devices")
Signed-off-by: Casey Connolly <casey.connolly@linaro.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251118-dts-oneplus-regulators-v2-1-3e67cea1e4e7@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
index bccc52e01da38..c50d335e0761f 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -155,7 +155,6 @@ ts_1p8_supply: ts-1p8-regulator {
 
 		gpio = <&tlmm 88 0>;
 		enable-active-high;
-		regulator-boot-on;
 	};
 };
 
-- 
2.51.0

