Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B5E1EB1BF;
	Thu, 17 Apr 2025 18:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913652; cv=none; b=cDoK5UOKv6RSdOT86B+6B59ZJclXZ9LVI+FXQ+ORz0sWi/Ms19WyNUy7MzP7mfUYTd1v2EWoVmMJ7aTRmCrfOHrhI0tgW1Yel4reYaoJQjRWlHCEY2bdot/R5I0Fws2rdI3PGFK4PlmtiYpSRR8tpW6EKIxiBzCZqaZD+3ExT8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913652; c=relaxed/simple;
	bh=Q8BtpwQRTZ7RJqfnd5EdGZc2Isqe6T2gqAn63g338AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifKUB9mvB7Pcwg/8g81Cl3PA4gu885fDG77S+eFMA5r7VNbdf7SpdYBf1hH/4sqb92Uq4eGOMLCkk9vQRcJ62igvArFhN+XPTej+MDE88Ygp2aavVrb/d3mdcy/jG7a0jyxbW78lY6XzkH+E64/Yu0Mm4L3KaZn8rNUlpnD7G+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yj8vbipU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yj8vbipU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AFFC4CEE4;
	Thu, 17 Apr 2025 18:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913652;
	bh=Q8BtpwQRTZ7RJqfnd5EdGZc2Isqe6T2gqAn63g338AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yj8vbipUXGDYP6ENjf3mRkNEOqDUlAS44xBz89sJGyKQVbR7EB/Ee4zvNxQDpWm5y
	 lKtqonxvy5H94D84DiOpwD65yiQ+47yt69Gl+1oWpwaeN74KcWOAU+IArBlRitpqpb
	 uZ0BbcbdlQSuVKteRCLTaNBUty+Z9aRjaNhVJL6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 6.14 391/449] dt-bindings: coresight: qcom,coresight-tpda: Fix too many reg
Date: Thu, 17 Apr 2025 19:51:19 +0200
Message-ID: <20250417175134.007394378@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit d72deaf05ac18e421d7e52a6be8966fd6ee185f4 upstream.

Binding listed variable number of IO addresses without defining them,
however example DTS code, all in-tree DTS and Linux kernel driver
mention only one address space, so drop the second to make binding
precise and correctly describe the hardware.

Fixes: a8fbe1442c2b ("dt-bindings: arm: Adds CoreSight TPDA hardware definitions")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250226112914.94361-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/arm/qcom,coresight-tpda.yaml |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/arm/qcom,coresight-tpda.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom,coresight-tpda.yaml
@@ -55,8 +55,7 @@ properties:
       - const: arm,primecell
 
   reg:
-    minItems: 1
-    maxItems: 2
+    maxItems: 1
 
   clocks:
     maxItems: 1


