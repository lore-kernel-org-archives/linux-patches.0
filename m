Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A3678B4B;
	Wed, 21 Feb 2024 14:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524162; cv=none; b=MdzwZn+qpWPahcJ/PUeTEpFgECtM0sGi/Sd5AAmnEaNJoz4gi0/kdbm+jx3EY6exszw7Gn518w6eY5bQdiY6DdYyMrwlcRNjtsh+KD/CKbOYl4741ys6xDixlSjjspFKQ76fs/RS0rbSMLpcDvCzy/d9/PT8EXdPksohSmdsPZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524162; c=relaxed/simple;
	bh=mIiAS08oUQIaBzYKD86HJawIkhayOJYs2QD/cPsu+rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gH3mDfqthz3G/A/nukFxYJbY5NuseqrOT9pQHS2mAzU3EYK2lC0gK0gICls6yKmhXo9jihvoqiT5a2PGHkqgGwLjU127sf7NBRsAX/iazF67SOh0ooZpFk0e5WR1qzdrDeKWju3S98aflNmFH9Nn6v9Z4s8x1l7oiUsAh9AVfIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5c2D7zv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5c2D7zv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D55C433C7;
	Wed, 21 Feb 2024 14:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524161;
	bh=mIiAS08oUQIaBzYKD86HJawIkhayOJYs2QD/cPsu+rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5c2D7zvKnGwPa7sba5TtlhBh6kmke9vTa8TYYOWbOM78cbj2hkXxlVysl/jqvthu
	 YfWd3geBMC7U3U1ujws9UK4Vo6wlDqSjol9+f/uyJobmEz+0CayNZPYfelcc6xHtYT
	 NQhy8Qrvalb/wnIhmnjyOKN07H/LKklM15Pi1Ab0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/379] ARM: dts: imx27: Fix sram node
Date: Wed, 21 Feb 2024 14:05:34 +0100
Message-ID: <20240221125959.504237927@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 2fb7b2a2f06bb3f8321cf26c33e4e820c5b238b6 ]

Per sram.yaml, address-cells, size-cells and ranges are mandatory.

Pass them to fix the following dt-schema warnings:

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx27.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/imx27.dtsi b/arch/arm/boot/dts/imx27.dtsi
index 7bc132737a37..8ae24c865521 100644
--- a/arch/arm/boot/dts/imx27.dtsi
+++ b/arch/arm/boot/dts/imx27.dtsi
@@ -588,6 +588,9 @@
 		iram: sram@ffff4c00 {
 			compatible = "mmio-sram";
 			reg = <0xffff4c00 0xb400>;
+			ranges = <0 0xffff4c00 0xb400>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 		};
 	};
 };
-- 
2.43.0



