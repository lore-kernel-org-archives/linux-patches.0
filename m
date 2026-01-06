Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6581328C037;
	Tue,  6 Jan 2026 17:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721323; cv=none; b=uqAqTioy7EFLf31w+0GvU7clyswQZpStL7RyMFVepS/SlcFOfd4GVQHL5w5WrA0Bvx7QGxfEyFfSl40vGt42UxmMY+cKh240lpWwbHo/4NxYYvucNNoCNmgcpJJwsh/mTpoS7rpD3ABZxPQFErmEgHSJPAllxAnrBaeiGiFuZME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721323; c=relaxed/simple;
	bh=X0UsfF8F/2h3TKFj/HCivDTeH1aqGXFWepX6yZ7JtsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=higsTPveODWKQaaox0fet2rHoMagwhTZyjEj3xyxEi1D6O06CqxeQJ2m4JL5ufT9Lp+2ii4/JtrXC3t8qUTYU/kbjyYW0gOxoTw0Sq1xap696UJBXoksckA6DRdkhCC9BjAE+F3hZW1BUTl/83E9ToPvr/v+3h2DXgctaIRLbVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XakR0m+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XakR0m+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF993C116C6;
	Tue,  6 Jan 2026 17:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721323;
	bh=X0UsfF8F/2h3TKFj/HCivDTeH1aqGXFWepX6yZ7JtsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XakR0m+gFcrsjHSUatg/hDgFFuNlRPK35aicOUKfrnyVpNQSXgD5Kyp5yh2mnxZac
	 Koc1F8Q4wESKfCs23MrSRZmbZ6aiLFq5Sq+scFyVNHx2+YgzTcfZXvmGwsjYif16TW
	 gG5qjQF28w7yfAVyhh+2S2B/wqzHWYIaUHKhUKbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 503/567] ARM: dts: microchip: sama7g5: fix uart fifo size to 32
Date: Tue,  6 Jan 2026 18:04:45 +0100
Message-ID: <20260106170509.976967405@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Nicolas Ferre <nicolas.ferre@microchip.com>

[ Upstream commit 5654889a94b0de5ad6ceae3793e7f5e0b61b50b6 ]

On some flexcom nodes related to uart, the fifo sizes were wrong: fix
them to 32 data.

Fixes: 7540629e2fc7 ("ARM: dts: at91: add sama7g5 SoC DT and sama7g5-ek")
Cc: stable@vger.kernel.org # 5.15+
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20251114103313.20220-2-nicolas.ferre@microchip.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/microchip/sama7g5.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/microchip/sama7g5.dtsi
+++ b/arch/arm/boot/dts/microchip/sama7g5.dtsi
@@ -811,7 +811,7 @@
 				dma-names = "tx", "rx";
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
-				atmel,fifo-size = <16>;
+				atmel,fifo-size = <32>;
 				status = "disabled";
 			};
 		};
@@ -837,7 +837,7 @@
 				dma-names = "tx", "rx";
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
-				atmel,fifo-size = <16>;
+				atmel,fifo-size = <32>;
 				status = "disabled";
 			};
 		};


