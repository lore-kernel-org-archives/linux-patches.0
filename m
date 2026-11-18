Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060899;
	b=QyGHhTMQW7zO3TW8OHGAxuCSSbUIF+/QALzUZ7ohZUUlLw3wpIMv5jjoC93uZu/ZGmiT
	 XK0gRPvU5uzLXbEQSQlyrIbasvcvSxByeTwXSZEmc0Ohdts0bfe8wmprCw1Nln2vo/niA
	 CZtQqhatNvc5a4prLHACwt1Oj6lPI6uQ8juNs9IY8zhkmzYqL5RbFEkol+JM+zaM5nBGl
	 FyaNbifrWPuwslJ6Eh85JIpIqxQPV6T3KdDbdes1YjAFs/wmy2hNPuLzJ/iupupUQKc+e
	 LoN2H1hwUOcbw7YwWVU6GtggeoJGLEQFQHJmJe8jcXAArg0KtmrBUVc2EmSk0tAvmVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g+rE890GKJGvTjbfD3IXvvh299VyMzCv3omksXDsBO8=;
	b=e30SzjlDTb7NKEJxoK+WvngH+sOlyLtylrsjymM33baZ3oglj8U3NCwoMXqWWFOfpBX5
	 O730c7gy8QsUKUXhLrqEtECa0HBpmHfukXYpZvnNuN9GIY7I6x4WADv+UBuRIEfibg7qh
	 L+pgf9r7tsiF6cfVfLoou8dl1O4V3lkAMJVg99NP+947HEaHcopTEi9BGraUOBf5TzwMD
	 3M6NNNiLOQScREpGPbl5zn+A6LVS39MJIYfeOEfOJ25VGGdZ/u/WSEAUkrt7wT6u+ILkF
	 ino/rm3uKCEEF9/kfN7ftUxQ+9GALV9qzidqmm86dUdCbYHyW2khZiHqD0Hz2obkddA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hy1rX6+c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12F4606A325;
	Thu, 19 Nov 2026 04:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hy1rX6+c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD471F000C4;
	Thu, 19 Nov 2026 04:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060899;
	bh=g+rE890GKJGvTjbfD3IXvvh299VyMzCv3omksXDsBO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hy1rX6+cWb8pJfA9Hnj25hLr8CY4AEJYmFyhcXsVlSWnmB7Odo8+JKuHE1z4mZTHX
	 c6BhApyJa3Xv8Jdp8tKEM/RLdq8I328GAA4GTDBVfvVDY/28Nr355spb6NA846pLi2
	 vkV5EXA0fGaE/FCHHmYm3Wr8V1A00zmjYw73BNyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1363/1848] dt-bindings: vendor-prefixes: Add Chip Wealth Technology
Date: Wed, 18 Nov 2026 15:56:41 +0100
Message-ID: <20261118150016.645657007@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8dbd288fdd659..762398cf70290 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -211,6 +211,8 @@ patternProperties:
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



