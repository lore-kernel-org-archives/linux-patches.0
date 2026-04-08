Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C212F39C2;
	Wed,  8 Apr 2026 18:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674636; cv=none; b=PpXD+toPEvivJNKOmcKOaStm3A6SxlTkMuaCviSljgBzN/UVEl+p8pk+pZu2JVas4hdvunZyG580lFWvYCFzE0dWFJzR+mZqLqmcAk24SEywkoqsty6j95LIJ1LwMc1eKdIzME6vGQ6H9XUAMHqVrdFBOMM/sDib8Ctg2ugxdtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674636; c=relaxed/simple;
	bh=XoISXFmUisSabrRvjDyTHy0QWhkdcwKiFL5JnhZaU2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiAb3GsDSZH4vQt0pBc8/5EAyEdF5APnPNlAXIGmgPmJk1j71dOmW2OIbo5094dffUPg/l4EvL86vy9rL+TjBpIUyeu1yEz8BG94x4/Nl99ZmuNnXye6FHjcEtnQSs088w1fmMnTqMkrmIy1XzqVZ/5/2jArFttWSEivj3KqcAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBDJKy9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBDJKy9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0BAC19421;
	Wed,  8 Apr 2026 18:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674636;
	bh=XoISXFmUisSabrRvjDyTHy0QWhkdcwKiFL5JnhZaU2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBDJKy9cJp6Zon3Gv8QOB2wddktmyeBX5CrNWceaIBDFL7fPj3jNapBB+CSXn6nLx
	 I9B0hWx6kSba1M/cGv5n0MgN7zvrzjxMot9PgVollM5hKL+52Y8Fmbvjum57FJO301
	 RZaQig7pettGY10CAgW1oV+jAKIiPkUW35XM1/8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Gibbons <jamie.gibbons@microchip.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 141/311] dt-bindings: gpio: fix microchip #interrupt-cells
Date: Wed,  8 Apr 2026 20:02:21 +0200
Message-ID: <20260408175944.680401859@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 184432d24ea18..f42c54653d521 100644
--- a/Documentation/devicetree/bindings/gpio/microchip,mpfs-gpio.yaml
+++ b/Documentation/devicetree/bindings/gpio/microchip,mpfs-gpio.yaml
@@ -37,7 +37,7 @@ properties:
     const: 2
 
   "#interrupt-cells":
-    const: 1
+    const: 2
 
   ngpios:
     description:
@@ -86,7 +86,7 @@ examples:
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



