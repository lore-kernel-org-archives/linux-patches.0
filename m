Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BBB15198D;
	Wed,  5 Feb 2025 14:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764134; cv=none; b=BgboUQ65kqv3TIpjDJ0MrJQiIeBDFM6+RgtgUGyxrt3pYnCnPsHuDnybWg5+1gWVItCqMuNPT3JbL4L0yYR4+ph5gsv0WSJkg0OxHJ+fNhXo4f7FeBifUVG68vLeLHH2nuTDecLFdIAqdAtvtHJFbS434J/7AS4rFy87qnb0aHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764134; c=relaxed/simple;
	bh=pyiifWzUKthvbgrTcRTOU2fhdri5+Z5I9JrJGNoUKYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nus0p5QVDzvGXl+AYAQGA/b9VhRYVrNG+gypB9pzBMs/dwlAeb2zymzTjw2owGe068grMg/z3r7nBmkF0Pq52cvJhP2taILAFDFuX8p7+4gAtr6Y+7uCqVdMpWE5/W4c89JMmgO1hgL3BpGzAv4NIYtJhUZyGby9PhdkJb/alZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ho4ITMtF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ho4ITMtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2B8C4CED1;
	Wed,  5 Feb 2025 14:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764134;
	bh=pyiifWzUKthvbgrTcRTOU2fhdri5+Z5I9JrJGNoUKYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ho4ITMtFRwOz4r1H1FdE98uhOyChFmKifagFhjV4dmjvVvUN8D2SqaKs+qYER+SpU
	 yN7oIqHMokcPpTNWn2JBdTACd/9fZE0nGoIkvzgTK+6fzNhlGBlaLvIZkdMTM1gV7M
	 ZhdkDfAnjuDXYZ070MfJnq7ht6T6CGaJda6BVvUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Conor Dooley <conor.dooley@microchip.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/590] dt-bindings: leds: class-multicolor: Fix path to color definitions
Date: Wed,  5 Feb 2025 14:37:27 +0100
Message-ID: <20250205134458.771908230@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 609bc99a4452ffbce82d10f024a85d911c42e6cd ]

The LED color definitions have always been in
include/dt-bindings/leds/common.h in upstream.

Fixes: 5c7f8ffe741daae7 ("dt: bindings: Add multicolor class dt bindings documention")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/a3c7ea92e90b77032f2e480d46418b087709286d.1731588129.git.geert+renesas@glider.be
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/leds/leds-class-multicolor.yaml         | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml b/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml
index e850a8894758d..bb40bb9e036ee 100644
--- a/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml
+++ b/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml
@@ -27,7 +27,7 @@ properties:
     description: |
       For multicolor LED support this property should be defined as either
       LED_COLOR_ID_RGB or LED_COLOR_ID_MULTI which can be found in
-      include/linux/leds/common.h.
+      include/dt-bindings/leds/common.h.
     enum: [ 8, 9 ]
 
 required:
-- 
2.39.5



