Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4BF140391;
	Tue, 27 Feb 2024 13:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042303; cv=none; b=eDE7Sy/oTMV153pTqYc93/M6nXO32fABjzHhAnZGT5JfeMlOdj25nCKDVVrDn/bpYz1fIs6TT+opOlp7O/j9LOy9PUgb+4J9EMIGmX7v+9qwhKtQ5snD6rTcEwEruj4kQ6NmcEwNE60hUZrtA8qEKGEJxzwLw+oSyu80D++h1TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042303; c=relaxed/simple;
	bh=dTdgKysP7BpBxE46/y75pzYut0LrqINtJ47XEwFau08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjQ7WbBJyYuqN+lMGN6bZSBCxEpujWYMKZYbgeuGpa9Zj2VU93NRR7ywyiJ5d9MJ/00n3t6FANmmclGyMpwn2Dxao1j9kX72BcTv1HbFxJ4ZFr2sCKLGp5z5xV0GzWDXSTXM5BJiL2Li2FT5cxJ+BdnIaWjwIACoowPNyr9XUv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yc1vZFKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yc1vZFKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04C0C433F1;
	Tue, 27 Feb 2024 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042303;
	bh=dTdgKysP7BpBxE46/y75pzYut0LrqINtJ47XEwFau08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yc1vZFKDThKzK0nHFEoICIsUWWjXHEkvKfABnXvijgS8LsV3MFxh7RGVgIUnymjXs
	 nEiPWuDIW+SS8LjFBVHyMBzHFVK6hP5xjLu8o5XVuZrH2wp99IFnOoKs2RDB3NX43W
	 jNUOGyG0FJKvevi8UEeoOTBLTQAdThTvhK5xjn0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 221/299] arm64: dts: tqma8mpql: fix audio codec iov-supply
Date: Tue, 27 Feb 2024 14:25:32 +0100
Message-ID: <20240227131632.880533770@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit a620a7f2ae8b08c5beea6369f61e87064ee222dc ]

IOVDD is supplied by 1.8V, fix the referenced regulator.

Fixes: d8f9d8126582d ("arm64: dts: imx8mp: Add analog audio output on i.MX8MP TQMa8MPxL/MBa8MPxL")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts     | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
index 4240e20d38ac3..258e90cc16ff3 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
@@ -168,6 +168,13 @@
 		enable-active-high;
 	};
 
+	reg_vcc_1v8: regulator-1v8 {
+		compatible = "regulator-fixed";
+		regulator-name = "VCC_1V8";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+	};
+
 	reg_vcc_3v3: regulator-3v3 {
 		compatible = "regulator-fixed";
 		regulator-name = "VCC_3V3";
@@ -464,7 +471,7 @@
 		clock-names = "mclk";
 		clocks = <&audio_blk_ctrl IMX8MP_CLK_AUDIOMIX_SAI3_MCLK1>;
 		reset-gpios = <&gpio4 29 GPIO_ACTIVE_LOW>;
-		iov-supply = <&reg_vcc_3v3>;
+		iov-supply = <&reg_vcc_1v8>;
 		ldoin-supply = <&reg_vcc_3v3>;
 	};
 
-- 
2.43.0



