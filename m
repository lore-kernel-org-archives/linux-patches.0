Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4357E36C9D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302335; cv=none; b=QRDJCmMhrte5AdoSWTUyKqQGPhHR+RJdLYet+Mnom/v46+V739nL5Dc16lZTLuJM6Tq3GHz+qSGsjlf+hw31PCqjkl2oKA52y9/HSPaCRX3jkdl6lPQRs8TG8Jus8zGdk060/T6HtcAJo9JrHzFZ/G2QuNZiJ4+JeZ/i2oUCivw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302335; c=relaxed/simple;
	bh=TDswUkH2qYumnBAKwgPn/L+djemLwQt9zIvcWTHaQsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SomZ764KnjyVLA56CjCN6rBF/zA1WNbpGRp66TEgNEVmBctR73cDE4U9z2N35pflHCXTo2mKgjV1ogK8KtL86eJTRHt+lsf4TuUKzujzZxOgjuU1Detr2ZRXR9I4qX6fbLThxxnedM7ICaQw3IkUwLHtJ5Y3TEh2iOAFEftkQbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MgCjK582; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MgCjK582"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEAFC19425;
	Sat, 28 Feb 2026 18:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302335;
	bh=TDswUkH2qYumnBAKwgPn/L+djemLwQt9zIvcWTHaQsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MgCjK582rQ4sxmUkZ5sb6qCiscO/fj+P/Brt2QfBV7I/u/DC3SotmGW3QZFRoZjid
	 K2wwbD3Ii+xoVqOyaCB4JJehWyClTbqI5AqpOH/zymSMsj3HCgZzo4XFuj4hoq0ls3
	 XGDQgYjnv4jpzECJFNZNF7UGDsHj45X58qpjf1q9Tq3tj13iaP93fFH4umkzNWBss3
	 4JdB0UCy5yhPsa6GYL4mqjm2qbOvKxl8nqvNK8sRmA3pSAEVv6i1iWwXuwNpFh8tHp
	 3MdhZc0lrrysMTXvzwQKY3MS1nvDU5LX/OBSgLzweS/jOz4ZfpcJVKP4NviRLxwdLb
	 MwHZeAb7HTADQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/232] arm64: dts: qcom: sdm845-oneplus: Don't mark ts supply boot-on
Date: Sat, 28 Feb 2026 13:08:29 -0500
Message-ID: <20260228181127.1592657-56-sashal@kernel.org>
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
index 0713b774a97be..281e1178a2f46 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -134,7 +134,6 @@ ts_1p8_supply: ts-1p8-regulator {
 
 		gpio = <&tlmm 88 0>;
 		enable-active-high;
-		regulator-boot-on;
 	};
 };
 
-- 
2.51.0

