Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C843183CDB;
	Sun,  1 Sep 2024 16:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208157; cv=none; b=mGro8RjM3tk+jYyEvPlACUWbvn4wRC6HBiSiUVCzXpAjBRhFHaSzREQyYHBl47N+9FIwMgT6YVcurUtFKrVrbbf3HN8f3mXSWHcVN7xRcS0oNHXifvhkRmrlSPwzc+78AScYot3ElfSJJ1SZRWX1eXvEu8T6RGjSiDCLf/BNzjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208157; c=relaxed/simple;
	bh=abECa1ULDUuHANIO+qVaYzv2UQxwuYbI1Brs9kqzvn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyuA2Yl4FBZs3/hFy0L44IvNiIJuc2OTG/8b+phNY8IGvL3jm4SgVH8Nhg8JdVwGQyPooK+8Dc80iHdWLg6xv6i01HX+Nh/uvWIfQwNBsGBkXprxvN/hlZSU4B2niatE20dgAgFWUTjY7EX0SrPTwhjtHZeERsc6AxAsrQT348A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lV760gSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lV760gSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8604C4CECC;
	Sun,  1 Sep 2024 16:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208157;
	bh=abECa1ULDUuHANIO+qVaYzv2UQxwuYbI1Brs9kqzvn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lV760gSwOjjR/bvsiTsZZ1IbzvH9EwT5KOfOfUNSUqb0QkEOO3czdBA82FqEuzCtT
	 xB1wIC6or+EGIB3oSfd217U7yq4ReTjByjhA18xzYNebuMPVfkM6OyNsGb0HcOPMb/
	 JghV2oIg7tQb6ALniFcPM+m6hxBp7QzIaJt+iUp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Niebel <Markus.Niebel@ew.tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 90/93] arm64: dts: freescale: imx93-tqma9352: fix CMA alloc-ranges
Date: Sun,  1 Sep 2024 18:17:17 +0200
Message-ID: <20240901160811.120892865@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Markus Niebel <Markus.Niebel@ew.tq-group.com>

[ Upstream commit cd0c6872aab4d2c556a5e953e6926a1b4485e543 ]

DRAM starts at 0x80000000.

Fixes: c982ecfa7992 ("arm64: dts: freescale: add initial device tree for MBa93xxLA SBC board")
Signed-off-by: Markus Niebel <Markus.Niebel@ew.tq-group.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi b/arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi
index f6e422dc2663e..b6f3c076fe54a 100644
--- a/arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi
@@ -19,7 +19,7 @@
 		linux,cma {
 			compatible = "shared-dma-pool";
 			reusable;
-			alloc-ranges = <0 0x60000000 0 0x40000000>;
+			alloc-ranges = <0 0x80000000 0 0x40000000>;
 			size = <0 0x10000000>;
 			linux,cma-default;
 		};
-- 
2.43.0



