Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C3934F270;
	Tue, 16 Dec 2025 11:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885639; cv=none; b=KdWNW9sugncmnDUeksy6PKy7nuU+i5OUC3haGwOTEs/zwufCddfaSEO9kIz7KphAY668aoxFx5DvR3rJz+Hpum9BJK0+rLKY/XMQ3zu72TzTFsh4xaXMCAnB60oqYzyVM/nZHiMVdOjAEhuTXbuqe65eiMdmIfSDZZ5y1bx3w6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885639; c=relaxed/simple;
	bh=piE/9WB/VC12FvEBTb5Y7MLVkbL2nm+LKvLcdj40SNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BP/lS3dzL7QpGh6Sr3kzRwBQafQZPbdJnoZL4k6OYHLP37cabB8JNPA8rE1R6uMNvpDUd6L9krWvxTwvbFrT0OXIpPSS/EMAaEHFbIKVBEW+mjsCH4pL2/Ki5tEnZPDHHtqGT7M/HdxUf6RPEClPiZuJgTgSGHn+Ope8cKK3Gbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDrPWJ+m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDrPWJ+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC86C4CEF1;
	Tue, 16 Dec 2025 11:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885639;
	bh=piE/9WB/VC12FvEBTb5Y7MLVkbL2nm+LKvLcdj40SNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDrPWJ+m34WDGAVlEcyBrH6ZFnU3Vgfx2hNhqvZ+8KZS8hQyhm8BkJYeQsWWVARLr
	 R5uOc2Xe/bdOyARwYIuR6TQ3Qpi054SFVKxqfGTtXBcq2j/z8a8/lOSO0uS5txRO7Z
	 EcygafSXUGcuqKfadDN1D+fg79sbWhRofyMRxCbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yegor Yefremov <yegorslists@googlemail.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 172/507] ARM: dts: am335x-netcom-plus-2xx: add missing GPIO labels
Date: Tue, 16 Dec 2025 12:10:13 +0100
Message-ID: <20251216111351.749315020@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yegor Yefremov <yegorslists@googlemail.com>

[ Upstream commit d0c4b1723c419a18cb434903c7754954ecb51d35 ]

Fixes: 8e9d75fd2ec2 ("ARM: dts: am335x-netcom: add GPIO names for NetCom Plus 2-port devices")

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
Link: https://lore.kernel.org/r/20251007103851.3765678-1-yegorslists@googlemail.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/am335x-netcom-plus-2xx.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/ti/omap/am335x-netcom-plus-2xx.dts b/arch/arm/boot/dts/ti/omap/am335x-netcom-plus-2xx.dts
index f66d57bb685ee..f0519ab301416 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-netcom-plus-2xx.dts
+++ b/arch/arm/boot/dts/ti/omap/am335x-netcom-plus-2xx.dts
@@ -222,10 +222,10 @@ &gpio3 {
 		"ModeA1",
 		"ModeA2",
 		"ModeA3",
-		"NC",
-		"NC",
-		"NC",
-		"NC",
+		"ModeB0",
+		"ModeB1",
+		"ModeB2",
+		"ModeB3",
 		"NC",
 		"NC",
 		"NC",
-- 
2.51.0



