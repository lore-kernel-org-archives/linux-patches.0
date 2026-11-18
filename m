Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016673;
	b=tr9dWVwAOQNbnTV+CTw4r65zvMRePzaA9TiZtGI5Rfn1M1GXMwQqft12jrclhFvwHyCz
	 KVkW2JU/DwbB+TUbEFU7bKTLjf4qYTI1zFH2rha3f8VipcLrRD101Zqx+m468AsvEvUNd
	 NM1H8KHt26PVGB7zE7JCbQZQE/vUqyQ4LRNLYwwtjn4hp84Ph6njI7hjhKwV3G/Ds15FQ
	 uE+IO87m5uhsvjDa2w4tGXg3RscA5rcuon4Af8jhB77+CRHIRvB8nxfFGHkFwxq9jJP3Q
	 ZQPOl9hJasWKzWznrRs2X36Sq6fuWyhC6LmJaINFoCYWkmVdUFkzSnVPuf1hr3ibCqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ihvRa6cYmnmzVBu+Ye87nTIcSNv/z1WwxwaqbbljwrE=;
	b=v6exffqFxY585j+fwrmAA0UJfhNP0Mth1z54y3FAuftQ6WPq/nvwMQLs5ZUd67M1vf+w
	 HO/QSvvUr5J0jB91CGALu7D7oT+Hi/GifcQtL8qO5Yj62borRhA2r3lTJ92CpXsKnk83z
	 2YHVNtX5OD25eV72vCQIsypYM83HbnSxedGjlHIAfnYHBkiJoF/5O2VJT/5AKLW0UWzZj
	 jdfP7oGZFBiAYBRii/aQ0tl51NRIMGabQr4R546rsIp9ZGCrg/77Gs9/gJz3SM3EbSsU0
	 W0TQDumSsw5J5sr++hdLtezVtIqn/2Z58za9fyG/4/mFb/QBc39bGXwZ9zopIE2+PyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C2g6Wora;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFFC606A31C;
	Wed, 18 Nov 2026 15:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C2g6Wora
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096481F000C5;
	Wed, 18 Nov 2026 15:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016673;
	bh=ihvRa6cYmnmzVBu+Ye87nTIcSNv/z1WwxwaqbbljwrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C2g6WoraMy/utPLXZ40yxzdykd85hstdZbqAnnb9ys8ZRiOlGwTkUFWpIPtpo/r9M
	 r+9GAyo+AI7hRKI3mvsJPeDEB6u3g3JP/jTmaNEPjcVmHO275P9TvpHHDiuMFKPsJ6
	 PmuvJc12eNL+DLNpfroxPswNRYYnHvJXhrkyilB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0613/2651] dt-bindings: vendor-prefixes: add vendor prefix for Nexperia B.V.
Date: Wed, 18 Nov 2026 15:30:53 +0100
Message-ID: <20261118150309.780988388@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 819a3e62d37a2fe73c1e7f241f2ac086042e7757 ]

Document the vendor prefix for the semiconductor company Nexperia B.V.

The company website is https://www.nexperia.com/

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260921-topic-sm8x50-nex10000ub-v2-1-eeeaf9b0c913@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index ff4a85f4cbd4e..c522112b41e77 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1194,6 +1194,8 @@ patternProperties:
     description: New Vision Display (Shenzhen) Co., Ltd.
   "^nexbox,.*":
     description: Nexbox
+  "^nexperia,.*":
+    description: Nexperia B.V.
   "^nextthing,.*":
     description: Next Thing Co.
   "^ni,.*":
-- 
2.53.0



