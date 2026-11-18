Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030107;
	b=1X69n12hSG7zUJjzAl/woErBoktl1ec7Jx+A+9lRwcZlL69N2Xg2TTXaMjjaesjPin1B
	 QkYDBf2CSsc914d26WTyqGCwSfDEisInJfGlf3GA1shN/fbnH7s2OI7BZipUlMM1xYj78
	 7Y6SlbWBjurUfn+z4tljlJ+M/qjFdb03+/IkXzphTmhSQgFbs+rCpeFHuloMg8HWkxzQl
	 hdXauadG08ilcMjwiIAzrZsBS9gtx56dgzBdzDi+rKeleLRNTueDVjqdjZa5plz8CpBxF
	 g9aQYtBjQYvM/tY43npnw16EDdPmMnBpNqiZx3wnHHHZ0cm4TMO8KXU2o+qZNnyK2FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ucQZR9ddsyQnrP1V4D1hGhnO6cGJrDtQX2/wpQgXVjw=;
	b=P86nrQPOPW+AdjFCD5307arek0cZ7o6PVGU6KLCIkMNefTca4oRKb2hmGC29nYiO06Xi
	 rfTmSUXyFmu8I/pp+2kQV7fUl2k2dtt4iQPVg6NUhrDxW4EJdX6XpFjk/dwYywH1abdqL
	 gtwfOgtu2mOcBnAhncP5XPlXj4/ANbChAJwsvcQyj6V0H4fosdHg7pkRqB4l2ArLnT0XX
	 Z8Ga09IMj/qH9jRLIoLVyeBrmcDB9gyVquvmN7J+cG721D2gPhVgzjqDDJjh7SOfsrwXt
	 LW+dGMLQ0L49Mh+qoWRaCQMb1MQqTvN+VGCdsjxo7PCbZeRyjf9aQfyqiNn5hE7qO/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BBWwFzG5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8742A60A6F78;
	Wed, 18 Nov 2026 19:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BBWwFzG5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3161F000C6;
	Wed, 18 Nov 2026 19:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030107;
	bh=ucQZR9ddsyQnrP1V4D1hGhnO6cGJrDtQX2/wpQgXVjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BBWwFzG5yXSDSsJ3UTQJWiZwqBbNVocPDKlqC+aSJF999kCXItQinxsMPk9G8QqRH
	 w4vslNNI5M0jUILLXgOEQcafGnZ8vkYe+HO9VDoJxAIx9IeU8COa2gp8nJWQVk5J4z
	 YUfWhWGReQadrGWKFL97ZBktyLP9vdGTZ7dCINWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Muzaffer Kadir <muzafferkadir@mainlining.org>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0586/1756] dt-bindings: vendor-prefixes: Add General Mobile
Date: Wed, 18 Nov 2026 15:45:13 +0100
Message-ID: <20261118150032.348158320@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muzaffer Kadir <muzafferkadir@mainlining.org>

[ Upstream commit 7034bec693b752bcd7ebb4fa00dc3b429b4dc4f7 ]

Add vendor prefix for General Mobile.
Link: https://www.generalmobile.com

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Muzaffer Kadir <muzafferkadir@mainlining.org>
Link: https://patch.msgid.link/20260921-msm8952-initial-support-v3-6-b96fd3fe298b@mainlining.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 600b42d555eb5..442eb7e493088 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -569,6 +569,8 @@ patternProperties:
     description: Gemei Digital Technology Co., Ltd.
   "^gemtek,.*":
     description: Gemtek Technology Co., Ltd.
+  "^generalmobile,.*":
+    description: General Mobile Fzc.
   "^genesys,.*":
     description: Genesys Logic, Inc.
   "^geniatech,.*":
-- 
2.53.0



