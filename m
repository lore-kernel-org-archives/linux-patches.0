Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0339D1519AA;
	Wed,  5 Feb 2025 14:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764707; cv=none; b=JyZAno+Qt4Tq2JElW0mPg4yvJBuyIamr16NSK0sD1xN1Xsw0J+v1mERVVq1S/2wxrFMSWerTlq3Zd+zyJSenH9h44r57cp23fgjZ+EBAg9L4t1KUDxYY8/exNVLODQkffbEOSwRuXMWx8QeofsSg4chMF7ZPyYx3x9k6qxida/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764707; c=relaxed/simple;
	bh=jVoVCl4AkUw/GyiBDgge9ezURkDIFxj4QdjVnwFzR3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uW2wqam9rKVJFK8Xl8k0s6M/Nxy4EyIsardOxXuakag0QMCljPVDWDFH8+xmSHlYpZep1k9qW8oT9KNy5EHQPzCjNSZSoeSTfcGtt0nkuH3gvyaPLd/zyHniVhbN9cqwAHPKFWaETEQHmpIgcIWJlzX+OPkAkFXYagQg3QVEkpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZnvks8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZnvks8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6200DC4CED1;
	Wed,  5 Feb 2025 14:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764706;
	bh=jVoVCl4AkUw/GyiBDgge9ezURkDIFxj4QdjVnwFzR3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZnvks8pBSTACbjOrbZDwmmd9Bbxtl06nyZ46qh47r41WgVX6nSQ6ODnXJ0Xh2JNp
	 drmglqtAogpq0LXyfxZEXtDSypmjYcqgIhuQetB5OTzrCsViUMEeFdPc7X0hZjEQQX
	 8Ga41H09B54zi3iqABFGxqgI56k8SHmOIyj78tk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Conor Dooley <conor.dooley@microchip.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 103/623] dt-bindings: leds: class-multicolor: Fix path to color definitions
Date: Wed,  5 Feb 2025 14:37:25 +0100
Message-ID: <20250205134500.157257250@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



