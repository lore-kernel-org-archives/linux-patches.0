Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EEF17A2F6;
	Tue, 21 Jul 2026 19:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661503; cv=none; b=HuLjZDjz+dEzRpi6EMuuJPPpYJk7OoY+kZ2lY2Xbdf4Sp5/37HFoosudtLEiinBnoW8cSvkd78NXtD7Oga6I3ACyqqSt36egvj7O7YCkjMNZJrRylXlWdrzpsqOpaXtc5GB/TnJ1Nav99GMsWp33xTCNYPGKIDicS0q9oon4kks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661503; c=relaxed/simple;
	bh=o2NmCz0yey4vZ6ZnJ0dgYgbGmg+rvSS070DAhdxBSRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7qXAYBxFAcg8eQDZwjCxrwRA5rWx3ofp6MOC12W6Atf1NibdT40GtmYM4+dlLTr6pjwDmsrF1Tyd6LZ/J9vGjxdAFXLB2QX9PFxIBO4E97bp0LtDdXclkZQpYhZF6egDOtuBP1k5h7ZDwKXcXTfM1dqfEaFksYyXrFX27VffrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0McssOi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0McssOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B911F000E9;
	Tue, 21 Jul 2026 19:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661502;
	bh=g6HjLUG5HkwncEE2O1iZuQQhY3bVKycKBeRIUrK2vcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E0McssOiw6MkmEkU4MHRtakBGCXPrgCoar/SFR0SJK6QZrbO9wuafKX54kzJUK65w
	 EEy1z0bzp8PBmaFh2bemUofwXaGh4fB3SXzAIfw5kajSQWoYw84+Nq9zxIjJLbgQUo
	 aqfTgyW/HpSLJaQlh76KM7JxccMqjF1oHlVK7VME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0047/1276] dt-bindings: media: sun4i-a10-video-engine: Add interconnect properties
Date: Tue, 21 Jul 2026 17:08:10 +0200
Message-ID: <20260721152447.139140919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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


