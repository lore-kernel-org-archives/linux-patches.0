Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0197FBA0;
	Wed, 21 Feb 2024 13:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522198; cv=none; b=tctrs+IGA7zn2A7K6UO+lQKacgBFDV4yiBe/8ne26deOcich2BtNBII4d0U8mCOmbfvy3caKM02LAbYorfS5pwodmq3IhMZXP/vEphMLhNtMz2JQPWJSCMgfNIS0j/h+t41ca6xF/nIDCe9guI1U3YCQ6o6mYeQLSg7zfXRvgco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522198; c=relaxed/simple;
	bh=wuv6rw/IUH5pvsEkx/BT+pVrhwKAaI1WuiUH5WNB1kU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVrVgH4qFQ4gSr/kMrqmIO+9V8g4dGIbuq6GeUSQoswetZi3BKvgqAksGlzGBHK+EI/Z4u9QXZUT8I1lvYTxi+0BfJlrC7P7dgDCpa+AaRLAhGShEZVGgliTaVVpn/mgs5CYPwKu4UHfqcJu/gc3yQFZ61YVYixdsAIBgPEVGqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qoz03Jyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qoz03Jyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE0CC433C7;
	Wed, 21 Feb 2024 13:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522197;
	bh=wuv6rw/IUH5pvsEkx/BT+pVrhwKAaI1WuiUH5WNB1kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qoz03JyfS7OZ4GDAP+GA/XzJ+j/k1mrWD7tyavn1GTnx1VpssOAiuJRO9TzkXefJs
	 S2BV1XXdRVoTG8CJrHLeRUSNq4yRa71qtopDRBv7qSCzOAUi65PNdWbGTjdueIoAx8
	 kQ1IFbSJpj5zM3A1h6wQBToeCfEUGIaFs//b8rs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/476] ARM: dts: samsung: exynos4210-i9100: Unconditionally enable LDO12
Date: Wed, 21 Feb 2024 14:02:33 +0100
Message-ID: <20240221130011.747163038@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 84228d5e29dbc7a6be51e221000e1d122125826c ]

The kernel hangs for a good 12 seconds without any info being printed to
dmesg, very early in the boot process, if this regulator is not enabled.

Force-enable it to work around this issue, until we know more about the
underlying problem.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Fixes: 8620cc2f99b7 ("ARM: dts: exynos: Add devicetree file for the Galaxy S2")
Cc: stable@vger.kernel.org # v5.8+
Link: https://lore.kernel.org/r/20231206221556.15348-2-paul@crapouillou.net
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4210-i9100.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210-i9100.dts b/arch/arm/boot/dts/exynos4210-i9100.dts
index 93880bdbcad9..8232d843bfe0 100644
--- a/arch/arm/boot/dts/exynos4210-i9100.dts
+++ b/arch/arm/boot/dts/exynos4210-i9100.dts
@@ -520,6 +520,14 @@ vtcam_reg: LDO12 {
 				regulator-name = "VT_CAM_1.8V";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+
+				/*
+				 * Force-enable this regulator; otherwise the
+				 * kernel hangs very early in the boot process
+				 * for about 12 seconds, without apparent
+				 * reason.
+				 */
+				regulator-always-on;
 			};
 
 			vcclcd_reg: LDO13 {
-- 
2.43.0



