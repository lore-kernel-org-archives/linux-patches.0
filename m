Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B7855E5E;
	Wed, 21 Feb 2024 13:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523893; cv=none; b=B1gA0yFcohs4eNXmKWM8YIbJoKcqW/ts0cv3w9JJVxsyPEvbkbWw97KlekphZlb77FjHXy9KJTR8ScrxgeC03+OCLIb27ZxnyF/ccd01i+saJn6V/1CTzqOaqdQ6+v7u7nnIoEMphry4zBrB2qOgaZV/L+2yjd60ZMJ5CyFwxUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523893; c=relaxed/simple;
	bh=GzjWqRRtqPlbkDZ/MUuRFB2Be1HvidGQ7PxCsGOwG6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/BZBQZLABW4/EY22qxE61J4zfHuEh6Mn2LpoTiB6A3MAGAhmNyBM15UsnHLwsSh6vJ6dSsTyaRUtlO3AvYWijhWvWALWBlxROhyCO40hM5e7kR5D1UN0hqX1VEvw5kYJFOKYkzWwwQB7OBNuNgw9QE0C30DWuctcS4ajK8CS0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjWzNXe/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjWzNXe/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9457FC433F1;
	Wed, 21 Feb 2024 13:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523893;
	bh=GzjWqRRtqPlbkDZ/MUuRFB2Be1HvidGQ7PxCsGOwG6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wjWzNXe/wIhny0WcGuowvMX2jaqYgqxPUC3WFhrij76vVdVxh9/WStg+Rtl+UKunF
	 HzkIsBko7Wf7a9ph9Cl2Var+fKglaMTXAcJ8mDXTUQ8FvJq3QHOd3lOQmaCkdGaNgw
	 J1/++wojC/oXChyUBQ0/r1bc4vCW5tQ2sta2h3A8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/379] ARM: dts: samsung: exynos4210-i9100: Unconditionally enable LDO12
Date: Wed, 21 Feb 2024 14:04:22 +0100
Message-ID: <20240221125957.363699145@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d186b93144e3..525618197197 100644
--- a/arch/arm/boot/dts/exynos4210-i9100.dts
+++ b/arch/arm/boot/dts/exynos4210-i9100.dts
@@ -464,6 +464,14 @@ vtcam_reg: LDO12 {
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



