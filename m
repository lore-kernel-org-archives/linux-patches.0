Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201CE46A5FF;
	Tue, 21 Jul 2026 15:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647951; cv=none; b=eFBfQue/qekucK3jAx6H/11gbXcGYZFhas41mpT0IBtR4g8MpQDAdZKHEb5QVdwRLrj16y84WkmJW58IEBOx7JDDTn/QvziHBFNkya3iRnANV7mvD6rZD+QRV18t+Mj6X6hAVe2u9QfsAZ+YQDMAq3V5nYhriZW1IcAtOW/MuXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647951; c=relaxed/simple;
	bh=Oal8KVkjBlHO4N2+IWWB+HP/q+4Ppq84dbq2PLFdVdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MD5wXIQylN+4/vv7NbrgSSgDkol5vV/yT5WWwDu+n/I71SV+2P61HgLYrU27XHEFuDURrmqK3+5p6ElIrHvyqLNPqxFZdKnj5ILMk3t00rdgCc0RJNkTOGawiQAeewD8qXlIK21wbo5gLrjzXMjhYbCsNRqnX+7yLiXvu5zYkDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FjD7gq3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FjD7gq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D061F000E9;
	Tue, 21 Jul 2026 15:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647950;
	bh=/uj03Ff5M3xqtQm3JtJ0eAqAAH/BLDUPtNzqsofQi2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1FjD7gq3/0JdNzA/BMZZa2eTiWtgdadEmNh2zCoLja4Y1YD2B/tSJC6+7gGVObyh8
	 qtV1NNMAgWo/dPrxiIv7Ulc0k+bmc0GicAvdWRSQMYBUenzd5AfFH6uLCva5X7/lxI
	 sb3ErK7FmifXl038kYOpQH2pLVLxw/lpGAnOpZA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 0016/2077] dt-bindings: media: sun4i-a10-video-engine: Add interconnect properties
Date: Tue, 21 Jul 2026 16:54:49 +0200
Message-ID: <20260721152553.050518784@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


