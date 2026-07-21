Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454D643C079;
	Tue, 21 Jul 2026 22:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671346; cv=none; b=ImkT3sAKR+UFvD+Os0bRsMdbOFazCPTXUBkczNFv5YlOM4SVoEuNZXOdyDTjhlgQf+hMtqeYUDft112GJPNRQh2Jl/kw0YaYKuT1b4INMKiDF+Xrb1Qs6ARbb50BZ6NujRVlZRQV5+KRnqUTP8DUM/Rt72MNo9WmC/CENuG457w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671346; c=relaxed/simple;
	bh=HeWAh1CcUn+T/lkiG7nr50ak5soiI2hT6NeUP9OBPpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GScMzRL54sEgtxQM6RYPNqu0+V4E2KOizdP0AMKez/dTRcwPCbOajdzrv2ufs68js9jCFW6eXLUqBE94xNd787mKD7rNfMsqsoxDnSz8evS1Il9R4eLrTsfYiW+bHg6vf08sKwFKLEhgAO4jCytLR9PjtDvjGkk5B2clXrR06ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1QJD6ocB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QJD6ocB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96A01F00A3A;
	Tue, 21 Jul 2026 22:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671345;
	bh=JqjcZC1B+5tbH4m0lLf38ZaREPndOCrOscbrgln7vP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1QJD6ocB3+ctdSiIXjCFO86gkdCf1Xce7iqUVeG1NArJTzNm34CsZre+rKlGolAJe
	 V8uwV/tiWlxPjwEp12166tSkPkPw3l7GRkOdNChhjapcWz0PUrbfq4u6M1520Hc3cF
	 4snOiXHhodxjzGw9s2RxuFBFBhhRY6jkmmQQpEaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 210/843] dt-bindings: media: sun4i-a10-video-engine: Add interconnect properties
Date: Tue, 21 Jul 2026 17:17:25 +0200
Message-ID: <20260721152410.742629030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -58,6 +58,16 @@ properties:
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


