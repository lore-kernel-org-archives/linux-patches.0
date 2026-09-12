Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3BE38656D;
	Sat, 12 Sep 2026 18:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239278; cv=none; b=tNxfQnflw5bMz9w0NyvTr7ccEwEtkDru63ZaS/q4tlgffVyBHb/iETwT3sv2KB4HhhMQkod/DChJch3CotjchuQqErDUNk0/Sl9ZFo2odgXX1bMncnEJ/34Vesw/IsGxuM4hLnpdfitsfYUfyFcvvdrtdmx6awAhA3ktDw1B98c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239278; c=relaxed/simple;
	bh=mEX673u8qUXB2L1wcLKJ0J8GFGRkkX1Crh/VzAnPvwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqVwmCA4MgXe6QYusbjvhE40kTgUH5sdbMSqFEgbmKJZCsqerrGgsMC2P4yF/4PxWk+ReMXiFSuOzXHqvqRi3Wbuo+yW+K8UyAx01lt33BIW+0KJE4HdvNSpRSlDLoCeOf5eRk+0f4zkLe52lXwMCjhUyORq2dQq+rkAlvLxwqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2o+e52Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2o+e52Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978FB1F000FF;
	Sat, 12 Sep 2026 18:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239276;
	bh=nQCaPBys1vqmeGWW0QrE0duxzm+vq7c0JlFIbo3TJUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g2o+e52YEnt18J9ebiym4IWxHtqch+3EQBos3d2QGWnoBgCfrEAn9fhakLJDCH75i
	 GOz7P809HGGmlrI5b5Q4tundpgeu/jYvKIwDDIHb1ETO5IfZ30ZhvJ6sGHk82nvAsT
	 w9lp26jVxtkA+P7rPo9QILuY2RgLeSEED7l2onrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 589/935] ARM: dts: allwinner: a10: Fix PMU interrupt
Date: Sat, 12 Sep 2026 09:00:19 +0200
Message-ID: <20260912065540.348411055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit eb7051f756460d7b951e94d9656e31ebb631ba28 ]

The Performance Monitoring Unit of the Cortex-A8 cores in the Allwinner
A10 SoC is connected to interrupt line 66, not 3. This is shown in the
manual (where interrupt 3 is assigned to UART2, also in our .dtsi), but
has also been confirmed by triggering an PMU overflow interrupt and
inspecting the IRQ controller status registers (from U-Boot).
Please note that "perf stat" does not use interrupts, this might explain
why this evaded the initial testing.

Fixes: 7e345d25c796 ("ARM: dts: sun4i-a10: Add PMU node")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Link: https://patch.msgid.link/20260720215128.5761-1-andre.przywara@arm.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun4i-a10.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index 1c5a666c54b53..b3a7167cc9de6 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -186,7 +186,7 @@ de: display-engine {
 
 	pmu {
 		compatible = "arm,cortex-a8-pmu";
-		interrupts = <3>;
+		interrupts = <66>;
 	};
 
 	reserved-memory {
-- 
2.53.0



