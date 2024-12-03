Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386D21F130E;
	Tue,  3 Dec 2024 15:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238341; cv=none; b=TQ2iUC/Gs2FTcIJEoXMg4UoUFK8XQ4SR+FS0p3zI3P+4w7hHznIW46uE1zz9Xk2toqxdqnSaEj3HKicoFM7UGC8wfD+kYod7QW/LaixlxIqbPI/t9N432ClTVsxVtCuu9WdB1dFf0DUuyH7vNlsIGjJAcmNkbrPJ4GMCEOQNVvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238341; c=relaxed/simple;
	bh=A8K23B6c9A5BQhkAUoDy1ARdgTbZE8HGDSA5UK4syHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtThAzFbmDO+MV6g64d7LpvrKYI34LaHBgb15OyiCBeHx+vLbAwMUyVtPoqcLKpfPHN11Xa0BUXyMbGCWl3Bc4h1scT2k1vM7ETlE9OXHh97r3+ZrVPXuULqslHk4y5Ok8z/xrE3/BPtBtd4PyCEw7GZ+MKrcuk8h881Q73A3wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1A+FJnO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1A+FJnO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFFEC4CECF;
	Tue,  3 Dec 2024 15:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238341;
	bh=A8K23B6c9A5BQhkAUoDy1ARdgTbZE8HGDSA5UK4syHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K1A+FJnOLw1d0GzykEcB4K1JvvHZHIzNeUqdaGr5Ltpqe4+Fp7Rc468k7KfBuEe3m
	 GNbkAkDf0mPBWZNYRDMqV9MZfmfA46w+Upxh9iUDwD1ziy/cpY+u/aBdaOI7txneW3
	 pIs9uPdQBqWWrMl4BavlEfEOgDzwBFe4nwh089ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Prusov <ivprusov@salutedevices.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 246/817] dt-bindings: vendor-prefixes: Add NeoFidelity, Inc
Date: Tue,  3 Dec 2024 15:36:58 +0100
Message-ID: <20241203144005.371342776@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Prusov <ivprusov@salutedevices.com>

[ Upstream commit 5d9e6d6fc1b98c8c22d110ee931b3b233d43cd13 ]

Add vendor prefix for NeoFidelity, Inc

Signed-off-by: Igor Prusov <ivprusov@salutedevices.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20240925-ntp-amps-8918-8835-v3-1-e2459a8191a6@salutedevices.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index a70ce43b3dc03..b18f6ee6d6de4 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1009,6 +1009,8 @@ patternProperties:
     description: Shanghai Neardi Technology Co., Ltd.
   "^nec,.*":
     description: NEC LCD Technologies, Ltd.
+  "^neofidelity,.*":
+    description: Neofidelity Inc.
   "^neonode,.*":
     description: Neonode Inc.
   "^netgear,.*":
-- 
2.43.0



