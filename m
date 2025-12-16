Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2087B36CDE3;
	Tue, 16 Dec 2025 12:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887462; cv=none; b=eQrW0/N5Va76Kf0kjl3YU6gGBD9mRMGXroeU1Blph8VcNRHKWB64/golrM68TrwpJV0KeVdi0yWjZ9ovwIesZLHYWDYDg8Aez4dJXbN2xYUrQiiDtGr0Qmd+IXe/uQmZO9vmc1M9WMM0h8KCPCKj9sXNNdIpExP06CebXayb6a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887462; c=relaxed/simple;
	bh=PuB4G7ltf4tGGJSbgHLbjj3WtAph3mdDuY757hes2Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssfr8nRx4JkyZ6i18I5DUoVxp1tOUU8iICrgF229OCY0zkgvA8IngGKhrNR1ue7L/fiLJIfsKtZyi2R1EB+boWBCUXTJdWEljE2u0Tzu+Tu46n6EpIBH+6qnP1fYRT6BoiQOD87mBbKUfxngiup+nlFjrJZW1jGXLKBwkHOdHUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jee9M8H2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jee9M8H2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BA4C4CEF1;
	Tue, 16 Dec 2025 12:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887461;
	bh=PuB4G7ltf4tGGJSbgHLbjj3WtAph3mdDuY757hes2Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jee9M8H262rrtMxgv2XJ+qNwLoddnCdLPkQZiNblTboZV682HFs4roo5+7II/3qpq
	 VzyFo5utYvX8XtZ14Br+gEm5IZ9rUyACskBlvmyYCkQ7kD4/jUypWsNopQ493yffdO
	 VpHIfGKxBfgs2dRwWXFALags9GlAhmZVEZE9+Lcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 236/614] ARM: dts: stm32: stm32mp157c-phycore: Fix STMPE811 touchscreen node properties
Date: Tue, 16 Dec 2025 12:10:03 +0100
Message-ID: <20251216111409.919205914@linuxfoundation.org>
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

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit e40b061cd379f4897e705d17cf1b4572ad0f3963 ]

Move st,adc-freq, st,mod-12b, st,ref-sel, and st,sample-time properties
from the touchscreen subnode to the parent touch@44 node. These properties
are defined in the st,stmpe.yaml schema for the parent node, not the
touchscreen subnode, resolving the validation error about unevaluated
properties.

Fixes: 27538a18a4fcc ("ARM: dts: stm32: add STM32MP1-based Phytec SoM")
Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Link: https://lore.kernel.org/r/20250915224611.169980-1-jihed.chaibi.dev@gmail.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/st/stm32mp157c-phycore-stm32mp15-som.dtsi    | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/st/stm32mp157c-phycore-stm32mp15-som.dtsi b/arch/arm/boot/dts/st/stm32mp157c-phycore-stm32mp15-som.dtsi
index bf0c32027baf7..370b2afbf15bf 100644
--- a/arch/arm/boot/dts/st/stm32mp157c-phycore-stm32mp15-som.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp157c-phycore-stm32mp15-som.dtsi
@@ -185,13 +185,13 @@ touch@44 {
 		interrupt-parent = <&gpioi>;
 		vio-supply = <&v3v3>;
 		vcc-supply = <&v3v3>;
+		st,sample-time = <4>;
+		st,mod-12b = <1>;
+		st,ref-sel = <0>;
+		st,adc-freq = <1>;
 
 		touchscreen {
 			compatible = "st,stmpe-ts";
-			st,sample-time = <4>;
-			st,mod-12b = <1>;
-			st,ref-sel = <0>;
-			st,adc-freq = <1>;
 			st,ave-ctrl = <1>;
 			st,touch-det-delay = <2>;
 			st,settling = <2>;
-- 
2.51.0



