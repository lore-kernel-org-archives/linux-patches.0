Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8684369A;
	Wed, 25 Feb 2026 01:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982985; cv=none; b=M2m7iYSIJHAA8yVT9C1MCZr+anwsUiMHEB9+EcFgE84dhZvD7eTgG6+DUG6v80PJWk0tR7DemVyvJFEhRFWMgcz8P6++YQ1mgwcR+s0iKrNwHTJIoEzyU7g/plUXmzLnFI/cDLEG6XRJQCscd1D751HIKgK7uloOI7XVHGxuVX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982985; c=relaxed/simple;
	bh=Eww9/HILV/GOH/DtL2WgC2UljnugCKpiwnQm9VDcRoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkJLl7MJGzmfg9ZlwtLozd2a2f1TgojUZXZpCYW5k4MOZTr9pg65TpO55NC3OSYMIqexdRICTI0k22J89B0tbrKt+NffJM+6XyzibmSJIS75mjdarM4sVmFGee5N4BCXjwND2rhpqwCvh9dTOx25IFnJmZcVef95ReB6vNBSsJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDBf9Sq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDBf9Sq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57130C116D0;
	Wed, 25 Feb 2026 01:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982985;
	bh=Eww9/HILV/GOH/DtL2WgC2UljnugCKpiwnQm9VDcRoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDBf9Sq4F/RM/nu8BIDYvYVfRV8t+2qf1NWQcWGoosTkiKlAPeKCxki7sg38UDSFG
	 hTGxD15yNYNwkCsjwGxoZ9YhBRjg8O4TC6gABLY1rynrEmIpilKboNcnDmAuL+0P5P
	 Yt0UswaW+El43JSt9C88LlH7iiF4/oiod6K0dDII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 155/781] arm64: dts: qcom: sdm845-oneplus: Dont mark ts supply boot-on
Date: Tue, 24 Feb 2026 17:14:24 -0800
Message-ID: <20260225012403.459626534@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index db6dd04c51bb5..ee62adfa6af0b 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -148,7 +148,6 @@ ts_1p8_supply: ts-1p8-regulator {
 
 		gpio = <&tlmm 88 0>;
 		enable-active-high;
-		regulator-boot-on;
 	};
 
 	panel_vci_3v3: panel-vci-3v3-regulator {
-- 
2.51.0



