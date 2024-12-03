Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A0C1F75B6;
	Tue,  3 Dec 2024 15:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240363; cv=none; b=flOBeugUQ5e3Z56laQhLsHv/UShLmYmlcUZXsmQr1PZLLJTas913KRdRTUwA/0y/2lzKkxMFAV9TggHyNxtd6UeGG14mIA78CMVJbIh9eH9ZzEXCTGj99+1LhlQzmYOfbVwyeAROeCpFfpSHoo535yscqr0vPkh2tvopRtax7vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240363; c=relaxed/simple;
	bh=QWHldTxWXLiWo4Md401aSGfe7AEUhdK1nRe5LwJDJPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmCfRKLBpR4vVpBFqzgsKHSSe7lH9mWJNfVNSXqgj01SWLZnXqFmh6TlV9iJQ4EXT9bhu0COCsFyMqphjnEmkwGGRGGael4E+3SLfiCKY7i3yTH+ecrXwG7snYx59KhWSxLW711WOvfEEqlgxKhp0s8oOgk9cByjrGOm6Ft9Ves=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZISTvPO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZISTvPO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28055C4CECF;
	Tue,  3 Dec 2024 15:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240363;
	bh=QWHldTxWXLiWo4Md401aSGfe7AEUhdK1nRe5LwJDJPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZISTvPO6DihDJLThMvzl8vd1emMaZk7IbKWgeYDMw3I3fVEJun6PqXAIU6wDhXa/O
	 fwV67GJtyiU+Xx89UueZUKII8zhFFB2W4x/+Yal3ZqpPWyWPVeYiHz68OCusY+MiLc
	 28A6Uxeap5r+3cOaNhM+f1ewB82ca08DSgS+67q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/826] arm64: dts: qcom: sda660-ifc6560: fix l10a voltage ranges
Date: Tue,  3 Dec 2024 15:37:21 +0100
Message-ID: <20241203144748.188330984@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 1dd7d9d41dedf8d42e04c0f2febd4dbe5a062d4a ]

L10A, being a fixed regulator, should have min_voltage = max_voltage,
otherwise fixed rulator fails to probe. Fix the max_voltage range to be
equal to minimum.

Fixes: 4edbcf264fe2 ("arm64: dts: qcom: sda660-ifc6560: document missing USB PHY supplies")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konradybcio@kernel.org>
Link: https://lore.kernel.org/r/20240907-sdm660-wifi-v1-4-e316055142f8@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts b/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts
index 60412281ab27d..962c8aa400440 100644
--- a/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts
+++ b/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts
@@ -104,7 +104,7 @@ vreg_l10a_1p8: vreg-l10a-regulator {
 		compatible = "regulator-fixed";
 		regulator-name = "vreg_l10a_1p8";
 		regulator-min-microvolt = <1804000>;
-		regulator-max-microvolt = <1896000>;
+		regulator-max-microvolt = <1804000>;
 		regulator-always-on;
 		regulator-boot-on;
 	};
-- 
2.43.0



