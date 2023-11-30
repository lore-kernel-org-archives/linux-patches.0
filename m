Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA2F524C2;
	Thu, 30 Nov 2023 16:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OkG3Hh0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC68C433C9;
	Thu, 30 Nov 2023 16:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361599;
	bh=g0rpaKQq6qnF1qxduhxZ/NDcjBVSxRW2Jd/MYss/RFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OkG3Hh0cmHAGXmjBZKatyxWoM8yT7qKo+lpuLpmLhCQrt/n+slToESqS3ki9oUR6J
	 GfaZGhJuF7mdcdwIhWO0GhEJF1SBWEQ62HRKhJi8qq4vb51fVDqN6WsJF//Kme0Smv
	 cAG5C1JKxZZQkUxtQMWLKgYYwopcSctwGk6cUcIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 078/112] dt-bindings: usb: microchip,usb5744: Add second supply
Date: Thu, 30 Nov 2023 16:22:05 +0000
Message-ID: <20231130162142.800364061@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

commit d0c930b745cafde8e7d25d0356c648bca669556a upstream.

The USB5744 has two power supplies one for 3V3 and one for 1V2. Add the
second supply to the USB5744 DT binding.

Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20231113145921.30104-2-francesco@dolcini.it
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/usb/microchip,usb5744.yaml |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/usb/microchip,usb5744.yaml
+++ b/Documentation/devicetree/bindings/usb/microchip,usb5744.yaml
@@ -36,7 +36,11 @@ properties:
 
   vdd-supply:
     description:
-      VDD power supply to the hub
+      3V3 power supply to the hub
+
+  vdd2-supply:
+    description:
+      1V2 power supply to the hub
 
   peer-hub:
     $ref: /schemas/types.yaml#/definitions/phandle
@@ -62,6 +66,7 @@ allOf:
       properties:
         reset-gpios: false
         vdd-supply: false
+        vdd2-supply: false
         peer-hub: false
         i2c-bus: false
     else:


