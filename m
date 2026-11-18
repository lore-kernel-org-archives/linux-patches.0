Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040232;
	b=LXc1LR01ybfUL7IJ6nHTYpA1dgk3qqRsyfFaV0JsNBNRkmBs+8fgahPWiCC2OQ/ns9ol
	 F85+DWlbJQBhzO7+PNNBOK++V3uwQv1vHJc1Da+AT0Z8IWFtkVVgQ1nhMWcqg3v0oYjiq
	 kb0Oh2Wg3jVh8pc5IiHho9vI9SiJSxFI6GFFJ5a/XqgwlyiLSDwK75Ms7m92zyoAeHZWI
	 1cA2C1T8Who3eLqHjmWveAEOsuXwpU4NCl35Y2blOuNKiLui57LPU7LGLqWO8n/imd+Br
	 nUba/Th9FeX4rA4kgn+W9oSaNb+YCRRXuVcv9023E+wvExdGJPzbRUWQwH3XsOiqaSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zQg+4qEwe4PLBNzn9G8W1JOCUNTc+yw9JLcDli6cnUA=;
	b=GFaPMDBn6ZbBFv5pWuvhCwl5WzD1GpqmYW8HXGXv4PWqHroukQKvQq/MdEvV667+Zzrr
	 uq6ksjvoSH8y472B3g/mRC/lvjC51q0aH9vu0kEaLa9VMZBCZiqE8RCunkgoqQqV8XYY6
	 pEV1IhSD0aBq4K6snud6ohCdIYFhYAGZsp1ZqAnuv17Cjuwlz40Fx2YLKiwSrGFwFzbeO
	 lknfvAlQYFtdQi7KDaE666rfRsE58lZHD29tqa63bGpKH4X4KHa8NJUzPaT8razpanoB6
	 8bRTs+a1VAp0f0QubuuugyLzL3xj+7MnQ+j0BRGXWGMJ79Af5KuhahZkWcTMA2AyICw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nu3Svbp6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96735606A32A;
	Wed, 18 Nov 2026 22:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nu3Svbp6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79C01F000C4;
	Wed, 18 Nov 2026 22:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040232;
	bh=zQg+4qEwe4PLBNzn9G8W1JOCUNTc+yw9JLcDli6cnUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nu3Svbp6hUn6PHg17fX26yzhtedtXiIFjJ5GhuguX8z3/YsiVH402ChRYfj6V7Xp6
	 g0i7NHFZNaG8lGXa+TGQCmhtunyBheFWH1/KWNYyUIl3xZGtq/4gsJnz/nFVLeN531
	 8Qf8pKW1frAiHrsqEs6yDNjg0Bu6EW2fz0DSmtWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Aaron Kling <webgeek1234@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2384/3318] dt-bindings: vendor-prefixes: Add Retroid Pocket
Date: Wed, 18 Nov 2026 15:50:06 +0100
Message-ID: <20261118150433.052986184@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit ea55bba4c68a49fcb527da6c71dd48879b705fd1 ]

Add an entry for Retroid Pocket (https://www.goretroid.com/)

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Link: https://patch.msgid.link/20260829-rp-qcs8550-v3-1-198d5b2fc475@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index d7bf41c3d440c..7877494c9c4df 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1161,6 +1161,8 @@ patternProperties:
     description: Renesas Electronics Corporation
   "^rervision,.*":
     description: Shenzhen Rervision Technology Co., Ltd.
+  "^retroidpocket,.*":
+    description: Retroid Pocket
   "^retronix,.*":
     description: Retronix Technology Inc.
   "^revotics,.*":
-- 
2.53.0



