Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6468112C49E;
	Tue, 30 Apr 2024 10:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473964; cv=none; b=W+qhX4ija4nrbgerbwWAVrxAacl6QW6GVCQ1R6eHtHCd7mjW7Fr2x7zEPYOdz4pa2W5GVTJ/r55+bG4A1Uol7ewPnyuh6aOEvqDhr73Sf7EKZpT/Hd48y3zqcdhhRhOMvOHWqTGZSNdzRzE7mJoGPOArFzVNq4yAoIoYd+eZak4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473964; c=relaxed/simple;
	bh=oH4mcZxB523aJoQjlAvDYoTn2sIfDxUzj5C+7rN8lBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQuZXEC/A8bc8jF9a+BaPKvHZtVF3VNwBLP7XLl7QFzXlXY3tsaj35OrRExPc3xWHYPJyV5EibHqDpr+ANt+oqgcMKDoI8PeKidy9nNV2hwu1QHRaFJVQx30re10ol0YHCniWOMW7IESzPnLMEyoam4vrRBj3b75q5CeRMtLUyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bR+PQP2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bR+PQP2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A5CC4AF19;
	Tue, 30 Apr 2024 10:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473964;
	bh=oH4mcZxB523aJoQjlAvDYoTn2sIfDxUzj5C+7rN8lBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bR+PQP2bj6/DVYFmfdiu/PSjs1trGOG8dXDoIytzHOaDUwe5GybpPdJETKdQ/l7Mr
	 7/W5rEWCj8bNhyF1wTwptaSR9HpGm4RJqn0DGqMcXIujSmQ4gqFEpxEuuZIYqSHc04
	 3bitRq8yKKWUZdBX+caQcqHKDQisJzNY0OnUY4mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iskander Amara <iskander.amara@theobroma-systems.com>,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 008/228] arm64: dts: rockchip: fix alphabetical ordering RK3399 puma
Date: Tue, 30 Apr 2024 12:36:26 +0200
Message-ID: <20240430103104.055469614@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iskander Amara <iskander.amara@theobroma-systems.com>

[ Upstream commit f0abb4b2c7acf3c3e4130dc3f54cd90cf2ae62bc ]

Nodes overridden by their reference should be ordered alphabetically to
make it easier to read the DTS. pinctrl node is defined in the wrong
location so let's reorder it.

Signed-off-by: Iskander Amara <iskander.amara@theobroma-systems.com>
Reviewed-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://lore.kernel.org/r/20240308085243.69903-2-iskander.amara@theobroma-systems.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: 945a7c857091 ("arm64: dts: rockchip: enable internal pull-up on PCIE_WAKE# for RK3399 Puma")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index d4324e57729b5..a8102d1e31987 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -416,15 +416,6 @@
 	gpio1830-supply = <&vcc_1v8>;
 };
 
-&pmu_io_domains {
-	status = "okay";
-	pmu1830-supply = <&vcc_1v8>;
-};
-
-&pwm2 {
-	status = "okay";
-};
-
 &pinctrl {
 	i2c8 {
 		i2c8_xfer_a: i2c8-xfer {
@@ -463,6 +454,15 @@
 	};
 };
 
+&pmu_io_domains {
+	status = "okay";
+	pmu1830-supply = <&vcc_1v8>;
+};
+
+&pwm2 {
+	status = "okay";
+};
+
 &sdhci {
 	/*
 	 * Signal integrity isn't great at 200MHz but 100MHz has proven stable
-- 
2.43.0



