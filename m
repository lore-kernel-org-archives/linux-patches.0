Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F658369D71;
	Tue, 21 Jul 2026 17:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655500; cv=none; b=RyhI0pEbTdTYEZS1Pe62RGrUDI2ptRgmKXpY34xykFHCEWBPYdjXzqg39s08dUQ1gzc8ptv5T8UV11093UFED5+VNuPoOPzITbdMkcHXwUwrycWVbLCAXFDcvjPyA1PvaLkqGp9sOBjbetTSjPSnr1lkiaT2FGsnkoZKvs02i5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655500; c=relaxed/simple;
	bh=N/1Eu6bRLw+x9fkh4DFWGz9NbEb5k/HklhWX1JJEIug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSekxZd0DSkt4XujnHaITQlImPGQGLbP3DWDKZF9xW2svsVMghT1i1bY+Y1/QtsCPoceJMwnV4vtQxjGkQD7vL7SBrNJSv3/fwD/iR6a2r3o/bcyrBagMByTJw++IL+XsFxS9Y5/hgCsjB7ZjvXuaawWBCz6o0MJ9dn+NuEkOOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FIA7yxMF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FIA7yxMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DA11F000E9;
	Tue, 21 Jul 2026 17:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655499;
	bh=MBjgyx13qRUEqaPokgteM5TwR9c6lBGRZjAEN5lRvWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FIA7yxMFQib0OpszQS7BEMo6uaBMwYHnP5wMgdbqU+7eAtFXKWNakB/z5ET1by7iM
	 yoXfGGNim1YqWgoEHpwUqhdHCpQ4/itSnOOKDR5lvHmkuyV3pKT543unm2Atz2t+8b
	 9NmnOqVR6beGs4fWX7aZ5sf4ttTGE2L0bljlqC3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0032/1611] dt-bindings: media: sun4i-a10-video-engine: Add interconnect properties
Date: Tue, 21 Jul 2026 17:02:28 +0200
Message-ID: <20260721152515.535585101@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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


