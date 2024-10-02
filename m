Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946771D0491;
	Wed,  2 Oct 2024 13:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877569; cv=none; b=pJEea5G90dPJKP3kCH+Qu7cthyE6yRa/8m5NCza6i9OqfHMlB5/GhC+JwcD+iPO9iBCXznQH8+0Akg8MmgphkuwmYwUl5e8obV59LlFUZ+fqH3pSFXuwR7WlsTfRsdeAgZVSmiEz/MjmB5wCBOLITSGW8p8scp+6taeR1XqVahs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877569; c=relaxed/simple;
	bh=2NcVqtH+oVH+qHlGWboEMvOiUNEjZsizC2fw4qV+7hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mB1U2QHoO4v1dt4fmaGb4iuAZSN7GyDrA7FkmUh6SRxaGmeeC5C73G68G/fv6+nWjiVAgaZlewWNx8YaGzmmspPbe/5ztULoAurguA2ubdIZ+CriT3Se9v8w07Lx4/k9nHkOiDycp6RyITPcTbvPqzT+4u0cy1HxEMayEE3N970=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/1bulW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/1bulW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5BDC4CEC5;
	Wed,  2 Oct 2024 13:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877569;
	bh=2NcVqtH+oVH+qHlGWboEMvOiUNEjZsizC2fw4qV+7hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/1bulW4xFIPwFnXfuqZVFFqSzP8WII2Iuom72PBg+dtDzrN/qVMrP3rdOerxzZ90
	 MPSOEBA9Ak/Vm7lWRAqnX14BYhbB/wFDvMSE/Iug2X0pvonLqMSceS1/N6augJXTnE
	 L91KhAbZZBfqn7kcT6mByxl8qPWfbeDPhpBbXpCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 119/634] arm64: dts: mediatek: mt8186: Fix supported-hw mask for GPU OPPs
Date: Wed,  2 Oct 2024 14:53:39 +0200
Message-ID: <20241002125815.809240777@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 2317d018b835842df0501d8f9e9efa843068a101 ]

The speedbin eFuse reads a value 'x' from 0 to 7 and, in order to
make that compatible with opp-supported-hw, it gets post processed
as BIT(x).

Change all of the 0x30 supported-hw to 0x20 to avoid getting
duplicate OPPs for speedbin 4, and also change all of the 0x8 to
0xcf because speedbins different from 4 and 5 do support 900MHz,
950MHz, 1000MHz with the higher voltage of 850mV, 900mV, 950mV
respectively.

Fixes: f38ea593ad0d ("arm64: dts: mediatek: mt8186: Wire up GPU voltage/frequency scaling")
Link: https://lore.kernel.org/r/20240725072243.173104-1-angelogioacchino.delregno@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8186.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8186.dtsi b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
index 4763ed5dc86cf..d63a9defe73e1 100644
--- a/arch/arm64/boot/dts/mediatek/mt8186.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
@@ -731,7 +731,7 @@
 		opp-900000000-3 {
 			opp-hz = /bits/ 64 <900000000>;
 			opp-microvolt = <850000>;
-			opp-supported-hw = <0x8>;
+			opp-supported-hw = <0xcf>;
 		};
 
 		opp-900000000-4 {
@@ -743,13 +743,13 @@
 		opp-900000000-5 {
 			opp-hz = /bits/ 64 <900000000>;
 			opp-microvolt = <825000>;
-			opp-supported-hw = <0x30>;
+			opp-supported-hw = <0x20>;
 		};
 
 		opp-950000000-3 {
 			opp-hz = /bits/ 64 <950000000>;
 			opp-microvolt = <900000>;
-			opp-supported-hw = <0x8>;
+			opp-supported-hw = <0xcf>;
 		};
 
 		opp-950000000-4 {
@@ -761,13 +761,13 @@
 		opp-950000000-5 {
 			opp-hz = /bits/ 64 <950000000>;
 			opp-microvolt = <850000>;
-			opp-supported-hw = <0x30>;
+			opp-supported-hw = <0x20>;
 		};
 
 		opp-1000000000-3 {
 			opp-hz = /bits/ 64 <1000000000>;
 			opp-microvolt = <950000>;
-			opp-supported-hw = <0x8>;
+			opp-supported-hw = <0xcf>;
 		};
 
 		opp-1000000000-4 {
@@ -779,7 +779,7 @@
 		opp-1000000000-5 {
 			opp-hz = /bits/ 64 <1000000000>;
 			opp-microvolt = <875000>;
-			opp-supported-hw = <0x30>;
+			opp-supported-hw = <0x20>;
 		};
 	};
 
-- 
2.43.0



