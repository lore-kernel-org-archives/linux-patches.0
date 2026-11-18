Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018151;
	b=W214OjSNu9kXiYNBHeiFEOQoJSF68vOFjZSiB0OBM+9iMw8UiYMicmY5UKpoQKZAY6Qz
	 uKyEYGFqBWyClOpE7KBjpR26bz0azOrDs9PnIq+V8bq5Ji+/HDx4Lhcg2HO1UX3xscJKu
	 acT6BGjzZVp6gYxITZgWgI8w9hxh8h9sZd5aGNdPcuh1rfvRy/iDHmkjEjZYGgXuUjbSB
	 8YxubS4AjxruWa+eOk+a9avyQd7WWTsPlSqlBJUhPNyxvnEzfpGdpknGot0E78LtuXW0h
	 zuh1JgUymsjC8+ua5DCNCBTqbpNzPZMsjbhrg4g4etTGqBPkLmgcnHt3pQPxYMVYmAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jx28y/tfbflQyXZD7CJK3Tq3rtFbK0xOHsVUZWO8DLQ=;
	b=Lg9v6QOcJtWb7IizymAs0puEnVjQh/kckP3zpj1yoaQEg4cztaHYcjeb2xA4jfLRSznM
	 675UKF8kOvBcIGFJ9w/uMxs2Q+6BKoad+9zEqNbq12x1YCthCQ6gUhi6lXvTRlBZLg8FP
	 mTPYfy6CXMeYSLxFoohofj5ixYi+ZPubXHCgSsBRzgpRKOHwHd5g35j3AWwM59PAg9J84
	 6K313TnWOzoSybS7jDTOVHQIWcu5+DZgJNNYDZHTOIwYOQ7r4hLgzQiubJ/sZClJtlLI5
	 xdaakzCk/sIjQuEcx3Qyd9R0ONj51uTFpBJBRwCLbCd2KPZe+plqO8PrGeSjSlNvxWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ODJZpo5t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF79606A325;
	Wed, 18 Nov 2026 16:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ODJZpo5t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F361F000C4;
	Wed, 18 Nov 2026 16:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018151;
	bh=Jx28y/tfbflQyXZD7CJK3Tq3rtFbK0xOHsVUZWO8DLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ODJZpo5t8vUrnwbvdcAfm2NuqwXKhAlytfUM5WFmV1RofwC6/hdnRPRFuJma488RB
	 wKpa4J6zsJXv3DEl24qdhj2Dc3K/d7j8y3yXXjrqlmt8zoqfOgjeR2rhRYlxbSCum8
	 ttAYgPKchKzVRXZtcE8mbSMj+mdlpXkQlW6mRE4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1139/2651] ARM: tegra: Add core supply for Tegra114 boards
Date: Wed, 18 Nov 2026 15:39:39 +0100
Message-ID: <20261118150329.014340512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit fa9ac42208aaf43e4ab460ea75b57b226ba5fc08 ]

After commit 4cc90d4c043e ("ARM: tegra: Configure Tegra114 power
domains"), a core-supply property is required in the PMC node.
Label the core regulator on Dalmore, NVIDIA SHIELD and Tegra Note 7
and add the property.

Fixes: 4cc90d4c043e ("ARM: tegra: Configure Tegra114 power domains")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Tested-by: Svyatoslav Ryhel <clamor95@gmail.com> # Tegratab/TN7
Reviewed-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nvidia/tegra114-dalmore.dts | 4 +++-
 arch/arm/boot/dts/nvidia/tegra114-roth.dts    | 4 +++-
 arch/arm/boot/dts/nvidia/tegra114-tn7.dts     | 4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/nvidia/tegra114-dalmore.dts b/arch/arm/boot/dts/nvidia/tegra114-dalmore.dts
index c06b52fe330a2..8d97a47c969c5 100644
--- a/arch/arm/boot/dts/nvidia/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/nvidia/tegra114-dalmore.dts
@@ -969,7 +969,7 @@ smps45 {
 						regulator-boot-on;
 					};
 
-					smps457 {
+					vdd_core: smps457 {
 						regulator-name = "vdd-core";
 						regulator-min-microvolt = <900000>;
 						regulator-max-microvolt = <1400000>;
@@ -1095,6 +1095,8 @@ flash@0 {
 	};
 
 	pmc@7000e400 {
+		core-supply = <&vdd_core>;
+
 		nvidia,invert-interrupt;
 		nvidia,suspend-mode = <1>;
 		nvidia,cpu-pwr-good-time = <500>;
diff --git a/arch/arm/boot/dts/nvidia/tegra114-roth.dts b/arch/arm/boot/dts/nvidia/tegra114-roth.dts
index a89b16573b427..f48d5c37e8480 100644
--- a/arch/arm/boot/dts/nvidia/tegra114-roth.dts
+++ b/arch/arm/boot/dts/nvidia/tegra114-roth.dts
@@ -837,7 +837,7 @@ vdd_1v8: smps3 {
 						regulator-boot-on;
 					};
 
-					smps457 {
+					vdd_core: smps457 {
 						regulator-name = "vdd-soc";
 						regulator-min-microvolt = <900000>;
 						regulator-max-microvolt = <1400000>;
@@ -960,6 +960,8 @@ rtc {
 	};
 
 	pmc@7000e400 {
+		core-supply = <&vdd_core>;
+
 		nvidia,invert-interrupt;
 	};
 
diff --git a/arch/arm/boot/dts/nvidia/tegra114-tn7.dts b/arch/arm/boot/dts/nvidia/tegra114-tn7.dts
index 75fbafb4a8723..4b1e47364fdbc 100644
--- a/arch/arm/boot/dts/nvidia/tegra114-tn7.dts
+++ b/arch/arm/boot/dts/nvidia/tegra114-tn7.dts
@@ -95,7 +95,7 @@ smps123 {
 						regulator-boot-on;
 					};
 
-					smps45 {
+					vdd_core: smps45 {
 						regulator-name = "vd-soc";
 						regulator-min-microvolt = <1100000>;
 						regulator-max-microvolt = <1100000>;
@@ -241,6 +241,8 @@ rtc {
 	};
 
 	pmc@7000e400 {
+		core-supply = <&vdd_core>;
+
 		nvidia,invert-interrupt;
 	};
 
-- 
2.53.0



