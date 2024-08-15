Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE06317C9A9;
	Thu, 15 Aug 2024 13:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730168; cv=none; b=YPnheZQSOPF1I1AWpROyMLjDM7ykcJmgoEwmiGtChwAzRpdBxvh8RSDsr3LcGlwN0TiV0cYcG3o/b+2p5ETLLns9CrIkF27ORsn1p3v1+LQ3C2wN7BuIyR/t0ZDM6p0FapFixVXhwe4/JM7/lYQ6XH91RB2jZFJtmhEjkF0yERI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730168; c=relaxed/simple;
	bh=T7g3qoKa5YR8ZBBBYG3JS87D/4B0oELWj2QQG+P6jts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tY46O4lBfbgWttL/2LSe3Qf5HxHM+jW9au5xI8vfoSc+XyB32Oi9sGrj9tDRcZScPhY5AbiqiuqrekOsbwo75ZpqWr8TP1+e4Sv6g417Ji8LzgTn1UpFnYPd5kR1FVzyCLP4nA/Lkl2aBFPs3Yc9stX99Ab0m5AZdz7DJKGLt+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vifaqXe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vifaqXe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1311C32786;
	Thu, 15 Aug 2024 13:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730168;
	bh=T7g3qoKa5YR8ZBBBYG3JS87D/4B0oELWj2QQG+P6jts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vifaqXe9r32ItxtMSE0/24pKZtUUUV0YfncKn+e54UEQcW1piH3reuUmljcRMxlFn
	 5UIh4IWy7x1t1I03hJqU9E2Y5PReHtNsrzjo7yamYP8YDmzEOMFbpXVnROka1R4Pjt
	 NnOAVs9DF2mMWkZT33IQxVnRTqyZCE5LXcXA0nzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	WANG Xuerui <git@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 324/484] MIPS: Loongson64: DTS: Add RTC support to Loongson-2K1000
Date: Thu, 15 Aug 2024 15:23:02 +0200
Message-ID: <20240815131953.923986263@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Binbin Zhou <zhoubinbin@loongson.cn>

[ Upstream commit e47084e116fccaa43644360d7c0b997979abce3e ]

The module is now supported, enable it.

Acked-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Signed-off-by: WANG Xuerui <git@xen0n.name>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Stable-dep-of: dbb69b9d6234 ("MIPS: dts: loongson: Fix liointc IRQ polarity")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
index b44aedba350a6..03abda568aa60 100644
--- a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
+++ b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
@@ -84,6 +84,13 @@ liointc1: interrupt-controller@1fe11440 {
 						<0x00000000>; /* int3 */
 		};
 
+		rtc0: rtc@1fe07800 {
+			compatible = "loongson,ls2k1000-rtc";
+			reg = <0 0x1fe07800 0 0x78>;
+			interrupt-parent = <&liointc0>;
+			interrupts = <60 IRQ_TYPE_LEVEL_LOW>;
+		};
+
 		uart0: serial@1fe00000 {
 			compatible = "ns16550a";
 			reg = <0 0x1fe00000 0 0x8>;
-- 
2.43.0



