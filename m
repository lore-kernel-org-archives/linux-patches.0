Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031999;
	b=oXbDGrBcs8lrUQ6/q3LOyL564rqqWu6M/Z6dtlSXvSqV5FvdXaUErqk+Sos5bwu5aiBI
	 iHfVb37Nod++YA3K1FwQK5Ra79PYZ2LAKeUCLwAxNH+/YnR46TdwbeSdx67WMdAwGUbak
	 tT26TYAjtpdjYzH1C9zL1LfVjizdgS8Y2/ju8cYy0hZkfoqwLZq2efT6V+AJ7ABB8YM7B
	 IH3nKcDDl55nIFctQzi36RkY3RcRY+aHVhDhv9RbbB257gmCiU/UixrbjkW8lbz4JXjTV
	 YVuWTC/uLMvx4xxVWlQMhfq6kCUGdaCbTpubE8VbpPHwzBu0jAyRy++J8xnf/bi9z/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9zYW2nfNfS+2APoSAoVbz2qBaDKcWVdOPLpfPdyo6xw=;
	b=aRiX1f4UHZodA8tNUZVgpMkRgn13ATJNJ05nG1HflIAtqpHqgM5y0aehNtDnHwmKBaxR
	 RGIn0LkXpmDu4v+6jsaVUkhCtqpueisZU78M+HyWklLjzxtmSIcKziLlPT1smWyiZe2G5
	 HDBtyRa2vnEKXV1kz0E/5YxxC+UuAbgno1UDeZq/MnF8+6nhzogOdwQgniRZ3QJzq8Q1t
	 xJt5Rxmw7ErQQCMMah0IYPqXlj3KeyGvz+Q/r2Tgx4qjP0cfFyKdqGKKF4c7lE0+9iMBH
	 B9mJJsnZqVeFPUSmcabHj4yY8pOhMEE8xJAPWD3ptLyWPCG72R/kQSOQ/GoJdh+YeKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qDJqddhR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2598606A334;
	Wed, 18 Nov 2026 19:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qDJqddhR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E6D1F000C4;
	Wed, 18 Nov 2026 19:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031998;
	bh=9zYW2nfNfS+2APoSAoVbz2qBaDKcWVdOPLpfPdyo6xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qDJqddhRp6gH035iHGsigon4u6n9iMcfTD0tTLMjqjsRXmTgq39RFxlh8EPZm14T6
	 /5Uyw+wVRhtmvxDmnqSyufJcc6Z9jU9N6+1RysVidIWshOweZeYX/Z3Zot4CJfeBs1
	 mzFo4lUHIlJJHrqrTn5tC/Y2slBJfi7rw7ixCh1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Zhao <longzhao@ambarella.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1256/1756] dt-bindings: vendor-prefixes: add Ambarella
Date: Wed, 18 Nov 2026 15:56:23 +0100
Message-ID: <20261118150059.692791352@linuxfoundation.org>
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

From: Long Zhao <longzhao@ambarella.com>

[ Upstream commit 5ef299ffb56531b3a4f2b311000da76beed403ee ]

Document the Ambarella, Inc. vendor prefix so Ambarella DT bindings
can be applied without waiting for the SoC series.

Signed-off-by: Long Zhao <longzhao@ambarella.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20261014-cv75-prefix-v1-1-fe95ed567880@ambarella.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index fb89e413e3d24..5f577bb1b692c 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -101,6 +101,8 @@ patternProperties:
     description: Amarula Solutions
   "^amazon,.*":
     description: Amazon.com, Inc.
+  "^ambarella,.*":
+    description: Ambarella, Inc.
   "^amcc,.*":
     description: Applied Micro Circuits Corporation (APM, formally AMCC)
   "^amd,.*":
-- 
2.53.0



