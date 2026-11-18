Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048611;
	b=T9UfeP+C4zAnrjqYlgu4YpfVIVW8E/GmJaPuiPTdH+nQYXqIzrbGTjiztALXCbEHDqev
	 X7a4NzIZrnfEP/NQALfoLzEVaCjCewzND8LsgA6O3t2PSQvNrcCJ1evjmek8CNr4tqU8m
	 LNF05ciEEZEOFw/CgZN9zdhpE94ai8PjwP3840w4mpoj62S/Q6so4b1z5GFKpsidFcUsw
	 AMmBbpVNEsKjUWyPgYOJfTI0PTxRYz31rbVIrdlij590+SZa8NvOo1wm97Kk73r9uht3b
	 ut6xqiRyQGIKocMQrV/9lEpLs5POCVRswMEERROHJksVaTZqd1ei+XGs6RVxT8i7m2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BlW7hkpnWmIwrBAE/9Ff7RrHtCPVGBopi9aC/d2rjWs=;
	b=Tr2gs3UfvvOKVvUIBnYtFqiJcEia2Qo+QRKOXZMq259zfOxvsCuW+zW/ev33ajbBYluB
	 frsjm/eRvqoSOAV99TuncfISOs9WauH3jGcUXq1j2dh7I+gOfpeQ0sZ08MnrjVg4Tn/T2
	 Yck3bPzwM0iSaUH7GBY4oB10DKmTdiMUDytWmF4sHxRC3U/L2qoSu0wNA6qZWbUxN6ABY
	 yvyDk1eHlPeWZrrhAuXXb7wrXKxFfYIrYGWTNGbixoVD/AmGMXzPtsq3H5dwRmv9yi01/
	 ztEEcNzEGClzVvzS+mrFRWdptIzunPPwMe4/OQveIAheNFpC7jnSCHAI9nScO7uBCLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0PYT4qpn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CB6606A31C;
	Thu, 19 Nov 2026 00:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0PYT4qpn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605C61F000C4;
	Thu, 19 Nov 2026 00:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048610;
	bh=BlW7hkpnWmIwrBAE/9Ff7RrHtCPVGBopi9aC/d2rjWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0PYT4qpnKicxe3TIgYYIUR8ORP85KZedcnkd8iFMMe5JbEmJyWD2lkXEkhVZxtTqm
	 s5iwLenMdgiqpuexVSJszM+h9yGP7aBREhMdX0N/wJoVUU46gdYZAR1DI/IcbFuyC/
	 sdLlpiv/if1GYS67wk6HUabCdVEaPpMeONZd/2lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Muzaffer Kadir <muzafferkadir@mainlining.org>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2056/2857] dt-bindings: vendor-prefixes: Add General Mobile
Date: Wed, 18 Nov 2026 15:51:30 +0100
Message-ID: <20261118150315.445043145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ab9238bb879f4..fbb480af8568d 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -502,6 +502,8 @@ patternProperties:
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



