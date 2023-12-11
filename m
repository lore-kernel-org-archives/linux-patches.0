Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3193B52F8E;
	Mon, 11 Dec 2023 18:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyKs3iz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C7AC433C9;
	Mon, 11 Dec 2023 18:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319712;
	bh=TbfbVwN3mYH8NqqRrmdCxgGUCMC6Qe3+AfEE5+3FwyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyKs3iz7pUCAFUF8xaI0bi1RslHhtM7nU02f1LiT+qGMQsuNxS/rvlh4Kh4SR6W4N
	 /OOxGnF7/bKwnZtzjomqSt8Ja/NHtUquA1q0K3U4Hu3qqLwQjGVvW/AHI7JHk1t2QQ
	 yAfhbPAuSIG96P0EWZoNVzty0hEcbsSL+1fNjIns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Frank Wunderlich <frank-w@public-files.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.6 176/244] arm64: dts: mt7986: change cooling trips
Date: Mon, 11 Dec 2023 19:21:09 +0100
Message-ID: <20231211182053.826188969@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Wunderlich <frank-w@public-files.de>

commit 1fcda8ceb014aafd56f10b33e0077c93b5dd45d1 upstream.

Add Critical and hot trips for emergency system shutdown and limiting
system load.

Change passive trip to active to make sure fan is activated on the
lowest trip.

Cc: stable@vger.kernel.org
Fixes: 1f5be05132f3 ("arm64: dts: mt7986: add thermal-zones")
Fixes: c26f779a2295 ("arm64: dts: mt7986: add pwm-fan and cooling-maps to BPI-R3 dts")
Suggested-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20231025170832.78727-4-linux@fw-web.de
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dts |   10 +++----
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi                |   20 ++++++++++++---
 2 files changed, 21 insertions(+), 9 deletions(-)

--- a/arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dts
+++ b/arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dts
@@ -150,16 +150,16 @@
 			trip = <&cpu_trip_active_high>;
 		};
 
-		cpu-active-low {
+		cpu-active-med {
 			/* active: set fan to cooling level 1 */
 			cooling-device = <&fan 1 1>;
-			trip = <&cpu_trip_active_low>;
+			trip = <&cpu_trip_active_med>;
 		};
 
-		cpu-passive {
-			/* passive: set fan to cooling level 0 */
+		cpu-active-low {
+			/* active: set fan to cooling level 0 */
 			cooling-device = <&fan 0 0>;
-			trip = <&cpu_trip_passive>;
+			trip = <&cpu_trip_active_low>;
 		};
 	};
 };
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -610,22 +610,34 @@
 			thermal-sensors = <&thermal 0>;
 
 			trips {
+				cpu_trip_crit: crit {
+					temperature = <125000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+
+				cpu_trip_hot: hot {
+					temperature = <120000>;
+					hysteresis = <2000>;
+					type = "hot";
+				};
+
 				cpu_trip_active_high: active-high {
 					temperature = <115000>;
 					hysteresis = <2000>;
 					type = "active";
 				};
 
-				cpu_trip_active_low: active-low {
+				cpu_trip_active_med: active-med {
 					temperature = <85000>;
 					hysteresis = <2000>;
 					type = "active";
 				};
 
-				cpu_trip_passive: passive {
-					temperature = <40000>;
+				cpu_trip_active_low: active-low {
+					temperature = <60000>;
 					hysteresis = <2000>;
-					type = "passive";
+					type = "active";
 				};
 			};
 		};


