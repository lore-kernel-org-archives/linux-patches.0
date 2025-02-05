Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809C71509BD;
	Wed,  5 Feb 2025 14:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764110; cv=none; b=KVAF6dAU63zK9fHEppRK0pQisy/3wj8EoSc5vXJPN1aQy+By3g8PV/NHrFJSRHPC6rzyzz8ehK2uC7yNHjEjPYZsfSFHahlDmF6qSc0knXH646QFB0XLqLkCpmLyKS0/C2hpGFXrTJNFnyoSP7/wB9GYdauTLuSVV39GfUxO45c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764110; c=relaxed/simple;
	bh=0eAfk+Pq1/5224mTksGgvqWiNkd7n9Jk1wXamabtg60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnsXaFnMT6ytg4yfoD64JInwK3Xr56gQulFbuNXEMcOxFt8o4OGDOIjMjW8m4X9RYVE4FyOM7vY3cKcqujN0QffuftwQYdbz+I4if5D1xmR/OrHktf8QTfWRY3A4WRXFALfCGlmTszJltAqJQZX36+nGxqp/NvUjlpjcdHJGCR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkCBOCZ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkCBOCZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D86C4CED1;
	Wed,  5 Feb 2025 14:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764110;
	bh=0eAfk+Pq1/5224mTksGgvqWiNkd7n9Jk1wXamabtg60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkCBOCZ1FbrWLibtlixt5cFnIku6zw0jeXNhipRYH/k7ecSUtcBw0s5pQI8fyS6Bn
	 2ZEUU21xRGlmDt8eqPkoqVDKj9xub0tSE1NJfOepGmE55AucOtX+UNMmAViVP+6r/e
	 fp9H8HjxlI5o8JC2Criq+AGh4bTDAKnwfY7x/24U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/590] dt-bindings: mmc: controller: clarify the address-cells description
Date: Wed,  5 Feb 2025 14:37:25 +0100
Message-ID: <20250205134458.695077336@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit b2b8e93ec00b8110cb37cbde5400d5abfdaed6a7 ]

The term "slot ID" has nothing to do with the SDIO function number
which is specified in the reg property of the subnodes, rephrase
the description to be more accurate.

Fixes: f9b7989859dd ("dt-bindings: mmc: Add YAML schemas for the generic MMC options")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Message-ID: <20241128-topic-amlogic-arm32-upstream-bindings-fixes-convert-meson-mx-sdio-v4-1-11d9f9200a59@linaro.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/mmc/mmc-controller.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mmc/mmc-controller.yaml b/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
index 58ae298cd2fcf..23884b8184a9d 100644
--- a/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
+++ b/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
@@ -25,7 +25,7 @@ properties:
   "#address-cells":
     const: 1
     description: |
-      The cell is the slot ID if a function subnode is used.
+      The cell is the SDIO function number if a function subnode is used.
 
   "#size-cells":
     const: 0
-- 
2.39.5



