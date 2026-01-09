Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF37B359F99;
	Fri,  9 Jan 2026 12:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960371; cv=none; b=kfXHSKtuDy7cSp0u0XhfuWLGSB5bBGZ+D/s4n/H94soF//Ay/Ya1foWZKR5jRIUCDECOjoq/SRkk6FdWeHNaa+6ivUwjOOuq+yIhEeUv8FkrnfwZ6LaS6YiXXZAhtmURVhaP3+Kka4SenpVd/AboyLzYm6KBOAuZXfGSDqjRXG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960371; c=relaxed/simple;
	bh=gYG+ai0pGCD28U2nLQJPJL70kz7Vs+0hRL/9suywcrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=at6nu4CPjRM38B53UiP2UKZJBuhtp1+cxoNniwFp7w7mie6Cf+8E+EnUjmsWTVS/xZFWIFcvT+PMzZjU61N6+bwtR7jdhau3p8o1yzuPnQvWa1M9HtpYstOpCrQp2OlWHXdi7YjYBrggxqWJcUURuCGict05f+bAr+UY6VIviG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMrRdPMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMrRdPMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E999C4CEF1;
	Fri,  9 Jan 2026 12:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960371;
	bh=gYG+ai0pGCD28U2nLQJPJL70kz7Vs+0hRL/9suywcrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMrRdPMJYN6HCAYA1mL/WCL/rvif+DO74vXWjLWHGvybn34H0/G+RfRhhjs43JX+E
	 ufsiGgUmBO1EdgKxJKLE2WCxrUZB+G/EHzylt+7D9SPbd6lyKXpj6lSHYKBEw9spps
	 Z+wjbX7aJ5nRKCk34ujUjX3g4excoJWePHFQa+x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 380/737] dt-bindings: mmc: sdhci-of-aspeed: Switch ref to sdhci-common.yaml
Date: Fri,  9 Jan 2026 12:38:39 +0100
Message-ID: <20260109112148.296172523@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Andrew Jeffery <andrew@codeconstruct.com.au>

commit ed724ea1b82a800af4704311cb89e5ef1b4ea7ac upstream.

Enable use of common SDHCI-related properties such as sdhci-caps-mask as
found in the AST2600 EVB DTS.

Cc: stable@vger.kernel.org # v6.2+
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/mmc/aspeed,sdhci.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/mmc/aspeed,sdhci.yaml
+++ b/Documentation/devicetree/bindings/mmc/aspeed,sdhci.yaml
@@ -41,7 +41,7 @@ properties:
 patternProperties:
   "^sdhci@[0-9a-f]+$":
     type: object
-    $ref: mmc-controller.yaml
+    $ref: sdhci-common.yaml
     unevaluatedProperties: false
 
     properties:


