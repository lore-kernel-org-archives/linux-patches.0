Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A701C68C;
	Sun,  1 Sep 2024 16:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208627; cv=none; b=lgGfS2QcyLQn9ALWblT2DjXyZIGDOf2U7CsNNI88IK0UXiO5is1PXc2pB+wlvqrC9pHLW9YPOK4DId/dZULXH79Zc8O4pg+Wh7U3+BXAJdYykKLxf57lFFVKZJI1YlVrrwUj6brsXq733t5KHuykiaH4b6L+zhcciEtx+p5pMpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208627; c=relaxed/simple;
	bh=ft8nhVgfs7QsMnLVoIwHu4vrNDqgcEw5D5aRS5E4R4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRBicViLjLj7sjiTtoso+rE4/Q70HDkSPEOsZX/9J8cCAaCEFYP5K5f+en4Z5G8kbnvoKN9BKKTpo7Z5ptjnze6fd6G/XIfA8/BJN0SWOQ/mNhM23mn/+uQcZJBZhDck0PJeFv1rNI0MLdDfNglsK2MMMrFJW17jUmY18xtISpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o69bB0am; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o69bB0am"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DFEC4CEC3;
	Sun,  1 Sep 2024 16:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208627;
	bh=ft8nhVgfs7QsMnLVoIwHu4vrNDqgcEw5D5aRS5E4R4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o69bB0amop8lSQXofPb3BlK57FrR/eu/oueCmXwWvtu/B4e1eaE7yNAfF0Wns+TYJ
	 rywbWX8mtX2TDdW9VVhF0SoG9Q84eeAeKTMHq3l7wRoisxPT+bYOjPPtfRHMc2mDv6
	 3a7xgAD///oL4G+mfvV79pSZ1opChp4tZ/4j2ACE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sicelo A. Mhlongo" <absicsz@gmail.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 141/149] ARM: dts: omap3-n900: correct the accelerometer orientation
Date: Sun,  1 Sep 2024 18:17:32 +0200
Message-ID: <20240901160822.749642864@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 07c5b963af78a..4bde3342bb959 100644
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



