Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3AF181B88;
	Sun,  1 Sep 2024 16:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208141; cv=none; b=rux8V4kDKGZjjIG06l6ecY1Kv39JgW4JciNyGsvvSueCZVs9gmXtn9NcwyvuKL3LGyLXA0K3TrW954Xy7Iu+fywQD6q3rG8r3vdZsIovvkcibu4G1YXeeKwSeW39HeXinIZ8kHONb3+d6nGn99qOOFIRHOy73BwMjgoGTkoZgbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208141; c=relaxed/simple;
	bh=/nSElZU80cYsyk0yjk5tdM2N1BQyZBnkEyVBphCnIzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0u0Rehz50oYmRURsOwNIzMl7pMHwElMudg+nOFgGBoXYM96CSBoy1WB+Z2HAMqWFsfZgDVCHNFMnmccm9MHFea9KScgSSstDa3tnn2jOJ6Q5Hak517010wIiM3HeL+SEZy9lsWho1660ydK4AUb4kAnYwmga8qyJ5j+He2ZDWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPF2hYKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPF2hYKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40462C4CEC3;
	Sun,  1 Sep 2024 16:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208140;
	bh=/nSElZU80cYsyk0yjk5tdM2N1BQyZBnkEyVBphCnIzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPF2hYKNZAucZSzjbhsQ1P5GUUob+KOJo0Op/eriRAth1K3QEIt+kUif7cZG3MGTA
	 h6JirXzPih46PNgmFOJ7QX5IRT+j4EP+ie7/9LH5xQvx0EBCon7PZn8dheGNHJaib4
	 e4yiH1YglEHFM0HO1G9ALSnObcNN8qx833kS/J1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sicelo A. Mhlongo" <absicsz@gmail.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 85/93] ARM: dts: omap3-n900: correct the accelerometer orientation
Date: Sun,  1 Sep 2024 18:17:12 +0200
Message-ID: <20240901160810.934428644@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Sicelo A. Mhlongo <absicsz@gmail.com>

[ Upstream commit 5062d9c0cbbc202e495e9b20f147f64ef5cc2897 ]

Negate the values reported for the accelerometer z-axis in order to
match Documentation/devicetree/bindings/iio/mount-matrix.txt.

Fixes: 14a213dcb004 ("ARM: dts: n900: use iio driver for accelerometer")

Signed-off-by: Sicelo A. Mhlongo <absicsz@gmail.com>
Reviewed-By: Andreas Kemnade <andreas@kemnade.info>
Link: https://lore.kernel.org/r/20240722113137.3240847-1-absicsz@gmail.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/omap3-n900.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ti/omap/omap3-n900.dts b/arch/arm/boot/dts/ti/omap/omap3-n900.dts
index d334853412517..036e472b77beb 100644
--- a/arch/arm/boot/dts/ti/omap/omap3-n900.dts
+++ b/arch/arm/boot/dts/ti/omap/omap3-n900.dts
@@ -781,7 +781,7 @@
 
 		mount-matrix =	 "-1",  "0",  "0",
 				  "0",  "1",  "0",
-				  "0",  "0",  "1";
+				  "0",  "0",  "-1";
 	};
 
 	cam1: camera@3e {
-- 
2.43.0



