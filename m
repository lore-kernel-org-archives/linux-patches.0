Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024506;
	b=ypGT4efl2Het0PfthmNfCdvChk6fqsLOy6roExp1MbCqKEKlDmF9FQfYg3Q9AALFn2PM
	 AksvaQHC0GfP1vmofv/pDrK8+fKKvHoFvhIuqLTYtNb0TgdYZzgmTlDEKw3V2IXxOC2td
	 zbeMh9TdBQOzeC360LiQ2lFX/O2u7Fg82uX0Oxj1wrh5mmO/mmm1E7tRVmJJ23SK9jJ1B
	 hKL+XlsL4cVzb/Fr4zuWkN9U+h53D4H9n+TVxg72w+HZLPHs6YnFaFXI6KDN+gwR19euP
	 MPH0jkAgliC/7NeCwW7rwo4cfUxKHhhnky8T/PcnyS/X9dHzOs9b1QGhVlSDVThvq2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nHeFbNZKByooKWtHp7nSXDbye8QE6m0QD7tQ2Srae4g=;
	b=ch5//+YEn29MwwXOS1Nt4OKhusx/awZfDxMTZLVRDKb76I/fetoly4yWrdN8mz0UW5wx
	 wLyz6RtFTDhcu2lLBifCTEhXOvOHL1pkelJ8i7O3UYA/mDzFVneZ0/z8tEy+aB7C3/15+
	 m0K1SIF2eTnUk+FBxCD1l2L7IsW38XSCJRURIJmBJtqlTAh2LHsVivR6KDT5o0VqtloLd
	 +kM1s5UnrVwjE7AMF3TnwLt3Nv0/e5dVprQwFPpHvF2Orhvyg/jFdPJuVR59V1Al0g4DN
	 R+R/a5yGS4nlp+0UPHUZQNHartj6/SW8N9QHASSqBp1k7HADGUBXbLRmAjIAGbOivsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YfLTnKFw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16496606A330;
	Wed, 18 Nov 2026 17:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YfLTnKFw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238E51F000CA;
	Wed, 18 Nov 2026 17:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024505;
	bh=nHeFbNZKByooKWtHp7nSXDbye8QE6m0QD7tQ2Srae4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YfLTnKFwgcODMmSNL8UP7wu/+lW2u7OIgYzLV3Hk4+CZl+MiaUCzcdHWFVBSXgMGt
	 7iWbkPj33iXgZXv0IjRJYM8sf1RNhbB2lUma7GYdJ8MPi3xb7XUubO8/69hMjzusQM
	 FEhiHvM9/C3lIbDpCiB19nIMxlPZk6lh0U2Ye37o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0750/2151] dt-bindings: vendor-prefixes: Add Chip Wealth Technology
Date: Wed, 18 Nov 2026 15:41:25 +0100
Message-ID: <20261118150149.351429406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8bc95dd4b2592..5e80440a22395 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -305,6 +305,8 @@ patternProperties:
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



