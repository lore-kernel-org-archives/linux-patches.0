Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED97212C487;
	Tue, 30 Apr 2024 11:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474924; cv=none; b=YMls9sDZShyg7czVIX15VO2FtqkDbrVHI1zhtJF5jZZjwyqK8y2/GpeOXwgnmO2h8A6x0OleEY438ZOjwBtSfsNySH4nACSow/IOH9eCepjxLwgWQ8/wvK12EU9nOUu7wfBRRD0keAqcugkatynKVF9aSOkA2BMZQJMguVXi8qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474924; c=relaxed/simple;
	bh=GcrgBWzP1trt2iApl+YVp3HY3/qoul3cng9K9iE8yYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrRRpRCPWSMXKjFoRI+8BWnn4cjQkdk5HsuPiCWvK5/ve/bGzfci5F33Yq4v/N0z9Oy+pJbkPdoWDPO3U3W+20VzzuXYBMbA1qM1uiy9mSFnhGeK9qu/d4jcpWw5kbimXa6Hj2sqYjddFbfnqHL0hKvLCFLeBvrmEKiEF3+NdXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQ2ZCvNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQ2ZCvNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7525EC4AF19;
	Tue, 30 Apr 2024 11:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474923;
	bh=GcrgBWzP1trt2iApl+YVp3HY3/qoul3cng9K9iE8yYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQ2ZCvNjfUakfH4onEUOrlu4erdo8uqbJKU0RzJ2lKre2LBrWWLiRwWHhL0tXRJJ0
	 7leU0TDtlKtYJcvF/HWjY0p54jK4y6qcjUmrJM2VA7sjQMMKuZGjgCUEq99z/uV+S3
	 J1lA5/aVegWogztkJAjdtx3oimVJakHLy5VO92DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/138] arm64: dts: mediatek: mt7622: add support for coherent DMA
Date: Tue, 30 Apr 2024 12:39:21 +0200
Message-ID: <20240430103051.664251527@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 3abd063019b6a01762f9fccc39505f29d029360a ]

It improves performance by eliminating the need for a cache flush on rx and tx

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 3ba5a6159434 ("arm64: dts: mediatek: mt7622: fix clock controllers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7622.dtsi | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index 884930a5849a2..07b4d3ba55612 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -357,7 +357,7 @@
 		};
 
 		cci_control2: slave-if@5000 {
-			compatible = "arm,cci-400-ctrl-if";
+			compatible = "arm,cci-400-ctrl-if", "syscon";
 			interface-type = "ace";
 			reg = <0x5000 0x1000>;
 		};
@@ -937,6 +937,8 @@
 		power-domains = <&scpsys MT7622_POWER_DOMAIN_ETHSYS>;
 		mediatek,ethsys = <&ethsys>;
 		mediatek,sgmiisys = <&sgmiisys>;
+		mediatek,cci-control = <&cci_control2>;
+		dma-coherent;
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
-- 
2.43.0



