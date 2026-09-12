Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EC94BEE5C;
	Sat, 12 Sep 2026 14:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223978; cv=none; b=VIIILhn33L5Rvxk7D1lvXESisLuhJ1STdSZtwDTxtCEPg+TKGpROEtFf7pZ5CsRBpuDvioPgE6wnBmP5ZU/GxdTzkTOSgDf9ZMowe5EEnOr2XcKJisW7jHjOE0G7UeXgfqJ/0mIoVlduAoVct6zymOc4h8VR6waImJKLjJhSmNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223978; c=relaxed/simple;
	bh=6xu4W0N9ZA0Ehr8UFdwVrHQ8igstLvIoR9103rFaaGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyB5r4p/N/usCpUCHZGIdz5LYuZ/LHRHWNUZZL69PqoyOFdHYfnJwv4Qp5s3r0pSUPCy1U5Zx4AfYpdhr+R3K4pDgRsBmT7j+V3V7wJV/F8v8+8w2vnyEPQ3M8g7NimWBeufHSiiABTmw62PgvOZ+l+SoTzLlgweqBWA/asOuyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1SRPDo8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1SRPDo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284DA1F000FF;
	Sat, 12 Sep 2026 14:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223977;
	bh=fW/Wc8X3noiQifZmE0m9of5zwDcOTBO11ilIDbk/Sd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K1SRPDo8A7l0sWw6K0FqqVKsVldwjttu2Y+muEVgs/3VGnpNN68U6DBP5jjxAg6WF
	 26IF6YZEHHD7x7T4dytzDUTxpBXPXugeamgY2UV8LZ7f5A7Q0AaKAkwHT4tdEJY2JV
	 zkpzq3O6B5J6A9rxu2IdX9lojufd0tm5Mpy02QLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0862/1424] ARM: dts: allwinner: a10: Fix PMU interrupt
Date: Sat, 12 Sep 2026 08:54:54 +0200
Message-ID: <20260912065626.621747227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/allwinner/sun4i-a10.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/allwinner/sun4i-a10.dtsi b/arch/arm/boot/dts/allwinner/sun4i-a10.dtsi
index 51a6464aab9a3..cabf619c2e217 100644
--- a/arch/arm/boot/dts/allwinner/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/allwinner/sun4i-a10.dtsi
@@ -185,7 +185,7 @@ de: display-engine {
 
 	pmu {
 		compatible = "arm,cortex-a8-pmu";
-		interrupts = <3>;
+		interrupts = <66>;
 	};
 
 	reserved-memory {
-- 
2.53.0



