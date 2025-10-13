Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A88E30F7FA;
	Mon, 13 Oct 2025 15:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368099; cv=none; b=GNqi/8KUFsosbu48OAarVMLHkW/4OyE9vMNqQpWoSEWqQFi40lyoL6pxrXxPYj3wU3FKXT+Ti3rbbRIteUd4/p2gWtOE8f6DXsibdAXytLBIIwMiV+nGlfyaFMKQPh339ml1g7xOfy6pML23Wd3QxPZ6xX4M43Yj3L0Ib5pLp30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368099; c=relaxed/simple;
	bh=CjFzEO0U3e/ZrXzCK8QgIV5UHb29Yo98RyVsELtPl7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCyIxv8hqAxg2zRs07vb8ltogFv8l3zj+/t+VEHbvnP6YdhNiQVib3wnNpT1QVx9ZXHmZPo//VowUwCDmeB81SJzDkIoNft5RqU+i6qqU38Od0/s/Bb9a0Zo4plSMOLF2EEQZv7DrEEvprNNH85BszuDzKEhrxwkSmIs4eLX0EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQulLi1H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQulLi1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB78C4CEE7;
	Mon, 13 Oct 2025 15:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368099;
	bh=CjFzEO0U3e/ZrXzCK8QgIV5UHb29Yo98RyVsELtPl7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQulLi1HXxhwl9TMWJKwXEBl8/wITNsSacnVTOJX3Faj1AEk+C8V84auXsL52YR2E
	 bEZ4BRbELkAC1L2+sEXFpNU5JdCwa9LiR0cTVkZiXbhWQai+HgfHAo2fWyW55ZJf2a
	 J5bU4FCQIakd+bpABRfRUSjOYjUqYfDq7ce2ejrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/262] ARM: dts: ti: omap: omap3-devkit8000-lcd: Fix ti,keep-vref-on property to use correct boolean syntax in DTS
Date: Mon, 13 Oct 2025 16:43:06 +0200
Message-ID: <20251013144327.718105945@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit 5af5b85505bc859adb338fe5d6e4842e72cdf932 ]

The ti,keep-vref-on property, defined as a boolean flag in the Device
Tree schema, was incorrectly assigned a value (<1>) in the DTS file,
causing a validation error: "size (4) error for type flag". Remove
the value to match the schema and ensure compatibility with the driver
using device_property_read_bool(). This fixes the dtbs_check error.

Fixes: ed05637c30e6 ("ARM: dts: omap3-devkit8000: Add ADS7846 Touchscreen support")
Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Link: https://lore.kernel.org/r/20250822225052.136919-1-jihed.chaibi.dev@gmail.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/omap3-devkit8000-lcd-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ti/omap/omap3-devkit8000-lcd-common.dtsi b/arch/arm/boot/dts/ti/omap/omap3-devkit8000-lcd-common.dtsi
index a7f99ae0c1fe9..78c657429f641 100644
--- a/arch/arm/boot/dts/ti/omap/omap3-devkit8000-lcd-common.dtsi
+++ b/arch/arm/boot/dts/ti/omap/omap3-devkit8000-lcd-common.dtsi
@@ -65,7 +65,7 @@ ads7846@0 {
 		ti,debounce-max = /bits/ 16 <10>;
 		ti,debounce-tol = /bits/ 16 <5>;
 		ti,debounce-rep = /bits/ 16 <1>;
-		ti,keep-vref-on = <1>;
+		ti,keep-vref-on;
 		ti,settle-delay-usec = /bits/ 16 <150>;
 
 		wakeup-source;
-- 
2.51.0



