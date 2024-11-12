Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63502141AB;
	Tue, 12 Nov 2024 10:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407989; cv=none; b=rC9/0UgBJpXB/G11+MIjqIx0Ymt1oOhrVMnArbF5QOhnqPHRwMNwWHaWKv2rG75OR2iz9NdRvmX61Ej+FMYveTCeEd/t3j1nMDaPrykIR1sUFfASelJXu9K1cRKIBz0Nr9NDMXg/WMMWanm+o1rbleMvzPzua+jCloGqqBGPkWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407989; c=relaxed/simple;
	bh=SObnhBLnmEHdf5PzoYQMAd3PlFCNhRMeLa5mI7iAMeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+obrkwIZ9Prh7UQvGhDlmIfgAI1K6bucjZodajIp305NW6OQ3UuCdzpI0jWMZ/6pmc6T4xqVXSCd/gFsVZg2qf7WUyae4+GJ6/TucxWsfcnADVMrTbGQ141M0uDcY0RFeLv/W82XonFhBOQ/t0Ed/DKCtyxAAt9RcO2ptENizQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8yIyJas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8yIyJas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2494BC4CECD;
	Tue, 12 Nov 2024 10:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407989;
	bh=SObnhBLnmEHdf5PzoYQMAd3PlFCNhRMeLa5mI7iAMeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8yIyJaso4b6SOfVkkkY4rI7Shv6KAQxvNm6fQL+AlOyJNqQM7+F/W7DKPFlzujpY
	 kMcdnm5MckiE6mMc9HPKyDCeSo+L9zL7PWrlQY3OLlN06GIWmR3vzklbXN9R8IDVM0
	 8zgPLW9H9MGqAK6/v5tcD9LewgBA6UZl+MG3Q92k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 6.11 003/184] arm64: dts: rockchip: Move L3 cache outside CPUs in RK3588(S) SoC dtsi
Date: Tue, 12 Nov 2024 11:19:21 +0100
Message-ID: <20241112101901.001267093@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragan Simic <dsimic@manjaro.org>

[ Upstream commit df5f6f2f62b9b50cef78f32909485b00fc7cf7f2 ]

Move the "l3_cache" node outside the "cpus" node in the base dtsi file for
Rockchip RK3588(S) SoCs.  The A55 and A76 CPU cores in these SoCs belong to
the ARM DynamIQ IP core lineup, which places the L3 cache outside the CPUs
and into the DynamIQ Shared Unit (DSU). [1]  Thus, moving the L3 cache DT
node one level higher in the DT improves the way the physical topology of
the RK3588(S) SoCs is represented in the SoC dtsi files.

While there, add a comment that explains it briefly, to save curious readers
from the need to reference the repository log for a clarification.

[1] ARM DynamIQ Shared Unit revision r4p0 TRM, version 0400-02

Fixes: c9211fa2602b ("arm64: dts: rockchip: Add base DT for rk3588 SoC")
Helped-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/84264d0713fb51ae2b9b731e28fc14681beea853.1727345965.git.dsimic@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
index ee99166ebd46f..f695c5d5f9144 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
@@ -337,15 +337,19 @@
 			cache-unified;
 			next-level-cache = <&l3_cache>;
 		};
+	};
 
-		l3_cache: l3-cache {
-			compatible = "cache";
-			cache-size = <3145728>;
-			cache-line-size = <64>;
-			cache-sets = <4096>;
-			cache-level = <3>;
-			cache-unified;
-		};
+	/*
+	 * The L3 cache belongs to the DynamIQ Shared Unit (DSU),
+	 * so it's represented here, outside the "cpus" node
+	 */
+	l3_cache: l3-cache {
+		compatible = "cache";
+		cache-size = <3145728>;
+		cache-line-size = <64>;
+		cache-sets = <4096>;
+		cache-level = <3>;
+		cache-unified;
 	};
 
 	display_subsystem: display-subsystem {
-- 
2.43.0



