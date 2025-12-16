Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDC8365A0E;
	Tue, 16 Dec 2025 12:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887046; cv=none; b=S5yvVSSaFPeE50vC88nbr9ygWWMfBD6gPiJKUqNTLoZiozG1NbRouPeFsLO0968Lwz3Zpn4lpb1p4FNiWUjHj8Hd36fh2YmS8uqEzlt7GWGjqpo6O1/nD3ZRrI+VpxZVaYZyYCwVkfYOOWhRUQ+xjjdOA7aRlbPQbFdQJD90+MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887046; c=relaxed/simple;
	bh=NWMLudf3Q8WZTb9a/pzuhI3V1Bd0kq1exJIXU0y9dlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLb83zQXQbboxI7eav3Sw9zeZ7n2vE52BRK7yeAbtriZxTQkSOBUO6l+hadYbbJxrqc5bGyWSuygi4h+dOeehXX1KzOTmJa2ClHaQIqT5xkFCEpTOlYcfY1t1HL9tShrUtGoWkjGM0nqNSLRlhdFlP9vbj49m40BIFwex0043kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qB6UAyR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qB6UAyR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5805FC4CEF1;
	Tue, 16 Dec 2025 12:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887045;
	bh=NWMLudf3Q8WZTb9a/pzuhI3V1Bd0kq1exJIXU0y9dlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qB6UAyR89C2xElKFLKUFASkUXEg+YEEL5pvNXgD/g7GqIG9FdR7vQHD9SApV2LnvE
	 dzMfhAy66NUjQIfdxeKM7u4VMw/fMfAfDH2NBlbrfxQRy/+kMPotTTC+t5ljHNrqC/
	 AWN4u/399Dqaduv0dCBW82y0LHaFD9jUFTcmZJvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 111/614] arm64: dts: qcom: x1e80100: Add missing quirk for HS only USB controller
Date: Tue, 16 Dec 2025 12:07:58 +0100
Message-ID: <20251216111405.357555764@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>

[ Upstream commit 6b3e8a5d6c88609d9ce93789524f818cca0aa485 ]

The PIPE clock is provided by the USB3 PHY, which is predictably not
connected to the HS-only controller. Add "qcom,select-utmi-as-pipe-clk"
quirk to  HS only USB controller to disable pipe clock requirement.

Fixes: 4af46b7bd66f ("arm64: dts: qcom: x1e80100: Add USB nodes")
Signed-off-by: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20251024105019.2220832-2-krishna.kurapati@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index 6beef835c33ad..662ad694cd914 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -4922,6 +4922,7 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			interconnect-names = "usb-ddr",
 					     "apps-usb";
 
+			qcom,select-utmi-as-pipe-clk;
 			wakeup-source;
 
 			status = "disabled";
-- 
2.51.0



