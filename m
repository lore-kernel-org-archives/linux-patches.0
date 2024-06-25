Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1702D12EBEA;
	Tue, 25 Jun 2024 09:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308695; cv=none; b=dhS3DsZbY99hltS2m20Hx8XKYY77KE4+ZK4u7TjrETYtXrgh64dYOdSnOPWbaIuK2W1GlAYpEr3l6D1ZUSW0UPxtqlO/VjclLziNRkFYWnghsqN0F5F/3y13smCW0t4OD8b58FEuai5zMmzkiGjzehaEY1hsLwWGBpmKoG2vTIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308695; c=relaxed/simple;
	bh=sHRQmKxh8wP8kAOdvpLMj1K76TCNmAntaOjxCdAbFkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sII+ZXBY46Edty+aZ94g4nyDcLQhW0kzhPoPur8gPzX+W0vdcfhCEKLtLi91MP/Dz0FXW/mzcjUpTJXRdiUvdIhCHGAdzkEZt6n2uBlGoObA8qTIRJg5TakhBPE5Kc/uuIbFexmp/P0iZozBkgYWDhPUP+E9ljYPcPfSvONNF5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COmeo7zX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COmeo7zX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893B0C32781;
	Tue, 25 Jun 2024 09:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308694;
	bh=sHRQmKxh8wP8kAOdvpLMj1K76TCNmAntaOjxCdAbFkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COmeo7zXtG7aOkD79iELbPEEaE+qLJboj0Rebe6ceD7+hlkrODWgekJXka+mYrIS9
	 CQEpWAc2naQGB2AB2xk9T7ZzPLr2bCWR43Onvd02du9YAZLBeRkdeoNx8Nwx/e9hDF
	 EEugd1XAQ4TaOlGo59NNEEj2NG88nw7qREcL9fP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Peng Fan <peng.fan@nxp.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.9 209/250] dt-bindings: dma: fsl-edma: fix dma-channels constraints
Date: Tue, 25 Jun 2024 11:32:47 +0200
Message-ID: <20240625085556.076828469@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -48,8 +48,8 @@ properties:
       - 3
 
   dma-channels:
-    minItems: 1
-    maxItems: 64
+    minimum: 1
+    maximum: 64
 
   clocks:
     minItems: 1


