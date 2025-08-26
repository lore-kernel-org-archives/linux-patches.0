Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D801DE4CD;
	Tue, 26 Aug 2025 13:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214916; cv=none; b=ou3P2B+KSyZKih5bar2axLM2qVpnHmN+Sp57PPYw8t+wbhSO2iopU1x081rDlZ92Sb3uCIi2vp5IT7B3QC23GCe4unHGNTjXUSPBZcNn3ctR4rwwAAswsfaz2z87EdkEU/j4cNKSY3g4eaa9AfbxhwrAJ4PRoTKb7smLs+xjPns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214916; c=relaxed/simple;
	bh=XzfeYpMmyhw/9rOYmW3Bj+bi85w2uoX4y74rjTQ78jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3qaYKKUI/4leLkMWMw3Fhj7w/uHSDQk6iENk2IIOjG4+eYodQkTGo+caNH398As62SiZVYfri9eXcrj1FfU76Thh9e5PbS+ktl/QfuwHD8NWTzgSJ9gCDiInWpuUwPDWn1+eIbUHVXZrpitO59ZE39z6btGQukm284BsuLzXRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5sfJMJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5sfJMJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3774EC4CEF1;
	Tue, 26 Aug 2025 13:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214916;
	bh=XzfeYpMmyhw/9rOYmW3Bj+bi85w2uoX4y74rjTQ78jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5sfJMJPkXpYdirZlLLkdOMovSr8kURdToxtFT/CupRL46yhktexhrOLaIM05+1Uc
	 IfxctyPihmINlYhAJyLwjNSF3PeR//E+Nvg2nLLBlXj6b2LzYSAByeTG9zpcTJnkfm
	 FQBD8EsWRTuSqN//e9yMcpZWAud+4uHdZPL1jZqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.1 287/482] dt-bindings: display: sprd,sharkl3-dsi-host: Fix missing clocks constraints
Date: Tue, 26 Aug 2025 13:09:00 +0200
Message-ID: <20250826110937.880928231@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 2558df8c13ae3bd6c303b28f240ceb0189519c91 upstream.

'minItems' alone does not impose upper bound, unlike 'maxItems' which
implies lower bound.  Add missing clock constraint so the list will have
exact number of items (clocks).

Fixes: 2295bbd35edb ("dt-bindings: display: add Unisoc's mipi dsi controller bindings")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250720123003.37662-4-krzysztof.kozlowski@linaro.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/display/sprd/sprd,sharkl3-dsi-host.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/display/sprd/sprd,sharkl3-dsi-host.yaml
+++ b/Documentation/devicetree/bindings/display/sprd/sprd,sharkl3-dsi-host.yaml
@@ -20,7 +20,7 @@ properties:
     maxItems: 2
 
   clocks:
-    minItems: 1
+    maxItems: 1
 
   clock-names:
     items:


