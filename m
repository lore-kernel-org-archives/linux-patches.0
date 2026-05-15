Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79D82C11DF;
	Fri, 15 May 2026 16:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862367; cv=none; b=jt5f8mlJECYNAY+EMUVoiH8u4weYOsKFwyENz4W11omQAZVMgjLSraUe/SYGIWbjSrJ77pgY6g1Wr6xRhv1PVDW0IU6WbyBgbQfRxSV1rZyCrVfi4zkXtvflHrwIz8cbbiLZjXvEswSAmsaeh7cwKEVlA4NP1Pt5WJYAF5FWl74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862367; c=relaxed/simple;
	bh=5tBijikLdMnS2ZEg5QUGrZs8Btq8hi3oGBZsaMdApM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9Z9uwxNBQRWNCaXhPgFBgSMG3vjfa6Z59qBZo8mA6cFX5oHFXODZN4GdEHLKXskL2x7Jz89S6Xf0JBary9D76bNFLsWygviE7iay+nsBb5rXpckFIAhcEUqboYe/zLR08/shMx76GdYPuYBkZqyk6Myxlw6PpKTqFxCECPtk6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVCZk4+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVCZk4+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF4AC2BCB0;
	Fri, 15 May 2026 16:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862366;
	bh=5tBijikLdMnS2ZEg5QUGrZs8Btq8hi3oGBZsaMdApM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVCZk4+iTyadwpuDgLiJgKB7h2kBLXldU4skR+wxwktLlbqVWy3mTw9PWUQwtxnBI
	 wM6JFNgaklsbORrFl8qkf3weQWCtf9tpKmC1qcpXklBODNomTw6oIacWtO5Cu6amd0
	 8EIYhebfCnMRxL488Oo/61kylfPUsJmmVvIsJ5vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor@kernel.org>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 021/201] media: dt-bindings: rockchip,vdec: Mark reg-names required for RK35{76,88}
Date: Fri, 15 May 2026 17:47:19 +0200
Message-ID: <20260515154658.992552688@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

commit a11db8d8b403eba1f82728f440727128e9997edd upstream.

The Rockchip Video Decoder driver expects reg-names to be mandatory for
RK3576 and RK3588 SoCs, however the binding does not currently require
the use of them.

As a consequence, driver would fail to probe with a hypothetical
devicetree that doesn't provide the reg-names for these SoCs, but which
is otherwise a perfectly valid DT from the binding perspective.

Update the binding and make reg-names required for the aforementioned
SoCs.  While this change introduces an ABI break, the expected impact on
potential users would be minimal, if any, since the old SoCs are
unaffected, while the video decoder support for these newer variants in
mainline driver and devicetrees hasn't been released yet.

Moreover, this is also a prerequisite for a subsequent binding update
introducing an alternative reg-names order, according to the
address-based listing in the vendor's datasheet.

Reported-by: Conor Dooley <conor@kernel.org>
Closes: https://lore.kernel.org/all/20260227-urologist-gratitude-7984733f2d41@spud/
Fixes: c6ffb7e1fb90 ("media: dt-bindings: rockchip: Document RK3588 Video Decoder bindings")
Fixes: a5c4a6526476 ("media: dt-bindings: rockchip: Add RK3576 Video Decoder bindings")
Cc: stable@vger.kernel.org
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/media/rockchip,vdec.yaml |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/devicetree/bindings/media/rockchip,vdec.yaml
+++ b/Documentation/devicetree/bindings/media/rockchip,vdec.yaml
@@ -127,6 +127,8 @@ allOf:
           minItems: 5
         reset-names:
           minItems: 5
+      required:
+        - reg-names
     else:
       properties:
         reg:


