Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A973E8C51;
	Thu, 15 Jan 2026 17:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499980; cv=none; b=i308LJhh/pyY5s+QnVWBbSKAIqzkroooGG7FqX3VAOF/fsAtP6IlRGfRRWvLVEpfxPt9QY+5mJi6VW++N8HfxnLxfH+TaTz7rjD+WGc9Qfopady6W8jpZ+H2aSktyf8ALKar8/3pZ9h/dRzPzySoFihpCxG3daMlw2JpP1mDVXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499980; c=relaxed/simple;
	bh=Ud7DVjA8PcDKXUz3cjARxagDtsUflNs/1swQPIFSZRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rph4jsEv+ApSwCW70qDf+o1HqmEtUcSGcIQdfpQcum1izEYYU/KkDWRhREQGg+EIpH8j5fk7lWS5QU8YcCVn0+qW7NibmTrUZMBQ7ysCQRtE3HzHNlzOAyTul//sFkIf7V4tmmmZ8KFtFukuaz0c2nYCWM2pW+QThPU3k7kB4gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TSmT5ir8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSmT5ir8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0ADC16AAE;
	Thu, 15 Jan 2026 17:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499980;
	bh=Ud7DVjA8PcDKXUz3cjARxagDtsUflNs/1swQPIFSZRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSmT5ir8MDYCnCcocJvlkhgaiDIFbACzz/NcdhGj3hxCEAl7wUrkvbz3LQnk+1RvQ
	 xZ93k13EDbqUFH+IwsANhzEVO8IsHL0DT1F7wRuXLkCFl/Ly9S6f9Z1DdGlgcpynA/
	 80nrs10WsPCZT/KPg+usS0iFFyHYzCXpeOl+ApME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 374/451] ARM: dts: microchip: sama5d2: fix spi flexcom fifo size to 32
Date: Thu, 15 Jan 2026 17:49:35 +0100
Message-ID: <20260115164244.445442721@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@microchip.com>

[ Upstream commit 7d5864dc5d5ea6a35983dd05295fb17f2f2f44ce ]

Unlike standalone spi peripherals, on sama5d2, the flexcom spi have fifo
size of 32 data. Fix flexcom/spi nodes where this property is wrong.

Fixes: 6b9a3584c7ed ("ARM: dts: at91: sama5d2: Add missing flexcom definitions")
Cc: stable@vger.kernel.org # 5.8+
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20251114140225.30372-1-nicolas.ferre@microchip.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/sama5d2.dtsi |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm/boot/dts/sama5d2.dtsi
+++ b/arch/arm/boot/dts/sama5d2.dtsi
@@ -555,7 +555,7 @@
 						 AT91_XDMAC_DT_PER_IF(1) |
 						 AT91_XDMAC_DT_PERID(12))>;
 					dma-names = "tx", "rx";
-					atmel,fifo-size = <16>;
+					atmel,fifo-size = <32>;
 					status = "disabled";
 				};
 
@@ -625,7 +625,7 @@
 						 AT91_XDMAC_DT_PER_IF(1) |
 						 AT91_XDMAC_DT_PERID(14))>;
 					dma-names = "tx", "rx";
-					atmel,fifo-size = <16>;
+					atmel,fifo-size = <32>;
 					status = "disabled";
 				};
 
@@ -835,7 +835,7 @@
 						 AT91_XDMAC_DT_PER_IF(1) |
 						 AT91_XDMAC_DT_PERID(16))>;
 					dma-names = "tx", "rx";
-					atmel,fifo-size = <16>;
+					atmel,fifo-size = <32>;
 					status = "disabled";
 				};
 
@@ -925,7 +925,7 @@
 						 AT91_XDMAC_DT_PER_IF(1) |
 						 AT91_XDMAC_DT_PERID(18))>;
 					dma-names = "tx", "rx";
-					atmel,fifo-size = <16>;
+					atmel,fifo-size = <32>;
 					status = "disabled";
 				};
 
@@ -976,7 +976,7 @@
 						 AT91_XDMAC_DT_PER_IF(1) |
 						 AT91_XDMAC_DT_PERID(20))>;
 					dma-names = "tx", "rx";
-					atmel,fifo-size = <16>;
+					atmel,fifo-size = <32>;
 					status = "disabled";
 				};
 


