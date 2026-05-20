Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339F234216C;
	Wed, 20 May 2026 16:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295749; cv=none; b=U0Zwor32E4IopaLzxtm2hgMvsc8IM5frw7kzuniMBv2P9LB+6LLKZGeazf/W16mXE7wo0bZssorGPfI+dnxF463MS+6IV5yt3lMWBaRqUl/xQeHqimUQX/bAie/zWGCWkU/oj8tjfQQYcZkyoo/tn6t68g5yV2cAj3pPWwFWa+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295749; c=relaxed/simple;
	bh=b8+ZOmMtE5lSzJ/UWWO/RPh+4vnkYQcj42vtPkdruTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=df+MSrWfT3wEn+AvGdV2LEeHjFPRB161L0wbYJfD3wmXtFtG70TjMG/mmHhqWyQcKyvJnMBWKQ8tJM4/IMSvM2pm5cSK5xFlzmAmypViRTsZ5FwuBq4NqkYqTF2a7HInifhVbdIPOsvH63lT9P89WYW19Nm9NoJi6J6Gj+sX5G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8A2cckH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8A2cckH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1AE1F00893;
	Wed, 20 May 2026 16:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295748;
	bh=xoEJhxzlA9SK5+65PbWV6ArmnsgDAekuY4nOOqpamt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k8A2cckH+LffGI8cQ5gmdJXmu9T+lfsovGYBSTpcajdF23eaVmezS92k1h+zl5iyB
	 niAzDTvDPf+mSwHKYFPwr5lcRNR2sbrxBkgTY5kdHPnWcYJZhrF9Q48kvwS+rrnILF
	 yPfLiHkKVTnhn30OYTHRfDdbbrgsacopVWpy17O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0537/1146] arm64: dts: imx91: Remove TMUs superfluous sensor ID
Date: Wed, 20 May 2026 18:13:07 +0200
Message-ID: <20260520162200.334794696@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 53a0485304f11f5371fddf9fb06b95268154bf82 ]

Currently a sensor ID is added to the reference, but
thermal-sensor@44482000 has #thermal-sensor-cells = <0>, so parsing fails.
This also has the effect that other hwmon sensors (jc42) fail to probe.
Fix this by removing the superfluous sensor ID.

Fixes: f0ed0e844452 ("arm64: dts: imx91: Add thermal-sensor and thermal-zone support")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx91.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx91.dtsi b/arch/arm64/boot/dts/freescale/imx91.dtsi
index f075592bfc01f..d63569b39bbc5 100644
--- a/arch/arm64/boot/dts/freescale/imx91.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx91.dtsi
@@ -11,7 +11,7 @@ thermal-zones {
 		cpu-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <2000>;
-			thermal-sensors = <&tmu 0>;
+			thermal-sensors = <&tmu>;
 
 			trips {
 				cpu_alert: cpu-alert {
-- 
2.53.0



