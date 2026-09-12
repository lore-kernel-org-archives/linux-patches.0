Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC7A4BEE38;
	Sat, 12 Sep 2026 16:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229994; cv=none; b=k7P3P6bEi2z8RaORCwTfAwQVSVFXh6/2DumMpKgVlV4v6QznmDFtBJpXdQCVqs1lovIJydkxct1+NKakCvRvqSXbSLPf0GESGbK84uvcV0Crq4/rNFYFYjGzuHwaXZYYNTI3lDXeKLjSdu1F1J4O4oB8S11L1wE8qV+uGaY0zQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229994; c=relaxed/simple;
	bh=OWah7i3+Y3sjIGb9KOlP0OwCBgJJ+BSynLi/ET5sW4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+gjFFDuXEUuMngIC742FAGhtHo9epuJHLEhAXYMEoAqWWk9+GiJhKaUTEYfSOUs8wMwGmo+TbHCt4mewLrW+/urrQOubVeccyVfIe5wh9Lzg6kR2JUzW9KuKgf9xW3Z8X0YQNypphbyd0qWxi4/JzGfMv6mWn9dl2PnMB1g06M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pml34u/S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pml34u/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66F81F000FF;
	Sat, 12 Sep 2026 16:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229992;
	bh=h/WY++bZ4iBXa+zEMtRc2bPAIn9rmZ6m8TkIyWX2ZVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pml34u/SdEwTFBmixqTz3BfiO5PIGKp0OKUkKlBVeDYRDngXIeCt1qqvN9K4DCHPL
	 LF+LRdJSjm/aj0sP+ySWE38lYTUTtmgo3JuqdYFLcBPInuP7vE1SlgQZTblNzeE45a
	 zsA27keIqq55aoxIKlQDveVN4YyL1gosyO71Fwvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0704/1191] ARM: dts: allwinner: a10: Fix PMU interrupt
Date: Sat, 12 Sep 2026 08:57:12 +0200
Message-ID: <20260912065604.082451159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 51a6464aab9a3..cabf619c2e217 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -185,7 +185,7 @@ de: display-engine {
 
 	pmu {
 		compatible = "arm,cortex-a8-pmu";
-		interrupts = <3>;
+		interrupts = <66>;
 	};
 
 	reserved-memory {
-- 
2.53.0



