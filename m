Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902763D5647;
	Wed, 20 May 2026 18:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300752; cv=none; b=iVXA3JytJZnZqBD7Fvg+fpe0++a+mbaKG+bcAvy+Pp2OSr0KLbSAbCzo3wfZsoFjwLnnnaUUYXGZaW2J3MMUraMKYC2Y5aTvJVRsZGnvov2BHcMl17Gc0dxC11dZWyIVQWL/PNFwntr3r2BO2pXvdroJa+FpjNNEpE80MitZQXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300752; c=relaxed/simple;
	bh=42JlA1V/XlvblFiI/MTh0D8WGcN3mIUAZL12xdrCNW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvg6kDsw1U/cqsI48SD+NaTcd3oiDSvmfN8bUo1EvlMVX2yKJ1NKzp0R7RnPiaESU0wjeRx6WmI844N/WTzFm5tj50Nmz2w7NjXt5pi7AgZRT16LYqZl/ibjxgq0ezwmyUxDq1pjJyO1JAfPfdoHGPG4BcVb+gErwtKd8IjCbn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WdvZqQNf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WdvZqQNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BA51F000E9;
	Wed, 20 May 2026 18:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300751;
	bh=tGOHLVFPrk8mQInvZd60i2bCL2mXY3W/7SdAL2+7wKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WdvZqQNfQ6fT4LIvLVE+FQNcx47Citg264TCZovZY/XrZEXbOsVlvOk8Y8++ZSsy0
	 RbBkMlClMSv2eoWN/qyzv19xkHbwSpi+21dBQKWoYUpNJ40pOCB8vNKT56MEDJzEL5
	 dKV5GT+uYU/q2PXKEBQrsouqxjhvIpjE+BlwNbOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 292/666] arm64: dts: qcom: sdm845-xiaomi-beryllium: Mark l1a regulator as powered during boot
Date: Wed, 20 May 2026 18:18:23 +0200
Message-ID: <20260520162117.544762297@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 3b0dd81eea6b7a239fce456ce4545af76f1a9715 ]

The regulator must be on, since it provides the display subsystem and
therefore the bootloader had turned it on before Linux booted.

Fixes: 77809cf74a8c ("arm64: dts: qcom: Add support for Xiaomi Poco F1 (Beryllium)")
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260320-beryllium-booton-v2-1-931d1be21eae@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
index 617b17b2d7d9d..c872d6442018d 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
@@ -147,6 +147,7 @@ vreg_l1a_0p875: ldo1 {
 			regulator-min-microvolt = <880000>;
 			regulator-max-microvolt = <880000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-boot-on;
 		};
 
 		vreg_l5a_0p8: ldo5 {
-- 
2.53.0



