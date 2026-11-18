Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055399;
	b=YvsiJAwuo655RvEct/Qh1Pphq/ydFneuUgQMAw8FvRp+VryREaUVzB9P4zCb8dZTUCP8
	 VvYyNcbJtnAJBPz6rSejPCMMwtANYRcONgab177i73ZCpaHvxiB7llaOe/zAWRD/RNahV
	 oHmMTiWd2klvStrih75n8iQVz0bY6FtZNe3ELAQIZYav0o2GU6Bw6xy3G/y0FRBP43GXx
	 yFSTTRx2vKkleOjX/OaCuqrTzx6W9KIlJcOV4cZVk45xkQxKtWiPeNPMtmGy/ZvRpgdoW
	 ksyjVEeJMhRYHi6pm2zuRDwmulB05Uck2Nkn/klBm9dru3HBYTf1Qa8FtUlZ2A8a+eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hmUMhm4pmpRFl+lY80QT2yfwPutxtgdxamE30YNWpOc=;
	b=zoqSBdgbD2KmmuiCBO71ez0FzHUI/J14HjsfQh5JKv99ifRK5FgGcc4yhpOVajaZ5Lng
	 s00vqsUN9sNNNg8DkjRRuA6PuDAcOiHjRoqpCgydx5D7WXwg5aiUZIMfCq6t73ChxpIOW
	 ZbLc31UbxhhnHF+iJpmhzSKT3bEISwCZLxg8Al9DMPvVRQMOugDmyXW1aKgdYVdqLSF2n
	 HYKCcsnRveJRhKyFY06Qyv8k6kcDzQOxRVlRd7fg5w6/SIMb9NsQnVlI5BYMxXvaE5Wlj
	 HFGmkABZYUOan+5B2nmeoZ4dBxf0tb+o15cw+rAI9woN78lZbMN5h4qBC6WuNtdRuMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NcoCZlqp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E037E606A33E;
	Thu, 19 Nov 2026 02:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NcoCZlqp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FFE1F000C4;
	Thu, 19 Nov 2026 02:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055398;
	bh=hmUMhm4pmpRFl+lY80QT2yfwPutxtgdxamE30YNWpOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NcoCZlqptQCWgNogZvoEjY/QiI7RzGW9e7CR9+flScHW3O6vmSyRkRozQWKHTP7lR
	 cE34Oc8nr0qrsorIPQmwyc4lQ1cx8m0qV3N52oPCnXoOuE0fyxjlOL5G+wxxhCz+Ys
	 Q8OFoWCze9BR2zjHsvo3bcWmMohG0J6T5WxXN8r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1617/2214] dt-bindings: vendor-prefixes: Add Chip Wealth Technology
Date: Wed, 18 Nov 2026 15:54:53 +0100
Message-ID: <20261118150116.675494759@linuxfoundation.org>
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

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit 058ee00216a1356e710446b59a800065d2abbd80 ]

Add an entry for Chip Wealth Technology (https://www.chipwealth.com/)

Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Link: https://patch.msgid.link/20260727-ayn-qcs8550-v9-1-e3db456e10e5@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 9cb4c3b95bd1b..aa06eff78e45b 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -229,6 +229,8 @@ patternProperties:
     description: ChipOne
   "^chipspark,.*":
     description: ChipSPARK
+  "^chipwealth,.*":
+    description: Chip Wealth Technology
   "^chongzhou,.*":
     description: Shenzhen Chongzhou Electronic Technology Co., Ltd
   "^chrontel,.*":
-- 
2.53.0



