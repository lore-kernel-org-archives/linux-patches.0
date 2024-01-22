Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD29F13398C;
	Tue, 23 Jan 2024 00:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969303; cv=none; b=ldQVnhn1fqhVz9XsNJCSLUUZXlZ160kepO9ePd+fp8nsPGpSZAOlWBy/aDbiDJHCZwSnMnEawam4xoiWa2pXnP33YjAX8BAtiRRKixbrZAwtKVqleM+SPHq0l7KW/jbB+bSsW9Se6dR4HEtC5lU2wiYivWNZ7nYyFu+t9CwmyeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969303; c=relaxed/simple;
	bh=clZv+p+NHOzB2qNnCIOVl68KGWy3s4BGBlY4s7rVUt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvwQa3T8rUONgApUH+zP6PsSnMDo3tG+DDGkVgi+1uYo1bxPVqk4gKIVCQ0ar525+XQL+K0NfF3wgHXE8t4cqVEHATQSHJ+IZJrG/PA1A/WmIQbdzhyogjKYXxBE8LBMKZ9aJ6njbSMpdhVy2AuebUFqlTSdgoEmmrp/vly81LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=msbqsTy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="msbqsTy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771ADC43394;
	Tue, 23 Jan 2024 00:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969303;
	bh=clZv+p+NHOzB2qNnCIOVl68KGWy3s4BGBlY4s7rVUt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=msbqsTy0t9+5ARzg8DNnmQJ54DgK+40hpdELWL1QrTNPDC5pMGA7uNxexKAEr3CLj
	 s1Yk1y08stNayZ5/hynClG3rNci5IuLKXLDtkiVjp+oVx6OozFBc2QoYeNMUNdtC25
	 orlBN8Ed+ZGa53eKMMCjwSJVZNtmkOffenYHf2qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 136/641] arm64: dts: qcom: qrb2210-rb1: use USB host mode
Date: Mon, 22 Jan 2024 15:50:40 -0800
Message-ID: <20240122235822.310120979@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Connolly <caleb.connolly@linaro.org>

[ Upstream commit e0cee8dc6757f9f18718eec553be9fffa503e103 ]

The default for the QCM2290 platform that this board is based on is OTG
mode, however the role detection logic is not hooked up for this board
and the dwc3 driver is configured to not allow role switching from
userspace.

Force this board to host mode as this is the preferred usecase until we
get role switching hooked up.

Fixes: e18771961336 ("arm64: dts: qcom: Add initial QTI RB1 device tree")
Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231025-b4-rb1-usb-host-v1-1-522616c575ef@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb2210-rb1.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts b/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
index 94885b9c21c8..fd38a6278f2f 100644
--- a/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
+++ b/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
@@ -415,6 +415,10 @@ &usb_qmpphy {
 	status = "okay";
 };
 
+&usb_dwc3 {
+	dr_mode = "host";
+};
+
 &usb_hsphy {
 	vdd-supply = <&pm2250_l12>;
 	vdda-pll-supply = <&pm2250_l13>;
-- 
2.43.0



