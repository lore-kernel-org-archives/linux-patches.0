Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2D33F871A;
	Fri, 15 May 2026 16:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861850; cv=none; b=l5ueQTazAhFgDWN+gZA5aSe6R8VAE6VIZy5trFSIVFlrdlz8eBLmJaYwMXphO+RIME65cBatQymzmgKQgVgKZkmMOUAGI3UHPB0EhtKksITcdxrGFSoAMV8vhw5XcGFkwpSgD/mgFev9Q12i87CO9Ps1tADn6X85p3unmT8pw1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861850; c=relaxed/simple;
	bh=LeM4TIUOFDg1uqTmZgzwQAAagWl+4TBzgCzSc5UQJxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxTbSFPeKoErXds7z7iWpQnoexn1bPWR1CG11cw7yBb8ieIu3dT5kL0cfm1kn6n7dyXhjRKwOxK3gGgwrttcvtUdlxCRWhDIKpVyNWADeRkLzNgrGN+LNHM6IHYJBIX4Z9RUwGTnd44EnfDA1GiWMQb3+NAGmS+HR6casZN04d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMQw1MF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMQw1MF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F48DC2BCB0;
	Fri, 15 May 2026 16:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861850;
	bh=LeM4TIUOFDg1uqTmZgzwQAAagWl+4TBzgCzSc5UQJxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMQw1MF3JXYp2ZyuZJkPqHVgIFzJZKGZjZ1CRDiDcOwx8Xjf2bXRs2JwwXkPgcijT
	 UsKgtLwvSImExtx07VJlQlwMKcOE+bPk+UPr60A8TAa7KyL78TzOSY9tX2Gb+HWN8X
	 V/5IUZgOB5D3gyoA+Zkio+7U/6HE/AfJCKfF2GwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 013/188] media: dt-bindings: rockchip,vdec: Add alternative reg-names order for RK35{76,88}
Date: Fri, 15 May 2026 17:47:10 +0200
Message-ID: <20260515154657.595100747@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

commit 35c8178ed2bd9821a75a406d762b2f2e161f9c70 upstream.

With the introduction of the RK3588 SoC, and RK3576 afterwards, three
register blocks have been provided for the video decoder unit instead of
just one, which are further referenced in vendor's datasheet by 'link
table', 'function' and 'cache'.  The former is present at the top of the
listing, starting at video decoder unit base address.

However, while documenting RK3588, the binding broke the convention
expecting the unit address to indicate the start of the primary register
range, i.e. the 'function' block got listed before the 'link' one.

Since the binding changes have been already released and a fix would
bring up an ABI break, mark the current 'reg-names' ordering as
deprecated and introduce an alternative 'link,function,cache' listing
which follows the address-based ordering according to the TRM.

Additionally, drop the 'reg' description items as the order is not fixed
anymore, while the information they offer is not very relevant anyway.

It's worth noting there are currently no (known) users impacted by these
binding changes, since the video decoder support for the aforementioned
SoCs in mainline driver and devicetrees hasn't been released yet - it
landed in v7.0-rc1 while all DTS updates resulting from this will be
handled before v7.0 is out.

Fixes: c6ffb7e1fb90 ("media: dt-bindings: rockchip: Document RK3588 Video Decoder bindings")
Fixes: a5c4a6526476 ("media: dt-bindings: rockchip: Add RK3576 Video Decoder bindings")
Cc: stable@vger.kernel.org
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/media/rockchip,vdec.yaml |   20 +++++++------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/Documentation/devicetree/bindings/media/rockchip,vdec.yaml
+++ b/Documentation/devicetree/bindings/media/rockchip,vdec.yaml
@@ -27,16 +27,20 @@ properties:
 
   reg:
     minItems: 1
-    items:
-      - description: The function configuration registers base
-      - description: The link table configuration registers base
-      - description: The cache configuration registers base
+    maxItems: 3
 
   reg-names:
-    items:
-      - const: function
-      - const: link
-      - const: cache
+    oneOf:
+      - items:
+          - const: link
+          - const: function
+          - const: cache
+      - items:
+          - const: function
+          - const: link
+          - const: cache
+        deprecated: true
+        description: Use link,function,cache block order instead.
 
   interrupts:
     maxItems: 1


