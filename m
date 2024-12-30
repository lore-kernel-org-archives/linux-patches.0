Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA67915E8B;
	Mon, 30 Dec 2024 15:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574025; cv=none; b=LXF4KkM5AoNZZ1lof3t8I6Gp67bFcmCBdaHtwDBQXzbU1EGB8CLmWmzr7Dnz48BmHVrtxfsdLZVgyL21fD709X04LpwTwFLT/cCCeMgmjzDaicC24JQ1ugJa0eeH36bSd2qPGTWVhb68YDEamiS+WQ/mqts5PoXLyba231yJrNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574025; c=relaxed/simple;
	bh=MY3fQy8DjxE7UeYCpRiuomEtU9V1YsIeRsLCVM6nPIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKkpFIQxJ8MN/8gMxLCAjrtTBYmsjOLT1LIzL8h9rahlJZDOEczfkzA56ChGW+1l/0+R+nhF6NfqJyyUev64fr5Cr5tJExR7RXt6PYqnxwY+u8wuFaz9MBbh5U+SZ2kVDjrXHfDW+kNhXekmub2lTW1MQkudk6c0lXROTRY9/jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJSCbQmZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJSCbQmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F950C4CED0;
	Mon, 30 Dec 2024 15:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574025;
	bh=MY3fQy8DjxE7UeYCpRiuomEtU9V1YsIeRsLCVM6nPIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJSCbQmZoQW/KGsiicPfjqDOAE2sUaqjsNoWIbQsBXOuqRLJOEmGbIp41xp3OkxLs
	 7OBNZoJxIYjPnamXFI0FF6MlYyQ7qbAEDnZGxg6w0R4jBuivnIEOitzJ4XTs8v0FHS
	 t201ltS+RUV/0wuyzcVrWXx+QC8irQTGID//4jH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willow Cunningham <willow.e.cunningham@maine.edu>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/114] arm64: dts: broadcom: Fix L2 linesize for Raspberry Pi 5
Date: Mon, 30 Dec 2024 16:42:00 +0100
Message-ID: <20241230154218.189594497@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willow Cunningham <willow.e.cunningham@gmail.com>

[ Upstream commit 058387d9c6b70e225da82492e1e193635c3fac3f ]

Set the cache-line-size parameter of the L2 cache for each core to the
correct value of 64 bytes.

Previously, the L2 cache line size was incorrectly set to 128 bytes
for the Broadcom BCM2712. This causes validation tests for the
Performance Application Programming Interface (PAPI) tool to fail as
they depend on sysfs accurately reporting cache line sizes.

The correct value of 64 bytes is stated in the official documentation of
the ARM Cortex A-72, which is linked in the comments of
arm64/boot/dts/broadcom/bcm2712.dtsi as the source for cache-line-size.

Fixes: faa3381267d0 ("arm64: dts: broadcom: Add minimal support for Raspberry Pi 5")
Signed-off-by: Willow Cunningham <willow.e.cunningham@maine.edu>
Link: https://lore.kernel.org/r/20241007212954.214724-1-willow.e.cunningham@maine.edu
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/bcm2712.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcm2712.dtsi b/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
index 6e5a984c1d4e..26a29e5e5078 100644
--- a/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
@@ -67,7 +67,7 @@
 			l2_cache_l0: l2-cache-l0 {
 				compatible = "cache";
 				cache-size = <0x80000>;
-				cache-line-size = <128>;
+				cache-line-size = <64>;
 				cache-sets = <1024>; //512KiB(size)/64(line-size)=8192ways/8-way set
 				cache-level = <2>;
 				cache-unified;
@@ -91,7 +91,7 @@
 			l2_cache_l1: l2-cache-l1 {
 				compatible = "cache";
 				cache-size = <0x80000>;
-				cache-line-size = <128>;
+				cache-line-size = <64>;
 				cache-sets = <1024>; //512KiB(size)/64(line-size)=8192ways/8-way set
 				cache-level = <2>;
 				cache-unified;
@@ -115,7 +115,7 @@
 			l2_cache_l2: l2-cache-l2 {
 				compatible = "cache";
 				cache-size = <0x80000>;
-				cache-line-size = <128>;
+				cache-line-size = <64>;
 				cache-sets = <1024>; //512KiB(size)/64(line-size)=8192ways/8-way set
 				cache-level = <2>;
 				cache-unified;
@@ -139,7 +139,7 @@
 			l2_cache_l3: l2-cache-l3 {
 				compatible = "cache";
 				cache-size = <0x80000>;
-				cache-line-size = <128>;
+				cache-line-size = <64>;
 				cache-sets = <1024>; //512KiB(size)/64(line-size)=8192ways/8-way set
 				cache-level = <2>;
 				cache-unified;
-- 
2.39.5



