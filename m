Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8288D14A087;
	Tue, 25 Jun 2024 09:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309368; cv=none; b=A5RqGQ0+fPuttcroaXQk09L63pnaV/T9FUyUOR23dzFsKCanXpx6rEZn28XuRyQRo0TpjLEPmud6SnhQxuM6X2bwtL5bjtyO+xjwI7ayHhLKAgp6erhdKcSN1G+5tPVkZBe4th1UESGG+WaBes1vudyFzaIZvGeKJEZVFCzyVkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309368; c=relaxed/simple;
	bh=ZMY508F1whexEW0iFjCkjSs+IlGczEIhMf6EDp7JcBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PK1uEI90eJLXhNMdPZr1aSDitjRH+DrNp42LpNv6TnhSCm5MwSpQBKTyj0BpW1bvZD7Q8S1dCOl4z9ogF8k6OVyRmcpPPZ0MIlkUSqnpOZ+sxAeEWFseKw96yg12YqzxzruREYwpxI26BjSwxijSZdOGwg5j5aMCvAXrozrfhkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqMY0ZTw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqMY0ZTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090FDC32781;
	Tue, 25 Jun 2024 09:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309368;
	bh=ZMY508F1whexEW0iFjCkjSs+IlGczEIhMf6EDp7JcBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QqMY0ZTw05+kqcq6jBFLwf4/fxnghGUn7zVnJY4a2fMIBvOjTBtf+CRrfxJcA1x3b
	 1YhOdyGO2tj7ddMD+2ZYruBZ5l2KQR8otBpQxyNxafi1bxuQ0RIf7nWl7vLFU4cwj0
	 xw4Qr8vMfOgv3SrbpTOkgx+57tZ8VtyM4/aU1eBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Peng Fan <peng.fan@nxp.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 155/192] dt-bindings: dma: fsl-edma: fix dma-channels constraints
Date: Tue, 25 Jun 2024 11:33:47 +0200
Message-ID: <20240625085543.109401632@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 1345a13f18370ad9e5bc98995959a27f9bd71464 upstream.

dma-channels is a number, not a list.  Apply proper constraints on the
actual number.

Fixes: 6eb439dff645 ("dt-bindings: fsl-dma: fsl-edma: add edma3 compatible string")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://lore.kernel.org/r/20240521083002.23262-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/dma/fsl,edma.yaml |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/dma/fsl,edma.yaml
+++ b/Documentation/devicetree/bindings/dma/fsl,edma.yaml
@@ -47,8 +47,8 @@ properties:
       - 3
 
   dma-channels:
-    minItems: 1
-    maxItems: 64
+    minimum: 1
+    maximum: 64
 
   clocks:
     minItems: 1


