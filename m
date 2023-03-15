Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE01C4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E671C433EF;
	Wed, 15 Mar 2023 12:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882667;
	bh=++22oCWeDRdzUHtuudFYIer7nwcHAUafStg7/A7lnIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQnJ5Sq121RJFIt3JyR1pQ+iO9zGc8ixtR8+rdFKVdzgbiRLvIyJd+XgAigbFD2nL
	 YvnBpBA61vKhyKEbvP/oO7f+qxjFBBeQiQ+aLzSqEE82LREHgV/9FfxtY4a37TuaGF
	 wPaffrPWJWRutXkLC2CBVggf5Uv/mgpmCBUS2TaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 25/68] ARM: dts: exynos: Override thermal by label in Exynos4210
Date: Wed, 15 Mar 2023 13:12:19 +0100
Message-Id: <20230315115727.078793866@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 1708f56081e239a29ed8646aa7fde6853235d93f ]

Using full paths to extend or override a device tree node is error prone
since if there was a typo error, a new node will be created instead of
extending the node as it was desired.  This will lead to run-time errors
that could be hard to detect.

A mistyped label on the other hand, will cause a dtc compile error
(during build time).

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20200830135200.24304-16-krzk@kernel.org
Stable-dep-of: 408ab6786dbf ("ARM: dts: exynos: correct TMU phandle in Exynos4210")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4210.dtsi | 36 +++++++++++++++----------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index f220716239dbf..d341dcad8da6d 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -372,26 +372,24 @@
 			};
 		};
 	};
+};
 
-	thermal-zones {
-		cpu_thermal: cpu-thermal {
-			polling-delay-passive = <0>;
-			polling-delay = <0>;
-			thermal-sensors = <&tmu 0>;
-
-			trips {
-				cpu_alert0: cpu-alert-0 {
-					temperature = <85000>; /* millicelsius */
-				};
-				cpu_alert1: cpu-alert-1 {
-					temperature = <100000>; /* millicelsius */
-				};
-				cpu_alert2: cpu-alert-2 {
-					temperature = <110000>; /* millicelsius */
-				};
-			};
-		};
-	};
+&cpu_alert0 {
+	temperature = <85000>; /* millicelsius */
+};
+
+&cpu_alert1 {
+	temperature = <100000>; /* millicelsius */
+};
+
+&cpu_alert2 {
+	temperature = <110000>; /* millicelsius */
+};
+
+&cpu_thermal {
+	polling-delay-passive = <0>;
+	polling-delay = <0>;
+	thermal-sensors = <&tmu 0>;
 };
 
 &gic {
-- 
2.39.2



