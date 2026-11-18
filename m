Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048414;
	b=qyxKSVZswyC/bJTMC04/IEAmuT2lQFgXFEKRt4V2CLxVxJGwNUxx2fWpMNuj5ss63Ik0
	 Kfb7D/V3daTTp6vrtIZPqbRPRAdlVXfNgrnvTWeDyd+n/bsOsfj7ScuCQPvD+w7hakQly
	 J55SfrJ7aO7yGzy4S6reXU9Lq74OcmS+UyAZ9klhBITv1DUJMUdTBRWxsYY9e78wZS4ck
	 eYkMEFndR4zcgLM+IVr1bsb2yVcLBouhUCbeQxhRCAh2G9b+3QtYWxZpFvIAXFlq6T1Uk
	 CdQYU2C9g6SLyfj9A3QFsqIfd793iGDkDjgg2UNJsx1ZdXlwcHGIecimM8C/V7TXMTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b//cvBMvLPuhRMDA/B8hjtyKjZp6q1dwQrcd6imZJXU=;
	b=nTXQEyArjK3hndeYGKz7HtkxWuh9cGHj28F3IlWZGoW5z1dE8y9b2VjjzMPctQ6YPv0h
	 6VTUzgBK1hR7jPBWTvAJ4xcdAaRwgS1NNWQXIcW9SwVvsXEEdz0aTMB3CgCuPABBLwj8R
	 J6IafKcjbvTV3BzkcGQQDmyWudOZl/ACpNfDVWR1kcN4rOBshbNKfX/ihIKQTxBkpXlXD
	 cmvPAbRkZeH4VgDNjo+zyG4Ej6mzpz0/jFWoTdxUhw0rKnJgkgwlUSNTYcz4dD8o0Q/5b
	 2CvTVw5YVhpsN66FhyiEzFaG92NUKUQlGXyItnNp1tz4oCQL5NKdSZI+DLxXVGazosg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xQt3MSGt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B9F606A325;
	Thu, 19 Nov 2026 00:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xQt3MSGt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2606E1F000C4;
	Thu, 19 Nov 2026 00:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048414;
	bh=b//cvBMvLPuhRMDA/B8hjtyKjZp6q1dwQrcd6imZJXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xQt3MSGtR2HSR37WLcQWOIqzR0Kral2QzJIJLQx7aZfkoTMf3/SIXu1SB+vpLg/kJ
	 yX0saw2gLbl7+hXSH1hdK1b6yO1pWMHjAFGS3Hy01xFx5yuUYOv0qudNtmLH+r+/K4
	 gHmRCnBGqTtiiMl1kkGSqp2RTvh1eCvN4jusN42Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1984/2857] dt-bindings: vendor-prefixes: add vendor prefix for Nexperia B.V.
Date: Wed, 18 Nov 2026 15:50:18 +0100
Message-ID: <20261118150312.816136579@linuxfoundation.org>
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
index fdcfda32bc923..655d56b06efd0 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -891,6 +891,8 @@ patternProperties:
     description: Guangdong Neweast Optoelectronics CO., LTD
   "^nexbox,.*":
     description: Nexbox
+  "^nexperia,.*":
+    description: Nexperia B.V.
   "^nextthing,.*":
     description: Next Thing Co.
   "^newhaven,.*":
-- 
2.53.0



