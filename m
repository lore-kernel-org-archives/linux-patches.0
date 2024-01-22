Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331BA604DE;
	Tue, 23 Jan 2024 01:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974691; cv=none; b=uyME3cKbmCKMVjM5sAlu78Xk0kDxUVwIwArNmV+KBmwn8XUQwI5ieP6iDstKO7lVOZSzXOGz/kbPar2TaCdrXDibXuQBx5zu7Atc3C6v69k0YGgU5YFcus0d06oGi3odQ3kgPp+Ko6Nrfg8VYgGTgDA9zPbkdRsTrAnqjWnJKSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974691; c=relaxed/simple;
	bh=DJsQlQ24GVSez00z2ealBnRE9oF2GjjoSlq7zWlB5t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMNfCu6LCUwzt+Pa+2l2sRB97TuJoQLDD0DH1A9ck9HkX5ssqbTrle//vSn7F7bIg8BoMsMx9f81W6vqzgAFh6WoC0cFcajucff7qW5grk7Sg0EI4N6gjwHyPWdSbEJvUQSe7z6Ubmi7fyT5qJmiVUj1VTBFAF7CeKdpmK9aRKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=moHexOi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="moHexOi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8C9C433F1;
	Tue, 23 Jan 2024 01:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974690;
	bh=DJsQlQ24GVSez00z2ealBnRE9oF2GjjoSlq7zWlB5t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=moHexOi+SevejD1gEfIuE2Ry+EsUj/fdlIs8yQH2q+unZ8T5/sFgj+6hnVay+wtdl
	 WUqHS4MaEgo09zOBTH8sBaqlOD2E2uUABtEM+oyCli7kAMbJcxpaW1jREPCwwJ5qbV
	 GZ/Dso+zIbXPX2pJ3kJOSpl1oehCc29UkZIrtw9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/583] arm64: dts: qcom: qrb2210-rb1: use USB host mode
Date: Mon, 22 Jan 2024 15:52:56 -0800
Message-ID: <20240122235815.964049565@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 52be19d55aed..37abb83ea464 100644
--- a/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
+++ b/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
@@ -372,6 +372,10 @@ &usb_qmpphy {
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



