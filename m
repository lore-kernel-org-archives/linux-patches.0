Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBE515442C;
	Thu,  3 Jul 2025 15:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555322; cv=none; b=gmbyqi+/YLxMycWHbWWoUkTlaIQZTkor2WgOxWi6WH9SD0k7FgHKkPDJpYeod8dsowJFGNDxFt2J9mIuQex2eendkrIuiTgh9IXqxwRPElFrCkU5HGDQxBekLWg4nGCJVtGP0SVZTwjCSzOyNdGm9JxAHk9TH0LrsBh7XkLVgdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555322; c=relaxed/simple;
	bh=i+LcOSndsaIjbmiky2Dl+zNRPs5wY8M0e9SpovhASn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Omt9ZdwWbFXfxboxcvwsJ6Ns76QkIfQW9x0x+aZqNwtBiWbitjZ4tCup617Ucd5K5n0OmEYMZKmMkALoJ2R4o9TXOE2XDpna1It5Ej0ExUBgrSZwdSwzOkYu3uMlinC0S6IC5WxgZd8Eaa57aurLt4YV3qCDPLdPiN2jiQBApXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L8JCEVar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L8JCEVar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F79EC4CEE3;
	Thu,  3 Jul 2025 15:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555321;
	bh=i+LcOSndsaIjbmiky2Dl+zNRPs5wY8M0e9SpovhASn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8JCEVar5CcMb8V7lZN1eJddUNS9nGSWRGlx1pgZpeCZZLaSpU0b0gqrCB2g2K08b
	 rgZNRU9e6ntHJAM9y6U9L0CXndNLofIe6oPnqmLjt1zd0eE5+LpBnGvtD62c8gx3V1
	 yiqERIh8k/MpD2u0YXqKdiufF1L6+mJZrEORBDyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 242/263] arm64: dts: qcom: x1e78100-t14s: mark l12b and l15b always-on
Date: Thu,  3 Jul 2025 16:42:42 +0200
Message-ID: <20250703144014.113238338@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit 673fa129e558c5f1196adb27d97ac90ddfe4f19c ]

The l12b and l15b supplies are used by components that are not (fully)
described (and some never will be) and must never be disabled.

Mark the regulators as always-on to prevent them from being disabled,
for example, when consumers probe defer or suspend.

Fixes: 7d1cbe2f4985 ("arm64: dts: qcom: Add X1E78100 ThinkPad T14s Gen 6")
Cc: stable@vger.kernel.org	# 6.12
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20250314145440.11371-3-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts b/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts
index b2c2347f54fa6..7f756ce48d2f6 100644
--- a/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts
+++ b/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts
@@ -344,6 +344,7 @@ vreg_l12b_1p2: ldo12 {
 			regulator-min-microvolt = <1200000>;
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l13b_3p0: ldo13 {
@@ -365,6 +366,7 @@ vreg_l15b_1p8: ldo15 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l17b_2p5: ldo17 {
-- 
2.39.5



