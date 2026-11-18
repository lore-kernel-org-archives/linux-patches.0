Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055318;
	b=VRYHv0RH6RlWTjlynurNDVjDUiPfGW2DuXI2L8VmNLE1S/VF92ADPWCermfh6K638y88
	 Osj8o6hhTwQJhD7AwijSAmV51VbHSSa6V9yPsaH6uSfBEEJXbnQZU0Uz52A9iPD9vdscK
	 j9XSfg4w1heY7x8JiSl/QODFlidUtIo6z7bGcs+rY53jICPMYvxkc37wNUaGvf8YMKGVm
	 Ki/a5ebS9k9SxvdWJcls91bN11/pMvT2yR2ZqcncHATg3yzHGDcJ1jJQAvBGwCp/rrfFV
	 LbHh5mqZGJRy2p0hzJKnqWKd7XG2+oQnAzwnXpfb/uqergT6lOUt75b2oGGekqfvfvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x6TIq8XPteTD+oh972Hn8CRkpXHQl5h1JqDwgyvQ0Bk=;
	b=VVF/8u6UTOLTFi5TNIhP1ykXhpk1QGRVcnLmt5f3uZaST8UQNBF2fHJ2vrqYY+Xrymop
	 /uLktwplCZP+Yjbns/RCnouOQmpGPdsPvJizA8Kp+1bQz0fZpbZOl6rzu4M5BO0SbAmkX
	 EvC+al9IHMVJF0tcuqyP4r9duHbZPJpAzplumuXJYi8REwEiG/wYLJJKTFuDW7Y2pzPVQ
	 SNXmdNHpP6AyxHlJxD/9mQ5wL7v3ip8BlUWYQvuLNsz7ik2WrmRF/wb4h3SrUTkc/tCd0
	 yo5+8I001FJtCcsnSOcjUc0VTYYpD+D7+ASjNJF1+aCxRm7MTP8jfvZUdj6WC24XPEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qJhEh/Pj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAE5606A332;
	Thu, 19 Nov 2026 02:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qJhEh/Pj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD381F000C4;
	Thu, 19 Nov 2026 02:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055318;
	bh=x6TIq8XPteTD+oh972Hn8CRkpXHQl5h1JqDwgyvQ0Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJhEh/Pj47v6cmxRv/VJIqaixr+SCU/BWS2Q7mfJRsn2rJaQiSa/x+zuvpqSLH69S
	 1psPO8lstvsgjIUD9MGPMEVHREGuikwwr9NhPASt4fgqZPepDXdDEbWclVjRwVVKy/
	 i2YWosRDbke760TqY4GMcdVZ6v4AyWmNB5mBg2k4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin, Meng-Bo" <linmengbo0689@protonmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1587/2214] dt-bindings: vendor-prefixes: Add GPLUS
Date: Wed, 18 Nov 2026 15:54:23 +0100
Message-ID: <20261118150115.481438992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin, Meng-Bo <linmengbo0689@protonmail.com>

[ Upstream commit d7a2d86837b9de8d378f040cfc9184905d82bd78 ]

Add vendor prefix for GPLUS.
https://www.gplus.com.tw

Signed-off-by: Lin, Meng-Bo <linmengbo0689@protonmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230107133145.139731-1-linmengbo0689@protonmail.com
Stable-dep-of: aa906abf611c ("dt-bindings: vendor-prefixes: add Free Mobile")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index f32408840be63..7dc90c24d5261 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -463,6 +463,8 @@ patternProperties:
     description: Shenzhen Huiding Technology Co., Ltd.
   "^google,.*":
     description: Google, Inc.
+  "^gplus,.*":
+    description: GPLUS
   "^grinn,.*":
     description: Grinn
   "^grmn,.*":
-- 
2.53.0



