Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565F41E2834;
	Wed, 25 Feb 2026 01:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983917; cv=none; b=jRw4blG9r8L456RDGx8ZKpXEumiQgG2CGDgoduXfzl69+tF5xmJ4V+V9VY4o89BkxbWbnFXP0n+tNAAQjuHmqXYzpGiCDea1qZf+Gyz1yVDUa5HyvItf9NnNp30apPZYmpfy+bP2LP8TjrEC/AV0zGv+bn4o0q3YA9z8K4gvw2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983917; c=relaxed/simple;
	bh=id2elLcNWyTl+OgnH9GNMWCymv0datOYmQ/C3Vgxqng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjGp0Es6zdCJ2rCctzVJgjiRmZa1rb964DyqJx8JJ8VX25IJykjTPCfBA3VXmpwDTMBG2tUOtQOUgK0PRPZiIE3E3BlSwIqk1+6xcRY1uQ+ATmnPrdf0wbnIH0iPDbkbwYHps7pdXcVoyRLrkQ7nZ398nyVkHsOKKgaHzXsJAaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNcXyRCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNcXyRCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10191C116D0;
	Wed, 25 Feb 2026 01:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983917;
	bh=id2elLcNWyTl+OgnH9GNMWCymv0datOYmQ/C3Vgxqng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNcXyRCrmxU/rke08fpVQqJ+aFkNXZUYmZNk3Tm9ANZjTwQ5TAh684yuqFekd97X7
	 sQQu1ddrGRUaRghTgvuGvZyXjEERu4Ze9Lr8dJsYMsdzk/v6pDGdauNyXI3CdEiCNN
	 icxXnNlJZ8vx64aHS2OAT9vUokwnMHBhB/9TXjy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 140/641] arm64: dts: qcom: msm8994-octagon: Fix Analog Devices vendor prefix of AD7147
Date: Tue, 24 Feb 2026 17:17:46 -0800
Message-ID: <20260225012352.516543234@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 4c983b10dd925..7ace3540ef0a0 100644
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



