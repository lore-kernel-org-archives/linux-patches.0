Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5A632144B;
	Tue, 26 Aug 2025 11:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208348; cv=none; b=opb0xvgIMJwm8UEoPie2mXloSws+8Vta739vNc5BP6YAYTAbUnV9tKe8hGgTQeV+WXvxl+jt9bXAJeeLg+JOXrUdRXnarlOtMyzhA8HL+S1V4cwq5lwKppdpzhtca6JEG1MA454SAopKwkiExzLyvYPyMncASVwnXMYV55cyA04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208348; c=relaxed/simple;
	bh=cZ/mux0pPjn4Vz2LxA0gCuhraCPEy9XDhsJmJJPKNZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3rmPl6uRtMGJ32m61Ciu/Ku5ptWkRnNsa5qR2FwtPd8Vegh/rNQvR7d4u+nAIQTkM6RDZG3ydhasO6KFei5jPHngrSFgCZWWX3aeiVfTP9QOSkX75YfAbX8ck7Qo4zs9ry4FvaN75vdoqYdAhDCmnO2DW5z8pAnbwMNaEWyUa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spSsXiq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spSsXiq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EF9C4CEF4;
	Tue, 26 Aug 2025 11:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208347;
	bh=cZ/mux0pPjn4Vz2LxA0gCuhraCPEy9XDhsJmJJPKNZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spSsXiq4YnY+UQ2sZt1HEQjRxOMRa45DsqrWxbNELYojNEi2AW4DCupUHMJflcJOQ
	 zLB0KpdUOuLkM+bvc7LIkhsNkNAfKP/FJ2tp1qaxUWHvqvlw2Pr0VRXgmsD+sLoAms
	 Wzu9OD7/uXUl2XGNdkw2pAjln9TEo+PSc9xOsb0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 045/322] dt-bindings: display: sprd,sharkl3-dpu: Fix missing clocks constraints
Date: Tue, 26 Aug 2025 13:07:40 +0200
Message-ID: <20250826110916.500151088@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 934da599e694d476f493d3927a30414e98a81561 upstream.

'minItems' alone does not impose upper bound, unlike 'maxItems' which
implies lower bound.  Add missing clock constraint so the list will have
exact number of items (clocks).

Fixes: 8cae15c60cf0 ("dt-bindings: display: add Unisoc's dpu bindings")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250720123003.37662-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/display/sprd/sprd,sharkl3-dpu.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/display/sprd/sprd,sharkl3-dpu.yaml
+++ b/Documentation/devicetree/bindings/display/sprd/sprd,sharkl3-dpu.yaml
@@ -25,7 +25,7 @@ properties:
     maxItems: 1
 
   clocks:
-    minItems: 2
+    maxItems: 2
 
   clock-names:
     items:


