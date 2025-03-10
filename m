Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA01190072;
	Mon, 10 Mar 2025 17:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628890; cv=none; b=E3LGAuyxgOVF6MP+gayaKjl5FAIqOhIKdTpdfxLTWrOeysMVMXC2JDl1WTV+CtKLly39+TNNnTnXBN4HrXV2Yoac2wMtHWRybuv7pnr5PaOpHnEf46j2z7bre5iVeyVXns2t48CyJiT+cBNB+79fjBDr/tHGlkCFGYPEfS+c7fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628890; c=relaxed/simple;
	bh=yAzGNgG7NJNTSewBizYOOYS60g3jRbnknB+6I92ZjpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSRl+GXNR+ee0hYRBkBnu+7kRrF79MRUpUP/r/It4kJX1fXJ7TxxjoYgPG0H5KGVXoaGS2RqMT/IYhDzkzwbjx9fWocJTpvdgXxGXcYznFjNT0fR6LkpPRDUUS8ftZymuLQcHg2HXHn2TDhjkyk/K1xY5KZo00VIus4nEdru/DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I27qUY8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I27qUY8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318A7C4CEE5;
	Mon, 10 Mar 2025 17:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628890;
	bh=yAzGNgG7NJNTSewBizYOOYS60g3jRbnknB+6I92ZjpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I27qUY8kuWMmE3Giyi2zIlpaUlkQWSHoetikRNSbKMUxjPKZopp5BAOD8z8ZwwmrF
	 DWMwfoC/bECN4Y6chQQW9SKFRyIX1wIp/jXuy/BJYeq7MRtpe6viin/iCk4yfQi6Dy
	 qa2Jwj6lKQOcoZ815UlQHPv3G0/og4JgVWxEaPz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/620] arm64: dts: mediatek: mt8516: reserve 192 KiB for TF-A
Date: Mon, 10 Mar 2025 17:59:10 +0100
Message-ID: <20250310170549.708601736@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Val Packett <val@packett.cool>

[ Upstream commit 2561c7d5d497b988deccc36fe5eac7fd50b937f8 ]

The Android DTB for the related MT8167 reserves 0x30000. This is likely
correct for MT8516 Android devices as well, and there's never any harm
in reserving 64KiB more.

Fixes: 5236347bde42 ("arm64: dts: mediatek: add dtsi for MT8516")
Signed-off-by: Val Packett <val@packett.cool>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241204190524.21862-5-val@packett.cool
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8516.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8516.dtsi b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
index 0b86863381cf3..5655f12723f14 100644
--- a/arch/arm64/boot/dts/mediatek/mt8516.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
@@ -144,10 +144,10 @@
 		#size-cells = <2>;
 		ranges;
 
-		/* 128 KiB reserved for ARM Trusted Firmware (BL31) */
+		/* 192 KiB reserved for ARM Trusted Firmware (BL31) */
 		bl31_secmon_reserved: secmon@43000000 {
 			no-map;
-			reg = <0 0x43000000 0 0x20000>;
+			reg = <0 0x43000000 0 0x30000>;
 		};
 	};
 
-- 
2.39.5



