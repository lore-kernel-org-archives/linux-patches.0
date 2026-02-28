Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462C8344D9A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301709; cv=none; b=Fuu04kPistrzRUY2Q9sZ5CjmLZnbOmyhQJfK16yHV8JHZMzHqohNTyL7utOdHm7nN4Rw9bU20MxUWNtfjl5w7PuOkZp+2Fa78YVX+ysZyajntK8uz83mPy7GAUkp8x+EORUxdTKucDGdG91OsVz+DojAmd02yJEo1soXGD6M7T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301709; c=relaxed/simple;
	bh=511vdJpOh7yh3gUd06CzNduniqwOhGmnGo9C5NZTJhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8SywEU5ucHKOWgW/Qpc2zZXTNBc3vTjpWGoM+m/ELbl3l6vHwpD2zfjCzuMCqKKdnbbcLkN98ru/HjPAt95WRsdVT3T9CP+IDgjElC/57nX2GWMffjtGxfWI8srjXynJz/7z03NDicAnMCR2j2ZKeVHI5VLy2/cmv39MJiv6XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VZ5Gfw2w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VZ5Gfw2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B761C116D0;
	Sat, 28 Feb 2026 18:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301709;
	bh=511vdJpOh7yh3gUd06CzNduniqwOhGmnGo9C5NZTJhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZ5Gfw2w/ACMcfxEFas0sC/z29rLH2rhzkKlrjKp+mREN0VqBQFhEBQVcrGkWWw3T
	 ju0Dx1gee33qac/PzY6TbNykfEL9VFennllGumavFW9CVWVI326d8mqJCHUGk+RWF1
	 2LAo54k2a+mpyWor+QbjNcujntowqGSbBomJb+pArkOe3VYrMyZkD89eDyGgUNFsjz
	 2fdHUz/9kmYU/4uDeziPBAp+g8fUkZsroLANDrqg7/VXAliJuM/0VpmE71s9566jf7
	 YOinkyxmYWWd3QoPgWrpv5krLiKul61Oa2CglFcoM4q6gEl0SrvCMqpRrpW4mlpSD/
	 qJZ8SG+ItdoIA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/385] arm64: dts: qcom: msm8994-octagon: Fix Analog Devices vendor prefix of AD7147
Date: Sat, 28 Feb 2026 12:55:25 -0500
Message-ID: <20260228180011.1568201-103-sashal@kernel.org>
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

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit 7db5fbe508deedec6c183d5056cf3c504c027f40 ]

Trivial change, Analog Devices vendor prefix is "adi", but there is
a valid "ad" vendor prefix of another company, this may explain why
the issue hasn't been discovered by the automatic tests.

A problem of not described compatible value is out of this change scope.

Fixes: c636eeb751f6 ("arm64: dts: qcom: msm8994-octagon: Add AD7147 and APDS9930 sensors")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251226003923.3341904-1-vladimir.zapolskiy@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994-msft-lumia-octagon.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8994-msft-lumia-octagon.dtsi b/arch/arm64/boot/dts/qcom/msm8994-msft-lumia-octagon.dtsi
index 10cd244dea4f7..ef8dfce8d9b2d 100644
--- a/arch/arm64/boot/dts/qcom/msm8994-msft-lumia-octagon.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994-msft-lumia-octagon.dtsi
@@ -378,7 +378,7 @@ &blsp2_i2c1 {
 	status = "okay";
 
 	sideinteraction: touch@2c {
-		compatible = "ad,ad7147_captouch";
+		compatible = "adi,ad7147_captouch";
 		reg = <0x2c>;
 
 		pinctrl-names = "default", "sleep";
-- 
2.51.0

