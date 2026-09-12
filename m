Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12BA36728D;
	Sat, 12 Sep 2026 09:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205852; cv=none; b=pKDFfChSyGymdSmeIYB1Tt8M33/4eunTv3fzl37nDipmEiugWdwoSJ64As+zE2rmeFCNvOBrgAdvmHGHwy4of669QIY98o/FC5BJwAicGP9HXshar0wCHiglkAEVwam9E340WeCqMY41RJLGQd/63K12Em0l4+p/nKu9883II8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205852; c=relaxed/simple;
	bh=D4oiNqohvOyppS/OqaWyq2C6pcdabDMCbfE/c8Xnks0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/uy6G4zgX5H7L3N9KnVQ7ZahxWpNAHDUg5W8IjAZByqKN/wAMmD+6GViJo1bU6VHtLSqVhEFlwuhnxY9J5iht9PWDOLqS91E+wQNmOS0Sx5XB0/PsQUr6o3QysPvk9E/4Tv2LHqKVBOlBbnWedJq6Aqi3CFWNABN4UvH2jIkqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyPKSOux; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyPKSOux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966851F000FF;
	Sat, 12 Sep 2026 09:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205850;
	bh=8ixmhCM4MxXjELN4X0RklJeoPhmmyZv/3PHnUvBxEpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yyPKSOuxooQ2+43xbiJc/dcp8xmxIm/wLlHfwTXoNJU8SH8eiND46C/dEnKAhapjR
	 D3DvtbEDjyTEZuxuuFCEhmALREZNLtJjEO1tLFA3GMm0549og9ncE9dITVaCxP4d9G
	 R8Rg/cm/VH6+E33Y5wXn1IjX9OcowUWi90cWYos8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0084/1518] media: dt-bindings: nxp,imx8-isi: Drop fsl,blk-ctrl requirement for i.MX8ULP
Date: Sat, 12 Sep 2026 08:37:33 +0200
Message-ID: <20260912065625.359893628@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Guoniu Zhou <guoniu.zhou@oss.nxp.com>

[ Upstream commit fc312f830d8df6c082bd6f7250aa5c0ff063eea4 ]

The i.MX8ULP variant does not require the fsl,blk-ctrl property. Add
fsl,imx8ulp-isi to the exception list alongside fsl,imx91-isi.

Fixes: 288517a3c6c9 ("dt-bindings: media: nxp,imx8-isi: Add i.MX8ULP ISI compatible string")
Cc: stable@vger.kernel.org
Signed-off-by: Guoniu Zhou <guoniu.zhou@oss.nxp.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20260424-csi2_imx8ulp-v12-1-da148eabc035@oss.nxp.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ added the missing fsl,blk-ctrl conditional using const instead of enum because this branch lacks i.MX91 support. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/media/nxp,imx8-isi.yaml |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/media/nxp,imx8-isi.yaml
+++ b/Documentation/devicetree/bindings/media/nxp,imx8-isi.yaml
@@ -66,7 +66,6 @@ required:
   - interrupts
   - clocks
   - clock-names
-  - fsl,blk-ctrl
   - ports
 
 allOf:
@@ -109,6 +108,16 @@ allOf:
             - port@0
             - port@1
 
+  - if:
+      properties:
+        compatible:
+          not:
+            contains:
+              const: fsl,imx8ulp-isi
+    then:
+      required:
+        - fsl,blk-ctrl
+
 additionalProperties: false
 
 examples:


