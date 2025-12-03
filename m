Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F2335BDAD;
	Wed,  3 Dec 2025 16:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778940; cv=none; b=mW5Y6aHKroFH4Wx6Mu9NwrrprCw5X7YCDn7L6k+6K4XotKP3ZwfOkbBPFIXgVqnSASl6TbA8D7zx/vrBWqS5EU8URnDka++ZT1uA5l7vV0BJyR8WO1Nc5Q0M765q4B4N8veP+8hP5jcdeljNpK6K0PEwnGFNsdpR2ompkMUY9Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778940; c=relaxed/simple;
	bh=DRhMATHWb0+k14E+DlFa4bEBrTHbH/RkVO518XFjhwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAI4woWzBG9bBKmEQIdSGueHts/IG6+Ahd6dmx4QDxN1apjQV8X+Al+qg5Goog+M3eGMjeUujOlrm8XgthVXkor+NXMBMd8o8sQMrccg5nGCbZmTQDvhU/5L9yGkEPtVjPKbRAlTykU4vD0ttph0+1LJ2WDb605niWOrYrbZLdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWhNEDFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWhNEDFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3F6C4CEF5;
	Wed,  3 Dec 2025 16:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778939;
	bh=DRhMATHWb0+k14E+DlFa4bEBrTHbH/RkVO518XFjhwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWhNEDFt9JAsp0hzp5jZEkr7zRcUCqgZpbdCQ47qvaK1a7NliqpM9JWbTXJANosBK
	 J6b0MOV2m3W2orB4rvPGtQ/ZrvymwWt3LtG7Dfqz1oLWM04E/VDL96/8pyGlm/iA3d
	 PED39xiH612EMV3w/lz5u6xt5yPYGu9Yk3QaLNfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	Thierry Reding <treding@nvidia.com>,
	Wen Yang <wen.yang@linux.dev>
Subject: [PATCH 6.1 074/568] arm64: tegra: Update cache properties
Date: Wed,  3 Dec 2025 16:21:16 +0100
Message-ID: <20251203152443.427346457@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre Gondois <pierre.gondois@arm.com>

[ Upstream commit 27f1568b1d5fe35014074f92717b250afbe67031 ]

The DeviceTree Specification v0.3 specifies that the cache node
'compatible' and 'cache-level' properties are 'required'. Cf.
s3.8 Multi-level and Shared Cache Nodes
The 'cache-unified' property should be present if one of the
properties for unified cache is present ('cache-size', ...).

Update the Device Trees accordingly.

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Wen Yang <wen.yang@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/nvidia/tegra194.dtsi |   15 ++++++++++++++
 arch/arm64/boot/dts/nvidia/tegra210.dtsi |    1 
 arch/arm64/boot/dts/nvidia/tegra234.dtsi |   33 +++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -3029,36 +3029,51 @@
 		};
 
 		l2c_0: l2-cache0 {
+			compatible = "cache";
+			cache-unified;
 			cache-size = <2097152>;
 			cache-line-size = <64>;
 			cache-sets = <2048>;
+			cache-level = <2>;
 			next-level-cache = <&l3c>;
 		};
 
 		l2c_1: l2-cache1 {
+			compatible = "cache";
+			cache-unified;
 			cache-size = <2097152>;
 			cache-line-size = <64>;
 			cache-sets = <2048>;
+			cache-level = <2>;
 			next-level-cache = <&l3c>;
 		};
 
 		l2c_2: l2-cache2 {
+			compatible = "cache";
+			cache-unified;
 			cache-size = <2097152>;
 			cache-line-size = <64>;
 			cache-sets = <2048>;
+			cache-level = <2>;
 			next-level-cache = <&l3c>;
 		};
 
 		l2c_3: l2-cache3 {
+			compatible = "cache";
+			cache-unified;
 			cache-size = <2097152>;
 			cache-line-size = <64>;
 			cache-sets = <2048>;
+			cache-level = <2>;
 			next-level-cache = <&l3c>;
 		};
 
 		l3c: l3-cache {
+			compatible = "cache";
+			cache-unified;
 			cache-size = <4194304>;
 			cache-line-size = <64>;
+			cache-level = <3>;
 			cache-sets = <4096>;
 		};
 	};
--- a/arch/arm64/boot/dts/nvidia/tegra210.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
@@ -2005,6 +2005,7 @@
 
 		L2: l2-cache {
 			compatible = "cache";
+			cache-level = <2>;
 		};
 	};
 
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -2907,117 +2907,150 @@
 		};
 
 		l2c0_0: l2-cache00 {
+			compatible = "cache";
 			cache-size = <262144>;
 			cache-line-size = <64>;
 			cache-sets = <512>;
 			cache-unified;
+			cache-level = <2>;
 			next-level-cache = <&l3c0>;
 		};
 
 		l2c0_1: l2-cache01 {
+			compatible = "cache";
 			cache-size = <262144>;
 			cache-line-size = <64>;
 			cache-sets = <512>;
 			cache-unified;
+			cache-level = <2>;
 			next-level-cache = <&l3c0>;
 		};
 
 		l2c0_2: l2-cache02 {
+			compatible = "cache";
 			cache-size = <262144>;
 			cache-line-size = <64>;
 			cache-sets = <512>;
 			cache-unified;
+			cache-level = <2>;
 			next-level-cache = <&l3c0>;
 		};
 
 		l2c0_3: l2-cache03 {
+			compatible = "cache";
 			cache-size = <262144>;
 			cache-line-size = <64>;
 			cache-sets = <512>;
 			cache-unified;
+			cache-level = <2>;
 			next-level-cache = <&l3c0>;
 		};
 
 		l2c1_0: l2-cache10 {
+			compatible = "cache";
 			cache-size = <262144>;
 			cache-line-size = <64>;
 			cache-sets = <512>;
 			cache-unified;
+			cache-level = <2>;
 			next-level-cache = <&l3c1>;
 		};
 
 		l2c1_1: l2-cache11 {
+			compatible = "cache";
 			cache-size = <262144>;
 			cache-line-size = <64>;
 			cache-sets = <512>;
 			cache-unified;
+			cache-level = <2>;
 			next-level-cache = <&l3c1>;
 		};
 
 		l2c1_2: l2-cache12 {
+			compatible = "cache";
 			cache-size = <262144>;
 			cache-line-size = <64>;
 			cache-sets = <512>;
 			cache-unified;
+			cache-level = <2>;
 			next-level-cache = <&l3c1>;
 		};
 
 		l2c1_3: l2-cache13 {
+			compatible = "cache";
 			cache-size = <262144>;
 			cache-line-size = <64>;
 			cache-sets = <512>;
 			cache-unified;
+			cache-level = <2>;
 			next-level-cache = <&l3c1>;
 		};
 
 		l2c2_0: l2-cache20 {
+			compatible = "cache";
 			cache-size = <262144>;
 			cache-line-size = <64>;
 			cache-sets = <512>;
 			cache-unified;
+			cache-level = <2>;
 			next-level-cache = <&l3c2>;
 		};
 
 		l2c2_1: l2-cache21 {
+			compatible = "cache";
 			cache-size = <262144>;
 			cache-line-size = <64>;
 			cache-sets = <512>;
 			cache-unified;
+			cache-level = <2>;
 			next-level-cache = <&l3c2>;
 		};
 
 		l2c2_2: l2-cache22 {
+			compatible = "cache";
 			cache-size = <262144>;
 			cache-line-size = <64>;
 			cache-sets = <512>;
 			cache-unified;
+			cache-level = <2>;
 			next-level-cache = <&l3c2>;
 		};
 
 		l2c2_3: l2-cache23 {
+			compatible = "cache";
 			cache-size = <262144>;
 			cache-line-size = <64>;
 			cache-sets = <512>;
 			cache-unified;
+			cache-level = <2>;
 			next-level-cache = <&l3c2>;
 		};
 
 		l3c0: l3-cache0 {
+			compatible = "cache";
+			cache-unified;
 			cache-size = <2097152>;
 			cache-line-size = <64>;
 			cache-sets = <2048>;
+			cache-level = <3>;
 		};
 
 		l3c1: l3-cache1 {
+			compatible = "cache";
+			cache-unified;
 			cache-size = <2097152>;
 			cache-line-size = <64>;
 			cache-sets = <2048>;
+			cache-level = <3>;
 		};
 
 		l3c2: l3-cache2 {
+			compatible = "cache";
+			cache-unified;
 			cache-size = <2097152>;
 			cache-line-size = <64>;
 			cache-sets = <2048>;
+			cache-level = <3>;
 		};
 	};
 


