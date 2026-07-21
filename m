Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EDC472541;
	Tue, 21 Jul 2026 20:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665558; cv=none; b=ZW4NMLw4VIVYBa6f+mPzv2gNSOlcV5EI/nF2lTaks+/5hte2Gg8G6C3kxmdOMJrQkeFV80hCk4WjVxGLe2JqfZK4pPdkcRp4Sq66VbYnr2/cSPzxlat/Wk0xlxBxsPG5fSrPWU8e7V0Gwb3pnDorGgEfH2SfiVayDIXMqPXf1zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665558; c=relaxed/simple;
	bh=0dRF653iD8wTcrZ7ZnYeqwtQH1tYVghKpZEIfVmmvMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3dDmRIOvoGCTgul5FZBCwYyiIOd5QPKBo1CbneV/JUkKmZWzOgVnRO2auDSa0hv/7WhIz/KwrktJoj3EQJEpD7AbXCazeeETlAh5DOSnnlQP7mvDlYAxKW0bP1LGJ4hAMjTjAZnnDt9jU7rys0L/OFelKFZQGpkf7nf5m44FQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykDph/dE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykDph/dE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B739D1F000E9;
	Tue, 21 Jul 2026 20:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665557;
	bh=mcha2dnIn/W9Htt4gQa1XDMTuH0dHjikM0Gs7zkz8IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ykDph/dEdeKG7huV0O6jzYi/XIGmpjcyTr6r4Atsxpol9SftgpJ2tjyCyn9UB8rO4
	 mswIT/1skgwrexODruA/ZmnYHrv90WXJ3jIOEZthogv5xzgs6PhHuqzNvKCcazGqOI
	 Xll2B+qat2z1N7BdN/93cwET8KBA7KXSGTpwAzRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0348/1266] dt-bindings: media: sun4i-a10-video-engine: Add interconnect properties
Date: Tue, 21 Jul 2026 17:13:05 +0200
Message-ID: <20260721152449.619554216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@kernel.org>

commit 018f2dc3a42098d3b04edd1480adc51d268adb14 upstream.

The Allwinner video engine sits behind the MBUS that is represented as
an interconnect.

Make sure that the interconnect properties are valid in the binding.

Fixes: d41662e52a03 ("media: dt-bindings: media: allwinner,sun4i-a10-video-engine: Add R40 compatible")
Cc: stable@vger.kernel.org
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/media/allwinner,sun4i-a10-video-engine.yaml |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-video-engine.yaml
+++ b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-video-engine.yaml
@@ -63,6 +63,16 @@ properties:
       CMA pool to use for buffers allocation instead of the default
       CMA pool.
 
+  # FIXME: This should be made required eventually once every SoC will
+  # have the MBUS declared.
+  interconnects:
+    maxItems: 1
+
+  # FIXME: This should be made required eventually once every SoC will
+  # have the MBUS declared.
+  interconnect-names:
+    const: dma-mem
+
 required:
   - compatible
   - reg


