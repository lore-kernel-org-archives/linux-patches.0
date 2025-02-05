Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7A01519AA;
	Wed,  5 Feb 2025 14:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764854; cv=none; b=G+yTZZ5KWVc/VANuYNoam04JzYrQGPqM6P3wb8+jPWqwqKxDW5TfdQyPoInMze80IH9v4zjROP5SgxMNtO/ddMm6cwnIEa1R4UYWECb2OYLidun52qK+y7VFaKzSnrfYIvu/znwFfV04JrKQBAHgZJVijXCi+gQ4qQi2sABk7L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764854; c=relaxed/simple;
	bh=MDwUTO2MLSnCoVTiw+DXu8Vw5qY1SKOZ5nfZGSX2Ekg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xvzwm+lkMl8DicTUkEV7eb/LmQuT1seEjh3D6I7fBDrK2lnBxQfklN8Ttv/WtooSr1YL8yYZYogDrdlWq6uBuSt7mP3/qGouUbd2Glv7z9OyimJR3J1S/WWVdCoqjq8AkouHXRJGaoAug5d3f67ALrOLExyqvA7XWdjWV6hnIXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crPdnwXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crPdnwXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5621BC4CED1;
	Wed,  5 Feb 2025 14:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764853;
	bh=MDwUTO2MLSnCoVTiw+DXu8Vw5qY1SKOZ5nfZGSX2Ekg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=crPdnwXlNBoUcMkVjnLC68QWLaLQfno7y3moua3+dLptT68PdMCwUsTEpYynbfcn5
	 m5UqGgJonevBlsaVkQJsp/ZLdKoaBRK3KHh55rcMIJITAtTsfq2m6N3qwoc0K6u67t
	 5ALqZzh3nEuS5Ngz7EafLmPthsb+j9N6/40fRzTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 210/393] arm64: dts: mediatek: mt8173-elm: Fix MT6397 PMIC sub-node names
Date: Wed,  5 Feb 2025 14:42:09 +0100
Message-ID: <20250205134428.333610625@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit beb06b727194f68b0a4b5183e50c88265ce185af ]

The MT6397 PMIC bindings specify exact names for its sub-nodes. The
names used in the current dts don't match, causing a validation error.

Fix up the names. Also drop the label for the regulators node, since
any reference should be against the individual regulator sub-nodes.

Fixes: 689b937bedde ("arm64: dts: mediatek: add mt8173 elm and hana board")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20241210092614.3951748-1-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi b/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
index 855babfdd8f0e..8df919d39e5ba 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
@@ -938,7 +938,7 @@
 		interrupt-controller;
 		#interrupt-cells = <2>;
 
-		clock: mt6397clock {
+		clock: clocks {
 			compatible = "mediatek,mt6397-clk";
 			#clock-cells = <1>;
 		};
@@ -949,7 +949,7 @@
 			#gpio-cells = <2>;
 		};
 
-		regulator: mt6397regulator {
+		regulators {
 			compatible = "mediatek,mt6397-regulator";
 
 			mt6397_vpca15_reg: buck_vpca15 {
@@ -1115,7 +1115,7 @@
 			};
 		};
 
-		rtc: mt6397rtc {
+		rtc: rtc {
 			compatible = "mediatek,mt6397-rtc";
 		};
 
-- 
2.39.5



