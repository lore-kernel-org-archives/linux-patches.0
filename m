Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2014E46A5FD;
	Tue, 21 Jul 2026 15:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648811; cv=none; b=JDZejse4nElc7Xuy1KLwHWVqmYXadeIV2O+AAUXM2hUBnzr7chcS8rU48qkb8oRRYDZUp9QgRaw+e1C3ep/V5DCvFaH0W0iqS9oQs4VCH0D9LQu/WlOoFkS0oHgPeU2eZTiPdoQbVl0MLsiVF1Qv6reBseOIs2Cgk/cq2PbXqmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648811; c=relaxed/simple;
	bh=9cWJgdxjuHFVIq9drvGa3an9Ql9WQQ9SgFOdcax9faQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5UKtByoQDLXVW6MjlEuEEOumKlpdrSZpM0yL7ri9p+Dbbkm21/sf/WcRBgwpP8rxizpWErQZ5R4ypY2lf35T2VlxeGaDkfyinXya9Gqox3Hqv2ZouVwEwFvCksqLh6Ouo+tPSJC5Z4GHdNw9Y6hZq7mZsKKLEn1A3CRobagZSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pVDE3U/K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pVDE3U/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DF61F000E9;
	Tue, 21 Jul 2026 15:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648810;
	bh=i89QdANV+6y1S8BJ1TaHkr6+Q86QFYbIf+8zkhfD4I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pVDE3U/KDXGHLjH0C9YEzVDDu8L8KX6NHGlECH/heoiKNOvq/YLEnxWGITyxlwLad
	 9ux9ml1aWXrGNuNaHqsFw8gL0xyQrSRTOJxiaK9wK8hxXTdsFR2h88H4YSiowy78as
	 R6qdmNjOcHAZdjJVciEqs07EqQ9nDmudJQr7Q9Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0340/2077] dt-bindings: vendor-prefixes: Add Verbatim Corporation
Date: Tue, 21 Jul 2026 17:00:13 +0200
Message-ID: <20260721152600.703915484@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 4b8c63c6a2811c23995c5d8cc8bb63d26caab299 ]

Verbatim Corporation has manufactured a few electronics items
over the years.

Link: https://en.wikipedia.org/wiki/Verbatim_(company)
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 11c55b5df0e4ca..ac83310259a914 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1785,6 +1785,8 @@ patternProperties:
     description: Variscite Ltd.
   "^vdl,.*":
     description: Van der Laan b.v.
+  "^verbatim,.*":
+    description: Verbatim Corporation
   "^verisilicon,.*":
     description: VeriSilicon Microelectronics (Shanghai) Co., Ltd.
   "^vertexcom,.*":
-- 
2.53.0



