Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65ECB67E;
	Wed,  8 Apr 2026 18:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672195; cv=none; b=UUW513zCCTRw75zx42LnHLN7StNSG/dlrYzjpVyz3Lf70iB8V1N+THAXF2SfKB5zgONLUCQWzp9jP63B1UDq3gT8epJAoQVf0AiHO1EnRfY0Oa2aFrpo7ABLo72xBqWR2i03QrBGxLVLX8uUVPelJfKnCsX//gCEQl5EWbUkR7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672195; c=relaxed/simple;
	bh=cwctjBHK6+vrXV9koSqNkn/ugV4O8of1iUhAUCd0lMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vo9bvmJ6Rwmn3Ratqwm0lvx1Vg6YzDDmXWU553RO35osKbtUoi8Mrn0nYo7TImSv3VGH1F6EgfW8pIqoRg7Ir/S4U8cL5Cp4x02LSqVcgQuFAC0KbZIKmTxyM43FpCS/UpkmZAak4h4XOMovaW15/SOqj3J0X7iCf8nQlOvrrSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJPyQKjU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJPyQKjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558A1C19421;
	Wed,  8 Apr 2026 18:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672195;
	bh=cwctjBHK6+vrXV9koSqNkn/ugV4O8of1iUhAUCd0lMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJPyQKjUqWzVnnyxE2kuZwtXYyqgRPumvLyuaaquqoBf/9v1lfXQ7Vd4g3VN7Obxf
	 Sp0ipFdCKLpfXXcbkMa5Kay6QQlBQiQ/ylGFHw9Niaoo4AVB+YEL5QUYs1bxmcXZhD
	 IEkBUDVCAj5sLEcGkzJIHKn5xDav0dNY/GA+piOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Gibbons <jamie.gibbons@microchip.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 194/312] dt-bindings: gpio: fix microchip #interrupt-cells
Date: Wed,  8 Apr 2026 20:01:51 +0200
Message-ID: <20260408175941.003593052@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d481e78958a74..2c7355e9547a1 100644
--- a/Documentation/devicetree/bindings/gpio/microchip,mpfs-gpio.yaml
+++ b/Documentation/devicetree/bindings/gpio/microchip,mpfs-gpio.yaml
@@ -33,7 +33,7 @@ properties:
     const: 2
 
   "#interrupt-cells":
-    const: 1
+    const: 2
 
   ngpios:
     description:
@@ -84,7 +84,7 @@ examples:
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



