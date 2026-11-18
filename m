Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021250;
	b=hBuiH1caeC6euFQ+Th+5VJJaa5ATcOeCULetLTISptzqZpqcYMY0sMNc6CY2i6aRcZhR
	 7zYU7LFYKbnmQUhL+77FiUbjqYBZMAvxtUHIHZEcoZFZqnFSNuGdNkasUv/a0/WPu87lH
	 xmcpDVpcfukiUhyCIImX0MQFYChAyYZb0/wMYu8JhdvQ0P3YuhTB1cMtu5n/FHwR74CkI
	 dYc+zIMIftjbk/U946rui7PF/rtnrNX5+4PB0hTIGNVM5Qf8YzGFCqKttAyoqgFTy6k+p
	 VXwqoZevkWLfxQp4cd5obaLuBkZDQWO1r2wvjlfKBu+KYkFzrtoqWAaJEKOA7VwJhUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2zUYRpLCOFrtd9EtDaPJ8TTu7xSYkfPa7JOO5IyTwIQ=;
	b=Deur3zz18MGj/nAQY0rq0t6F6IiEhS6JJxqV4rmQh5vKkbhnalxQPk4pHadZklUcGZQn
	 KYCnL/3iVkI3l4ZGB81nrJjJcUnfg+uBE2o+HOHFy1rPrV5wm7qhv3PxRzJH/B2DVfb2+
	 oTmgTpBKz++Al/3b0H7PUj1eREX4+NSfsfkWEZjEocAB7DWtakJf7NCvMtWtWvrzGeF+I
	 JJ6cRdQKEz89AofzIjmECjaE1brk53NE/eAYuCLkOu5AfSTqnCtywBs/g7/vBQiCBFPy3
	 cm94JC2jvLhClBtEgqAW+iXWVUNI2s7fEQoNDP5FxtV9ZHfGhXQbycSwc3BsgPS/W2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=apC0BKeD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1CB606A337;
	Wed, 18 Nov 2026 17:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=apC0BKeD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E4B1F000C5;
	Wed, 18 Nov 2026 17:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021250;
	bh=2zUYRpLCOFrtd9EtDaPJ8TTu7xSYkfPa7JOO5IyTwIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=apC0BKeDdxIp0080aKQNuuVC4rKOSKja1MjXHi+BPzyD2N3Lq8zqkU7zbRKtUY+5Z
	 qC3i8ZEzcDyFJ3O7CElk3SKfQFkO6rIu0CxR7w4VhPHR+x+osZGL0v475cVcTJIMEU
	 sQDEm91vts9QX5Yby9bEYQ8oDt/5s/btuyPJ9wWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2241/2651] dt-bindings: clock: mediatek: Add MT8516 fallbacks
Date: Wed, 18 Nov 2026 15:58:01 +0100
Message-ID: <20261118150406.160313335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 1d48ecb48e2ab9dd2564e735a1c1b29a5eeeb599 ]

MT8516 topckgen and apmixedsys nodes use the common syscon fallback
form. Add the MT8516 compatibles to the branches that allow the
syscon fallback.

Fixes: cd9fdd06b0e8 ("dt-bindings: arm: mediatek: topckgen: Convert to DT schema")
Fixes: 16a146735df3 ("dt-bindings: arm: mediatek: apmixedsys: Convert to DT schema")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260921232807.3137010-1-robh@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/clock/mediatek,apmixedsys.yaml          | 2 +-
 Documentation/devicetree/bindings/clock/mediatek,topckgen.yaml  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/mediatek,apmixedsys.yaml b/Documentation/devicetree/bindings/clock/mediatek,apmixedsys.yaml
index 591a9e862c7d4..438723d253207 100644
--- a/Documentation/devicetree/bindings/clock/mediatek,apmixedsys.yaml
+++ b/Documentation/devicetree/bindings/clock/mediatek,apmixedsys.yaml
@@ -26,7 +26,6 @@ properties:
           - mediatek,mt7988-apmixedsys
           - mediatek,mt8135-apmixedsys
           - mediatek,mt8173-apmixedsys
-          - mediatek,mt8516-apmixedsys
       - items:
           - const: mediatek,mt7623-apmixedsys
           - const: mediatek,mt2701-apmixedsys
@@ -42,6 +41,7 @@ properties:
               - mediatek,mt7629-apmixedsys
               - mediatek,mt8167-apmixedsys
               - mediatek,mt8183-apmixedsys
+              - mediatek,mt8516-apmixedsys
           - const: syscon
 
   reg:
diff --git a/Documentation/devicetree/bindings/clock/mediatek,topckgen.yaml b/Documentation/devicetree/bindings/clock/mediatek,topckgen.yaml
index c080fb0a16181..6594d491e215b 100644
--- a/Documentation/devicetree/bindings/clock/mediatek,topckgen.yaml
+++ b/Documentation/devicetree/bindings/clock/mediatek,topckgen.yaml
@@ -23,7 +23,6 @@ properties:
           - mediatek,mt7622-topckgen
           - mediatek,mt8135-topckgen
           - mediatek,mt8173-topckgen
-          - mediatek,mt8516-topckgen
       - items:
           - const: mediatek,mt7623-topckgen
           - const: mediatek,mt2701-topckgen
@@ -43,6 +42,7 @@ properties:
               - mediatek,mt7988-topckgen
               - mediatek,mt8167-topckgen
               - mediatek,mt8183-topckgen
+              - mediatek,mt8516-topckgen
           - const: syscon
 
   reg:
-- 
2.53.0



