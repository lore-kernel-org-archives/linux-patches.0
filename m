Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB233D6CAE;
	Wed,  8 Apr 2026 18:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673905; cv=none; b=gD65qMQwJOoX9MDBUTMKMd3yXms34GbXFZV4p+i1GhbmYUVrYak6mpeasw33kLHn+YAWiW1HtiAn/k3swqcCOfm+vjIscq2RxT/aHbqVuejiJVEHLDapC4LjsUjNupOd1IX2kZlw8CQpwUmK3K2yju880RQa6A7sJHC5OGWUvIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673905; c=relaxed/simple;
	bh=6Iq3LuEYpJBBypHhyUKFgIbMsjGN8VM91zGCABA6Ij0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyAL9xnhurH8rP1b8AdRKogJy5gzvFbmVC867mR2GdYXZg9JmfKCSAHWyPRTvHZhAdtmNjWGzXy7a4PS0u/SSFIJmJFID1UCXpRiLkZeVYlk89E7uFcTO4RFL5n+xO7slXYW8R8LWa7oYEs799XrS7EXloOn/mQ8LhEmNy1QFwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3TuRPTJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3TuRPTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FB7C2BCB0;
	Wed,  8 Apr 2026 18:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673905;
	bh=6Iq3LuEYpJBBypHhyUKFgIbMsjGN8VM91zGCABA6Ij0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3TuRPTJukKmZv7H+/AaOr+kHfQ781PBIBN9bzMUqFFuRTvPG/fTMLkiolWMvag6K
	 7FAIb1pdKLy7sjb75bb8Ljc3PjCNfCUiX7fycDK71HyXFdHFTIcSPBHQJCfMmkBlN8
	 XK1NL6+8mHRY3OXaQEa1pbh4G+4jzlgBZXiiaZ6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Gibbons <jamie.gibbons@microchip.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/242] dt-bindings: gpio: fix microchip #interrupt-cells
Date: Wed,  8 Apr 2026 20:02:27 +0200
Message-ID: <20260408175931.089413997@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Jamie Gibbons <jamie.gibbons@microchip.com>

[ Upstream commit 6b5ef8c88854b343b733b574ea8754c9dab61f41 ]

The GPIO controller on PolarFire SoC supports more than one type of
interrupt and needs two interrupt cells.

Fixes: 735806d8a68e9 ("dt-bindings: gpio: add bindings for microchip mpfs gpio")
Signed-off-by: Jamie Gibbons <jamie.gibbons@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20260326-wise-gumdrop-49217723a72a@spud
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/gpio/microchip,mpfs-gpio.yaml         | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/microchip,mpfs-gpio.yaml b/Documentation/devicetree/bindings/gpio/microchip,mpfs-gpio.yaml
index d78da7dd2a566..dafd80bdd23aa 100644
--- a/Documentation/devicetree/bindings/gpio/microchip,mpfs-gpio.yaml
+++ b/Documentation/devicetree/bindings/gpio/microchip,mpfs-gpio.yaml
@@ -34,7 +34,7 @@ properties:
     const: 2
 
   "#interrupt-cells":
-    const: 1
+    const: 2
 
   ngpios:
     description:
@@ -83,7 +83,7 @@ examples:
         gpio-controller;
         #gpio-cells = <2>;
         interrupt-controller;
-        #interrupt-cells = <1>;
+        #interrupt-cells = <2>;
         interrupts = <53>, <53>, <53>, <53>,
                      <53>, <53>, <53>, <53>,
                      <53>, <53>, <53>, <53>,
-- 
2.53.0



